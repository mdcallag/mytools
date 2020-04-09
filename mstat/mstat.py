#!/usr/bin/python3
#
# Copyright (C) 2009 Google Inc.
# Copyright (C) 2009 Facebook Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Originally published when I worked at Google.
# Additional improvements when I worked at Facebook.
# More improvements when I worked at MongoDB
#

"""Multiple-stat reporter

This gathers performance statistics from multiple data sources and reports
them over the same interval. It supports iostat and vmstat on modern Linux
distributions and SHOW GLOBAL STATUS output from MySQL. It is a convenient way
to collect data during benchmarks and can perform some computations on the
collected data including 'rate', 'avg' and 'max'. It can also aggregate
data from multiple devices from iostat.

This reports all data from vmstat, iostat and SHOW GLOBAL STATUS as counters
and as rates. Other stats can be derived from them and defined on the command
line or via file named by the --sources option.

Run it like:
  mstat.py --loops 1000000 --interval 60
"""

__author__ = 'Mark Callaghan (mdcallag@gmail.com)'

import itertools
import optparse
import subprocess
import sys
import time

def parse_opts(args):
  parser = optparse.OptionParser()
  parser.add_option("--dbms", action="store",
                    type="string",dest="dbms",
                    default="",
                    help="one of: mysql, mongo, postgres")
  parser.add_option("--db_user", action="store",
                    type="string",dest="db_user",
                    default="",
                    help="Username for database")
  parser.add_option("--db_password", action="store",
                    type="string",dest="db_password",
                    default="",
                    help="Password for database")
  parser.add_option("--db_host", action="store",
                    type="string",dest="db_host",
                    default="localhost",
                    help="Hostname for database")
  parser.add_option("--db_name", action="store",
                    type="string",dest="db_name",
                    default="test",
                    help="Database name")
  parser.add_option("--db_retries", action="store",
                    type="int",dest="db_retries",
                    default="3",
                    help="Number of times to retry failed queries")
  parser.add_option("--sources", action="store",
                    type="string",dest="data_sources",
                    default="",
                    help="File that lists data sources to plot in addition"
                    "to those listed on the command line")
  parser.add_option("--interval", action="store",
                    type="int", dest="interval",
                    default="10",
                    help="Report every interval seconds")
  parser.add_option("--loops", action="store",
                    type="int", dest="loops",
                    default="10",
                    help="Stop after this number of intervals")
  options, args = parser.parse_args(args)
  if options.dbms not in ["", "mysql", "postgres", "mongo"]:
    print("dbms is ::%s:: but must be one of mysql, postgres, mongo" % options.dbms)
    sys.exit(1);
  return options, args

pg_numeric_typecodes = [20, 701]
pg_date_typecodes = [1184]

def divfunc(x, y):
  fy = float(y)
  if not fy:
    return 0.0
  else:
    return float(x) / float(y)

class MstatContext:
  def __init__(self, interval):
    self.cache_sources = {}
    self.devices = []
    # The values are the numbers of counters of that type, which is found at startup
    self.counters = { 'iostat':0, 'vmstat':0, 'my.status':0, 'mo.status':0 }
    self.tabs_1row = []
    self.tabs_nrow = []
    self.tee_iters = []
    self.use_sources = {}
    self.shared_sources = {}
    self.interval = interval

  def add_tab_1row(self, k):
    self.counters[k] = 0
    self.tabs_1row.append(k)

  def add_tab_nrow(self, k):
    self.counters[k] = 0
    self.tabs_nrow.append(k)

class MyIterable:
  def __iter__(self):
    return self

class TeeIter(MyIterable):
  def __init__(self, ctx, type_name):
    self.type_name = type_name
    self.index = ctx.counters[type_name]
    self.tee_iter = None
    ctx.counters[type_name] += 1
    ctx.tee_iters.append(self)

  def __next__(self):
    return next(self.tee_iter)

  next = __next__

class CacheIter(MyIterable):
  def __init__(self, iter):
    self.iter = iter
    self.value = None
    self.stop = False

  def __next__(self):
    if self.stop:
      raise StopIteration

    return self.value

  next = __next__

  def cache_next(self):
    try:
      self.value = self.iter.next()
      return self.value
    except StopIteration:
      self.value = None
      self.stop = True
      return None

class Timestamper(MyIterable):
  def __next__(self):
    return time.strftime('%Y-%m-%d_%H:%M:%S')

  next = __next__

class Counter(MyIterable):
  def __init__(self, interval):
    self.interval = interval
    self.value = 0

  def __next__(self):
    result = str(self.value)
    self.value += self.interval
    return result

  next = __next__

def get_my_conn(db_user, db_password, db_host, db_name):
  return MySQLdb.connect(host=db_host, user=db_user, passwd=db_password, db=db_name)

def get_mo_conn(db_user, db_password, db_host, db_name):
  return pymongo.MongoClient("mongodb://%s:%s@%s:27017" % (db_user, db_password, db_host))

def get_pg_conn(db_user, db_password, db_host, db_name):
  if not db_user:   
    conn = psycopg2.connect(dbname=db_name, host=db_host)
  else:
    conn = psycopg2.connect(dbname=db_name, host=db_host, user=db_user, password=db_password)
  conn.set_session(autocommit=True)
  return conn

def get_conn(db_user, db_password, db_host, db_name, dbms):
  if dbms == 'mysql':
    return get_my_conn(db_user, db_password, db_host, db_name)
  elif dbms == 'postgres':
    return get_pg_conn(db_user, db_password, db_host, db_name)
  elif dbms == 'mongo':
    return get_mo_conn(db_user, db_password, db_host, db_name)
  else:
    print('dbms not known ::%s::' % dbms)

class ScanMysql(MyIterable):
  def __init__(self, db_user, db_password, db_host, db_name, sql, retries,
               err_data):
    self.db_user = db_user
    self.db_password = db_password
    self.db_host = db_host
    self.db_name = db_name
    self.sql = sql
    self.retries = retries
    self.err_data = err_data

  def __next__(self):
    r = self.retries
    while r >= 0:
      conn = None
      try:
        conn = get_my_conn(self.db_user, self.db_password, self.db_host, self.db_name)
        cursor = conn.cursor()
        cursor.execute(self.sql)
        result = []
        for row in cursor.fetchall():
          result.append(' '.join(row))
        conn.close()
        # print 'Connectdb'
        if result:
          return '\n'.join(result)
        else:
          return self.err_data
      except MySQLdb.Error as e:
        print('sql (%s) fails (%s)' % (self.sql, e))
        if conn is not None:
          try:
            conn.close()
          except MySQLdb.Error:
            pass
        time.sleep(0.1)
      r -= 1
    return self.err_data

  next = __next__

# This will need work to do things other than run serverStatus
class ScanMongo(MyIterable):
  def __init__(self, db_user, db_password, db_host, db_name, command, retries):
    self.db_user = db_user
    self.db_password = db_password
    self.db_host = db_host
    self.db_name = db_name
    self.command = command
    self.retries = retries

  def __next__(self):
    r = self.retries
    while r >= 0:
      conn = None
      try:
        conn = get_mo_conn(self.db_user, self.db_password, self.db_host, self.db_name)
        # TODO don't hardware local
        db = conn['local']
        status = db.command(self.command)
        kv_res = {}
        walk_mongo(status, kv_res, "")
        return kv_res
      except pymongo.errors.PyMongoError as e:
        print('mo error: %s' % e)
        time.sleep(0.1)

      r -= 1
    return {'error': 0}

  next = __next__

class ScanSQLRow(MyIterable):
  def __init__(self, db_user, db_password, db_host, db_name, sql, retries, key_prefix, dbms):
    self.db_user = db_user
    self.db_password = db_password
    self.db_host = db_host
    self.db_name = db_name
    self.sql = sql
    self.retries = retries
    self.key_prefix = key_prefix
    self.dbms = dbms

  def do_my(self):
    try:
      return self.work()
    except MySQLdb.Error as e:
      print('ScanSQLRow  (%s) fails (%s)' % (self.sql, e))
      return None, True

  def do_pg(self):
    try:
      return self.work()
    except psycopg2.Error as e:
      print('ScanSQLRow  (%s) fails (%s)' % (self.sql, e))
      return None, True

  def work(self):
    conn = get_conn(self.db_user, self.db_password, self.db_host, self.db_name, self.dbms)
    cursor = conn.cursor()
    cursor.execute(self.sql)
    result = {}
    row = cursor.fetchall()[0]
    for i in range(len(cursor.description)):
      #print('d::%s::%s' % (i, cursor.description[i].name))
      k = '%s.%s' % (self.key_prefix, cursor.description[i].name)
      v = row[i]
      result[k] = v
    #print('ScanSQLRow ::%s' % result)
    cursor.close()
    conn.close()
    return result, False

  def __next__(self):
    r = self.retries
    while r >= 0:
      if (self.dbms == 'mysql'):
        res, err = self.do_my()
      elif (self.dbms == 'postgres'):
        res, err = self.do_pg()
      else:
        print('ScanSQLRow dbms must be mysql or postgres, was ::%s::' % self.dbms)

      if not err:
        return res

      time.sleep(0.1)
      r -= 1

    err = {}
    err['error'] = 0
    return err

  next = __next__

class ScanFork(MyIterable):
  def __init__(self, cmdline, skiplines):
    self.proc = subprocess.Popen(cmdline, shell=True, bufsize=1,
                                 universal_newlines=True,                                
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
    self.cmdline = cmdline
    self.lines_to_skip = skiplines
    sys.stderr.write("forked pid %d for (%s)\n" % (self.proc.pid, cmdline))
    sys.stderr.flush()

  def __next__(self):
    while True:
      line = self.proc.stdout.readline()
      if not line:
        raise StopIteration
      elif self.lines_to_skip > 0:
        self.lines_to_skip -= 1
        continue
      else:
        return line

  next = __next__

class FilterEquals(MyIterable):
  def __init__(self, pos, value, iterable, iostat_hack=False):
    self.pos = pos
    self.value = value
    self.iter = iterable
    self.iostat_hack = iostat_hack

  def __next__(self):
    while True:
      lines = next(self.iter)
      for line in lines.split('\n'):
        cols = line.split()
        if len(cols) >= (self.pos + 1) and cols[self.pos] == self.value:
          return line
        # Ugly hack for long device name split over 2 lines
        # elif self.iostat_hack and len(cols) == 1 and cols[self.pos] == self.value:
        # return '%s %s' % (self.value, next(self.iter)

  next = __next__

class ValueForKey(MyIterable):
  def __init__(self, key, iterable):
    self.key = key
    self.iter = iterable

  def __next__(self):
    while True:
      row_dict = next(self.iter)
      #print(row_dict)
      return str(row_dict[self.key])

  next = __next__

class Project(MyIterable):
  def  __init__(self, pos, iterable):
    self.pos = pos
    self.iter = iter(iterable)

  def __next__(self):
    line = next(self.iter)
    cols = line.split()
    try:
      v = float(cols[self.pos])
      return cols[self.pos]
    except ValueError:
      return 0.0

  next = __next__

class ProjectByPrefix(MyIterable):
  def __init__(self, separator, prefix, iterable):
    self.separator = separator
    self.prefix = prefix
    self.iter = iter(iterable)
    # print 'ProjectByPrefix searches for %s' % prefix

  def __next__(self):
    line = self.iter.next()
    cols = line.split(self.separator)
    for c in cols:
      if c.startswith(self.prefix):
        return c[len(self.prefix):].rstrip()
    raise StopIteration    

  next = __next__

class ExprAbsToRel(MyIterable):
  def __init__(self, interval, iterable, name):
    self.interval = interval
    self.iter = iter(iterable)
    self.prev = None
    self.name = name

  def __next__(self):
    #print('ExprAbsToRel for %s' % self.name)
    current = float(next(self.iter))
    if self.prev is None:
      self.prev = current
      return '0'
    else:
      diff = current - self.prev
      rate = diff / self.interval
      self.prev = current
      return str(rate)

  next = __next__

class ExprFunc(MyIterable):
  def __init__(self, func, iterables):
    self.func = func
    self.iters = [iter(i) for i in iterables]

  def __next__(self):
    return str(self.func([float(i.next()) for i in self.iters]))

  next = __next__

class ExprAvg(MyIterable):
  def __init__(self, iterables):
    self.iters = [iter(i) for i in iterables]

  def __next__(self):
    return str(sum([float(i.next()) for i in self.iters]) / len(self.iters))

class ExprBinaryFunc(MyIterable):
  def __init__(self, func, i1, i2):
    self.func = func
    self.iter1 = iter(i1)
    self.iter2 = iter(i2)

  def __next__(self):
    return str(self.func(self.iter1.next(), self.iter2.next()))

  next = __next__

vmstat_cols = { 'swpd':2, 'free':3, 'buff':4, 'cache':5, 'si':6, 'so':7,
                'bi':8, 'bo':9, 'in':10, 'cs':11, 'us':12, 'sy':13,
                'id':14, 'wa':15 }

# Iostat output...
# Old style
#    Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
# New style
#    Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util

# Initialized in iostat_init
iostat_cols = { }

funcs = [ 'sum', 'rate', 'ratesum', 'max', 'avg', 'div' ]

def iostat_init():
  scan_iostat = ScanFork('iostat -kx 1 1', 0)
  saw_device = False
  devices = []
  global iostat_cols
  iostat_cols = {}
  for line in scan_iostat:
    if line.startswith('Device'):
      cols = line.split()
      for idx, c in enumerate(cols[1:]):
        iostat_cols[c] = idx+1
      saw_device = True
    elif saw_device:
      cols = line.split()
      if cols:
        devices.append(cols[0])
  #print('iostat devices: %s' % devices)
  #print('iostat columns: %s' % iostat_cols)
  return devices

def flashcache_get_cols():
  scan_fc = ScanFork('cat /proc/flashcache_stats', 0)
  for line in scan_fc:
    line.rstrip()
    for col in line.split(' '):
      x = col.find('=')
      flashcache_cols.append(col[:x])
      # print 'Flashcache found: %s' % flashcache_cols[-1]

def get_matched_devices(prefix, devices):
  assert prefix[-1] == '*'
  matched = []
  for d in devices:
    if d.startswith(prefix[:-1]) and len(d) > len(prefix[:-1]):
      matched.append(d)
  return matched

def get_my_cols(db_user, db_password, db_host, db_name):
  names = []
  try:
    connect = MySQLdb.connect(host=db_host, user=db_user, passwd=db_password,
                              db=db_name)
    cursor = connect.cursor()
    cursor.execute('SHOW GLOBAL STATUS')
    for row in cursor.fetchall():
      if len(row) == 2:
        try:
          v = float(row[1])
          names.append(row[0])
        except ValueError:
          pass
    connect.close()
    return names
  except MySQLdb.Error as e:
    print('SHOW GLOBAL STATUS fails:', e)
    return []

def walk_mongo(json_as_dict, kv_res, prefix):
  for k, v in json_as_dict.items():
    k = str.replace(k, " ", "_")
    k = str.replace(k, ")", "_")
    k = str.replace(k, "(", "_")
    k = str.replace(k, ",", "_")
    if not prefix:
      next_prefix = k
    else:
      next_prefix = '%s.%s' % (prefix, k)

    if isinstance(v, dict):
      walk_mongo(v, kv_res, next_prefix)
    elif next_prefix != 'tcmalloc.tcmalloc.formattedString':
      kv_res[next_prefix] = v

def get_mo_stats(db_user, db_password, db_host, db_name, ctx):
  try:
    conn = get_mo_conn(db_user, db_password, db_host, db_name)
    db = conn['local']
    status = db.command('serverStatus')
    kv_res = {}
    walk_mongo(status, kv_res, "")
    # for k, v in kv_res.items(): print('%s = %s' % (k, v))
    non_numeric_keys = []
    for k, v in kv_res.items():
      #print('key %s has type %s' % (k, type(v)))
      if not isinstance(v, (float, int)) or isinstance(v, (bool)):
        non_numeric_keys.append(k)
    for nnk in non_numeric_keys:
      #print('del key %s' % nnk)
      del kv_res[nnk]
    return kv_res.keys()
  except pymongo.errors.PyMongoError as e:
    print('mo error: %s' % e)
    return {}

def get_pg_stats(db_user, db_password, db_host, db_name, ctx):
  # TODO: figure out how to support counters that can come and go after mstat has been started
  # nrow_stat_tables = { 'pg_stat_database' : ['datname'] }
  nrow_stat_tables = { }

  tabs1 = {}
  tabsn = {}

  try:
    conn = get_pg_conn(db_user, db_password, db_host, db_name)
    cursor = conn.cursor()

    cursor.execute('select * from pg_stat_bgwriter')
    rows = cursor.fetchall()
    if cursor.description:
      bgw_cols = []
      for i in range(len(cursor.description)):
        print('d::%s::%s::%s' % (i, cursor.description[i].name, cursor.description[i].type_code))
        bgw_cols.append((cursor.description[i].name, cursor.description[i].type_code))
      tabs1['pg_stat_bgwriter'] = bgw_cols
      ctx.add_tab_1row('pg.pg_stat_bgwriter')

    for tab_name, key_cols in nrow_stat_tables.items():
      cursor.execute('select * from %s' % tab_name)
      rows = cursor.fetchall()
      if cursor.description:
        db_cols = [key_cols]
        for i in range(len(cursor.description)):
          print('d::%s::%s::%s' % (i, cursor.description[i].name, cursor.description[i].type_code))
          if cursor.description[i].name not in key_cols:
            db_cols.append((cursor.description[i].name, cursor.description[i].type_code))
        print('pg: %s :: %s :: %s' % (tab_name, key_cols, db_cols))
        tabsn[tab_name] = db_cols
        ctx.add_tab_nrow(tab_name)

    cursor.close()
    conn.close()

  except psycopg2.Error as e:
    print('pg error: %s' % e)
  return tabs1, tabsn

def make_basic_expr(arg, ctx, can_expand):
  # print "make_basic_expr for %s" % arg
  arg_parts = arg.split('.')
  pend = len(arg_parts)

  if arg_parts[0] in ['timer', 'timestamp', 'counter']:
    assert pend == 1
    return (arg, ctx.shared_sources[arg_parts[0]])

  elif arg_parts[0] == 'vmstat':
    assert pend >= 2
    assert arg_parts[1] in vmstat_cols
    return (arg, Project(vmstat_cols[arg_parts[1]], TeeIter(ctx, 'vmstat')))

  elif arg_parts[0] == 'iostat':
    assert pend >= 3
    assert arg_parts[2] in iostat_cols
    found = []

    if arg_parts[1][-1] == '*':
      assert can_expand
      assert 3 == pend

      matched = get_matched_devices(arg_parts[1], ctx.devices)
      if matched:
        ctx.counters['iostat'] += len(matched)
        for m in matched:
          found.append([arg_parts[0], m, arg_parts[2]])

    elif arg_parts[1] in ctx.devices:
      found.append(arg_parts)

    else:
      assert "cannot match iostat for %s" % arg

    result = []
    for e in found:
      filter_iter = FilterEquals(0, e[1], TeeIter(ctx, 'iostat'))
      result.append(('.'.join(e), Project(iostat_cols[e[2]], filter_iter)))

    if can_expand:
      return result
    else:
      # print 'iostat make_basic_expr return %s' % result[0][0]
      return result[0]

  elif arg_parts[0] == 'my':
    assert arg_parts[1] == 'status'
    assert pend >= 3

    filter = FilterEquals(0, arg_parts[2], TeeIter(ctx, 'my.status'))
    return (arg, Project(1, filter))

  elif arg_parts[0] == 'mo':
    assert arg_parts[1] == 'status'
    assert pend >= 3
    # print('mongo: %s' % arg)
    return (arg, ValueForKey('.'.join(arg_parts[2:]), TeeIter(ctx, 'mo.status')))

  elif arg_parts[0] == 'pg':
    #print('pg val: %s %s %s' % (arg_parts[0], arg_parts[1], ctx.tabs_1row))
    prefix = 'pg.%s' % arg_parts[1]
    if prefix in ctx.tabs_1row:
      assert pend >= 3
      return (arg, ValueForKey('%s.%s' % (prefix, arg_parts[2]), TeeIter(ctx, prefix)))
    elif prefix in ctx.tabs_nrow:
      assert pend >= 3
      return (arg, ValueForKeyN('%s.%s' % (prefix, arg_parts[2:]), TeeIter(ctx, prefix)))
    else:
      print('pg what is ::%s::' % prefix)
      sys.exit(1)

  else:
    print('validate_arg fails for %s' % arg)
    assert False

def get_tokens(strl):
  r = []
  cur = ''
  sepl = [')', '(', ',']

  for e in strl:
    if e in sepl:

      if cur:
        r.append(cur)
        cur = ''

      if e != ',':
        r.append(e)

    else:
      cur += e

  if cur:
    r.append(cur)

  # print 'get_tokens(%s, %s) returns %s' % (strl, sepl, r)
  return r

def parse_input(arg, ctx, can_expand):
  #print("parse_input for %s" % arg)
  tokens = get_tokens(arg)
  e, rem = parse_expr(tokens, ctx, can_expand)
  assert not rem
  return e

def parse_expr(parts, ctx, can_expand):
  # print 'parse_expr for %s' % parts

  if parts[0] in funcs:
    (exprs, rem) = parse_expr_list(parts[1:], ctx, can_expand)
    return (parse_func_call(ctx, parts[0], exprs), rem)
  else:
    return parse_basic_expr(parts, ctx, can_expand)

def parse_expr_list(parts, ctx, can_expand):
  # print "parse_expr_list"
  assert parts[0] == '('
  parts = parts[1:]
  args = []

  while parts and parts[0] != ')':
    (e, rem) = parse_expr(parts, ctx, can_expand)
    args.append(e)
    parts = rem

  if parts:
    assert parts[0] == ')'
    parts = parts[1:]

  return (args, parts)

def parse_func_call(ctx, func_name, func_arg_list):
  #print("parse_func_call for %s, %d" % (func_name, len(func_arg_list)))

  name = '%s(%s)' % (func_name, ','.join([e[0] for e in func_arg_list]))

  if func_name == 'rate':
    assert len(func_arg_list) == 1
    return (name, ExprAbsToRel(ctx.interval, func_arg_list[0][1], name))

  elif func_name == 'sum':
    assert len(func_arg_list) >= 1
    return (name, ExprFunc(sum, [e[1] for e in func_arg_list]))

  elif func_name == 'ratesum':
    assert len(func_arg_list) >= 1
    sum_iter = ExprFunc(sum, [e[1] for e in func_arg_list])
    return (name, ExprAbsToRel(interval, sum_iter, name))

  elif func_name == 'avg':
    assert len(func_arg_list) >= 1
    return (name, ExprAvg([e[1] for e in func_arg_list]))

  elif func_name == 'max':
    assert len(func_arg_list) >= 1
    return (name, ExprFunc(max, [e[1] for e in func_arg_list]))

  elif func_name == 'div':
    assert len(func_arg_list) == 2
    return (name, ExprBinaryFunc(divfunc, func_arg_list[0][1], func_arg_list[1][1]))

  else:
    assert False

def parse_basic_expr(parts, ctx, can_expand):
  # print "parse_basic_expr for %s" % parts
  return (make_basic_expr(parts[0], ctx, can_expand), parts[1:])

def add_source(kv, sources):
  # print 'add_source for %s' % kv[0]
  assert len(kv) == 2
  sources[kv[0]] = kv[1]

def build_inputs(args, interval, loops, db_user, db_password, db_host,
                 db_name, db_retries, data_sources, dbms):
  ctx = MstatContext(interval)
  ctx.devices = iostat_init()

  ctx.shared_sources['timer'] = CacheIter(iter(Counter(interval)))
  ctx.shared_sources['timestamp'] = CacheIter(iter(Timestamper()))
  ctx.shared_sources['counter'] = CacheIter(iter(Counter(1)))

  for arg in ['timestamp', 'timer', 'counter']:
    ctx.use_sources[arg] = make_basic_expr(arg, ctx, False)[1]

  for dev in ctx.devices:
    for col in iostat_cols:
      add_source(make_basic_expr('iostat.%s.%s' % (dev, col), ctx, False), ctx.use_sources)
      add_source(parse_input('rate(iostat.%s.%s)' % (dev, col), ctx, False), ctx.use_sources)

  for col in vmstat_cols:
    add_source(make_basic_expr('vmstat.%s' % col, ctx, False), ctx.use_sources)
    add_source(parse_input('rate(vmstat.%s)' % col,  ctx, False), ctx.use_sources)

  derived_stats = []

  print('counters: %s' % ctx.counters)

  scan_1row = []
  scan_nrow = []

  my_cols = None
  if dbms == 'mysql':
    my_cols = get_my_cols(db_user, db_password, db_host, db_name)
    if my_cols is None:
      print('Unable to access MySQL for host(%s), db(%s), user(%s)' % (db_host, db_name, db_user))
      sys.exit(1)
    for col in my_cols:
      add_source(make_basic_expr('my.status.%s' % col, ctx, False), ctx.use_sources)
      add_source(parse_input('rate(my.status.%s)' % col, ctx, False), ctx.use_sources)
    derived_stats.append(
        (('Innodb_data_sync_read_requests', 'Innodb_data_sync_read_svc_seconds'),
          'div(rate(my.status.Innodb_data_sync_read_svc_seconds),rate(my.status.Innodb_data_sync_read_requests))',
          my_cols))
    derived_stats.append(
        (('Questions', 'Command_seconds'),
          'div(rate(my.status.Command_seconds),rate(my.status.Questions))',
          my_cols))

  if dbms == 'postgres':
    pg_tabs1, pg_tabsn = get_pg_stats(db_user, db_password, db_host, db_name, ctx)
    if pg_tabs1 is None or pg_tabsn is None:
      print('Unable to access Postgres for host(%s), db(%s), user(%s)' % (db_host, db_name, db_user))
      sys.exit(1)

    # data from tables that have 1 row
    for tab_name, tab_cols in pg_tabs1.items():
      scan_1row.append(('pg', tab_name))
      for col_name, col_type in tab_cols:
        add_source(make_basic_expr('pg.%s.%s' % (tab_name, col_name), ctx, False), ctx.use_sources)
        if col_type in pg_numeric_typecodes:
          print('rate for %s' % col_name)
          add_source(parse_input('rate(pg.%s.%s)' % (tab_name, col_name), ctx, False), ctx.use_sources)

    # data from tables that have n rows
    # TODO not supported yet

  if dbms == 'mongo':
    mongo_keys = get_mo_stats(db_user, db_password, db_host, db_name, ctx)
    for key in mongo_keys:
      add_source(make_basic_expr('mo.status.%s' % key, ctx, False), ctx.use_sources)
      add_source(parse_input('rate(mo.status.%s)' % key, ctx, False), ctx.use_sources)
 
  for e in derived_stats:
    all_found = True
    for col in e[0]:
      if col not in e[2]:
        all_found = False
        break
    if all_found:
      add_source(parse_input(e[1], ctx, False), ctx.use_sources)

  for arg in args:
    for k, v in parse_input(arg, ctx, True):
      ctx.use_sources[k] = v

  tee = {}
  tee_used = {}
  for k,v in ctx.counters.items(): tee_used[k] = 0
  print('ctx counters: %s' % ctx.counters)

  if ctx.counters['vmstat']:
    scan_vmstat = ScanFork('vmstat -n %d %d' % (interval, loops+1), 2)
    tee['vmstat'] = itertools.tee(scan_vmstat, ctx.counters['vmstat'])

  if ctx.counters['iostat']:
    scan_iostat = ScanFork('iostat -x %d %d' % (interval, loops+1), 0)
    tee['iostat'] = itertools.tee(scan_iostat, ctx.counters['iostat'])

  if ctx.counters['my.status']:
    scan_mystat = ScanMysql(db_user, db_password, db_host, db_name,
                            'SHOW GLOBAL STATUS', db_retries, 'Foo 0')
    tee['my.status'] = itertools.tee(scan_mystat, ctx.counters['my.status'])

  if ctx.counters['mo.status']:
    scan = ScanMongo(db_user, db_password, db_host, db_name, 'serverStatus', db_retries)
    tee['mo.status'] = itertools.tee(scan, ctx.counters['mo.status'])

  for dbms_prefix, tab_name in scan_1row:
    counter_prefix = '%s.%s' % (dbms_prefix, tab_name) 
    scan = ScanSQLRow(db_user, db_password, db_host, db_name,
                      'select * from %s' % tab_name, db_retries,
                      counter_prefix, dbms)
    tee[counter_prefix] = itertools.tee(scan, ctx.counters[counter_prefix])

  for i in ctx.tee_iters:
    i.tee_iter = tee[i.type_name][i.index]
    tee_used[i.type_name] += 1

  for i in ctx.counters.keys():
    print('check for %s tee_used %d == ctx.counters %d' % (i, tee_used[i], ctx.counters[i]))
    assert tee_used[i] == ctx.counters[i]

  return ctx

def init_for_dbms(options):
  if options.dbms == 'mongo':
    globals()['pymongo'] = __import__('pymongo')
  elif options.dbms == 'mysql':
    globals()['MySQLdb'] = __import__('MySQLdb')
  elif options.dbms == 'postgres':
    globals()['psycopg2'] = __import__('psycopg2')
  else:
    print('no dbms configured')

def main(argv=None):
  if argv is None:
    argv = sys.argv
  options, args = parse_opts(argv[1:])
  init_for_dbms(options)

  ctx = build_inputs(args, options.interval, options.loops,
                     options.db_user, options.db_password,
                     options.db_host, options.db_name, options.db_retries,
                     options.data_sources, options.dbms)

  i=1
  for k in sorted(ctx.use_sources.keys()):
    print('%d %s' % (i, k))
    i += 1

  print('START')

  shared_iters = [v for k,v in ctx.shared_sources.items()]
  use_iters = [iter(ctx.use_sources[k]) for k in sorted(ctx.use_sources.keys())]

  try:
    for x in range(options.loops):
      shared_vals = [i.cache_next() for i in shared_iters]

      print(' '.join([i.next() for i in use_iters]))
      time.sleep(options.interval)
  except StopIteration:
    pass

if __name__ == "__main__":
    sys.exit(main())
