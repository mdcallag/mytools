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

DEFINE_string('dbms', 'mysql', 'one of: mysql, mongodb, postgres')

# MySQL flags
DEFINE_string('db_host', '::1', 'Hostname for the test')
DEFINE_string('db_name', 'test', 'Name of database for the test')
DEFINE_string('engine', 'innodb', 'Storage engine for the table')
DEFINE_string('engine_options', '', 'Options for create table')
DEFINE_string('db_user', 'root', 'DB user for the test')
DEFINE_string('db_password', 'pw', 'DB password for the test')
DEFINE_string('db_config_file', '', 'MySQL configuration file')
DEFINE_boolean('mysql_use_socket', False, 'Connect using socket')
DEFINE_string('db_socket', '/tmp/mysql.sock', 'socket for mysql connect')

DEFINE_boolean('setup', False,
               'Create table. Drop and recreate if it exists.')

DEFINE_integer('parent_table_size', 1, 'Number of rows in parent table')
DEFINE_integer('children_per_parent', 10, 'Number of rows in child table per parent')

DEFINE_integer('threads', 1, 'Number of concurrent connections')

DEFINE_integer('seed', 3221223452, 'RNG seed')

DEFINE_integer('test_duration_seconds', 60, 'Number of seconds for which each test runs')

DEFINE_boolean('fk', False, "Use foreign key from child to parent table")

def get_conn(autocommit_trx=True):
  if not FLAGS.mysql_use_socket:
    return MySQLdb.connect(host=FLAGS.db_host, user=FLAGS.db_user,
                           db=FLAGS.db_name, passwd=FLAGS.db_password,
                           read_default_file=FLAGS.db_config_file,
                           autocommit=autocommit_trx)
  else:
    return MySQLdb.connect(unix_socket=FLAGS.db_socket, user=FLAGS.db_user,
                           db=FLAGS.db_name, passwd=FLAGS.db_password,
                           read_default_file=FLAGS.db_config_file,
                           autocommit=autocommit_trx)

def create_tables():
  conn = get_conn()
  cursor = conn.cursor()
  cursor.execute('drop table if exists child')
  cursor.execute('drop table if exists parent')

  ddl_parent = """
create table parent(
  id integer not null,
  k integer not null,
  primary key (id)
) engine=%s""" % FLAGS.engine

  fk = ""
  if FLAGS.fk:
    fk = ", foreign key (parent_id) references parent(id) on delete cascade"

  ddl_child = """
create table child(
  id integer not null,
  k integer not null,
  parent_id integer not null,
  primary key (parent_id, id) %s
) engine=%s""" % (fk, FLAGS.engine)

  cursor.execute(ddl_parent)
  #print(ddl_child)
  cursor.execute(ddl_child)

  cursor.close()
  conn.close()

def load_tables():
  conn = get_conn()
  cursor = conn.cursor()

  for i in range(FLAGS.parent_table_size // 1000):
    s = []
    s.append("insert into parent (id, k) values ")
    for j in range(1000):
      if j == 0:
        s.append("(%d, %d)" % ((i*1000)+j, (i*1000)+j))
      else:
        s.append(", (%d, %d)" % ((i*1000)+j, (i*1000)+j))
    insert_sql = ' '.join(s)
    #print(insert_sql)
    cursor.execute(insert_sql)

  for i in range(FLAGS.parent_table_size):
    s = []
    s.append("insert into child (id, k, parent_id) values ")
    for j in range(FLAGS.children_per_parent):
      if j == 0:
        s.append("(%d, %d, %d)" % (j, j, i))
      else:
        s.append(", (%d, %d, %d)" % (j, j, i))
    insert_sql = ' '.join(s)
    #print(insert_sql)
    cursor.execute(insert_sql)

  cursor.close()
  conn.close()

def check_table_sizes(caller):
    conn = get_conn(False)
    cursor = conn.cursor()

    cursor.execute('select count(*) from parent')
    nrows = cursor.fetchone()[0] 
    assert nrows == FLAGS.parent_table_size, "%s: parent rows: expected %d, found %d" % (caller, FLAGS.parent_table_size, nrows)

    child_rows = FLAGS.parent_table_size * FLAGS.children_per_parent
    cursor.execute('select count(*) from child')
    nrows = cursor.fetchone()[0] 
    assert nrows == child_rows, "%s: child rows: expected %d, found %d" % (caller, child_rows, nrows)

    cursor.execute('select count(*), parent_id from child group by parent_id having count(*) != %s' % FLAGS.children_per_parent)
    found_bad = False
    for row in cursor:
      found_bad = True
      print('%s: bad data in child: %s, %s' % (caller, row[0], row[1]))
    if found_bad:
      assert False, 'child has bad data'

def child_delete_insert_thr(done_flag, good_v, bad_v):
  loops = 0
  ok = 0
  err = 0

  while True:
    parent_id = random.randrange(0, FLAGS.parent_table_size)
    child_id = random.randrange(0, FLAGS.children_per_parent)

    conn = get_conn(False)
    cursor = conn.cursor()
    nrows = 0

    try:
      cursor.execute('delete from child where id = %d and parent_id = %d' % (child_id, parent_id))
      cursor.execute('select row_count()')
      nrows = cursor.fetchone()[0]
      #print(nrows)
      conn.commit()
    except MySQLdb.Error as e:
      err = err + 1
      nrows = 0
      print("child_delete_insert_thr: delete", e)

    if nrows == 1:
      try: 
        cursor.execute('insert into child (id, k, parent_id) values (%d, %d, %d)' % (child_id, child_id, parent_id))
        conn.commit()
        ok = ok + 1
      except MySQLdb.Error as e:
        err = err + 1
        print("child_delete_insert_thr: insert", e)

    loops = loops + 1
    if not loops % 100 and done_flag.value == 1:
      break

    good_v.value = ok
    bad_v.value = err

def parent_delete_insert_thr(done_flag, good_v, bad_v):
  loops = 0
  ok = 0
  err = 0

  while True:
    parent_id = random.randrange(0, FLAGS.parent_table_size)

    conn = get_conn(False)
    cursor = conn.cursor()
    nrows = 0

    try:
      cursor.execute('delete from parent where id = %d' % parent_id)
      cursor.execute('select row_count()')
      nrows = cursor.fetchone()[0]
      #print(nrows)
      if not FLAGS.fk:
        cursor.execute('delete from child where parent_id = %d' % parent_id)

      conn.commit()
    except MySQLdb.Error as e:
      err = err + 1
      nrows = 0
      print("parent_delete_insert_thr: delete", e)

    if nrows != 1: print(nrows)
    if nrows >= 1:
      try: 
        cursor.execute('insert into parent (id, k) values (%d, %d)' % (parent_id, parent_id))
        for x in range(0, FLAGS.children_per_parent):
          cursor.execute('insert into child (id, k, parent_id) values (%d, %d, %d)' % (x, x, parent_id))
        conn.commit()
        ok = ok + 1
      except MySQLdb.Error as e:
        err = err + 1
        print("parent_delete_insert_thr: insert", e)

    loops = loops + 1
    if not loops % 100 and done_flag.value == 1:
      break

    good_v.value = ok
    bad_v.value = err

def child_update_thr(done_flag, good_v, bad_v):
  loops = 0
  ok = 0
  err = 0

  while True:
    parent_id = random.randrange(0, FLAGS.parent_table_size)
    child_id = random.randrange(0, FLAGS.children_per_parent)

    conn = get_conn(False)
    cursor = conn.cursor()
    nrows = 0

    try:
      cursor.execute('update child set k = k + 1 where id = %d and parent_id = %d' % (child_id, parent_id))
      cursor.execute('select row_count()')
      nrows = cursor.fetchone()[0]
      #print(nrows)
      conn.commit()
    except MySQLdb.Error as e:
      err = err + 1
      nrows = 0
      print("child_delete_insert_thr: delete", e)

    if nrows == 1:
      ok = ok + 1

    loops = loops + 1
    if not loops % 100 and done_flag.value == 1:
      break

    good_v.value = ok
    bad_v.value = err

def parent_update_thr(done_flag, good_v, bad_v):
  loops = 0
  ok = 0
  err = 0

  while True:
    parent_id = random.randrange(0, FLAGS.parent_table_size)

    conn = get_conn(False)
    cursor = conn.cursor()
    nrows = 0

    try:
      cursor.execute('update parent set k = k + 1 where id = %d' % (parent_id))
      cursor.execute('select row_count()')
      nrows = cursor.fetchone()[0]
      #print(nrows)
      conn.commit()
    except MySQLdb.Error as e:
      err = err + 1
      nrows = 0
      print("child_delete_insert_thr: delete", e)

    if nrows == 1:
      ok = ok + 1

    loops = loops + 1
    if not loops % 100 and done_flag.value == 1:
      break

    good_v.value = ok
    bad_v.value = err

def fk_helper(fn, fn_name):
  done_flag = Value('i', 0)
  threads = []
  good_vars = []
  bad_vars = []

  check_table_sizes("%s:pre" % fn_name)

  for i in range(FLAGS.threads):
    good_v = Value('i', 0)
    bad_v = Value('i', 0)
    good_vars.append(good_v)
    bad_vars.append(bad_v)

    x = Process(target=fn, args=(done_flag, good_v, bad_v))
    threads.append(x)

  for t in threads:
    t.start()

  for loops in range(FLAGS.test_duration_seconds // 10):
    time.sleep(10)
 
  done_flag.value = 1
 
  for t in threads:
    t.join()

  good_sum = 0
  print("%s: good" % fn_name)
  for v in good_vars:
    print(v.value) 
    good_sum = good_sum + v.value

  bad_sum = 0
  print("%s: bad" % fn_name)
  for v in bad_vars:
    print(v.value) 
    bad_sum = bad_sum + v.value

  print('%s: (good, bad): total=( %.0f , %.0f ) and per-thread=( %.0f , %.0f )' % (
        fn_name,
        good_sum / FLAGS.test_duration_seconds,
        bad_sum / FLAGS.test_duration_seconds,
        good_sum / FLAGS.test_duration_seconds / FLAGS.threads,
        bad_sum / FLAGS.test_duration_seconds / FLAGS.threads))

  check_table_sizes("%s:post" % fn_name)

def child_delete_insert():
  fk_helper(child_delete_insert_thr, "child_delete_insert")

def child_update():
  fk_helper(child_update_thr, "child_update")

def parent_delete_insert():
  fk_helper(parent_delete_insert_thr, "parent_delete_insert")

def parent_update():
  fk_helper(parent_update_thr, "parent_update")

def main(argv):
  assert not (FLAGS.parent_table_size % 1000), "parent_table_size must be a multiple of 1000"

  multiprocessing.set_start_method('fork')
  random.seed(FLAGS.seed)

  if FLAGS.setup:
    create_tables()
    load_tables()

  child_delete_insert()
  child_update()
  parent_delete_insert()
  parent_update()

if __name__ == '__main__':
  new_argv = ParseArgs(sys.argv[1:])
  sys.exit(main([sys.argv[0]] + new_argv))
