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
import optparse
from datetime import datetime
import time
import random
import sys
import math
import timeit
import traceback
import cProfile

import numpy
from simple_pid import PID
import torch

from learning.rl import RLModel, default_network_arch, softmax_policy

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
DEFINE_boolean('control_autovac', False, 'If we are taking control of the autovacuuming')
DEFINE_boolean('enable_pid', False, 'Enable PID control for autovac delay')
DEFINE_integer('initial_autovac_delay', 60, 'Initial autovacuuming delay')
DEFINE_boolean('enable_logging', False, 'Enable collection of stats to logging table')
DEFINE_boolean('enable_learning', False, "Enable reinforcement learning for autovacuum")
DEFINE_boolean('use_learned_model', False, "Use previously learned model")
DEFINE_string('learned_model_file', '', "Specify file name for previously learned model")
DEFINE_boolean('enable_agent', False, 'Enables monitoring and autovac agent thread')

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
      ddls.append("alter table %s add index %s_marketsegment (productid, customerid, price) " % (
                  FLAGS.table_name, FLAGS.table_name))

      if FLAGS.num_secondary_indexes >= 2:
        ddls.append("alter table %s add index %s_registersegment (cashregisterid, customerid, price) " % (
                    FLAGS.table_name, FLAGS.table_name))

      if FLAGS.num_secondary_indexes >= 3:
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

  db_cursor.close()
  et = time.time()
  #if get_min and val is not None:
  #  print("get_min_trxid = %d in %.3f seconds\n" % (val, et-st), flush=True)
  return val

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
    max_trxid = get_min_or_max_trxid(False)
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
      max_trxid = get_min_or_max_trxid(False)
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

def statement_maker(rounds, insert_stmt_q, delete_stmt_q, barrier, shared_min_trxid, rand_data_buf):
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

  # print("statement_maker: loop start at %s\n" % time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time())), flush=True)
  # generate rows to insert and delete statements
  for r in range(rounds):
    rows = generate_insert_rows(rand_data_buf, FLAGS.use_prepared_insert)

    insert_stmt_q.put(rows)
    inserted += FLAGS.rows_per_commit

    # deletes - TODO support for MongoDB
    if FLAGS.delete_per_insert:
      # Smallest trxid which is used for deletes
      min_trxid = -1
      if FLAGS.delete_per_insert:
          assert FLAGS.dbms != 'mongo'
          min_trxid = get_min_or_max_trxid(True)
          if min_trxid is None:
              # Clamping min_trxid to 0.
              min_trxid = 0
          assert min_trxid >= 0
       #   print('min_trxid = %d\n' % min_trxid)

      delete_sql = ('delete from %s where(transactionid>=%d and transactionid<%d);'
                    % (FLAGS.table_name, min_trxid, min_trxid + FLAGS.rows_per_commit))
      # print('%s\n' % delete_sql)
      delete_stmt_q.put(delete_sql)
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

def log_tuples(queue, cursor, query, schema):
    # TODO: db_id, exp_group, exp_name,
    now = datetime.now()
    stmts = []
    insert_stmts = []

    cursor.execute(query)
    tuples = cursor.fetchall()

    for tuple in tuples:
        for field_name, v in zip(schema, tuple):
            stmt = []
            insert_stmt = "("

            stmt.append(now)
            insert_stmt += "'%s'" % now + ", "

            stmt.append(query)
            insert_stmt += "'%s'" % query.replace("'", "''") + ", "

            stmt.append(field_name)
            insert_stmt += "'%s'" % field_name + ", "

            if v is None:
                stmt.extend([None, None, None, None, None])
                insert_stmt += "NULL, NULL, NULL, NULL, NULL"
            elif type(v) is str:
                stmt.extend([v, None, None, None, None])
                insert_stmt += "'%s', NULL, NULL, NULL, NULL" % v
            elif type(v) is int:
                stmt.extend([None, v, None, None, None])
                insert_stmt += "NULL, '%d', NULL, NULL, NULL" % v
            elif type(v) is float:
                stmt.extend([None, None, v, None, None])
                insert_stmt += "NULL, NULL, '%.2f', NULL, NULL" % v
            elif type(v) is bool:
                stmt.extend([None, None, None, v, None])
                insert_stmt += "NULL, NULL, NULL, %s, NULL" % v
            elif type(v) is datetime:
                stmt.extend([None, None, None, None, v])
                insert_stmt += "NULL, NULL, NULL, NULL, '%s'" % v
            else:
                print("Unknown type for value: ", v)
                print(type(v))
                assert False

            #print("Statement: ", stmt)
            stmts.append(stmt)

            insert_stmt += ")"
            insert_stmts.append(insert_stmt)

    final_insert_stmt = "insert into logging (reading_time, reading_metadata, reading_name, reading_value_str, reading_value_int, reading_value_float, reading_value_bool, reading_value_time) values %s" % ", ".join(insert_stmts)
    #print(final_insert_stmt)
    cursor.execute(final_insert_stmt)

    return tuples

def agent_thread(done_flag):
    db_conn = get_conn()
    cursor = db_conn.cursor()
    event_queue = Queue()

    #create logging table
    ddl = "create table if not exists logging (reading_id bigserial primary key, reading_time timestamp without time zone, reading_metadata varchar(4000), reading_name varchar(1000) not null, reading_value_str varchar(4000), reading_value_int bigint, reading_value_float float, reading_value_bool bool, reading_value_time timestamp without time zone)"
    cursor.execute(ddl)

    #pretend we just did an autovacuum
    initial_time = time.time()
    last_autovac_time = initial_time

    current_delay = FLAGS.initial_autovac_delay
    prev_delay = current_delay
    delay_adjustment_count = 0
    vacuum_count = 0

    #cursor.execute("alter system set autovacuum_naptime to %d" % current_delay)
    if FLAGS.control_autovac:
        cursor.execute("alter table %s set ("
                       "autovacuum_enabled = off,"
                       "autovacuum_vacuum_scale_factor = 0,"
                       "autovacuum_vacuum_insert_scale_factor = 0,"
                       "autovacuum_vacuum_threshold = 0,"
                       "autovacuum_vacuum_cost_delay = 0,"
                       "autovacuum_vacuum_cost_limit = 10000"
                       ")" % FLAGS.table_name)
    else:
        cursor.execute("alter table %s reset ("
                       "autovacuum_enabled,"
                       "autovacuum_vacuum_scale_factor,"
                       "autovacuum_vacuum_insert_scale_factor,"
                       "autovacuum_vacuum_threshold,"
                       "autovacuum_vacuum_cost_delay,"
                       "autovacuum_vacuum_cost_limit"
                       ")" % FLAGS.table_name)

    #cursor.execute("select from pg_reload_conf()")

    range_min = math.log(1/(5*60.0))
    range_max = math.log(1.0)
    #print("Range: ", range_min, range_max)
    pid = PID(Kp=0.5, Ki=0.5, Kd=2.0, setpoint=60.0, output_limits=(range_min, range_max), auto_mode=True)

    count = 0
    live_sum = 0.0
    dead_sum = 0.0
    free_sum = 0.0

    # State for RL model
    if FLAGS.use_learned_model:
        print("Loading model state from file...")
        model_state = torch.load(FLAGS.learned_model_file)
        model = RLModel(default_network_arch)

        model.load_state_dict(model_state['model_state_dict'])
        #model.load_state_dict(model_state.state_dict())

        rng = numpy.random.RandomState(0)
        live_pct_buffer = []
        num_read_deltapct_buffer = []
        num_read_tuples_buffer = []

    while not done_flag.value:
        now = time.time()

        #if FLAGS.enable_logging:
        #pgstattuples = log_tuples(event_queue, cursor,"select * from pgstattuple('purchases_index')",
        #                          ("table_len", "tuple_count", "tuple_len", "tuple_percent", "dead_tuple_count", "dead_tuple_len", "dead_tuple_percent", "free_space", "free_percent"))

        #log_tuples(event_queue, cursor,"select * from pg_stat_user_tables where relname = 'purchases_index'",
        #           ("relid", "schemaname", "relname", "seq_scan", "seq_tup_read", "idx_scan", "idx_tup_fetch",
        #            "n_tup_ins", "n_tup_upd", "n_tup_del", "n_tup_hot_upd", "n_live_tup", "n_dead_tup", "n_mod_since_analyze",
        #            "n_ins_since_vacuum", "last_vacuum", "last_autovacuum", "last_analyze",  "last_autoanalyze", "vacuum_count",
        #            "autovacuum_count", "analyze_count", "autoanalyze_count"))

        #log_tuples(event_queue, cursor, "select pg_visibility_map_summary('purchases_index')", ("pg_visibility_map_summary", ))

        #log_tuples(event_queue, cursor, "select * from pg_sys_cpu_usage_info()",
        #           ("usermode_normal_process_percent", "usermode_niced_process_percent",
        #            "kernelmode_process_percent", "idle_mode_percent", "io_completion_percent",
        #            "servicing_irq_percent", "servicing_softirq_percent", "user_time_percent",
        #            "processor_time_percent", "privileged_time_percent", "interrupt_time_percent"))

        #log_tuples(event_queue, cursor, "select * from pg_sys_memory_info()",
        #           ("total_memory", "used_memory", "free_memory", "swap_total",
        #            "swap_used", "swap_free", "cache_total", "kernel_total", "kernel_paged", "kernel_non_paged",
        #            "total_page_file", "avail_page_file"))

        #log_tuples(event_queue, cursor, "select * from pg_sys_load_avg_info()",
        #           ("load_avg_one_minute", "load_avg_five_minutes", "load_avg_ten_minutes", "load_avg_fifteen_minutes"))

        #log_tuples(event_queue, cursor, "select * from pg_sys_process_info()",
        #           ("total_processes", "running_processes", "sleeping_processes", "stopped_processes", "zombie_processes"))

        #t = pgstattuples[0]
        #live_pct = t[3]
        #dead_pct = t[6]
        #free_pct = t[8]

        cursor.execute("select pg_total_relation_size('public.purchases_index')")
        total_space = cursor.fetchall()[0][0]

        cursor.execute("select pg_table_size('public.purchases_index')")
        used_space = cursor.fetchall()[0][0]

        cursor.execute("select n_live_tup, n_dead_tup, seq_tup_read from pg_stat_user_tables where relname = '%s'" % FLAGS.table_name)
        stats = cursor.fetchall()[0]
        n_live_tup = stats[0]
        n_dead_tup = stats[1]
        seq_tup_read = stats[2]
        #print("Live tup: %d, Dead dup: %d, Seq reads: %d" % (n_live_tup, n_dead_tup, seq_tup_read))

        live_raw_pct = 0.0 if n_live_tup+n_dead_tup == 0 else n_live_tup/(n_live_tup+n_dead_tup)

        print("Total: %d, Used: %d, Live raw pct: %.2f" % (total_space, used_space, live_raw_pct))
        sys.stdout.flush()

        used_pct = used_space/total_space
        live_pct = 100*live_raw_pct*used_pct
        dead_pct = 100*(1.0-live_raw_pct)*used_pct
        free_pct = 100*(1.0-used_pct)

        count += 1
        live_sum += live_pct
        dead_sum += dead_pct
        free_sum += free_pct

        print("Live tuple %% (avg): %.2f, %.2f, Dead tuple %% (avg): %.2f, %.2f, Free space %% (avg): %.2f, %.2f"
              % (live_pct, live_sum / count, dead_pct, dead_sum / count, free_pct, free_sum / count))
        sys.stdout.flush()

        if FLAGS.use_learned_model:
            # generate state
            delta = 0.0 if len(num_read_tuples_buffer) == 0 else seq_tup_read - num_read_tuples_buffer[0]
            if delta < 0:
                delta = 0
            delta_pct = 0.0 if n_live_tup == 0 else delta / n_live_tup

            if len(live_pct_buffer) >= 10:
                live_pct_buffer.pop()
                num_read_deltapct_buffer.pop()
                num_read_tuples_buffer.pop()

            live_pct_buffer.insert(0, live_pct)
            num_read_deltapct_buffer.insert(0, delta_pct)
            num_read_tuples_buffer.insert(0, seq_tup_read)

            l1 = numpy.pad(live_pct_buffer, (0, 10-len(live_pct_buffer)), 'constant', constant_values=(0, 0))
            l2 = numpy.pad(num_read_deltapct_buffer, (0, 10-len(num_read_deltapct_buffer)), 'constant', constant_values=(0, 0))
            state = torch.tensor([list(map(float, [*l1, *l2]))])
            print("State: ", state)

            # Select action
            action = int(softmax_policy(model, state, rng, default_network_arch['num_actions'], 0.01, False))
            print("Action: ", action)
            if action == 0:
                # Do not vacuum
                current_delay = 5*60
            elif action == 1:
                # Do vacuum
                current_delay = 1
            else:
                assert("Invalid action")
        elif FLAGS.enable_pid:
            pid_out = pid(live_pct)
            current_delay = int(math.ceil(1.0/math.exp(pid_out)))
            print("PID output %f, current_delay %d" % (pid_out, current_delay))
            sys.stdout.flush()

        if prev_delay != current_delay:
            prev_delay = current_delay
            delay_adjustment_count += 1
            #print("alter system set autovacuum_naptime to %d" % current_delay)
            #if FLAGS.control_autovac:
                #cursor.execute("alter system set autovacuum_naptime to %d" % current_delay)
                #cursor.execute("select from pg_reload_conf()")

        if FLAGS.control_autovac:
            if int(now-last_autovac_time) >= current_delay:
                last_autovac_time = now
                print("Vacuuming table...")
                sys.stdout.flush()
                cursor.execute("vacuum %s" % FLAGS.table_name)
                vacuum_count += 1

        cursor.execute("select vacuum_count, autovacuum_count from pg_stat_user_tables where relname = '%s'" % FLAGS.table_name)
        internal_vac_count, internal_autovac_count = cursor.fetchall()[0]

        print("===================> Time %.2f: Vac: %d, Internal vac: %d, Internal autovac: %d" % (now-initial_time, vacuum_count, internal_vac_count, internal_autovac_count))
        sys.stdout.flush()

        time.sleep(1)

    print("Delay adjustments: ", delay_adjustment_count)
    print("Live tuple: %.2f, Dead tuple: %.2f, Free space: %.2f" % (live_sum / count, dead_sum / count, free_sum / count))
    sys.stdout.flush()

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
  while not done_flag.value:
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

def run_benchmark(parent_barrier):
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

    request_gen = Process(target=statement_maker, args=(rounds, insert_stmt_q, delete_stmt_q, barrier, shared_min_trxid, rand_data_buf))

    if FLAGS.enable_agent:
        agent = Process(target=agent_thread, args=(done_flag,))

    # start up the insert execution process with this queue
    inserter.start()
    if FLAGS.delete_per_insert:
      deleter.start()
    request_gen.start()

    if FLAGS.enable_agent:
        agent.start()

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
  if parent_barrier:
      parent_barrier.wait()

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

        if FLAGS.enable_agent:
            # print('Wait for agent...')
            sys.stdout.flush()
            agent.join()

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
    for qthr in query_thr: print(qr1)
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

def apply_options(argv):
    ParseArgs(argv)

    if FLAGS.delete_per_insert and FLAGS.dbms == 'mongo':
        print('Not supported: delete_per_insert')
        sys.exit(-1)

    if FLAGS.max_seconds and FLAGS.no_inserts:
        print('Cannot set max_seconds when no_inserts is set')
        sys.exit(-1)

    fixup_options()

def run_main():
    print('i_sec\tt_sec\ti_ips\tt_ips\ti_dps\tt_dps\ti_qps\tt_qps\tmax_i\tmax_d\tmax_q\tt_ins\tt_del\tt_query\tretry_i\tretry_d\tretry_q')
    run_benchmark(None)
    return 0

if __name__ == '__main__':
    apply_options(sys.argv[1:])
    sys.exit(run_main())
