#!/usr/bin/python
#
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

"""MySQL client that runs all commands from stdin
"""

__author__ = 'Mark Callaghan'

import itertools
import optparse
import random
import sys
import threading
import time
import fileinput
import MySQLdb

def get_conn(options):
    if options.db_host:
        return MySQLdb.connect(host=options.db_host,
                               user=options.db_user,
                               passwd=options.db_password,
                               db=options.db_name)
    else:
        return MySQLdb.connect(unix_socket=options.db_socket,
                               user=options.db_user,
                               passwd=options.db_password,
                               db=options.db_name)


def process_sql(options, files):
    conn = get_conn(options)
    cursor = conn.cursor()

    for line in fileinput.input(files):
        if line:
            r = cursor.execute(line)
            rows = cursor.fetchall()
            if options.print_query:
                print line;
            if options.print_result:
                print rows

    cursor.close()
    conn.close()

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
                    default="",
                    help="Hostname for database")
  parser.add_option("--db_socket", action="store",
                    type="string",dest="db_socket",
                    default="",
                    help="Socket for database")
  parser.add_option("--db_name", action="store",
                    type="string",dest="db_name",
                    default="test",
                    help="Database name")

  parser.add_option('--print_query', action='store_true',
                    default=False, dest='print_query',
                    help='Print each query')
  parser.add_option('--print_result', action='store_true',
                    default=False, dest='print_result',
                    help='Print each query result')
                    
  return parser.parse_args(args)

def main(argv=None):
    if argv is None:
        argv = sys.argv

    options, args = parse_opts(argv[1:])
    process_sql(options, [f for f in argv[1:] if not f.startswith('--')])

if __name__ == "__main__":
    sys.exit(main())

