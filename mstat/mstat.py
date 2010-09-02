#!/usr/bin/python
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
# Originally published by Google.
# Additional improvements from Facebook.
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

import MySQLdb

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
    self.counters = { 'iostat':0, 'vmstat':0, 'my.status':0, 'flashcache':0 }
    self.tee_iters = []
    self.use_sources = {}
    self.shared_sources = {}
    self.interval = interval

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

  def next(self):
    return self.tee_iter.next()

class CacheIter(MyIterable):
  def __init__(self, iter):
    self.iter = iter
    self.value = None
    self.stop = False

  def next(self):
    if self.stop:
      raise StopIteration

    return self.value

  def cache_next(self):
    try:
      self.value = self.iter.next()
      return self.value
    except StopIteration, e:
      self.value = None
      self.stop = True
      return None

class Timestamper(MyIterable):
  def next(self):
    return time.strftime('%Y-%m-%d_%H:%M:%S')

class Counter(MyIterable):
  def __init__(self, interval):
    self.interval = interval
    self.value = 0

  def next(self):
    result = str(self.value)
    self.value += self.interval
    return result

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

  def next(self):
    r = self.retries
    while r >= 0:
      connect = None
      try:
        connect = MySQLdb.connect(host=self.db_host, user=self.db_user,
                                  passwd=self.db_password,
                                  db = self.db_name)
        cursor = connect.cursor()
        cursor.execute(self.sql)
        result = []
        for row in cursor.fetchall():
          result.append(' '.join(row))
        connect.close()
        # print 'Connectdb'
        if result:
          return '\n'.join(result)
        else:
          return self.err_data
      except MySQLdb.Error, e:
        print 'sql (%s) fails (%s)' % (self.sql, e)
        if connect is not None:
          try:
            connect.close()
          except MySQLdb.Error, e:
            pass
        time.sleep(0.1)
      r -= 1
    return self.err_data

class ScanFork(MyIterable):
  def __init__(self, cmdline, skiplines):
    self.proc = subprocess.Popen(cmdline, shell=True, bufsize=1,
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
    self.cmdline = cmdline
    self.lines_to_skip = skiplines
    print >>sys.stderr, "forked pid %d for (%s)" % (
      self.proc.pid, cmdline)

  def next(self):
    while True:
      line = self.proc.stdout.readline()
      if not line:
        raise StopIteration
      elif self.lines_to_skip > 0:
        self.lines_to_skip -= 1
        continue
      else:
        return line

class ScanReFork(MyIterable):
  def __init__(self, cmdline, skiplines, max_fork):
    self.cmdline = cmdline
    self.lines_to_skip = skiplines
    self.cur_lines_to_skip = skiplines
    self.max_fork = max_fork
    self.cur_fork = 0
    self.init_helper()

  def init_helper(self):
    if self.cur_fork >= self.max_fork:
      raise StopIteration

    self.cur_fork += 1
    self.proc = subprocess.Popen(self.cmdline, shell=True, bufsize=1,
                                 stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
    self.cur_lines_to_skip = self.lines_to_skip
    print >>sys.stderr, "forked #%d pid %d for (%s)" % (
      self.cur_fork, self.proc.pid, self.cmdline)

  def next(self):
    while True:
      line = self.proc.stdout.readline().rstrip()
      # print 'ScanReFork (%d) read : %s' % (self.cur_fork, line)
      if not line:
        self.init_helper()
        continue
      elif self.cur_lines_to_skip > 0:
        self.cur_lines_to_skip -= 1
        continue
      else:
        return line

class FilterEquals(MyIterable):
  def __init__(self, pos, value, iterable, iostat_hack=False):
    self.pos = pos
    self.value = value
    self.iter = iterable
    self.iostat_hack = iostat_hack

  def next(self):
    while True:
      lines = self.iter.next()
      for line in lines.split('\n'):
        cols = line.split()
        if len(cols) >= (self.pos + 1) and cols[self.pos] == self.value:
          return line
        # Ugly hack for long device name split over 2 lines
        # elif self.iostat_hack and len(cols) == 1 and cols[self.pos] == self.value:
        # return '%s %s' % (self.value, self.iter.next())

class Project(MyIterable):
  def  __init__(self, pos, iterable):
    self.pos = pos
    self.iter = iter(iterable)

  def next(self):
    line = self.iter.next()
    cols = line.split()
    try:
      v = float(cols[self.pos])
      return cols[self.pos]
    except ValueError, e:
      return 0.0

class ProjectByPrefix(MyIterable):
  def __init__(self, separator, prefix, iterable):
    self.separator = separator
    self.prefix = prefix
    self.iter = iter(iterable)
    # print 'ProjectByPrefix searches for %s' % prefix

  def next(self):
    line = self.iter.next()
    cols = line.split(self.separator)
    for c in cols:
      if c.startswith(self.prefix):
        return c[len(self.prefix):].rstrip()
    raise StopIteration    

class ExprAbsToRel(MyIterable):
  def __init__(self, interval, iterable):
    self.interval = interval
    self.iter = iter(iterable)
    self.prev = None

  def next(self):
    current = float(self.iter.next())
    if self.prev is None:
      self.prev = current
      return '0'
    else:
      diff = current - self.prev
      rate = diff / self.interval
      self.prev = current
      return str(rate)

class ExprFunc(MyIterable):
  def __init__(self, func, iterables):
    self.func = func
    self.iters = [iter(i) for i in iterables]

  def next(self):
    return str(self.func([float(i.next()) for i in self.iters]))

class ExprAvg(MyIterable):
  def __init__(self, iterables):
    self.iters = [iter(i) for i in iterables]

  def next(self):
    return str(sum([float(i.next()) for i in self.iters]) / len(self.iters))

class ExprBinaryFunc(MyIterable):
  def __init__(self, func, i1, i2):
    self.func = func
    self.iter1 = iter(i1)
    self.iter2 = iter(i2)

  def next(self):
    return str(self.func(self.iter1.next(), self.iter2.next()))

vmstat_cols = { 'swpd':2, 'free':3, 'buff':4, 'cache':5, 'si':6, 'so':7,
                'bi':8, 'bo':9, 'in':10, 'cs':11, 'us':12, 'sy':13,
                'id':14, 'wa':15 }

iostat_cols = { 'rrqm/s':1, 'wrqm/s':2, 'r/s':3, 'w/s':4, 'rsec/s':5,
                'wsec/s':6,  'avgrq-sz':7, 'avgqu-sz':8, 'await':9,
                'svctm':10, '%util':11 }

flashcache_cols = []

funcs = [ 'sum', 'rate', 'ratesum', 'max', 'avg', 'div' ]

def iostat_get_devices():
  scan_iostat = ScanFork('iostat -x 1 1', 0)
  saw_device = False
  devices = []
  for line in scan_iostat:
    if line.startswith('Device:'):
      saw_device = True
    elif saw_device:
      cols = line.split()
      if cols:
        devices.append(cols[0])
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
        except ValueError, e:
          pass
    connect.close()
    return names
  except MySQLdb.Error, e:
    print 'SHOW GLOBAL STATUS fails (%s)' % e
    return []

def make_basic_expr(arg, ctx, can_expand):
  # print "make_basic_expr for %s" % arg
  arg_parts = arg.split('.')
  pend = len(arg_parts)

  if arg_parts[0] in ['timer', 'timestamp', 'counter']:
    assert pend == 1
    return (arg, ctx.shared_sources[arg_parts[0]])

  elif arg_parts[0] == 'flashcache':
    assert pend >= 2
    assert arg_parts[1] in flashcache_cols
    return (arg, ProjectByPrefix(' ', '%s=' % arg_parts[1], TeeIter(ctx, 'flashcache')))

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

  else:
    print 'validate_arg fails for %s' % arg
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
  # print "parse_input for %s" % arg
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
  # print "parse_func_call for %s, %d" % (func_name, len(func_arg_list))

  name = '%s(%s)' % (func_name, ','.join([e[0] for e in func_arg_list]))

  if func_name == 'rate':
    assert len(func_arg_list) == 1
    return (name, ExprAbsToRel(ctx.interval, func_arg_list[0][1]))

  elif func_name == 'sum':
    assert len(func_arg_list) >= 1
    return (name, ExprFunc(sum, [e[1] for e in func_arg_list]))

  elif func_name == 'ratesum':
    assert len(func_arg_list) >= 1
    sum_iter = ExprFunc(sum, [e[1] for e in func_arg_list])
    return (name, ExprAbsToRel(interval, sum_iter))

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
                 db_name, db_retries, data_sources):
  flashcache_get_cols()
  
  ctx = MstatContext(interval)
  ctx.devices = iostat_get_devices()

  ctx.shared_sources['timer'] = CacheIter(iter(Counter(interval)))
  ctx.shared_sources['timestamp'] = CacheIter(iter(Timestamper()))
  ctx.shared_sources['counter'] = CacheIter(iter(Counter(1)))

  for arg in ['timestamp', 'timer', 'counter']:
    ctx.use_sources[arg] = make_basic_expr(arg, ctx, False)[1]

  for col in flashcache_cols:
    add_source(make_basic_expr('flashcache.%s' % col, ctx, False), ctx.use_sources)
    add_source(parse_input('rate(flashcache.%s)' % col,  ctx, False), ctx.use_sources)

  for dev in ctx.devices:
    for col in iostat_cols:
      add_source(make_basic_expr('iostat.%s.%s' % (dev, col), ctx, False), ctx.use_sources)
      add_source(parse_input('rate(iostat.%s.%s)' % (dev, col), ctx, False), ctx.use_sources)

  for col in vmstat_cols:
    add_source(make_basic_expr('vmstat.%s' % col, ctx, False), ctx.use_sources)
    add_source(parse_input('rate(vmstat.%s)' % col,  ctx, False), ctx.use_sources)

  my_cols = get_my_cols(db_user, db_password, db_host, db_name)
  for col in my_cols:
    add_source(make_basic_expr('my.status.%s' % col, ctx, False), ctx.use_sources)
    add_source(parse_input('rate(my.status.%s)' % col, ctx, False), ctx.use_sources)

  derived_stats =\
    [(('reads', 'read_hits'),
      'div(rate(flashcache.read_hits),rate(flashcache.reads))',
      flashcache_cols),
     (('writes', 'write_hits'),
      'div(rate(flashcache.write_hits),rate(flashcache.writes))',
      flashcache_cols),
     (('Innodb_data_sync_read_requests', 'Innodb_data_sync_read_svc_seconds'),
      'div(rate(my.status.Innodb_data_sync_read_svc_seconds),rate(my.status.Innodb_data_sync_read_requests))',
      my_cols),
     (('Questions', 'Command_seconds'),
      'div(rate(my.status.Command_seconds),rate(my.status.Questions))',
      my_cols)]

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
  tee_used = { 'vmstat':0, 'iostat':0, 'my.status':0, 'flashcache':0 }

  if ctx.counters['flashcache']:
    scan_flashcache = ScanReFork('cat /proc/flashcache_stats', 0, loops+1)
    tee['flashcache'] = itertools.tee(scan_flashcache, ctx.counters['flashcache'])

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

  for i in ctx.tee_iters:
    i.tee_iter = tee[i.type_name][i.index]
    tee_used[i.type_name] += 1

  for i in ['vmstat', 'iostat', 'my.status', 'flashcache']:
    print 'check for %s tee_used %d == ctx.counters %d' % (i, tee_used[i], ctx.counters[i])
    assert tee_used[i] == ctx.counters[i]

  return ctx

def parse_opts(args):
  parser = optparse.OptionParser()
  parser.add_option("--db_user", action="store",
                    type="string",dest="db_user",
                    default="root",
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
                    " to those listed on the command line")
  parser.add_option("--interval", action="store",
                    type="int", dest="interval",
                    default="10",
                    help="Report every interval seconds")
  parser.add_option("--loops", action="store",
                    type="int", dest="loops",
                    default="10",
                    help="Stop after this number of intervals")
  return parser.parse_args(args)

def main(argv=None):
  if argv is None:
    argv = sys.argv
  options, args = parse_opts(argv[1:])

  ctx = build_inputs(args, options.interval, options.loops,
                     options.db_user, options.db_password,
                     options.db_host, options.db_name, options.db_retries,
                     options.data_sources)

  keys = ctx.use_sources.keys()
  keys.sort()

  i=1
  for k in keys:
    print '%d %s' % (i, k)
    i += 1

  print 'START'

  shared_iters = [v for k,v in ctx.shared_sources.iteritems()]
  use_iters = [iter(ctx.use_sources[k]) for k in keys]

  try:
    for x in xrange(options.loops):
      shared_vals = [i.cache_next() for i in shared_iters]

      print ' '.join([i.next() for i in use_iters])
      time.sleep(options.interval)
  except StopIteration, e:
    pass

if __name__ == "__main__":
    sys.exit(main())
