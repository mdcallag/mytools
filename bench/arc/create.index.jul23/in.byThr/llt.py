#!/usr/bin/python -W ignore::DeprecationWarning

"""
Implements configurable long-lived transactions to understand their impact
on benchmark performance.
"""

__author__ = 'Mark Callaghan'

import os
import string
import optparse
from datetime import datetime
import time
import random
import sys
import math
import timeit
import traceback
import multiprocessing

#
# flags module, on loan from gmt module by Chip Turner.
#

FLAGS = optparse.Values()
parser = optparse.OptionParser()
pk_name = None
columns = []

def rthist_new():
  obj = {}
  hist = [0,0,0,0,0,0,0,0,0,0]
  obj['hist'] = hist
  obj['max'] = 0
  return obj

def rthist_start(obj):
  return timeit.default_timer()

def rthist_finish(obj, start):
  now = timeit.default_timer()
  elapsed = now - start
  # Linear search assuming the first few buckets get the most responses
  # And when not, then the overhead of this isn't relevant

  if elapsed >= obj['max']:
    obj['max'] = elapsed

  rt = obj['hist']

  if elapsed <= 0.000256:
    rt[0] += 1
  elif elapsed <= 0.001:
    rt[1] += 1
  elif elapsed <= 0.004:
    rt[2] += 1
  elif elapsed <= 0.016:
    rt[3] += 1
  elif elapsed <= 0.064:
    rt[4] += 1
  elif elapsed <= 0.256:
    rt[5] += 1
  elif elapsed <= 1:
    rt[6] += 1
  elif elapsed <= 4:
    rt[7] += 1
  elif elapsed <= 16:
    rt[8] += 1
  else:
    rt[9] += 1

  # Convert to usecs as an int
  return int(elapsed * 1000000.0)

def rthist_result(obj, prefix):
  rt = obj['hist']
  res = '%10s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %11s\n'\
        '%10s %9d %9d %9d %9d %9d %9d %9d %9d %9d %9d %11.6f' % (
         prefix, '256us', '1ms', '4ms', '16ms', '64ms', '256ms', '1s', '4s', '16s', 'gt', 'max',
         prefix, rt[0], rt[1], rt[2], rt[3], rt[4], rt[5], rt[6], rt[7], rt[8], rt[9], obj['max'])
  return res
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

  if FLAGS.dbms == 'mongo':
    globals()['pymongo'] = __import__('pymongo')
  elif FLAGS.dbms == 'mysql':
    globals()['MySQLdb'] = __import__('MySQLdb')
  elif FLAGS.dbms == 'postgres':
    globals()['psycopg2'] = __import__('psycopg2')
  else:
    print('dbms must be one of: mysql, mongodb, postgres')
    sys.exit(-1)

  return new_argv

def ShowUsage():
  parser.print_help()

#
# options
#

DEFINE_integer('rows_per_query', 1000, '#rows per query')
DEFINE_integer('report_secs', 10, 'Interval for status reports')
DEFINE_integer('transaction_secs', 10, 'Transaction duration')
DEFINE_integer('thinktime_ms', 0, 'Number of milliseconds to sleep after a query')
DEFINE_string('dbms', 'mysql', 'one of: mysql, mongodb, postgres')
DEFINE_string('columns', 'foo',
              'Name(s) of columns to fetch (comma separated). PK must be first.')

# All flags
DEFINE_string('dbopt', 'none', 'Per DBMS options, comma separated')

# MySQL & MongoDB flags
DEFINE_string('db_host', 'localhost', 'Hostname for the test')
DEFINE_string('db_name', 'test', 'Name of database for the test')
DEFINE_string('table_name', 'foo', 'Name of table to use')

# MySQL flags
DEFINE_string('db_user', 'root', 'DB user for the test')
DEFINE_string('db_password', '', 'DB password for the test')
DEFINE_string('db_socket', '/tmp/mysql.sock', 'socket for mysql connect')

# MongoDB flags
DEFINE_integer('mongo_w', 1, 'Value for MongoDB write concern: w')
DEFINE_string('mongo_r', 'local', 'Value for MongoDB read concern when transactions are not used')
DEFINE_boolean('mongo_j', False, 'Value for MongoDB write concern: j')

def fixup_options():
  if FLAGS.dbms == 'mongo':
    if FLAGS.dbopt != 'none':
      mopts = FLAGS.dbopt.split(',')
      for mopt in mopts:
        if mopt == 'journal':
          FLAGS.mongo_j = True
        elif mopt.startswith('r_'):
          FLAGS.mongo_r = mopt[2:]
        elif mopt.startswith('w_'):
          w = mopt[2:]
          try:
            w = int(w)
          except ValueError:
            pass
          FLAGS.mongo_w = w
    print('Using Mongo w=%s, r=%s, j=%d' % (FLAGS.mongo_w, FLAGS.mongo_r, FLAGS.mongo_j))

def get_conn():
  if FLAGS.dbms == 'mongo':
    return pymongo.MongoClient("mongodb://%s:%s@%s:27017" % (FLAGS.db_user, FLAGS.db_password, FLAGS.db_host))
  elif FLAGS.dbms == 'mysql':
    return MySQLdb.connect(host=FLAGS.db_host, user=FLAGS.db_user,
                           db=FLAGS.db_name, passwd=FLAGS.db_password,
                           autocommit=False)
  else:
    # TODO user, passwd, etc
    conn = psycopg2.connect(dbname=FLAGS.db_name, host=FLAGS.db_host)
    conn.set_session(autocommit=False)
    return conn

def get_mongo_session(db, db_conn):
  trx_opt = pymongo.client_session.TransactionOptions(
      read_concern = pymongo.read_concern.ReadConcern(level="snapshot"),
      write_concern = pymongo.write_concern.WriteConcern(w=FLAGS.mongo_w, j=FLAGS.mongo_j),
      max_commit_time_ms=1000*180)
  mongo_session = db_conn.start_session(causal_consistency=False,
                                        default_transaction_options=trx_opt)
  mongo_collection = db.get_collection(FLAGS.table_name)
  return mongo_session, mongo_collection

def generate_query_mongo(conn, last_pk, mongo_session):
  p = {}
  for c in columns: p[c] = 1

  if last_pk is None:
    f = {}
  else:
    f = {'_id': {'$gt' : last_pk }}

  r = conn.find(f,
                projection = p,
                sort = [('_id', pymongo.ASCENDING)],
                limit = FLAGS.rows_per_query,
                hint = [('_id', pymongo.ASCENDING)],
                session = mongo_session)
  return r

def generate_query_sql(conn, last_pk, table_name):
  if last_pk is None:
    where = ''
  else:
    where = 'WHERE %s > %s' % (pk_name, last_pk)

  sql = 'SELECT %s FROM %s %s ORDER BY %s LIMIT %d' % (
      FLAGS.columns, FLAGS.table_name, where, pk_name, FLAGS.rows_per_query)
  return sql

def Query():

  db_conn = get_conn()
  start_time = time.time()
  loops = 0

  if FLAGS.dbms == 'mongo':
    db = db_conn[FLAGS.db_name]
    db_thing = db[FLAGS.table_name]
    mongo_session, mongo_collection = get_mongo_session(db, db_conn)
    mongo_session.start_transaction()
  elif FLAGS.dbms in ['mysql', 'postgres']:
    db_thing = db_conn.cursor()
    mongo_session = None
  else:
    assert False

  commits = 0
  t_queries = 0
  i_queries = max_q = retries = restarts = 0
  trx_start_time = time.time()
  prev_report_time = trx_start_time
  next_report_time = trx_start_time + FLAGS.report_secs
  rthist = rthist_new()
  last_pk = None

  while True:
    ts = rthist_start(rthist)

    now = time.time()
    if now - trx_start_time >= FLAGS.transaction_secs:
      trx_start_time = now
      if FLAGS.dbms == 'mongo':
        try:
          mongo_session.commit_transaction()
          commits += 1
        except pymongo.errors.PyMongoError as e:
          if e.has_error_label("TransientTransactionError"):
            retries += 1
            if mongo_session.in_transaction:
              mongo_session.abort_transaction()
              mongo_session.start_transaction()
          else:
            print("Mongo error on commit: ", e)
            raise e
        mongo_session.start_transaction()
      else:
        db_conn.commit()
        commits += 1

    if now - next_report_time >= FLAGS.report_secs:
      print_stats(t_queries, i_queries, start_time, now, prev_report_time, max_q, retries, restarts, commits)
      commits = i_queries = max_q = retries = restarts = 0
      next_report_time = now + FLAGS.report_secs
      prev_report_time = now

    if FLAGS.dbms == 'mongo':
      done = False
      while not done:
        try:
          query = generate_query_mongo(db_thing, last_pk, mongo_session)

          count = 0
          for r in query:
            count += 1
            last_pk = r[pk_name]
          if count < FLAGS.rows_per_query:
            last_pk = None
            restarts += 1

          done = True

        except pymongo.errors.PyMongoError as e:
          if e.has_error_label("TransientTransactionError"):
            retries += 1
            if mongo_session.in_transaction:
              mongo_session.abort_transaction()
              mongo_session.start_transaction()
          else:
            print("Mongo error on query: ", e)
            raise e

    elif FLAGS.dbms == 'mysql':
      # print("Query is:", query)
      try:
        query = generate_query_sql(db_thing, last_pk, FLAGS.table_name)
        db_thing.execute(query)
        # TODO - reuse this code
        rows = db_thing.fetchall()
        count = 0
        for r in rows:
          count += 1
          last_pk = r[0]
        if count < FLAGS.rows_per_query:
          last_pk = None
          restarts += 1

      except MySQLdb.Error as e:
        if e[0] != 2006:
          #print("Ignoring MySQL exception: ", e)
          retries += 1
        else:
          print("Query error: ", e)
          raise e

    elif FLAGS.dbms == 'postgres':
      try:
        query = generate_query_sql(db_thing, last_pk, FLAGS.table_name)
        db_thing.execute(query)
        # TODO - reuse this code
        rows = db_thing.fetchall()
        count = 0
        for r in rows:
          count += 1
          last_pk = r[0]
        if count < FLAGS.rows_per_query:
          last_pk = None
          restarts += 1

        count = len(db_thing.fetchall())
      except psycopg2.Error as e:
        print("Query error: %s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag))
        raise e

    else:
      assert False

    loops += 1
    elapsed = rthist_finish(rthist, ts)
    if elapsed > max_q: max_q = elapsed
    t_queries += 1
    i_queries += 1

    if FLAGS.thinktime_ms > 0:
      time.sleep(FLAGS.thinktime_ms / 1000.0)

  rthist_result(rthist, 'Query rt:')

  if FLAGS.dbms == 'mongo':
    pass
  elif FLAGS.dbms in ['mysql', 'postgres']:
    db_thing.close()
  else:
    assert False

  db_conn.close()

def print_stats(t_queries, i_queries, start_time, now, prev_now, max_q, retries, restarts, commits):
  print('%.1f\t%.1f\t%.1f\t%.1f\t%.0f\t%d\t%d\t%d' % (
      now - prev_now,                                   # i_sec
      now - start_time,                                 # t_sec
      i_queries / (now - prev_now),                     # i_qps
      t_queries / (now - start_time),                   # t_qps
      max_q, retries, restarts, commits))
  sys.stdout.flush()

def main(argv):
  global pk_name
  global columns

  fixup_options()

  columns = FLAGS.columns.split(',')
  pk_name = columns[0]
  print('pk: %s and cols %s' % (pk_name, columns))

  print('i_sec\tt_sec\ti_qps\tt_qps\tmax_q\tretries\teof\tcommits')
  Query()
  return 0

if __name__ == '__main__':
  new_argv = ParseArgs(sys.argv[1:])
  sys.exit(main([sys.argv[0]] + new_argv))
