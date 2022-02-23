
"""Does fully/partial inserts using (K,L) where L can be varied. In this case:
   * take an ordered sequence
   * break into into blocks of size L
   * within each block the keys are randomly ordered
   * across blocks the order is preserved
   * when L=1 then the result is still fully ordered

   A typical command line is:
     python3 ordins.py --db_user=foo --db_password=bar --max_rows=1000000000 --L=1000

   Results are printed after each secs_per_report (approximately)
   The output is:
     Legend:
       tot_rows = total number of rows inserted
       tot_secs = total number of seconds the test has run
       tot_ips = tot_rows / tot_secs
       int_rows = number of rows inserted in last interval
       int_secs = number of seconds for the last interval
       int_ips = int_rows / int_secs
       tot_rows tot_secs tot_ips int_rows int_secs int_ips
     1000000 100 10000 100000 10 10000
"""

__author__ = 'Mark Callaghan'

import os
import base64
import string
import optparse
from datetime import datetime
import time
import random
import sys
import math
import timeit
import traceback

#
# flags module, on loan from gmt module by Chip Turner.
#

FLAGS = optparse.Values()
parser = optparse.OptionParser()

letters_and_digits = string.ascii_letters + string.digits

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

DEFINE_integer('data_length_max', 100, 'Max size of data in data column')
DEFINE_integer('data_length_min', 100, 'Min size of data in data column')
DEFINE_integer('data_random_pct', 50, 'Percentage of row that has random data')
DEFINE_integer('rows_per_commit', 1000, '#rows per transaction')
DEFINE_integer('secs_per_report', 10, 'Frequency at which progress is reported')
DEFINE_integer('max_rows', 100000, 'Number of rows to insert')
DEFINE_integer('L', 1, 'Block size in which rows are reordered')

DEFINE_boolean('setup', False,
               'Create table. Drop and recreate if it exists.')
DEFINE_integer('seed', 3221223452, 'RNG seed')

# Can override other options, see get_conn
DEFINE_string('dbopt', 'none', 'Per DBMS options, comma separated')

DEFINE_string('dbms', 'mysql', 'one of: mysql, mongodb, postgres')

# MySQL & MongoDB flags
DEFINE_string('db_host', 'localhost', 'Hostname for the test')
DEFINE_string('db_name', 'test', 'Name of database for the test')
DEFINE_string('table_name', 'ordins', 'Name of table to use')

# MySQL flags
DEFINE_string('engine', 'innodb', 'Storage engine for the table')
DEFINE_string('engine_options', '', 'Options for create table')
DEFINE_string('db_user', 'root', 'DB user for the test')
DEFINE_string('db_password', '', 'DB password for the test')
DEFINE_string('db_config_file', '', 'MySQL configuration file')
DEFINE_string('db_socket', '/tmp/mysql.sock', 'socket for mysql connect')
#DEFINE_integer('bulk_load', 1, 'Enable bulk load optimizations - only RocksDB today')

# MongoDB flags
DEFINE_integer('mongo_w', 1, 'Value for MongoDB write concern: w')
DEFINE_string('mongo_r', 'local', 'Value for MongoDB read concern when transactions are not used')
DEFINE_boolean('mongo_j', False, 'Value for MongoDB write concern: j')
DEFINE_boolean('mongo_trx', False, 'Use Mongo transactions when true')
DEFINE_string('name_data', 'data', 'Name for data attribute')

def fixup_options():
  if FLAGS.dbms == 'mongo':
    if FLAGS.dbopt != 'none':
      mopts = FLAGS.dbopt.split(',')
      for mopt in mopts:
        if mopt == 'journal':
          FLAGS.mongo_j = True
        elif mopt == 'transaction':
          FLAGS.mongo_trx = True
        elif mopt.startswith('r_'):
          FLAGS.mongo_r = mopt[2:]
        elif mopt.startswith('w_'):
          w = mopt[2:]
          try:
            w = int(w)
          except ValueError:
            pass
          FLAGS.mongo_w = w
    print('Using Mongo w=%s, r=%s, j=%d, trx=%s' % (FLAGS.mongo_w, FLAGS.mongo_r, FLAGS.mongo_j, FLAGS.mongo_trx))

def get_conn():
  if FLAGS.dbms == 'mongo':
    return pymongo.MongoClient("mongodb://%s:%s@%s:27017" % (FLAGS.db_user, FLAGS.db_password, FLAGS.db_host))
  elif FLAGS.dbms == 'mysql':
    return MySQLdb.connect(host=FLAGS.db_host, user=FLAGS.db_user,
                           db=FLAGS.db_name, passwd=FLAGS.db_password,
                           unix_socket=FLAGS.db_socket, read_default_file=FLAGS.db_config_file,
                           autocommit=True)
  else:
    # TODO user, passwd, etc
    conn = psycopg2.connect(dbname=FLAGS.db_name, host=FLAGS.db_host)
    conn.set_session(autocommit=True)
    return conn

def get_mongo_session(db, db_conn):
  if FLAGS.mongo_trx:
    trx_opt = pymongo.client_session.TransactionOptions(
        read_concern = pymongo.read_concern.ReadConcern(level="snapshot"),
        write_concern = pymongo.write_concern.WriteConcern(w=FLAGS.mongo_w, j=FLAGS.mongo_j),
        max_commit_time_ms=1000*180)
    mongo_session = db_conn.start_session(causal_consistency=False,
                                          default_transaction_options=trx_opt)
    mongo_collection = db.get_collection(FLAGS.table_name)
  else:
    mongo_session = None
    m_write_concern = pymongo.WriteConcern(w=FLAGS.mongo_w, j=FLAGS.mongo_j)
    mongo_collection = db.get_collection(
        FLAGS.table_name,
        write_concern = pymongo.write_concern.WriteConcern(w=FLAGS.mongo_w, j=FLAGS.mongo_j),
        read_concern = pymongo.read_concern.ReadConcern(FLAGS.mongo_r))

  return mongo_session, mongo_collection

def create_table_mongo():
  conn = get_conn()
  db = conn[FLAGS.db_name]
  db.drop_collection(FLAGS.table_name)
  db.create_collection(FLAGS.table_name)

def create_table_mysql():
  conn = get_conn()
  cursor = conn.cursor()
  cursor.execute('drop table if exists %s' % FLAGS.table_name)

  ddl_sql = 'id bigint not null, '\
            'data varchar(4000), '\
            'primary key (id) '

  ddl_sql = 'create table %s ( %s ) engine=%s %s' % (
      FLAGS.table_name, ddl_sql, FLAGS.engine, FLAGS.engine_options)
  #print(ddl_sql)
  cursor.execute(ddl_sql)

  cursor.close()
  conn.close()

def create_table_postgres():
  conn = get_conn()
  cursor = conn.cursor()
  cursor.execute('drop table if exists %s' % FLAGS.table_name)

  col_sql = 'id bigint not null primary key, '\
            'data varchar(4000) '

  ddl_sql = 'create table %s ( %s ) %s' % (
      FLAGS.table_name, col_sql, FLAGS.engine_options)
  #print(ddl_sql)
  cursor.execute(ddl_sql)
  conn.commit()

  cursor.close()
  conn.close()

def create_table():
  if FLAGS.dbms == 'mongo':
    create_table_mongo()
  elif FLAGS.dbms == 'mysql':
    create_table_mysql()
  else:
    create_table_postgres()

def generate_data(rand_data_buf):
  data_len = random.randrange(FLAGS.data_length_min, FLAGS.data_length_max+1)
  # multiply by 0.75 to account of base64 overhead
  rand_data_len = int(data_len * 0.75 * (float(FLAGS.data_random_pct) / 100))
  rand_data_off = random.randrange(0, len(rand_data_buf) - rand_data_len)
  nonrand_data_len = data_len - rand_data_len

  data = '%s%s' % ('a' * nonrand_data_len,
      rand_data_buf[rand_data_off:(rand_data_off+rand_data_len)])
  return data

def generate_row_mongo(pk, rand_data_buf):
  data = generate_data(rand_data_buf)
  return {'_id': pk, FLAGS.name_data : data }

def generate_row_mysql_pg(pk, rand_data_buf):
  data = generate_data(rand_data_buf)
  return "(%d,'%s')" % (pk, data)

def generate_row(pk, rand_data_buf):
  if FLAGS.dbms == 'mongo':
    return generate_row_mongo(pk, rand_data_buf)
  elif FLAGS.dbms in ['mysql', 'postgres']:
    return generate_row_mysql_pg(pk, rand_data_buf)
  else:
    assert False

def generate_insert_rows(keys, rand_data_buf):
  rows = [generate_row(pk, rand_data_buf) for pk in keys]

  if FLAGS.dbms == 'mongo':
    return rows
  elif FLAGS.dbms in ['mysql', 'postgres']:
    sql_data = ',\n'.join(rows)
    return 'insert into %s (id, data) values %s' % (FLAGS.table_name, sql_data)
  else:
    assert False

def nextKey(key_buf):
  if not len(key_buf['keys']):
    start = key_buf['next']
    stop = start + FLAGS.L
    if stop > (FLAGS.max_rows + 1):
      stop = FLAGS.max_rows + 1
    key_buf['next'] = stop
    #print('start, stop = %s, %s' % (start, stop))
    new_keys = [i for i in range(start, stop, 1)]
    random.shuffle(new_keys)
    # I couuld call reverse here because pop() is used rather than pop(0)
    # however popping from the end is OK because it is just one more shuffle
    key_buf['keys'] = new_keys

  return key_buf['keys'].pop()

def InsertData(ninserted, key_buf, rand_data_buf):
  nrows = FLAGS.rows_per_commit
  if (ninserted + nrows) > FLAGS.max_rows:
    nrows = FLAGS.max_rows - ninserted

  keys = []
  for x in range(nrows):
    keys.append(nextKey(key_buf))

  # print('keys: %s' % keys)
  rows = generate_insert_rows(keys, rand_data_buf)
  return rows, nrows

def inserter():
  rand_data_buf = base64.b64encode(os.urandom(1024 * 1024 * 4)).decode('ascii')

  db_conn = get_conn()

  if FLAGS.dbms == 'mysql':
    cursor = db_conn.cursor()
    # TODO
    #if FLAGS.bulk_load:
    #  if FLAGS.engine.lower() == 'rocksdb':
    #    cursor.execute('set rocksdb_bulk_load=1')
    cursor.close()

  if FLAGS.dbms == 'mongo':
    db = db_conn[FLAGS.db_name]
    mongo_session, mongo_collection = get_mongo_session(db, db_conn)
  elif FLAGS.dbms in ['mysql', 'postgres']:
    cursor = db_conn.cursor()
  else:
    assert False

  retries = 0
  key_buf = { 'next': 1, 'keys': [] }

  ninserted = 0
  prev_inserted = 0

  start_time = time.time()
  prev_report = start_time

  while ninserted < FLAGS.max_rows:
    stmt, nrows = InsertData(ninserted, key_buf, rand_data_buf)         # get the statement we need to execute from the queue
    
    if FLAGS.dbms == 'mongo':
      done = False
      while not done:
        try:
          # res has type pymongo.InsertManyResult
          if mongo_session: mongo_session.start_transaction()
          res = mongo_collection.insert_many(stmt, ordered=True,
                                             bypass_document_validation=False, session=mongo_session)
          assert len(res.inserted_ids) == len(stmt)

          if mongo_session: mongo_session.commit_transaction()
          done = True

        except pymongo.errors.PyMongoError as e:
          if e.has_error_label("TransientTransactionError"):
            retries += 1
            if mongo_session.in_transaction: mongo_session.abort_transaction()
          else:
            print("Mongo error on insert: ", e)
            raise e

    elif FLAGS.dbms == 'mysql':
      try:
        cursor.execute(stmt)
      except MySQLdb.Error as e:
        if e[0] != 2006:
          # print("Ignoring MySQL exception: ", e)
          retries += 1
        else:
          raise e
    elif FLAGS.dbms == 'postgres':
      try:
        cursor.execute(stmt)
      except psycopg2.Error as e:
        print("Insert error: %s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag))
        raise e
    else:
      assert False
    
    ninserted += nrows

    now = time.time()
    if (now - prev_report) >= FLAGS.secs_per_report:
      print_stats(ninserted, prev_inserted, start_time, prev_report, now)
      prev_inserted = ninserted
      prev_report = now

  db_conn.close()

def print_stats(inserted, prev_inserted, start_time, last_report, now):
 # tot_rows tot_secs tot_ips int_rows int_secs int_ips

  print('%d\t%.1f\t%.1f\t%d\t%.1f\t%.1f' % (
        inserted,
        now - start_time,
        inserted / (now - start_time),
        inserted - prev_inserted, 
        now - last_report,
        (inserted - prev_inserted) / (now - last_report)))

  sys.stdout.flush()

def run_benchmark():
  random.seed(FLAGS.seed)

  if FLAGS.setup:
    create_table()
    # print('created table')

  inserter()

  print('Done')

def main(argv):

  fixup_options()

  print('t_ins\tt_sec\tt_ips\ti_ins\ti_secs\ti_ips')
  run_benchmark()
  return 0

if __name__ == '__main__':
  new_argv = ParseArgs(sys.argv[1:])
  sys.exit(main([sys.argv[0]] + new_argv))
