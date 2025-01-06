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

   Results are printed after each secs_per_report (approximately)

  The insert benchmark was implemented in C++ and defined at http://blogs.tokutek.com/tokuview/iibench
  This has long since diverged.
"""

__author__ = 'Mark Callaghan'

import os
import base64
import string
from multiprocessing import Queue, Process, Pipe, Value, Lock, Barrier
import multiprocessing
import optparse
from datetime import datetime
import time
import random
import sys
import math
import timeit
import traceback
import cProfile

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

DEFINE_integer('my_id', 0, 'With N iibench processes this ranges from 1 to N')
DEFINE_integer('data_length_max', 10, 'Max size of data in data column')
DEFINE_integer('data_length_min', 10, 'Min size of data in data column')
DEFINE_integer('data_random_pct', 50, 'Percentage of row that has random data')
DEFINE_integer('rows_per_commit', 1000, '#rows per transaction')
DEFINE_integer('secs_per_report', 10, 'Frequency at which progress is reported')
DEFINE_integer('rows_per_query', 10,
               'Number of rows per to fetch per query. Each query '
               'thread does one query per insert.')
DEFINE_integer('cashregisters', 1000, '# cash registers')
DEFINE_integer('products', 10000, '# products')
DEFINE_integer('customers', 100000, '# customers')
DEFINE_integer('max_price', 500, 'Maximum value for price column')
DEFINE_integer('max_rows', 10000, 'Number of rows to insert')
DEFINE_boolean('no_inserts', False, 'When True don''t do inserts')
DEFINE_integer('max_seconds', 0, 'Max number of seconds to run, when > 0')
DEFINE_integer('query_threads', 0, 'Number of query threads')
DEFINE_boolean('query_pk_only', False, 'When true all queries use the PK index')
DEFINE_boolean('setup', False,
               'Create table. Drop and recreate if it exists.')
DEFINE_integer('warmup', 0, 'TODO')
DEFINE_integer('initial_size', 0, 'Number of initial tuples to insert before benchmarking')
DEFINE_boolean('print_get_min', False, 'Print time for get_min query')
DEFINE_integer('resync_get_min', 1000,
               'Query the min value of the transactionid column every resync_get_min '\
               'loop iterations in statement_maker. When 0 only query once at process '\
               'start with is the original behavior. Querying too often is bad for '\
               'performance, but querying occasionally makes sure deletes are done '\
               'as expected despite gaps in the PK values that might occur with '\
               'InnoDB auto-increment or PG sequences')
DEFINE_integer('max_table_rows', 10000000, 'Maximum number of rows in table')
DEFINE_boolean('delete_per_insert', False,
               'When True, do a delete for every insert')
DEFINE_integer('num_secondary_indexes', 3, 'Number of secondary indexes (0 to 3)')
DEFINE_boolean('secondary_at_end', False, 'Create secondary index at end')
DEFINE_boolean('secondary_at_start', False, 'Create secondary index at start')
DEFINE_integer('inserts_per_second', 0, 'Rate limit for inserts')
DEFINE_integer('seed', 3221223452, 'RNG seed')
# Can override other options, see get_conn
DEFINE_string('dbopt', 'none', 'Per DBMS options, comma separated')

DEFINE_string('dbms', 'mysql', 'one of: mysql, mongodb, postgres')

DEFINE_boolean('use_prepared_query', False,
               'Use prepared statements for queries, only supported for Postgres today')
DEFINE_boolean('use_prepared_insert', False,
               'Use prepared statements for inserts, only supported for Postgres today')

DEFINE_integer('htap_transaction_seconds', 0,
               'Number of seconds for which HTAP transactions are open. '
               'There are not HTAP transactions when 0.')

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
DEFINE_integer('bulk_load', 1, 'Enable bulk load optimizations - only RocksDB today')

# MySQL & Postgres flags
DEFINE_integer('num_partitions', 0, 'Use range partitioning when not 0')
DEFINE_integer('rows_per_partition', 0,
              'Number of rows per partition. If 0 this is computed as max_rows/num_partitions')

# MongoDB flags
DEFINE_integer('mongo_w', 1, 'Value for MongoDB write concern: w')
DEFINE_string('mongo_r', 'local', 'Value for MongoDB read concern when transactions are not used')
DEFINE_boolean('mongo_j', False, 'Value for MongoDB write concern: j')
DEFINE_boolean('mongo_trx', False, 'Use Mongo transactions when true')
DEFINE_string('name_cash', 'cashregisterid', 'Name for cashregisterid attribute')
DEFINE_string('name_cust', 'customerid', 'Name for customerid attribute')
DEFINE_string('name_ts', 'dateandtime', 'Name for dateandtime attribute')
DEFINE_string('name_price', 'price', 'Name for price attribute')
DEFINE_string('name_prod', 'product', 'Name for product attribute')
DEFINE_string('name_data', 'data', 'Name for data attribute')

#
# iibench
#

you_are_done='done'

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
        '%10s %9d %9d %9d %9d %9d %9d %9d %9d %9d %9d %11.6f' % ( prefix, '256us', '1ms', '4ms', '16ms', '64ms', '256ms', '1s', '4s', '16s', 'gt', 'max',
         prefix, rt[0], rt[1], rt[2], rt[3], rt[4], rt[5], rt[6], rt[7], rt[8], rt[9], obj['max'])
  return res

def fixup_options():
  if FLAGS.inserts_per_second and (FLAGS.rows_per_commit > FLAGS.inserts_per_second):
    FLAGS.rows_per_commit = FLAGS.inserts_per_second

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

def get_conn(autocommit_trx=True):
  if FLAGS.dbms == 'mongo':
    assert autocommit_trx
    return pymongo.MongoClient("mongodb://%s:%s@%s:27017" % (FLAGS.db_user, FLAGS.db_password, FLAGS.db_host))
  elif FLAGS.dbms == 'mysql':
    return MySQLdb.connect(host=FLAGS.db_host, user=FLAGS.db_user,
                           db=FLAGS.db_name, passwd=FLAGS.db_password,
                           unix_socket=FLAGS.db_socket, read_default_file=FLAGS.db_config_file,
                           autocommit=autocommit_trx)
  else:
    # TODO user, passwd, etc
    conn = psycopg2.connect(dbname=FLAGS.db_name, host=FLAGS.db_host,
                            user=FLAGS.db_user, password=FLAGS.db_password)
    conn.set_session(autocommit=autocommit_trx)
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

def create_index_mongo():
  conn = get_conn()
  db = conn[FLAGS.db_name]

  if FLAGS.num_secondary_indexes >= 1:
    db[FLAGS.table_name].create_index([(FLAGS.name_prod, pymongo.ASCENDING),
                                       (FLAGS.name_cust, pymongo.ASCENDING),
                                       (FLAGS.name_price, pymongo.ASCENDING)],
                                       name="pc")
  if FLAGS.num_secondary_indexes >= 2:
    db[FLAGS.table_name].create_index([(FLAGS.name_cash, pymongo.ASCENDING),
                                       (FLAGS.name_cust, pymongo.ASCENDING),
                                       (FLAGS.name_price, pymongo.ASCENDING)],
                                       name="cpc")
  if FLAGS.num_secondary_indexes >= 3:
    db[FLAGS.table_name].create_index([(FLAGS.name_price, pymongo.ASCENDING),
                                       (FLAGS.name_ts, pymongo.ASCENDING),
                                       (FLAGS.name_cust, pymongo.ASCENDING)],
                                       name="pdc")

def create_table_mongo():
  conn = get_conn()
  db = conn[FLAGS.db_name]
  db.drop_collection(FLAGS.table_name)
  db.create_collection(FLAGS.table_name)

def create_index_mysql():
  if FLAGS.num_secondary_indexes >= 1:
    conn = get_conn()
    cursor = conn.cursor()

    ddls = []

    # Comparing create index isn't apples-to-apples here. Eventually I will revisit this.
    # 1) I think that MySQL can create multiple indexes via one table scan. MongoDB and PG cannot.
    # 2) Postgres can create an index with parallelism. I usually disable that in the config file.

    if FLAGS.engine.lower() == 'rocksdb':
      # Don't understand it yet by mysqld VSZ and RSS grow too much during create index for MyRocks
      #ddls.append("alter table %s add index %s_marketsegment (productid, customerid, price) COMMENT 'cfname=xms' " % (
      ddls.append("alter table %s add index %s_marketsegment (productid, customerid, price) " % (
                  FLAGS.table_name, FLAGS.table_name))

      if FLAGS.num_secondary_indexes >= 2:
        #ddls.append("alter table %s add index %s_registersegment (cashregisterid, customerid, price) COMMENT 'cfname=xrs' " % (
        ddls.append("alter table %s add index %s_registersegment (cashregisterid, customerid, price) " % (
                    FLAGS.table_name, FLAGS.table_name))

      if FLAGS.num_secondary_indexes >= 3:
        #ddls.append("alter table %s add index %s_pdc (price, dateandtime, customerid) COMMENT 'cfname=xpdc' " % (
        ddls.append("alter table %s add index %s_pdc (price, dateandtime, customerid) " % (
                     FLAGS.table_name, FLAGS.table_name))

    else:
      index_ddl = "alter table %s add index %s_marketsegment (productid, customerid, price) " % (
                     FLAGS.table_name, FLAGS.table_name)

      if FLAGS.num_secondary_indexes >= 2:
        index_ddl += ", add index %s_registersegment (cashregisterid, customerid, price) " % (
                     FLAGS.table_name)

      if FLAGS.num_secondary_indexes >= 3:
        index_ddl += ", add index %s_pdc (price, dateandtime, customerid) " % (
                     FLAGS.table_name)

      ddls.append(index_ddl)

    for ddl_sql in ddls:
      #print("DDL: %s" % ddl_sql)
      cursor.execute(ddl_sql)

    cursor.close()
    conn.close()

def create_table_mysql():
  conn = get_conn()
  cursor = conn.cursor()
  cursor.execute('drop table if exists %s' % FLAGS.table_name)

  ddl_sql = 'transactionid bigint not null auto_increment, '\
            'dateandtime datetime, '\
            'cashregisterid int not null, '\
            'customerid int not null, '\
            'productid int not null, '\
            'price int not null, '\
            'data varchar(4000), '\
            'primary key (transactionid) '

  if FLAGS.num_partitions > 0:
    if FLAGS.rows_per_partition > 0:
      rows_per_part = FLAGS.rows_per_partition
    else:
      rows_per_part = FLAGS.max_rows / FLAGS.num_partitions

    part_sql = 'partition by range( transactionid ) ('
    for i in range(FLAGS.num_partitions - 1):
      part_sql += ' partition p%d values less than (%d),\n' % (i, (i+1)*rows_per_part)
    part_sql += ' partition p%d values less than (MAXVALUE)\n)' % (FLAGS.num_partitions - 1)
  else:
    part_sql = ""

  ddl_sql = 'create table %s ( %s ) engine=%s %s %s' % (
      FLAGS.table_name, ddl_sql, FLAGS.engine, FLAGS.engine_options, part_sql)
  #print(ddl_sql)
  cursor.execute(ddl_sql)

  cursor.close()
  conn.close()

def create_index_postgres():
  if FLAGS.num_secondary_indexes >= 1:
    conn = get_conn()
    cursor = conn.cursor()

    # TODO: should fillfactor be set?
    # ddl = "create index %s_marketsegment on %s (productid, customerid, price) with (deduplicate_items=off)" % (
    ddl = "create index %s_marketsegment on %s (productid, customerid, price) " % (
          FLAGS.table_name, FLAGS.table_name)
    cursor.execute(ddl)

    if FLAGS.num_secondary_indexes >= 2:
      #ddl = "create index %s_registersegment on %s (cashregisterid, customerid, price) with (deduplicate_items=off)" % (
      ddl = "create index %s_registersegment on %s (cashregisterid, customerid, price) " % (
            FLAGS.table_name, FLAGS.table_name)
      cursor.execute(ddl)

    if FLAGS.num_secondary_indexes >= 3:
      #ddl = "create index %s_pdc on %s (price, dateandtime, customerid) with (deduplicate_items=off)" % (
      ddl = "create index %s_pdc on %s (price, dateandtime, customerid) " % (
            FLAGS.table_name, FLAGS.table_name)
      cursor.execute(ddl)

    conn.commit()
    cursor.close()
    conn.close()

def create_table_postgres():
  conn = get_conn()
  cursor = conn.cursor()
  cursor.execute('drop table if exists %s' % FLAGS.table_name)

  if FLAGS.num_partitions > 0:
    part_sql = 'partition by range( transactionid )'
  else:
    part_sql = ''

  col_sql = 'transactionid bigserial primary key, '\
            'dateandtime timestamp without time zone, '\
            'cashregisterid int not null, '\
            'customerid int not null, '\
            'productid int not null, '\
            'price int not null, '\
            'data varchar(4000) '

  ddl_sql = 'create table %s ( %s ) %s %s' % (
      FLAGS.table_name, col_sql, part_sql, FLAGS.engine_options)
  #print(ddl_sql)
  cursor.execute(ddl_sql)
  conn.commit()

  seq_name = '%s_transactionid_seq' % FLAGS.table_name

  if FLAGS.num_partitions > 0:
    if FLAGS.rows_per_partition > 0:
      rows_per_part = FLAGS.rows_per_partition
    else:
      rows_per_part = FLAGS.max_rows / FLAGS.num_partitions

    low_val = 0
    high_val = rows_per_part

    for i in range(FLAGS.num_partitions):

      if i < (FLAGS.num_partitions - 1):
        range_sql = 'for values from (%d) to (%d)' % (low_val, high_val)
      else:
        range_sql = 'for values from (%d) to (MAXVALUE)' % (low_val)

      ddl_sql = 'create table %s_p%d partition of %s %s ' % (
          FLAGS.table_name, i, FLAGS.table_name, range_sql)
      #print(ddl_sql)
      cursor.execute(ddl_sql)
      conn.commit()

      low_val = high_val
      high_val += rows_per_part

  # TODO: what is a good value for cache to reduce overhead?
  ddl_sql = 'alter sequence %s cache 1000' % (seq_name)
  # print(ddl_sql)
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

def create_index():
  if FLAGS.dbms == 'mongo':
    create_index_mongo()
  elif FLAGS.dbms == 'mysql':
    create_index_mysql()
  else:
    create_index_postgres()

def generate_cols(rand_data_buf):
  cashregisterid = random.randrange(0, FLAGS.cashregisters)
  productid = random.randrange(0, FLAGS.products)
  customerid = random.randrange(0, FLAGS.customers)
  price = random.randrange(0, FLAGS.max_price)
  data_len = random.randrange(FLAGS.data_length_min, FLAGS.data_length_max+1)
  # multiply by 0.75 to account of base64 overhead
  rand_data_len = int(data_len * 0.75 * (float(FLAGS.data_random_pct) / 100))
  rand_data_off = random.randrange(0, len(rand_data_buf) - rand_data_len)
  nonrand_data_len = data_len - rand_data_len

  data = '%s%s' % ('a' * nonrand_data_len,
      rand_data_buf[rand_data_off:(rand_data_off+rand_data_len)])
  return cashregisterid, productid, customerid, price, data

def generate_row_mongo(when, rand_data_buf):
  cashregisterid, productid, customerid, price, data = generate_cols(rand_data_buf)
  return {FLAGS.name_ts : when, FLAGS.name_cash : cashregisterid,
          FLAGS.name_cust : customerid, FLAGS.name_prod : productid,
          FLAGS.name_price : price, FLAGS.name_data : data }

def generate_row_mysql_pg(when, rand_data_buf, use_prepared):
  cashregisterid, productid, customerid, price, data = generate_cols(rand_data_buf)
  if not use_prepared:
    return "('%s',%d,%d,%d,%.2f,'%s')" % (
        when,cashregisterid,customerid,productid,price,data)
  else:
    return (when,cashregisterid,customerid,productid,price,data)

def generate_row(when, rand_data_buf, use_prepared):
  if FLAGS.dbms == 'mongo':
    assert not use_prepared
    return generate_row_mongo(when, rand_data_buf)
  elif FLAGS.dbms == 'mysql':
    assert not use_prepared
    return generate_row_mysql_pg(when, rand_data_buf, False)
  elif FLAGS.dbms == 'postgres':
    return generate_row_mysql_pg(when, rand_data_buf, use_prepared)
  else:
    assert False

def generate_pdc_query_mongo(cursor, price, mongo_session):
  return (
           cursor.find({FLAGS.name_price: {'$gte' : price }},
                     projection = {FLAGS.name_price:1, FLAGS.name_ts:1, FLAGS.name_cust:1, '_id':0},
                     sort = [(FLAGS.name_price, pymongo.ASCENDING),
                             (FLAGS.name_ts, pymongo.ASCENDING),
                             (FLAGS.name_cust, pymongo.ASCENDING)],
                     limit = FLAGS.rows_per_query,
                     hint = [(FLAGS.name_price, pymongo.ASCENDING),
                             (FLAGS.name_ts, pymongo.ASCENDING),
                             (FLAGS.name_cust, pymongo.ASCENDING)],
                     session = mongo_session)
         )

def generate_pdc_query_mysql_pg(cursor, price, force, table_name):
  if force:
    force_txt = 'FORCE INDEX (%s_pdc)' % table_name
  else:
    force_txt = ''
  
  sql = 'SELECT price,dateandtime,customerid FROM %s %s WHERE '\
        '(price >= %s) '\
        'ORDER BY price, dateandtime, customerid '\
        'LIMIT %d' % (table_name, force_txt, price, FLAGS.rows_per_query)
  return sql

def generate_pdc_query_ps_pg(cursor, table_name):
  prep_sql = 'PREPARE pdc_query_ps (int) as '\
             'SELECT price, dateandtime, customerid FROM %s WHERE '\
             '(price >= $1) '\
             'ORDER BY price, dateandtime, customerid '\
             'LIMIT %d' % (table_name, FLAGS.rows_per_query)
  
  try:
    cursor.execute(prep_sql)
  except psycopg2.Error as e:
    print("pdc_query prepare error: %s\n%s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag, prep_sql))
    raise e
  return 'execute pdc_query_ps (%s)'

def generate_pdc_query(cursor, table_name, session, give_me_ps, vals_only, min_id, max_id):
  price = random.randrange(0, FLAGS.max_price)

  if FLAGS.dbms == 'mongo':
    assert not give_me_ps and not vals_only
    return generate_pdc_query_mongo(cursor, price, session)
  elif FLAGS.dbms == 'mysql':
    assert not give_me_ps and not vals_only
    return generate_pdc_query_mysql_pg(cursor, price, True, table_name)
  else:
    if give_me_ps:
      return generate_pdc_query_ps_pg(cursor, table_name)
    elif vals_only:
      return [price]
    else:
      return generate_pdc_query_mysql_pg(cursor, price, False, table_name)

def generate_market_query_mongo(cursor, productid, mongo_session):
  return (
           cursor.find({FLAGS.name_prod: {'$gte' : productid}}, 
                     projection = {FLAGS.name_prod:1, FLAGS.name_cust:1, '_id':0},
                     sort = [(FLAGS.name_prod, pymongo.ASCENDING),
                             (FLAGS.name_cust, pymongo.ASCENDING),
                             (FLAGS.name_price, pymongo.ASCENDING)],
                     limit = FLAGS.rows_per_query,
                     hint = [(FLAGS.name_prod, pymongo.ASCENDING),
                             (FLAGS.name_cust, pymongo.ASCENDING),
                             (FLAGS.name_price, pymongo.ASCENDING)],
                     session = mongo_session)
         )
 
def generate_market_query_mysql_pg(cursor, productid, force, table_name):
  if force:
    force_txt = 'FORCE INDEX (%s_marketsegment)' % table_name
  else:
    force_txt = ''

  sql = 'SELECT productid, customerid, price FROM %s %s WHERE '\
        '(productid >= %s) '\
        'ORDER BY productid, customerid, price '\
        'LIMIT %d' % (table_name, force_txt, productid, FLAGS.rows_per_query)
  return sql

def generate_market_query_ps_pg(cursor, table_name):
  prep_sql = 'PREPARE market_query_ps (int) as '\
             'SELECT productid, customerid, price FROM %s WHERE '\
             '(productid >= $1) '\
             'ORDER BY productid, customerid, price '\
             'LIMIT %d' % (table_name, FLAGS.rows_per_query)

  try:
    cursor.execute(prep_sql)
  except psycopg2.Error as e:
    print("market_query prepare error: %s\n%s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag, prep_sql))
    raise e
  return 'execute market_query_ps (%s)'

def generate_market_query(cursor, table_name, session, give_me_ps, vals_only, min_id, max_id):
  productid = random.randrange(0, FLAGS.products)

  if FLAGS.dbms == 'mongo':
    assert not give_me_ps and not vals_only
    return generate_market_query_mongo(cursor, productid, session)
  elif FLAGS.dbms == 'mysql':
    assert not give_me_ps and not vals_only
    return generate_market_query_mysql_pg(cursor, productid, True, table_name)
  else:
    if give_me_ps:
      return generate_market_query_ps_pg(cursor, table_name)
    elif vals_only:
      return [productid]
    else:
      return generate_market_query_mysql_pg(cursor, productid, False, table_name)

def generate_register_query_mongo(cursor, cashregisterid, mongo_session):
  return (
           cursor.find({FLAGS.name_cash: {'$gte' : cashregisterid}}, 
                     projection = {FLAGS.name_cash:1, FLAGS.name_price:1, FLAGS.name_cust:1, '_id':0},
                     sort = [(FLAGS.name_cash, pymongo.ASCENDING),
                             (FLAGS.name_cust, pymongo.ASCENDING),
                             (FLAGS.name_price, pymongo.ASCENDING)],
                     limit = FLAGS.rows_per_query,
                     hint = [(FLAGS.name_cash, pymongo.ASCENDING),
                             (FLAGS.name_cust, pymongo.ASCENDING),
                             (FLAGS.name_price, pymongo.ASCENDING)],
                     session = mongo_session)
         )
 
def generate_register_query_mysql_pg(cursor, cashregisterid, force, table_name):
  if force:
    force_txt = 'FORCE INDEX (%s_registersegment)' % table_name
  else:
    force_txt = ''

  sql = 'SELECT cashregisterid,customerid,price FROM %s '\
        '%s WHERE (cashregisterid > %d) '\
        'ORDER BY cashregisterid, customerid, price '\
        'LIMIT %d' % (table_name, force_txt, cashregisterid, FLAGS.rows_per_query)
  return sql

def generate_register_query_ps_pg(cursor, table_name):
  prep_sql = 'PREPARE register_query_ps (int) as '\
             'SELECT cashregisterid, customerid, price FROM %s '\
             'WHERE (cashregisterid > $1) '\
             'ORDER BY cashregisterid, customerid, price '\
             'LIMIT %d' % (table_name, FLAGS.rows_per_query)

  try:
    cursor.execute(prep_sql)
  except psycopg2.Error as e:
    print("register_query prepare error: %s\n%s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag, prep_sql))
    raise e
  return 'execute register_query_ps (%s)'

def generate_register_query(cursor, table_name, session, give_me_ps, vals_only, min_id, max_id):
  cashregisterid = random.randrange(0, FLAGS.cashregisters)

  if FLAGS.dbms == 'mongo':
    assert not give_me_ps and not vals_only
    return generate_register_query_mongo(cursor, cashregisterid, session)
  elif FLAGS.dbms == 'mysql':
    assert not give_me_ps and not vals_only
    return generate_register_query_mysql_pg(cursor, cashregisterid, True, table_name)
  else:
    if give_me_ps:
      return generate_register_query_ps_pg(cursor, table_name)
    elif vals_only:
      return [cashregisterid]
    else:
      return generate_register_query_mysql_pg(cursor, cashregisterid, False, table_name)

def generate_pk_query_mysql_pg(cursor, ids, table_name):
  sql = 'SELECT transactionid, productid, data FROM %s '\
        'WHERE transactionid in (%s)' % (table_name, ','.join(ids))
  return sql

def generate_pk_query_ps_pg(cursor, table_name, num_params):
  params_str = ["$%d" % x for x in range(1, num_params+1)]
  types_str = ["int" for x in range(num_params)]
  str_arr = ["%s" for x in range(num_params)]

  prep_sql = 'PREPARE pk_query_ps (%s) as '\
             'SELECT transactionid, productid, data FROM %s '\
             'WHERE transactionid in (%s)' % (','.join(types_str), table_name, ','.join(params_str))
  # print(prep_sql)

  try:
    cursor.execute(prep_sql)
  except psycopg2.Error as e:
    print("pk_query prepare error: %s\n%s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag, prep_sql))
    raise e

  str_arr_joined = ','.join(str_arr)
  # print('execute pk_query_ps (%s)' % str_arr_joined)
  return 'execute pk_query_ps (%s)' % str_arr_joined

def generate_pk_query(cursor, table_name, session, give_me_ps, vals_only, min_id, max_id):

  if FLAGS.dbms == 'mongo':
    # TODO not implemented
    assert False
  elif FLAGS.dbms == 'mysql':
    assert not give_me_ps and not vals_only
    ids = [str(random.randrange(min_id, max_id)) for x in range(FLAGS.rows_per_query)]
    return generate_pk_query_mysql_pg(cursor, ids, table_name)
  else:
    if give_me_ps:
      return generate_pk_query_ps_pg(cursor, table_name, FLAGS.rows_per_query)
    elif vals_only:
      return [random.randrange(min_id, max_id) for x in range(FLAGS.rows_per_query)]
    else:
      ids = [str(random.randrange(min_id, max_id)) for x in range(FLAGS.rows_per_query)]
      return generate_pk_query_mysql_pg(cursor, ids, table_name)

def generate_insert_rows(rand_data_buf, use_prepared):
  if FLAGS.dbms == 'mongo':
    when = datetime.utcnow()
  elif FLAGS.dbms in ['mysql', 'postgres']:
    when = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
  else:
    assert False

  # This allows the number of rows to exceed max_rows by a small amount, < rows_per_commit
  rows = [generate_row(when, rand_data_buf, use_prepared) \
      for i in range(FLAGS.rows_per_commit)]

  if FLAGS.dbms == 'mongo':
    return rows
  elif FLAGS.dbms in ['mysql', 'postgres']:
    if not use_prepared:
      sql_data = ',\n'.join(rows)
      return 'insert into %s '\
             '(dateandtime,cashregisterid,customerid,productid,price,data) '\
             'values %s' % (FLAGS.table_name, sql_data)
    else:
      flat_list = [x for xs in rows for x in xs]
      return flat_list
  else:
    assert False

def dump_pg_backend_id(cursor, output_file_name):
  assert FLAGS.dbms == 'postgres'

  try: 
    cursor.execute('select pg_backend_pid()')
    process_id = cursor.fetchone()
    outf = open(output_file_name, "w")
    outf.write("backend_id: %s\n" % process_id)
    outf.close()

  except psycopg2.Error as e:
    print("select pg_backend_id() fails: %s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag))
    sys.exit(-1)

def get_min_or_max_trxid(get_min):
  db_conn = get_conn()
  db_cursor = db_conn.cursor()

  if get_min:
    sql = 'select min(transactionid) from %s' % FLAGS.table_name
  else:
    sql = 'select max(transactionid) from %s' % FLAGS.table_name

  val = -99
  st = time.time()

  if FLAGS.dbms == 'mysql':
    # print("Query is:", query)
    try:
      db_cursor.execute(sql)
      row = db_cursor.fetchone()
      val = row[0]
    except MySQLdb.Error as e:
      if e[0] != 2006:
        #print("Ignoring MySQL exception: ", e)
        shared_var[3].value += 1
      else:
        print("Query error: ", e)
        raise e

  elif FLAGS.dbms == 'postgres':
    try:
      db_cursor.execute(sql)
      row = db_cursor.fetchone()
      val = row[0]
      
    except psycopg2.Error as e:
      print("Query error: %s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag))
      raise e
  else:
    assert False

  try:
    db_cursor.close()
  except Exception as e:
    print('Cursor.close in get_min_or_max_trxid: %s' % e)

  try:
    db_conn.close()
  except Exception as e:
    print('Connection.close in get_min_or_max_trxid: %s' % e)

  et = time.time()
  return (val, et-st)

def HtapTrx(done_flag, barrier):

  # block on this until main thread wants all processes to run
  barrier.wait()

  # print('HTAP thread running')
  db_conn = get_conn(False)

  mongo_session = None
  if FLAGS.dbms == 'mongo':
    # db = db_conn[FLAGS.db_name]
    # db_thing = db[FLAGS.table_name]
    # mongo_session, mongo_collection = get_mongo_session(db, db_conn)
    print('HtapTrx not supported for MongoDB')
    assert False
  elif FLAGS.dbms in ['mysql', 'postgres']:
    db_thing = db_conn.cursor()
  else:
    assert False

  while True:
    if FLAGS.dbms == 'mongo':
      assert False
    elif FLAGS.dbms == 'mysql':
      # print("Query is:", query)
      try:
        # print("HTAP query at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)
        query = 'select * from %s limit 1' % FLAGS.table_name;
        db_thing.execute(query)
        count = len(db_thing.fetchall())
        for x in range(FLAGS.htap_transaction_seconds):
          if done_flag.value == 1:
            break
          time.sleep(1)
          
        # print("HTAP commit at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)
        db_conn.commit()

      except MySQLdb.Error as e:
        if e[0] != 2006:
          #print("Ignoring MySQL exception: ", e)
          shared_var[3].value += 1
        else:
          print("Query error: ", e)
          raise e

    elif FLAGS.dbms == 'postgres':
      try:
        # print("HTAP query at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)
        query = 'select * from %s limit 1' % FLAGS.table_name;
        db_thing.execute(query)
        count = len(db_thing.fetchall())
        for x in range(FLAGS.htap_transaction_seconds):
          if done_flag.value == 1:
            break
          time.sleep(1)
        # print("HTAP commit at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)
        db_conn.commit()

      except psycopg2.Error as e:
        print("Query error: %s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag))
        raise e

    else:
      assert False

    if done_flag.value == 1:
      break

  if FLAGS.dbms == 'mongo':
    pass
  elif FLAGS.dbms in ['mysql', 'postgres']:
    db_thing.close()
  else:
    assert False

  db_conn.close()
  #print("HTAP done at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)

def Query(query_generators, shared_var, done_flag, barrier, result_q, shared_min_trxid):

  # block on this until main thread wants all processes to run
  barrier.wait()

  # print('Query thread running')
  db_conn = get_conn()

  start_time = time.time()
  loops = 0

  if FLAGS.dbms == 'mongo':
    db = db_conn[FLAGS.db_name]
    db_thing = db[FLAGS.table_name]
    mongo_session, mongo_collection = get_mongo_session(db, db_conn)
  elif FLAGS.dbms in ['mysql', 'postgres']:
    db_thing = db_conn.cursor()
    mongo_session = None
    if FLAGS.dbms == 'postgres':
      dump_pg_backend_id(db_thing, "o.pgid.%d.query.%s" % (FLAGS.my_id, FLAGS.table_name))
  else:
    assert False

  rthist = rthist_new()

  # Smallest trxid
  min_trxid = 0

  # Largest trxid 
  max_trxid = -1
  if FLAGS.query_pk_only:
    assert FLAGS.dbms != 'mongo'
    max_trxid, _ = get_min_or_max_trxid(False)
    assert max_trxid >= 0
    # print('max_trxid = %d\n' % max_trxid)
  
  ps_names = []
  if FLAGS.use_prepared_query:
    assert FLAGS.dbms == 'postgres'
    for q in query_generators:
      ps_names.append(q(db_thing, FLAGS.table_name, None, True, False, min_trxid, max_trxid))

  total_count = 0

  while True:
    query_id = random.randrange(0, len(query_generators))
    query_func = query_generators[query_id]

    # Smallest trxid
    min_trxid = shared_min_trxid.value

    ts = rthist_start(rthist)

    if FLAGS.dbms == 'mongo':
      done = False
      while not done:
        try:
          # TODO -- autocommit would be nice here
          if mongo_session: mongo_session.start_transaction()

          query = query_func(db_thing, FLAGS.table_name, mongo_session, False, False, min_trxid, max_trxid)

          count = 0
          for r in query: count += 1
          total_count += count
          # if count: print('fetched %d' % count) print('fetched %d' % count)

          if mongo_session: mongo_session.commit_transaction()
          done = True

        except pymongo.errors.PyMongoError as e:
          if e.has_error_label("TransientTransactionError"):
            shared_var[3].value += 1
            if mongo_session.in_transaction: mongo_session.abort_transaction()
          else:
            print("Mongo error on query: ", e)
            raise e

    elif FLAGS.dbms == 'mysql':
      try:
        query = query_func(db_thing, FLAGS.table_name, None, False, False, min_trxid, max_trxid)
        # print("Query is:", query)
        db_thing.execute(query)
        count = len(db_thing.fetchall())
        total_count += count
      except MySQLdb.Error as e:
        if e[0] != 2006:
          #print("Ignoring MySQL exception: ", e)
          shared_var[3].value += 1
        else:
          print("Query error: ", e)
          raise e

    elif FLAGS.dbms == 'postgres':
      try:
        if not FLAGS.use_prepared_query:
          query = query_func(db_thing, FLAGS.table_name, None, False, False, min_trxid, max_trxid)
          # print("Query is:", query)
          db_thing.execute(query)
        else:
          query_args = query_func(db_thing, FLAGS.table_name, None, False, True, min_trxid, max_trxid)
          db_thing.execute(ps_names[query_id], query_args)

        count = len(db_thing.fetchall())
        total_count += count
      except psycopg2.Error as e:
        print("Query error: %s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag))
        raise e

    else:
      assert False

    elapsed = rthist_finish(rthist, ts)
    with shared_var[2].get_lock():
      if elapsed > shared_var[2].value: shared_var[2].value = elapsed

    #except:
    #  e = sys.exc_info()[0]
    #  print("Query exception: ", e)

    loops += 1
    if (loops % 16) == 0:
      shared_var[1].value = loops
      if done_flag.value == 1:
        break

    if (loops % 100) == 0 and FLAGS.query_pk_only:
      max_trxid, _ = get_min_or_max_trxid(False)
      assert max_trxid >= 0
      # print('trxid(min,max) = (%d, %d)\n' % (min_trxid, max_trxid))

  if FLAGS.dbms == 'mongo':
    pass
  elif FLAGS.dbms in ['mysql', 'postgres']:
    db_thing.close()
  else:
    assert False

  extra = 'Query thread: %s queries, fetched/query(expected, actual) = ( %s , %.3f )' % (loops, FLAGS.rows_per_query, float(total_count) / loops)
  # print('%s\n' % extra)

  db_conn.close()
  result_q.put((rthist_result(rthist, 'Query rt:'), extra))

def statement_maker(rounds, insert_stmt_q, delete_stmt_q, done_flag, barrier, shared_min_trxid, rand_data_buf):
  # print("statement_maker: pre-lock at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)
  # block on this until main thread wants all processes to run
  barrier.wait()
  # print("statement_maker: post-lock at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)
  
  inserted = 0

  sum_queries = 0

  rounds_per_second = 0
  if (FLAGS.inserts_per_second):
    rounds_per_second = int(math.ceil(float(FLAGS.inserts_per_second) / FLAGS.rows_per_commit))
    if rounds_per_second < 1:
      rounds_per_second = 1
    last_rate_check = time.time()
    # print("rounds per second = %d" % rounds_per_second, flush=True)

  # Smallest trxid which is used for deletes
  min_trxid = -1
  resync = FLAGS.resync_get_min
  get_min_queried = False

  # For anyone, including me, trying to figure out whether inserts and deletes happen at the same rate,
  # the queues (insert_stmt_q, delete_stmt_q) have a small fixed size (currently 8) so the inserter or
  # deleter threads that consume from those queues can be at most 8 statements ahead of the other.

  # print("statement_maker: loop start at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)
  # generate rows to insert and delete statements
  for r in range(rounds):
    if done_flag.value:
      break
    rows = generate_insert_rows(rand_data_buf, FLAGS.use_prepared_insert)

    insert_stmt_q.put(rows)
    inserted += FLAGS.rows_per_commit

    # deletes - TODO support for MongoDB
    if FLAGS.delete_per_insert:
      assert FLAGS.dbms != 'mongo'
      assert resync >= 0

      # If I have yet to figure out (get_min_queried=FALSE) the min value of the PK column
      # or resync is requested (resync_get_min>0) and it is time to resync (resync=0).
      if not get_min_queried or (resync == 0 and FLAGS.resync_get_min > 0):
        resync = FLAGS.resync_get_min
        min_trxid, nsecs = get_min_or_max_trxid(True)
        if not get_min_queried or FLAGS.print_get_min:
          # Must print the first time, optionally print after that
          print("get_min_trxid = %d in %.3f seconds\n" % (min_trxid, nsecs), flush=True)
          get_min_queried = True

        if min_trxid is None:
          # Clamping min_trxid to 0.
          min_trxid = 0
      elif FLAGS.resync_get_min > 0:
        resync -= 1
        
      assert min_trxid >= 0
      #print('min_trxid = %d\n' % min_trxid)

      #delete_sql = ('delete from %s where(transactionid>=%d and transactionid<%d);'
      #              % (FLAGS.table_name, min_trxid, min_trxid + FLAGS.rows_per_commit))

      if FLAGS.dbms == 'mysql':
        delete_sql = ('delete from %s where transactionid >= %d order by transactionid asc limit %d'
                      % (FLAGS.table_name, min_trxid, FLAGS.rows_per_commit))
      elif FLAGS.dbms == 'postgres':
        delete_sql = ('delete from %s where transactionid in (select transactionid from %s where transactionid >= %d order by transactionid asc limit %d)'
                      % (FLAGS.table_name, FLAGS.table_name, min_trxid, FLAGS.rows_per_commit))
      else:
        assert False

      # print('%s\n' % delete_sql)
      delete_stmt_q.put(delete_sql)
      min_trxid += FLAGS.rows_per_commit
      shared_min_trxid.value = min_trxid

    # enforce write rate limit if set
    now = time.time()
    if rounds_per_second and (r % rounds_per_second) == 0:
      if now > last_rate_check and now < (last_rate_check + 0.95):
        sleep_time = 1.0 - (now - last_rate_check)
        assert sleep_time > 0.0 and sleep_time < 1.0
        # print("sleep %s" % sleep_time)
        time.sleep(sleep_time)
      last_rate_check = time.time()

  # block until the queue is empty
  insert_stmt_q.put(you_are_done)
  insert_stmt_q.close()

  if FLAGS.delete_per_insert:
    delete_stmt_q.put(you_are_done)
    delete_stmt_q.close()

def insert_ps_pg(cursor, table_name):
  #col_sql = 'transactionid bigserial primary key, '\
  #          'dateandtime timestamp without time zone, '\
  #          'cashregisterid int not null, '\
  #          'customerid int not null, '\
  #          'productid int not null, '\
  #          'price real not null, '\
  #          'data varchar(4000) '
  #return "'%s',%d,%d,%d,%.2f,'%s'" % ( when,cashregisterid,customerid,productid,price,data)
  # row_types = 'timestamp,int,int,int,real,varchar(4000)'
  #    return 'insert into %s '\
  #           '(dateandtime,cashregisterid,customerid,productid,price,data) '\
  #           'values %s' % (FLAGS.table_name, sql_data)
  # TODO(types)

  x=1
  ph_arr = []
  ty_arr = []
  for r in range(FLAGS.rows_per_commit):
    ph = '($%d, $%d, $%d, $%d, $%d, $%d)' % (x, x+1, x+2, x+3, x+4, x+5)
    ph_arr.append(ph)
    x += 6

  types = ','.join(['timestamp, int, int, int, real, varchar'] * FLAGS.rows_per_commit)
  placeholders = ','.join(ph_arr)

  prep_sql = 'PREPARE insert_ps (%s) as '\
             'INSERT INTO %s '\
             '(dateandtime,cashregisterid,customerid,productid,price,data) '\
             'VALUES %s' % (types, table_name, placeholders)
  # print(prep_sql)

  try:
    cursor.execute(prep_sql)
  except psycopg2.Error as e:
    print("insert prepare error: %s\n%s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag, prep_sql))
    raise e
  params = '%s,' * ((6 * FLAGS.rows_per_commit) - 1) + '%s'
  return 'execute insert_ps (%s)' % (params)

def statement_executor(stmt_q, shared_var, done_flag, barrier, result_q, is_inserter):
  # print("statement_exec(inserter=%s): pre-lock at %s\n" % (is_inserter, time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))), flush=True)
  # block on this until main thread wants all processes to run
  barrier.wait()
  # print("statement_exec(inserter=%s): post-lock at %s\n" % (is_inserter, time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))), flush=True)

  db_conn = get_conn()
  if FLAGS.dbms == 'mysql':
    cursor = db_conn.cursor()

    if not FLAGS.unique_checks:
      if FLAGS.engine.lower() == 'rocksdb':
        #cursor.execute('set rocksdb_skip_unique_check=1')
        cursor.execute('set unique_checks=0')
      elif FLAGS.engine.lower() == 'tokudb':
        cursor.execute('set unique_checks=0')

    if FLAGS.bulk_load:
      if FLAGS.engine.lower() == 'rocksdb':
        cursor.execute('set rocksdb_bulk_load=1')

    cursor.close()

  if FLAGS.dbms == 'mongo':
    assert is_inserter
    db = db_conn[FLAGS.db_name]
    mongo_session, mongo_collection = get_mongo_session(db, db_conn)
  elif FLAGS.dbms in ['mysql', 'postgres']:
    cursor = db_conn.cursor()
    if FLAGS.dbms == 'postgres':
      s = 'insert'
      if not is_inserter: s = 'delete' 
      dump_pg_backend_id(cursor, "o.pgid.%d.%s.%s" % (FLAGS.my_id, s, FLAGS.table_name))

  else:
    assert False

  if is_inserter and FLAGS.use_prepared_insert:
    assert FLAGS.dbms == 'postgres'
    insert_ps = insert_ps_pg(cursor, FLAGS.table_name)

  rthist = rthist_new()

  # print("statement_exec(inserter=%s): enter loop at %s\n" % (is_inserter, time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))), flush=True)
  while True:
    stmt = stmt_q.get()  # get the statement we need to execute from the queue

    if stmt == you_are_done:
      break

    ts = rthist_start(rthist)

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
            shared_var[3].value += 1
            if mongo_session.in_transaction: mongo_session.abort_transaction()
          else:
            print("Mongo error on insert: ", e)
            sys.exit(-1)

    elif FLAGS.dbms == 'mysql':
      try:
        cursor.execute(stmt)
      except MySQLdb.Error as e:
        if e[0] != 2006:
          # print("Ignoring MySQL exception: ", e)
          shared_var[3].value += 1
        else:
          sys.exit(-1)
    elif FLAGS.dbms == 'postgres':
      try:
        if not is_inserter or not FLAGS.use_prepared_insert:
          #print(stmt)
          cursor.execute(stmt)
          if not is_inserter and cursor.rowcount != FLAGS.rows_per_commit: print('delete: %s : %s' % (cursor.rowcount, stmt))
        else:
          #print(stmt)
          #print(insert_ps)
          cursor.execute(insert_ps, stmt)

      except psycopg2.Error as e:
        print("SQL error: %s\n%s\n%s\n" % (e.pgerror, e.pgcode, e.diag))
        sys.exit(-1)
    else:
      assert False
    
    elapsed = rthist_finish(rthist, ts)
    with shared_var[2].get_lock():
      if elapsed > shared_var[2].value: shared_var[2].value = elapsed

    shared_var[0].value = shared_var[0].value + FLAGS.rows_per_commit

  done_flag.value = 1
  stmt_q.close()
  db_conn.close()
  if is_inserter:
    result_q.put(rthist_result(rthist, 'Insert rt:'))
  else:
    result_q.put(rthist_result(rthist, 'Delete rt:'))

def sum_queries(shared_vars, inserted):
  total = 0
  max_q = 0
  retry_q = 0
  retry_i = 0
  retry_d = 0

  # All but the last two have the number of queries completed per thread
  for c in shared_vars[0:-2]:
    total += c[1].value
    c[0].value = inserted
    v = c[2].value
    c[2].value = -1
    if v > max_q: max_q = v
    retry_q += c[3].value

  retry_i = shared_vars[-2][3].value
  retry_d = shared_vars[-1][3].value

  return max_q, total, retry_q, retry_i, retry_d

def print_stats(shared_vars, inserted, prev_inserted, deleted, prev_deleted, prev_sum, start_time, last_report, now):
  sum_q = 0
  max_q = 0

  max_i = shared_vars[-2][2].value
  shared_vars[-2][2].value = -1
  if max_i == -1: max_i = 0

  max_d = shared_vars[-1][2].value
  shared_vars[-1][2].value = -1
  if max_d == -1: max_d = 0

  max_q, sum_q, retry_q, retry_i, retry_d = sum_queries(shared_vars, inserted)

  print('%.1f\t%.1f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d' % (
      now - last_report,                                # i_sec
      now - start_time,                                 # t_sec
      (inserted - prev_inserted) / (now - last_report), # i_ips
      inserted / (now - start_time),                    # t_ips
      (deleted - prev_deleted) / (now - last_report),   # i_dps
      deleted / (now - start_time),                     # t_dps
      (sum_q - prev_sum) / (now - last_report),         # i_qps
      sum_q / (now - start_time),                       # t_qps
      max_i, max_d, max_q, inserted, deleted, sum_q, retry_i, retry_d, retry_q))
  sys.stdout.flush()
  return sum_q

def run_benchmark():
  # Use 'fork' start method because we need to pass local variables to child
  # processes (e.g., connection parameters).  This is important for macOS,
  # where the default start method is 'spawn' since python 3.8.
  multiprocessing.set_start_method('fork')
  random.seed(FLAGS.seed)
  rounds = int(math.ceil(float(FLAGS.max_rows) / FLAGS.rows_per_commit))

  n_parties = 1

  if FLAGS.htap_transaction_seconds:
    n_parties += 1

  if FLAGS.query_threads:
    n_parties += FLAGS.query_threads

  if not FLAGS.no_inserts:
    n_parties += 2
    if FLAGS.delete_per_insert:
      n_parties += 1

  if FLAGS.setup:
    create_table()
    if FLAGS.secondary_at_start:
      create_index()
    # print('created table')
  else:
    conn = get_conn()
    conn.close()

  rand_data_buf = base64.b64encode(os.urandom(1024 * 1024 * 4)).decode('ascii')
  if FLAGS.initial_size > 0:
      conn = get_conn()
      cursor = conn.cursor()
      print("Inserting initial tuples...")
      for i in range(int(FLAGS.initial_size/FLAGS.rows_per_commit)):
        rows = generate_insert_rows(rand_data_buf, FLAGS.use_prepared_insert)
        cursor.execute(rows)
      print("Done")

  # Used to get all threads running at the same point in time
  barrier = Barrier(n_parties)

  # Array of tuple of Values, each tuple is ...
  #   [0] tracks the number of inserts or deletes
  #   [1] num_queries, returns number of queries done by query process
  #   [2] max response time per interval for queries or insert (inserter is last index entry)
  #   [3] num_retries for Query and statement_executor to return number of times a transaction is retried
  shared_vars = []

  query_args = []

  # Estimate for current min value of transactionid column in the test table
  shared_min_trxid = Value('i', 0)

  # Flag to indicate that inserts are done
  done_flag = Value('i', 0)

  if FLAGS.query_threads:
    if not FLAGS.query_pk_only:
      query_args.append(generate_market_query)
      if FLAGS.num_secondary_indexes >= 2: query_args.append(generate_register_query)
      if FLAGS.num_secondary_indexes >= 3: query_args.append(generate_pdc_query)
    else:
      query_args.append(generate_pk_query)

    for i in range(FLAGS.query_threads):
      shared_vars.append((Value('i', 0), Value('i', 0), Value('i', -1), Value('i', 0)))

    query_thr = []
    query_result = Queue()
    for i in range(FLAGS.query_threads):
      query_thr.append(Process(target=Query, args=(query_args, shared_vars[i], done_flag, barrier, query_result, shared_min_trxid)))

  if not FLAGS.no_inserts:
    insert_stmt_q = Queue(8)
    delete_stmt_q = Queue(8)
    insert_stmt_result = Queue()
    delete_stmt_result = Queue()

    shared_vars.append((Value('i', 0), Value('i', 0), Value('i', -1), Value('i', 0)))
    shared_vars.append((Value('i', 0), Value('i', 0), Value('i', -1), Value('i', 0)))

    inserter = Process(target=statement_executor, args=(insert_stmt_q, shared_vars[-2], done_flag, barrier, insert_stmt_result, True))

    deleter = None
    if FLAGS.delete_per_insert:
      deleter = Process(target=statement_executor, args=(delete_stmt_q, shared_vars[-1], done_flag, barrier, delete_stmt_result, False))

    request_gen = Process(target=statement_maker, args=(rounds, insert_stmt_q, delete_stmt_q, done_flag, barrier, shared_min_trxid, rand_data_buf))

    # start up the insert execution process with this queue
    inserter.start()
    if FLAGS.delete_per_insert:
      deleter.start()
    request_gen.start()

  htap_thr = None
  if FLAGS.htap_transaction_seconds:
    htap_thr = Process(target=HtapTrx, args=(done_flag, barrier))

  # start up the query processes
  if FLAGS.query_threads:
    for qthr in query_thr:
      qthr.start()

  if FLAGS.htap_transaction_seconds:
    htap_thr.start()

  # After the insert and query processes lock/unlock this they can run
  barrier.wait()
  test_start = time.time()

  start_time = time.time()
  last_report = start_time
  inserted = 0
  deleted = 0
  prev_inserted = 0
  prev_deleted = 0
  prev_sum = 0

  while True:
    time.sleep(FLAGS.secs_per_report)

    # print progress
    inserted = shared_vars[-2][0].value
    deleted = shared_vars[-1][0].value
    now = time.time()
    prev_sum = print_stats(shared_vars, inserted, prev_inserted, deleted, prev_deleted, prev_sum, start_time, last_report, now)
    prev_inserted = inserted
    prev_deleted = deleted
    last_report = now

    if done_flag.value == 1 or (FLAGS.max_seconds and (now - start_time) >= FLAGS.max_seconds):
      done_flag.value = 1  # setting this might be redundant

      if not FLAGS.no_inserts:
        # print('Wait for inserter')
        inserter.join()
        print(insert_stmt_result.get())

        if FLAGS.delete_per_insert:
          # print('Wait for deleter')
          deleter.join()
          print(delete_stmt_result.get())

        sys.stdout.flush()
        request_gen.terminate()
        sys.stdout.flush()

        inserter.terminate()

        if FLAGS.delete_per_insert:
          deleter.terminate()

      # exit the while loop to continue shutting down
      break

  # print("Join threads at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)
  if FLAGS.htap_transaction_seconds:
    htap_thr.join()

  extra_arr = []
  if FLAGS.query_threads:
    for qthr in query_thr: qthr.join()
    (qr1, qr2) = query_result.get()
    print(qr1)
    extra_arr.append(qr2)
    sys.stdout.flush()
    for qthr in query_thr: qthr.terminate()

  for qr2 in extra_arr: print(qr2)

  if FLAGS.secondary_at_end:
    x_start = time.time()
    create_index()
    x_end = time.time()
    print('Created secondary indexes in %.1f seconds' % (x_end - x_start))

  test_end = time.time()
  max_q, sum_q, retry_q, retry_i, retry_d = sum_queries(shared_vars, inserted)
  print('Totals: %.1f secs, %.1f rows/sec, %s rows, %d %d %d insert-delete-query retry' % (
      test_end - test_start,
      inserted / (test_end - test_start),
      inserted, retry_i, retry_d, retry_q))
  print('Done')

def main(argv):
  if FLAGS.delete_per_insert and FLAGS.dbms == 'mongo':
    print('Not supported: delete_per_insert')
    sys.exit(-1)

  if FLAGS.max_seconds and FLAGS.no_inserts:
    print('Cannot set max_seconds when no_inserts is set')
    sys.exit(-1)

  if FLAGS.resync_get_min < 0:
    print('resync_get_min must be >= 0')

  fixup_options()

  print('i_sec\tt_sec\ti_ips\tt_ips\ti_dps\tt_dps\ti_qps\tt_qps\tmax_i\tmax_d\tmax_q\tt_ins\tt_del\tt_query\tretry_i\tretry_d\tretry_q')
  run_benchmark()
  return 0

if __name__ == '__main__':
  new_argv = ParseArgs(sys.argv[1:])
  sys.exit(main([sys.argv[0]] + new_argv))
  #cProfile.run('main([sys.argv[0]] + new_argv)', sort='tottime')
