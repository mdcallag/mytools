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

"""The autoincrement benchmark.

   This tests performance on a table with one auto increment column
   with 1 or more sessions inserting and 1 or more sessions running
   queries.

   A typical command line is:
     aibench.py --db_user=foo --db_password=bar --max_rows=1000000000

   Results are printed after each rows_per_reports rows are inserted.
   The output is:
     Legend:
       #rows = total number of rows inserted
       #seconds = number of seconds for the last insert batch
       #total_seconds = total number of seconds the test has run
       table_size = actual table size (inserts - deletes)
       cum_ips = #rows / #total_seconds
       last_ips = #rows / #seconds
       #queries = total number of queries
       cum_qps = #queries / #total_seconds
       last_ips = #queries / #seconds
       #rows #seconds table_size cum_ips last_ips #queries cum_qps last_qps
     1000000 895 1118 1000000 1118 5990 5990 7 7
     2000000 1897 1054 2000000 998 53488 47498 28 47
"""

__author__ = 'Mark Callaghan'
__author__ = 'Anon from Tokutek'

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
DEFINE_string('db_name', 'test', 'Name of database for the test')
DEFINE_string('db_user', 'root', 'DB user for the test')
DEFINE_string('db_password', '', 'DB password for the test')
DEFINE_string('db_host', 'localhost', 'Hostname for the test')
DEFINE_integer('max_rows', 10000, 'Number of rows to insert')
DEFINE_integer('rows_per_report', 1000000,
               '#rows per progress report printed to stdout. If this '
               'is too small, some rates may be negative.')
DEFINE_integer('rows_per_query', 100,
               'Number of rows per to fetch per query.')
DEFINE_integer('num_query_sessions', 1,
               'Number of concurrent sessions doing queries.')
DEFINE_integer('num_insert_sessions', 1,
               'Number of concurrent sessions doing inserts.')
DEFINE_string('table_name', 'autoinc',
              'Name of table to use')
DEFINE_boolean('setup', False,
               'Create table. Drop and recreate if it exists.')
DEFINE_integer('warmup', 0, 'TODO')
DEFINE_string('db_socket', '/tmp/mysql.sock', 'socket for mysql connect')
DEFINE_string('db_config_file', '', 'MySQL configuration file')
DEFINE_boolean('read_uncommitted', False, 'Set cursor isolation level to read uncommitted')
DEFINE_integer('unique_checks', 1, 'Set unique_checks')


#
# iibench
#

insert_done='insert_done'

def get_conn():
  return MySQLdb.connect(host=FLAGS.db_host, user=FLAGS.db_user,
                         db=FLAGS.db_name, passwd=FLAGS.db_password,
                         unix_socket=FLAGS.db_socket,
                         read_default_file=FLAGS.db_config_file)

def create_table():
  conn = get_conn()
  cursor = conn.cursor()
  cursor.execute('drop table if exists %s' % FLAGS.table_name)
  cursor.execute('create table %s ( '
                 'id int not null auto_increment, '
                 'value int not null, '
                 'primary key (id)) '
                 'engine=%s' % (FLAGS.table_name, FLAGS.engine))
  cursor.close()
  conn.close()

def Query(shared_arr, shared_index):
  try:
    QueryWork(shared_arr, shared_index)
  except:
    print 'Query session %d has exception %s' % (shared_index, sys.exc_info()[0])

def QueryWork(shared_arr, shared_index):
  db_conn = get_conn()

  start_time = time.time()
  loops = 0

  cursor = db_conn.cursor()
  cursor.execute('set autocommit=1')

  if FLAGS.read_uncommitted:
    cursor.execute('set transaction isolation level read uncommitted')

  while True:
    query = ('select value from %s order by id desc limit %d' %
             (FLAGS.table_name, FLAGS.rows_per_query))
    cursor.execute(query)
    count = len(cursor.fetchall())

    loops += 1
    if (loops % 4) == 0:
      shared_arr[shared_index] = loops

  cursor.close()
  db_conn.close()

def get_latest(counters):
  total = 0
  for c in counters:
    total += c
  return total

def get_max_pk(cursor):
  cursor.execute('select max(id) from %s' % FLAGS.table_name)
  # catch empty database
  try:
    return int(cursor.fetchall()[0][0])
  except:
    return 0

def print_report(insert_arr, query_arr, first_pk, prev_time, start_time,
                 prev_sum_inserts, prev_sum_queries):
  now = time.time()

  if FLAGS.num_query_sessions:
    sum_queries = get_latest(query_arr)
  else:
    sum_queries = 0

  sum_inserts = get_latest(insert_arr)

  print '%d %.1f %.1f %d %.1f %.1f %d %.1f %.1f' % (
    sum_inserts + first_pk,
    now - prev_time,
    now - start_time,
    sum_inserts,
    sum_inserts / (now - start_time),
    (sum_inserts - prev_sum_inserts) / (now - prev_time),
    sum_queries,
    sum_queries / (now - start_time),
    (sum_queries - prev_sum_queries) / (now - prev_time))
  sys.stdout.flush()
  return now, sum_queries, sum_inserts

def Insert(insert_arr, query_arr, insert_index):
  try:
    InsertWork(insert_arr, query_arr, insert_index)
  except:
    print 'Insert session %d has exception %s' % (insert_index, sys.exc_info()[0])

def InsertWork(insert_arr, query_arr, insert_index):
  start_time = time.time()
  prev_time = start_time

  prev_sum_queries = 0
  prev_sum_inserts = 0
  update = 0

  db_conn = get_conn()
  cursor = db_conn.cursor()

  if FLAGS.engine == 'tokudb':
    cursor.execute('set tokudb_commit_sync=0')
  cursor.execute('set autocommit=1')
  cursor.execute('set unique_checks=%d' % (FLAGS.unique_checks))

  first_pk = get_max_pk(cursor)
  max_rows = FLAGS.max_rows / FLAGS.num_insert_sessions
  if not insert_index:
    max_rows = FLAGS.max_rows - (max_rows * (FLAGS.num_insert_sessions - 1))

  for inserted in xrange(1, max_rows + 1):
    sql = 'insert into %s (id,value) values (NULL,1)' % FLAGS.table_name
    cursor.execute(sql)

    update += 1
    if (update == 100):
      insert_arr[insert_index] += update
      update = 0

    # The first insert session reports stats
    if not insert_index and (inserted % FLAGS.rows_per_report) == 0:
      (prev_time, prev_sum_queries, prev_sum_inserts) = \
          print_report(insert_arr, query_arr, first_pk, prev_time,
                       start_time, prev_sum_inserts, prev_sum_queries)

  insert_arr[insert_index] += update

  if not insert_index:
    while prev_sum_inserts != FLAGS.max_rows:
      time.sleep(0.5)
      (prev_time, prev_sum_queries, prev_sum_inserts) = \
          print_report(insert_arr, query_arr, first_pk, prev_time,
                       start_time, prev_sum_inserts, prev_sum_queries)

  cursor.close()
  db_conn.close()

def run_benchmark():
  random.seed(3221223452)

  if FLAGS.setup:
    create_table()

  query_arr = Array('i', [0 for x in xrange(FLAGS.num_query_sessions)])
  query_sessions = []
  for x in xrange(FLAGS.num_query_sessions):
    query_sessions.append(Process(target=Query, args=(query_arr, x)))

  insert_arr = Array('i', [0 for x in xrange(FLAGS.num_insert_sessions)])
  insert_sessions = []
  for x in xrange(FLAGS.num_insert_sessions):
    insert_sessions.append(Process(target=Insert, args=(insert_arr, query_arr, x)))

  # start up the insert execution process with this queue
  for x in xrange(FLAGS.num_insert_sessions):
    insert_sessions[x].start()

  # start up the query processes
  for x in xrange(FLAGS.num_query_sessions):
    query_sessions[x].start()

  # block until the inserter is done
  for x in xrange(FLAGS.num_insert_sessions):
    insert_sessions[x].join()
    insert_sessions[x].terminate()

  for x in xrange(FLAGS.num_query_sessions):
    query_sessions[x].terminate()

  print 'Done'

def main(argv):
  print '#rows #seconds #total_seconds table_size cum_ips last_ips #queries cum_qps last_qps'
  run_benchmark()
  return 0

if __name__ == '__main__':
  new_argv = ParseArgs(sys.argv[1:])
  sys.exit(main([sys.argv[0]] + new_argv))
