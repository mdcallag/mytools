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

def main(argv):
  conn = get_conn()
  cur = conn.cursor()
  cur.execute("select version()")
  d = cur.fetchone()
  print(d)

if __name__ == '__main__':
  new_argv = ParseArgs(sys.argv[1:])
  sys.exit(main([sys.argv[0]] + new_argv))
