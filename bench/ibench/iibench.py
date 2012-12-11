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
import MySQLdb
from multiprocessing import Queue, Process, Pipe, Array
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
  return new_argv

def ShowUsage():
  parser.print_help()

#
# options
#

DEFINE_string('engine', 'innodb', 'Storage engine for the table')
DEFINE_string('engine_options', '', 'Options for create table')
DEFINE_integer('data_length_max', 10, 'Max size of data in data column')
DEFINE_integer('data_length_min', 10, 'Min size of data in data column')
DEFINE_integer('data_random_pct', 50, 'Percentage of row that has random data')
DEFINE_string('db_name', 'test', 'Name of database for the test')
DEFINE_string('db_user', 'root', 'DB user for the test')
DEFINE_string('db_password', '', 'DB password for the test')
DEFINE_string('db_host', 'localhost', 'Hostname for the test')
DEFINE_integer('rows_per_commit', 1000, '#rows per transaction')
DEFINE_integer('rows_per_report', 1000000,
               '#rows per progress report printed to stdout. If this '
               'is too small, some rates may be negative.')
DEFINE_integer('rows_per_query', 1000,
               'Number of rows per to fetch per query. Each query '
               'thread does one query per insert.')
DEFINE_integer('cashregisters', 1000, '# cash registers')
DEFINE_integer('products', 10000, '# products')
DEFINE_integer('customers', 100000, '# customers')
DEFINE_integer('max_price', 500, 'Maximum value for price column')
DEFINE_integer('max_rows', 10000, 'Number of rows to insert')
DEFINE_boolean('insert_only', False,
               'When True, only run the insert thread. Otherwise, '
               'start 4 threads to do queries.')
DEFINE_boolean('no_inserts', False, 'When True don''t do inserts')
DEFINE_boolean('query_pk_only', False, 'When True only query PK index')
DEFINE_string('table_name', 'purchases_index',
              'Name of table to use')
DEFINE_boolean('setup', False,
               'Create table. Drop and recreate if it exists.')
DEFINE_integer('warmup', 0, 'TODO')
DEFINE_string('db_socket', '/tmp/mysql.sock', 'socket for mysql connect')
DEFINE_string('db_config_file', '', 'MySQL configuration file')
DEFINE_integer('max_table_rows', 10000000, 'Maximum number of rows in table')
DEFINE_boolean('with_max_table_rows', False,
               'When True, allow table to grow to max_table_rows, then delete oldest')
DEFINE_boolean('read_uncommitted', False, 'Set cursor isolation level to read uncommitted')
DEFINE_integer('unique_checks', 1, 'Set unique_checks')
DEFINE_integer('tokudb_commit_sync', 1, 'Sync on commit for TokuDB')
DEFINE_integer('sequential', 1, 'Insert in sequential order')
DEFINE_integer('secondary_indexes', 1, 'Use secondary indexes')


#
# iibench
#

insert_done='insert_done'

def get_conn():
  return MySQLdb.connect(host=FLAGS.db_host, user=FLAGS.db_user,
                         db=FLAGS.db_name, passwd=FLAGS.db_password,
                         unix_socket=FLAGS.db_socket, read_default_file=FLAGS.db_config_file)

def create_table():
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

  if FLAGS.secondary_indexes:
    ddl_index = ', key marketsegment (price, customerid), '\
                'key registersegment (cashregisterid, price, customerid), '\
                'key pdc (price, dateandtime, customerid) '
  else:
    ddl_index = ''

  ddl_sql = 'create table %s ( %s %s ) engine=%s %s' % (
      FLAGS.table_name, ddl_sql, ddl_index, FLAGS.engine, FLAGS.engine_options)

  print ddl_sql
  cursor.execute(ddl_sql)
  cursor.close()
  conn.close()

def get_max_pk(conn):
  cursor = conn.cursor()
  cursor.execute('select max(transactionid) from %s' % FLAGS.table_name)
  # catch empty database
  try:
    max_pk = int(cursor.fetchall()[0][0])
  except:
    max_pk = 0
  cursor.close()
  return max_pk

def generate_cols():
  cashregisterid = random.randrange(0, FLAGS.cashregisters)
  productid = random.randrange(0, FLAGS.products)
  customerid = random.randrange(0, FLAGS.customers)
  price = ((random.random() * FLAGS.max_price) + customerid) / 100.0
  data_len = random.randrange(FLAGS.data_length_min, FLAGS.data_length_max+1)
  # multiply by 0.75 to account of base64 overhead
  rand_data_len = int(data_len * 0.75 * (float(FLAGS.data_random_pct) / 100))
  rand_data = base64.b64encode(os.urandom(rand_data_len))
  nonrand_data_len = data_len - len(rand_data)

  data = '%s%s' % ('a' * nonrand_data_len, rand_data)
  return cashregisterid, productid, customerid, price, data

def generate_row(datetime, max_pk):
  cashregisterid, productid, customerid, price, data = generate_cols()
  if not max_pk:
    return '("%s",%d,%d,%d,%.2f,"%s")' % (
        datetime,cashregisterid,customerid,productid,price,data)
  else:
    return '(%d,"%s",%d,%d,%d,%.2f,"%s")' % (
        random.randrange(1, max_pk+1),
        datetime,cashregisterid,customerid,productid,price,data)

def generate_pdc_query(row_count, start_time):
  customerid = random.randrange(0, FLAGS.customers)
  price = ((random.random() * FLAGS.max_price) + customerid) / 100.0

  random_time = ((time.time() - start_time) * random.random()) + start_time
  when = random_time + (random.randrange(max(row_count,1)) / 100000.0)
  datetime = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(when))

  sql = 'SELECT price,dateandtime,customerid FROM %s FORCE INDEX (pdc) WHERE '\
        '(price=%.2f and dateandtime="%s" and customerid>=%d) OR '\
        '(price=%.2f and dateandtime>"%s") OR '\
        '(price>%.2f) LIMIT %d' % (FLAGS.table_name, price,
                                   datetime, customerid,
                                   price, datetime, price,
                                   FLAGS.rows_per_query)
  return sql

def generate_pk_query(row_count, start_time):
  if FLAGS.with_max_table_rows and row_count > FLAGS.max_table_rows :
    pk_txid = row_count - FLAGS.max_table_rows + random.randrange(FLAGS.max_table_rows)
  else:
    pk_txid = random.randrange(max(row_count,1))

  if FLAGS.rows_per_query > 1:
    sql = 'SELECT * FROM %s WHERE transactionid >= %d ORDER BY transactionid LIMIT %d' % (
      FLAGS.table_name, pk_txid, FLAGS.rows_per_query)
  else:
    sql = 'SELECT * FROM %s WHERE transactionid = %d' % (FLAGS.table_name, pk_txid)

  return sql

def generate_market_query(row_count, start_time):
  customerid = random.randrange(0, FLAGS.customers)
  price = ((random.random() * FLAGS.max_price) + customerid) / 100.0

  sql = 'SELECT price,customerid FROM %s FORCE INDEX (marketsegment) WHERE '\
        '(price=%.2f and customerid>=%d) OR '\
        '(price>%.2f) LIMIT %d' % (
      FLAGS.table_name, price, customerid, price, FLAGS.rows_per_query)
  return sql

def generate_register_query(row_count, start_time):
  customerid = random.randrange(0, FLAGS.customers)
  price = ((random.random() * FLAGS.max_price) + customerid) / 100.0
  cashregisterid = random.randrange(0, FLAGS.cashregisters)

  sql = 'SELECT cashregisterid,price,customerid FROM %s '\
        'FORCE INDEX (registersegment) WHERE '\
        '(cashregisterid=%d and price=%.2f and customerid>=%d) OR '\
        '(cashregisterid=%d and price>%.2f) OR '\
        '(cashregisterid>%d) LIMIT %d' % (
      FLAGS.table_name, cashregisterid, price, customerid,
      cashregisterid, price, cashregisterid, FLAGS.rows_per_query)
  return sql

def generate_insert_rows_sequential(row_count):
  when = time.time() + (row_count / 100000.0)
  datetime = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(when))
#  rows = [generate_row(datetime) for i in xrange(FLAGS.rows_per_commit)]
  rows = [generate_row(datetime, 0) for i in range(min(FLAGS.rows_per_commit, FLAGS.max_rows))]
  return ',\n'.join(rows)

def generate_insert_rows_random(row_count):
  when = time.time() + (row_count / 100000.0)
  datetime = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(when))
  rows = [generate_row(datetime, FLAGS.max_table_rows) for i in range(min(FLAGS.rows_per_commit, FLAGS.max_rows))]
  return ',\n'.join(rows)


def Query(max_pk, query_func, shared_arr):
  db_conn = get_conn()

  row_count = max_pk
  start_time = time.time()
  loops = 0

  cursor = db_conn.cursor()
  if FLAGS.read_uncommitted:  cursor.execute('set transaction isolation level read uncommitted')

  while True:
    query = query_func(row_count, start_time)
    cursor.execute(query)
    count = len(cursor.fetchall())
    loops += 1
    if (loops % 4) == 0:
      if not FLAGS.no_inserts:
        row_count = shared_arr[0]
      shared_arr[1] = loops
      if not FLAGS.read_uncommitted:
        cursor.execute('commit')

  cursor.close()
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

  if not FLAGS.insert_only:
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

def Insert(rounds, max_pk, insert_q, pdc_arr, pk_arr, market_arr, register_arr):
  # generate insert rows in this loop and place into queue as they're
  # generated.  The execution process will pull them off from here.
  start_time = time.time()
  prev_time = start_time
  inserted = 0

  counters = [pdc_arr, pk_arr, market_arr, register_arr]
  for c in counters:
    c[0] = max_pk

  prev_sum = 0
  table_size = 0
  # we use the tail pointer for deletion - it tells us the first row in the
  # table where we should start deleting
  tail = 0
  sum_queries = 0

  for r in xrange(rounds):
    if FLAGS.sequential:
      rows = generate_insert_rows_sequential(max_pk + inserted)
      sql = 'insert into %s '\
            '(dateandtime,cashregisterid,customerid,productid,price,data) '\
            'values %s' % (FLAGS.table_name, rows)
    else:
      rows = generate_insert_rows_random(FLAGS.max_table_rows)
      sql = 'replace into %s '\
            '(transactionid,dateandtime,cashregisterid,customerid,productid,price,data) '\
            'values %s' % (FLAGS.table_name, rows)
      # print sql

    insert_q.put(sql)
    inserted += FLAGS.rows_per_commit
    table_size += FLAGS.rows_per_commit

    if (inserted % FLAGS.rows_per_report) == 0:
      prev_time, prev_sum = \
          print_stats(counters, max_pk, inserted, prev_time, prev_sum,
                      start_time, table_size)

    # deletes
    if FLAGS.with_max_table_rows:
      if table_size > FLAGS.max_table_rows:
        sql = ('delete from %s where(transactionid>=%d and transactionid<%d);'
               % (FLAGS.table_name, tail, tail + FLAGS.rows_per_commit))
        insert_q.put(sql)
        table_size -= FLAGS.rows_per_commit
        tail += FLAGS.rows_per_commit

  # block until the queue is empty
  insert_q.put(insert_done)
  insert_q.close()

def statement_executor(stmt_q, db_conn, cursor):

  while True:
    stmt = stmt_q.get()  # get the statement we need to execute from the queue

    if stmt == insert_done: break
    # execute statement and commit
    try:
      cursor.execute(stmt)
      db_conn.commit()
    except MySQLdb.Error, e:
      if e[0] != 2006:
        print "Ignoring MySQL exception"
        print e
        try:
          db_conn.rollback()
          print "Rollback done"
        except MySQLdb.Error, e:
          print "Error on rollback"
          print e
      else:
        raise e
    
  stmt_q.close()

def run_benchmark():
  random.seed(3221223452)
  rounds = int(math.ceil(float(FLAGS.max_rows) / FLAGS.rows_per_commit))

  if FLAGS.setup:
    create_table()
    max_pk = 0
  else:
    conn = get_conn()
    max_pk = get_max_pk(conn)
    conn.close()

  # Get the queries set up
  pdc_count = Array('i', [0,0])
  pk_count = Array('i', [0,0])
  market_count = Array('i', [0,0])
  register_count = Array('i', [0,0])

  if not FLAGS.insert_only:
    query_pk = Process(target=Query, args=(max_pk, generate_pk_query, pk_count))

    if not FLAGS.query_pk_only:
      query_pdc = Process(target=Query, args=(max_pk, generate_pdc_query, pdc_count))
      query_market = Process(target=Query, args=(max_pk, generate_market_query, market_count))
      query_register = Process(target=Query,
                               args=(max_pk, generate_register_query, register_count))

  # set up a queue that will be shared across the insert generation / insert
  # execution processes

  db_conn = get_conn()
  cursor = db_conn.cursor()
  if not FLAGS.tokudb_commit_sync:
    cursor.execute('set tokudb_commit_sync=0')
  cursor.execute('set unique_checks=%d' % (FLAGS.unique_checks))

  if not FLAGS.no_inserts:
    stmt_q = Queue(1)
    insert_delete = Process(target=statement_executor, args=(stmt_q, db_conn, cursor))
    inserter = Process(target=Insert, args=(rounds,max_pk,stmt_q,
                       pdc_count, pk_count, market_count, register_count))

    # start up the insert execution process with this queue
    insert_delete.start()
    inserter.start()

  # start up the query processes
  if not FLAGS.insert_only:
    query_pk.start()
    if not FLAGS.query_pk_only:
      query_pdc.start()
      query_market.start()
      query_register.start()

  if not FLAGS.no_inserts:
    # block until the inserter is done
    insert_delete.join()

  # close the connection and then terminate the insert / delete process
  cursor.close()
  db_conn.close()

  if not FLAGS.no_inserts:
    inserter.terminate()
    insert_delete.terminate()

  if FLAGS.no_inserts:
    start_time = time.time()
    prev_time = start_time
    inserted = 0
    counters = [pdc_count, pk_count, market_count, register_count]
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

  if not FLAGS.insert_only:
    query_pk.terminate()
    if not FLAGS.query_pk_only:
      query_pdc.terminate()
      query_market.terminate()
      query_register.terminate()

  print 'Done'

def main(argv):
  print '#rows #seconds #total_seconds cum_ips table_size last_ips #queries cum_qps last_qps'
  run_benchmark()
  return 0

if __name__ == '__main__':
  new_argv = ParseArgs(sys.argv[1:])
  sys.exit(main([sys.argv[0]] + new_argv))
