#!/usr/bin/python -W ignore::DeprecationWarning
#
# Copyright (C) 2009 Google Inc.
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

"""Implements a modified version of the insert benchmark as defined by Tokutek.

   A typical command line is:
     iibench.py --db_user=foo --db_password=bar --max_rows=1000000000

   Results are printed after each rows_per_reports rows are inserted.
   The output is:
     Legend:
       #rows = total number of rows inserted
       #seconds = number of seconds for the last insert batch
       #total_seconds = total number of seconds the test has run
       cum_ips = #rows / #total_seconds
       table_size = actual table size (inserts - deletes)
       last_ips = #rows / #seconds
       #queries = total number of queries
       cum_qps = #queries / #total_seconds
       last_ips = #queries / #seconds
       #rows #seconds cum_ips table_size last_ips #queries cum_qps last_qps
     1000000 895 1118 1000000 1118 5990 5990 7 7
     2000000 1897 1054 2000000 998 53488 47498 28 47

  The insert benchmark is defined at http://blogs.tokutek.com/tokuview/iibench

  This differs with the original by running queries concurrent with the inserts.
  For procesess are started and each is assigned one of the indexes. Each
  process then runs index-only queries in a loop that scan and fetch data
  from rows_per_query index entries.

  This depends on multiprocessing which is only in Python 2.6. Backports to
  2.4 and 2.5 are at http://code.google.com/p/python-multiprocessing
"""

__author__ = 'Mark Callaghan'

import os
import base64
import string
from multiprocessing import Queue, Process, Pipe, Array, Lock
import optparse
from datetime import datetime
import time
import random
import sys
import math

#
# flags module, on loan from gmt module by Chip Turner.
#

FLAGS = optparse.Values()
parser = optparse.OptionParser()

letters_and_digits = string.letters + string.digits

def DEFINE_string(name, default, description, short_name=None):
  if default is not None and default != '':
    description = "%s (default: %s)" % (description, default)
  args = [ "--%s" % name ]
  if short_name is not None:
    args.insert(0, "-%s" % short_name)

  parser.add_option(type="string", help=description, *args)
  parser.set_default(name, default)
  setattr(FLAGS, name, default)

def DEFINE_integer(name, default, description, short_name=None):
  if default is not None and default != '':
    description = "%s (default: %s)" % (description, default)
  args = [ "--%s" % name ]
  if short_name is not None:
    args.insert(0, "-%s" % short_name)

  parser.add_option(type="int", help=description, *args)
  parser.set_default(name, default)
  setattr(FLAGS, name, default)

def DEFINE_boolean(name, default, description, short_name=None):
  if default is not None and default != '':
    description = "%s (default: %s)" % (description, default)
  args = [ "--%s" % name ]
  if short_name is not None:
    args.insert(0, "-%s" % short_name)

  parser.add_option(action="store_true", help=description, *args)
  parser.set_default(name, default)
  setattr(FLAGS, name, default)

def ParseArgs(argv):
  usage = sys.modules["__main__"].__doc__
  parser.set_usage(usage)
  unused_flags, new_argv = parser.parse_args(args=argv, values=FLAGS)

  if FLAGS.mongo:
    globals()['pymongo'] = __import__('pymongo')
  else:
    globals()['MySQLdb'] = __import__('MySQLdb')

  return new_argv

def ShowUsage():
  parser.print_help()

#
# options
#

DEFINE_integer('data_length_max', 10, 'Max size of data in data column')
DEFINE_integer('data_length_min', 10, 'Min size of data in data column')
DEFINE_integer('data_random_pct', 50, 'Percentage of row that has random data')
DEFINE_integer('rows_per_commit', 1000, '#rows per transaction')
DEFINE_integer('rows_per_report', 1000000,
               '#rows per progress report printed to stdout. If this '
               'is too small, some rates may be negative.')
DEFINE_integer('rows_per_query', 10,
               'Number of rows per to fetch per query. Each query '
               'thread does one query per insert.')
DEFINE_integer('cashregisters', 1000, '# cash registers')
DEFINE_integer('products', 10000, '# products')
DEFINE_integer('customers', 100000, '# customers')
DEFINE_integer('max_price', 500, 'Maximum value for price column')
DEFINE_integer('max_rows', 10000, 'Number of rows to insert')
DEFINE_boolean('no_inserts', False, 'When True don''t do inserts')
DEFINE_boolean('query_pk_only', False, 'When True only query PK index')
DEFINE_integer('query_threads', 0, 'Number of query threads')
DEFINE_boolean('setup', False,
               'Create table. Drop and recreate if it exists.')
DEFINE_integer('warmup', 0, 'TODO')
DEFINE_integer('max_table_rows', 10000000, 'Maximum number of rows in table')
DEFINE_boolean('with_max_table_rows', False,
               'When True, allow table to grow to max_table_rows, then delete oldest')
DEFINE_integer('sequential', 1, 'Insert in sequential PK order')
DEFINE_integer('num_secondary_indexes', 3, 'Number of secondary indexes (0 to 3)')
DEFINE_integer('inserts_per_second', 0, 'Rate limit for inserts')
DEFINE_integer('seed', 3221223452, 'RNG seed')

# MySQL & MongoDB flags
DEFINE_string('db_host', 'localhost', 'Hostname for the test')
DEFINE_string('db_name', 'test', 'Name of database for the test')
DEFINE_string('table_name', 'purchases_index', 'Name of table to use')

# MySQL flags
DEFINE_string('engine', 'innodb', 'Storage engine for the table')
DEFINE_string('engine_options', '', 'Options for create table')
DEFINE_string('db_user', 'root', 'DB user for the test')
DEFINE_string('db_password', '', 'DB password for the test')
DEFINE_string('db_config_file', '', 'MySQL configuration file')
DEFINE_string('db_socket', '/tmp/mysql.sock', 'socket for mysql connect')
DEFINE_integer('unique_checks', 1, 'Set unique_checks')

# MongoDB flags
DEFINE_boolean('mongo', False, 'if True then for MongoDB, else for MySQL')
DEFINE_integer('mongo_w', 1, 'Value for MongoDB write concern: w')
DEFINE_boolean('mongo_j', False, 'Value for MongoDB write concern: j')
DEFINE_boolean('mongo_fsync', False, 'Value for MongoDB write concern: fsync')
DEFINE_string('name_cash', 'cashregisterid', 'Name for cashregisterid attribute')
DEFINE_string('name_cust', 'customerid', 'Name for customerid attribute')
DEFINE_string('name_ts', 'dateandtime', 'Name for dateandtime attribute')
DEFINE_string('name_price', 'price', 'Name for price attribute')
DEFINE_string('name_prod', 'product', 'Name for product attribute')
DEFINE_string('name_data', 'data', 'Name for data attribute')

#
# iibench
#

insert_done='insert_done'

def get_conn():
  if FLAGS.mongo:
    return pymongo.MongoClient("mongodb://%s:27017" % FLAGS.db_host)
  else:
    return MySQLdb.connect(host=FLAGS.db_host, user=FLAGS.db_user,
                           db=FLAGS.db_name, passwd=FLAGS.db_password,
                           unix_socket=FLAGS.db_socket, read_default_file=FLAGS.db_config_file)

def create_table_mongo():
  conn = get_conn()
  db = conn[FLAGS.db_name]
  db.drop_collection(FLAGS.table_name)

  if FLAGS.num_secondary_indexes >= 1:
    db[FLAGS.table_name].create_index([(FLAGS.name_price, pymongo.ASCENDING),
                                       (FLAGS.name_cust, pymongo.ASCENDING)], name="pc")
  if FLAGS.num_secondary_indexes >= 2:
    db[FLAGS.table_name].create_index([(FLAGS.name_cash, pymongo.ASCENDING),
                                       (FLAGS.name_price, pymongo.ASCENDING),
                                       (FLAGS.name_cust, pymongo.ASCENDING)], name="cpc")
  if FLAGS.num_secondary_indexes >= 3:
    db[FLAGS.table_name].create_index([(FLAGS.name_price, pymongo.ASCENDING),
                                       (FLAGS.name_ts, pymongo.ASCENDING),
                                       (FLAGS.name_cust, pymongo.ASCENDING)], name="pdc")

def create_table_mysql():
  conn = get_conn()
  cursor = conn.cursor()
  cursor.execute('drop table if exists %s' % FLAGS.table_name)

  ddl_sql = 'transactionid int not null auto_increment, '\
            'dateandtime datetime, '\
            'cashregisterid int not null, '\
            'customerid int not null, '\
            'productid int not null, '\
            'price float not null, '\
            'data varchar(4000), '\
            'primary key (transactionid) '

  ddl_sql = 'create table %s ( %s ) engine=%s %s' % (
      FLAGS.table_name, ddl_sql, FLAGS.engine, FLAGS.engine_options)
  print ddl_sql
  cursor.execute(ddl_sql)

  if FLAGS.num_secondary_indexes >= 1:
    cursor.execute("alter table %s add index marketsegment (price, customerid) "
                   % FLAGS.table_name)
  if FLAGS.num_secondary_indexes >= 2:
    cursor.execute("alter table %s add index registersegment (cashregisterid, price, customerid) "
                   % FLAGS.table_name)
  if FLAGS.num_secondary_indexes >= 3:
    cursor.execute("alter table %s add index pdc (price, dateandtime, customerid) "
                   % FLAGS.table_name)

  cursor.close()
  conn.close()

def create_table():
  if FLAGS.mongo:
    create_table_mongo()
  else:
    create_table_mysql()

def get_max_pk_mongo(conn):
  docs = conn[FLAGS.db_name][FLAGS.table_name].find({}).sort([('_id', pymongo.DESCENDING)]).limit(1)
  for d in docs:
    return d['_id']
  return 0

def get_max_pk_mysql(conn):
  cursor = conn.cursor()
  cursor.execute('select max(transactionid) from %s' % FLAGS.table_name)
  # catch empty database
  try:
    max_pk = int(cursor.fetchall()[0][0])
  except:
    max_pk = 0
  cursor.close()
  return max_pk

def get_max_pk(conn):
  if FLAGS.mongo:
    return get_max_pk_mongo(conn)
  else:
    return get_max_pk_mysql(conn)

def generate_cols(rand_data_buf):
  cashregisterid = random.randrange(0, FLAGS.cashregisters)
  productid = random.randrange(0, FLAGS.products)
  customerid = random.randrange(0, FLAGS.customers)
  price = ((random.random() * FLAGS.max_price) + customerid) / 100.0
  data_len = random.randrange(FLAGS.data_length_min, FLAGS.data_length_max+1)
  # multiply by 0.75 to account of base64 overhead
  rand_data_len = int(data_len * 0.75 * (float(FLAGS.data_random_pct) / 100))
  rand_data_off = random.randrange(0, len(rand_data_buf) - rand_data_len)
  nonrand_data_len = data_len - rand_data_len

  data = '%s%s' % ('a' * nonrand_data_len,
      rand_data_buf[rand_data_off:(rand_data_off+rand_data_len)])
  return cashregisterid, productid, customerid, price, data

def generate_row_mongo(when, max_pk, is_sequential, rand_data_buf):
  cashregisterid, productid, customerid, price, data = generate_cols(rand_data_buf)
  if is_sequential:
    pk = max_pk + 1
  else:
    pk = random.randrange(1, max_pk+1)

  return {'_id' : pk, FLAGS.name_ts : when, FLAGS.name_cash : cashregisterid,
          FLAGS.name_cust : customerid, FLAGS.name_prod : productid,
          FLAGS.name_price : price, FLAGS.name_data : data }

def generate_row_mysql(when, max_pk, is_sequential, rand_data_buf):
  cashregisterid, productid, customerid, price, data = generate_cols(rand_data_buf)
  if is_sequential:
    return '("%s",%d,%d,%d,%.2f,"%s")' % (
        when,cashregisterid,customerid,productid,price,data)
  else:
    return '(%d,"%s",%d,%d,%d,%.2f,"%s")' % (
        random.randrange(1, max_pk+1),
        when,cashregisterid,customerid,productid,price,data)

def generate_row(when, max_pk, is_sequential, rand_data_buf):
  if FLAGS.mongo:
    return generate_row_mongo(when, max_pk, is_sequential, rand_data_buf)
  else:
    return generate_row_mysql(when, max_pk, is_sequential, rand_data_buf)

def generate_pdc_query_mongo(row_count, conn, price):
  # print "query pdc"
  return (
           conn.find({FLAGS.name_price: {'$gte' : price }},
                     fields = {FLAGS.name_price:1, FLAGS.name_ts:1, FLAGS.name_cust:1, '_id':0})
               .sort([(FLAGS.name_price, pymongo.ASCENDING),
                      (FLAGS.name_ts, pymongo.ASCENDING),
                      (FLAGS.name_cust, pymongo.ASCENDING)])
               .limit(FLAGS.rows_per_query)
               .hint([(FLAGS.name_price, pymongo.ASCENDING),
                      (FLAGS.name_ts, pymongo.ASCENDING),
                      (FLAGS.name_cust, pymongo.ASCENDING)])
         )

def generate_pdc_query_mysql(row_count, conn, price):
  sql = 'SELECT price,dateandtime,customerid FROM %s FORCE INDEX (pdc) WHERE '\
        '(price>=%.2f) '\
        'ORDER BY price,dateandtime,customerid '\
        'LIMIT %d' % (FLAGS.table_name, price, FLAGS.rows_per_query)
  return sql

def generate_pdc_query(row_count, conn):
  customerid = random.randrange(0, FLAGS.customers)
  price = ((random.random() * FLAGS.max_price) + customerid) / 100.0

  if FLAGS.mongo:
    return generate_pdc_query_mongo(row_count, conn, price)
  else:
    return generate_pdc_query_mysql(row_count, conn, price)

def generate_pk_query_mongo(row_count, conn, pk_txid):
  # print "query pk"
  if FLAGS.rows_per_query > 1:
    return (
             conn.find({'_id': {'$gte' : pk_txid}})
                 .sort('_id')
                 .limit(FLAGS.rows_per_query)
           )
  else:
    return conn.find_one({'_id': pk_txid})
 
def generate_pk_query_mysql(row_count, conn, pk_txid):
  if FLAGS.rows_per_query > 1:
    sql = 'SELECT * FROM %s WHERE transactionid >= %d ORDER BY transactionid LIMIT %d' % (
      FLAGS.table_name, pk_txid, FLAGS.rows_per_query)
  else:
    sql = 'SELECT * FROM %s WHERE transactionid = %d' % (FLAGS.table_name, pk_txid)

  return sql

def generate_pk_query(row_count, conn):
  if FLAGS.with_max_table_rows and row_count > FLAGS.max_table_rows :
    pk_txid = row_count - FLAGS.max_table_rows + random.randrange(FLAGS.max_table_rows)
  else:
    pk_txid = random.randrange(max(row_count,1))

  if FLAGS.mongo:
    return generate_pk_query_mongo(row_count, conn, pk_txid)
  else:
    return generate_pk_query_mysql(row_count, conn, pk_txid)

def generate_market_query_mongo(row_count, conn, price):
  # print "query market"
  return (
           conn.find({FLAGS.name_price: {'$gte' : price}}, 
                     fields = {FLAGS.name_price:1, FLAGS.name_cust:1, '_id':0})
               .sort([(FLAGS.name_price, pymongo.ASCENDING),
                      (FLAGS.name_cust, pymongo.ASCENDING)])
               .limit(FLAGS.rows_per_query)
               .hint([(FLAGS.name_price, pymongo.ASCENDING),
                      (FLAGS.name_cust, pymongo.ASCENDING)])
         )
 
def generate_market_query_mysql(row_count, conn, price):
  sql = 'SELECT price,customerid FROM %s FORCE INDEX (marketsegment) WHERE '\
        '(price>=%.2f) '\
        'ORDER BY price,customerid '\
        'LIMIT %d' % (FLAGS.table_name, price, FLAGS.rows_per_query)
  return sql

def generate_market_query(row_count, conn):
  customerid = random.randrange(0, FLAGS.customers)
  price = ((random.random() * FLAGS.max_price) + customerid) / 100.0

  if FLAGS.mongo:
    return generate_market_query_mongo(row_count, conn, price)
  else:
    return generate_market_query_mysql(row_count, conn, price)

def generate_register_query_mongo(row_count, conn, cashregisterid):
  # print "query register"
  return (
           conn.find({FLAGS.name_cash: {'$gte' : cashregisterid}}, 
                     fields = {FLAGS.name_cash:1, FLAGS.name_price:1, FLAGS.name_cust:1, '_id':0})
               .sort([(FLAGS.name_cash, pymongo.ASCENDING),
                      (FLAGS.name_price, pymongo.ASCENDING),
                      (FLAGS.name_cust, pymongo.ASCENDING)])
               .limit(FLAGS.rows_per_query)
               .hint([(FLAGS.name_cash, pymongo.ASCENDING),
                      (FLAGS.name_price, pymongo.ASCENDING),
                      (FLAGS.name_cust, pymongo.ASCENDING)])
         )
 
def generate_register_query_mysql(row_count, conn, cashregisterid):
  sql = 'SELECT cashregisterid,price,customerid FROM %s '\
        'FORCE INDEX (registersegment) WHERE '\
        '(cashregisterid>%d) '\
        'ORDER BY cashregisterid,price,customerid '\
        'LIMIT %d' % (FLAGS.table_name, cashregisterid, FLAGS.rows_per_query)
  return sql

def generate_register_query(row_count, conn):
  cashregisterid = random.randrange(0, FLAGS.cashregisters)

  if FLAGS.mongo:
    return generate_register_query_mongo(row_count, conn, cashregisterid)
  else:
    return generate_register_query_mysql(row_count, conn, cashregisterid)

def generate_insert_rows_sequential(row_count, rand_data_buf):
  if FLAGS.mongo:
    when = datetime.utcnow()
  else:
    when = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))

  rows = [generate_row(when, row_count + i, True, rand_data_buf) \
      for i in range(min(FLAGS.rows_per_commit, FLAGS.max_rows))]

  if FLAGS.mongo:
    return rows
  else:
    sql_data = ',\n'.join(rows)
    return 'insert into %s '\
           '(dateandtime,cashregisterid,customerid,productid,price,data) '\
           'values %s' % (FLAGS.table_name, sql_data)

def generate_insert_rows_random(row_count, rand_data_buf):
  if FLAGS.mongo:
    when = datetime.utcnow()
  else:
    when = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))

  rows = [generate_row(when, FLAGS.max_table_rows, False, rand_data_buf) \
      for i in range(min(FLAGS.rows_per_commit, FLAGS.max_rows))]

  if FLAGS.mongo:
    assert 0
  else:
    sql_data = ',\n'.join(rows)
    return 'replace into %s '\
           '(transactionid,dateandtime,cashregisterid,customerid,productid,price,data) '\
           'values %s' % (FLAGS.table_name, sql_data)

def Query(query_args, shared_arr, lock):

  # block on this until main thread wants all processes to run
  lock.acquire()
  lock.release()

  db_conn = get_conn()

  # assume it is 0, row_count will soon be corrected
  row_count = 0
  start_time = time.time()
  loops = 0

  if FLAGS.mongo:
    db_thing = db_conn[FLAGS.db_name][FLAGS.table_name]
  else:
    db_conn.autocommit(True)
    db_thing = db_conn.cursor()

  while True:
    query_func = random.choice(query_args)

    try:
      query = query_func(row_count, db_thing)

      if FLAGS.mongo:
        count = 0
        for r in query:
          count += 1
        # if count: print 'fetched %d' % count
        # print 'fetched %d' % count
      else:
        # print "Query is:", query
        db_thing.execute(query)
        count = len(db_thing.fetchall())
    except:
      e = sys.exc_info()[0]
      print "Query exception"
      print e  

    loops += 1
    if (loops % 4) == 0:
      if not FLAGS.no_inserts:
        row_count = shared_arr[0]
      shared_arr[1] = loops

  if not FLAGS.mongo:
    db_thing.close()
  db_conn.close()

def get_latest(counters, row_count):
  total = 0
  for c in counters:
    total += c[1]
    c[0] = row_count
  return total

def print_stats(counters, max_pk, inserted, prev_time, prev_sum, start_time, table_size):
  now = time.time()
  sum_queries = 0

  if FLAGS.query_threads:
    sum_queries = get_latest(counters, max_pk + inserted)

  if FLAGS.sequential:
    nrows = inserted + max_pk
  else:
    nrows = inserted

  print '%d %.1f %.1f %.1f %d %.1f %.0f %.1f %.1f' % (
      nrows,
      now - prev_time,
      now - start_time,
      inserted / (now - start_time),
      table_size,
      FLAGS.rows_per_report / (now - prev_time),
      sum_queries,
      sum_queries / (now - start_time),
      (sum_queries - prev_sum) / (now - prev_time))
  sys.stdout.flush()
  return now, sum_queries

def Insert(rounds, insert_q, counters, lock):
  # block on this until main thread wants all processes to run
  lock.acquire()
  lock.release()

  if FLAGS.setup:
    max_pk = 0
  else:
    conn = get_conn()
    max_pk = get_max_pk(conn)
    conn.close()

  for c in counters:
    c[0] = max_pk

  # generate insert rows in this loop and place into queue as they're
  # generated.  The execution process will pull them off from here.
  start_time = time.time()
  prev_time = start_time
  inserted = 0

  prev_sum = 0
  table_size = 0
  # we use the tail pointer for deletion - it tells us the first row in the
  # table where we should start deleting
  tail = 0
  sum_queries = 0

  rand_data_buf = base64.b64encode(os.urandom(1024 * 1024 * 4))

  rounds_per_second = 0
  if (FLAGS.inserts_per_second):
    rounds_per_second = int(math.ceil(float(FLAGS.inserts_per_second) / FLAGS.rows_per_commit))
    if rounds_per_second < 1:
      rounds_per_second = 1
    last_check = time.time()
    # print "rounds per second = %d" % rounds_per_second

  for r in xrange(rounds):
    if FLAGS.sequential:
      rows = generate_insert_rows_sequential(max_pk + inserted, rand_data_buf)
    else:
      rows = generate_insert_rows_random(FLAGS.max_table_rows, rand_data_buf)

    insert_q.put(rows)
    inserted += FLAGS.rows_per_commit
    table_size += FLAGS.rows_per_commit

    if (inserted % FLAGS.rows_per_report) == 0:
      prev_time, prev_sum = \
          print_stats(counters, max_pk, inserted, prev_time, prev_sum,
                      start_time, table_size)

    # deletes
    if FLAGS.with_max_table_rows:
      if table_size > FLAGS.max_table_rows:
        if FLAGS.mongo:
          assert False
        else:
          sql = ('delete from %s where(transactionid>=%d and transactionid<%d);'
                 % (FLAGS.table_name, tail, tail + FLAGS.rows_per_commit))
        insert_q.put(sql)
        table_size -= FLAGS.rows_per_commit
        tail += FLAGS.rows_per_commit

    # optionally enforce write rate limit
    if rounds_per_second and (r % rounds_per_second) == 0:
      # print "check time on %d" % r
      now = time.time()
      if now > last_check and now < (last_check + 0.95):
        sleep_time = 1.0 - (now - last_check)
        # print "sleep %s" % sleep_time
        time.sleep(sleep_time)
      last_check = time.time()

  # block until the queue is empty
  insert_q.put(insert_done)
  insert_q.close()

def statement_executor(stmt_q, lock):
  # block on this until main thread wants all processes to run
  lock.acquire()
  lock.release()

  db_conn = get_conn()
  if not FLAGS.mongo and not FLAGS.unique_checks:
    cursor = db_conn.cursor()
    if FLAGS.engine.lower() == 'rocksdb':
      cursor.execute('set rocksdb_skip_unique_check=1')
    elif FLAGS.engine.lower() == 'tokudb':
      cursor.execute('set unique_checks=0')
    cursor.close()

  if FLAGS.mongo:
    collection = db_conn[FLAGS.db_name][FLAGS.table_name]
    # db_conn.write_concern['w'] = FLAGS.mongo_w
    # db_conn.write_concern['j'] = FLAGS.mongo_j
    # db_conn.write_concern['fsync'] = FLAGS.mongo_fsync
    # print "w, j, fsync : %s, %s, %s" % (FLAGS.mongo_w, FLAGS.mongo_j, FLAGS.mongo_fsync)
  else:
    db_conn.autocommit(True)
    cursor = db_conn.cursor()

  while True:
    stmt = stmt_q.get()  # get the statement we need to execute from the queue

    if stmt == insert_done:
      break

    if FLAGS.mongo:
      try:
        # TODO options for these
        res = collection.insert(stmt, w=FLAGS.mongo_w, j=FLAGS.mongo_j, fsync=FLAGS.mongo_fsync)
        assert len(res) == len(stmt)
      except pymongo.errors.PyMongoError, e:
        print "Mongo error on insert"
        print e
        raise e

    else:
      try:
        cursor.execute(stmt)
      except MySQLdb.Error, e:
        if e[0] != 2006:
          print "Ignoring MySQL exception"
          print e
        else:
          raise e
    
  stmt_q.close()
  db_conn.close()


def run_benchmark():
  random.seed(FLAGS.seed)
  rounds = int(math.ceil(float(FLAGS.max_rows) / FLAGS.rows_per_commit))

  # Lock is held until processes can start running
  lock = Lock()
  lock.acquire()

  # Array of tuples, each tuple is (max_pk, num_queries)
  #   max_pk passes max value of PK to query process
  #   num_queries returns number of queries done by query process
  counters = []

  if FLAGS.query_threads:
    query_args = [generate_pk_query]
    counters.append(Array('i', [0,0]))

    if not FLAGS.query_pk_only:
      query_args.append(generate_pdc_query)
      query_args.append(generate_market_query)
      query_args.append(generate_register_query)
      counters.append(Array('i', [0,0]))
      counters.append(Array('i', [0,0]))
      counters.append(Array('i', [0,0]))

    query_thr = []
    for i in xrange(FLAGS.query_threads):
      query_thr.append(Process(target=Query, args=(query_args, counters[i], lock)))

  if not FLAGS.no_inserts:
    stmt_q = Queue(1)
    insert_delete = Process(target=statement_executor, args=(stmt_q, lock))
    inserter = Process(target=Insert, args=(rounds, stmt_q, counters, lock))

    # start up the insert execution process with this queue
    insert_delete.start()
    inserter.start()

  # start up the query processes
  if FLAGS.query_threads:
    for qthr in query_thr:
      qthr.start()

  if FLAGS.setup:
    create_table()
    max_pk = 0
  else:
    conn = get_conn()
    max_pk = get_max_pk(conn)
    conn.close()

  # After the insert and query processes lock/unlock this they can run
  lock.release()

  if not FLAGS.no_inserts:
    # block until the inserter is done
    insert_delete.join()

  if not FLAGS.no_inserts:
    inserter.terminate()
    insert_delete.terminate()

  if FLAGS.no_inserts:
    start_time = time.time()
    prev_time = start_time
    inserted = 0
    for c in counters:
      c[0] = max_pk

    prev_sum = 0
    table_size = 0
    sum_queries = 0

    while True:
      time.sleep(10)
      prev_time, prev_sum = \
          print_stats(counters, max_pk, inserted, prev_time, prev_sum, start_time, table_size)
      if prev_sum >= FLAGS.max_rows:
        break

  if FLAGS.query_threads:
    for qthr in query_thr:
      qthr.terminate()

  print 'Done'

def main(argv):
  print '#rows #seconds #total_seconds cum_ips table_size last_ips #queries cum_qps last_qps'
  run_benchmark()
  return 0

if __name__ == '__main__':
  new_argv = ParseArgs(sys.argv[1:])
  sys.exit(main([sys.argv[0]] + new_argv))
