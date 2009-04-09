#!/usr/bin/python
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

"""Wisconsin benchmark

This runs a modified version of the wisconsin benchmark

"""

__author__ = 'Mark Callaghan'

import itertools
import optparse
import random
import sys
import threading
import time

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


def get_gen_prime(rows):
    if rows <= 1000:
        return 26, 1009
    elif rows <= 10000:
        return 59, 10007
    elif rows <= 100000:
        return 242, 100003
    elif rows <= 1000000:
        return 568, 1000003
    elif rows <= 10000000:
        return 1792, 10000019
    elif rows <= 100000000:
        return 5649, 100000007
    elif rows <= 1000000000:
        return 16807, 2147483647
    else:
        print 'Max scale factor is %d' % (100000000 / 10000)
        sys.exit(1)

def gen_row(unique1, unique2):
    return ('(%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)'
            % (unique1, unique2, unique1, unique2,
               unique1 % 1000000,
               unique1 % 100000,
               unique1 % 10000,
               unique1 % 1000,
               unique1 % 100,
               unique1 % 10,
               unique1 % 5,
               unique1 % 2,
               unique1))

def mix(seed, limit, gen, prime):
    while True:
        seed = (gen * seed) % prime
        if seed <= limit:
            return seed

def insert_table(options, nrows, table_name):
    conn = get_conn(options)
    cursor = conn.cursor()

    gen, prime = get_gen_prime(nrows)
    seed = gen
    rows = []
    for i in xrange(nrows):
        seed = mix(seed, rows, gen, prime)
        unique1 = seed - 1
        unique2 = i
        rows.append(gen_row(unique1, unique2))
        if len(rows) == 1000:
            sql = 'insert into %s values %s'\
                % (table_name, ',\n'.join(rows))
            # print sql
            r = cursor.execute(sql)
            assert r == 1000
            cursor.execute('commit')
            rows = []

    cursor.execute('select count(*) from %s' % table_name)
    print 'inserted %d rows into %s' % (
        cursor.fetchall()[0][0], table_name)
    cursor.close()
    conn.close()

def insert_wisc(options):
    insert_table(options, options.onekrows, 'onektup')
    insert_table(options, options.tenkrows, 'tenktup1')
    insert_table(options, options.tenkrows, 'tenktup2')

def index_wisc(options):
    conn = get_conn(options)
    cursor = conn.cursor()
    alters = ['alter table %s add constraint unique(unique1)']

    creates = ['create index x_%s_hundred on %s(hundred)']

    if options.complex_query:
        creates.append('create index x_%s_thousand on %s(thousand)')
        creates.append('create index x_%s_tenThousand on %s(tenThousand)')
        creates.append('create index x_%s_hundredThousand on %s(hundredThousand)')
        creates.append('create index x_%s_million on %s(million)')

    for t in ['onektup', 'tenktup1', 'tenktup2']:
        for sql in alters:
            cursor.execute(sql % t)
        for sql in creates:
            cursor.execute(sql % (t, t))

    cursor.close()
    conn.close()

def create_wisc(options):
    conn = get_conn(options)
    cursor = conn.cursor()
    cursor.execute("drop table if exists onektup")
    cursor.execute("drop table if exists tenktup1")
    cursor.execute("drop table if exists tenktup2")
    sql = ("create table %s ( "
           "unique1 int, unique2 int primary key, "
           "unique1_ni int, unique2_ni int, "
           "million int, hundredThousand int, "
           "tenThousand int, thousand int, "
           "hundred int, ten int, five int, two int, "
           "unique3 int"
           ") engine=%s")
    
    for t in ['onektup', 'tenktup1', 'tenktup2']:
        cursor.execute(sql % (t, options.engine))
    cursor.close()
    conn.close()

def query1t(options):
    vals = options.scale_factor * 100
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique2_ni '
            'between %d and %d' % (start, start + vals - 1),
            vals, 'q1t', True)

def query1s(options):
    vals = options.scale_factor * 100
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique2_ni '
            'between %d and %d' % (start, start + vals - 1),
            vals, 'q1s', False)

def query3t(options):
    vals = options.scale_factor * 100
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique2 '
            'between %d and %d' % (start, start + vals - 1),
            vals, 'q3t', True)

def query3s(options):
    vals = options.scale_factor * 100
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique2 '
            'between %d and %d' % (start, start + vals - 1),
            vals, 'q3s', False)

def query2t(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique2_ni '
            'between %d and %d' % (start, start + vals - 1),
            vals, 'q2t', True)

def query2s(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique2_ni '
            'between %d and %d' % (start, start + vals - 1),
            vals, 'q2s', False)

def query4t(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique2 '
            'between %d and %d' % (start, start + vals - 1),
            vals, 'q4t', True)

def query4s(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique2 '
            'between %d and %d' % (start, start + vals - 1),
            vals, 'q4s', False)

def query5t(options):
    vals = options.scale_factor * 100
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique1 '
            'between %d and %d' % (start, start + vals - 1),
            vals-1, 'q5t', True)

def query5s(options):
    vals = options.scale_factor * 100
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique1 '
            'between %d and %d' % (start, start + vals - 1),
            vals-1, 'q5s', False)

def query6t(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique1 '
            'between %d and %d' % (start, start + vals - 1),
            vals-1, 'q6t', True)

def query6s(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select * from tenktup1 where unique1 '
            'between %d and %d' % (start, start + vals - 1),
            vals-1, 'q6s', False)

def query12t(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select tenktup1.* from tenktup1, tenktup2 '
            'where tenktup2.unique2 between %d and %d and '
            'tenktup1.unique2 = tenktup2.unique2' %
            (start, start + vals - 1), vals, 'q12t', True)

def query12s(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select tenktup1.* from tenktup1, tenktup2 '
            'where tenktup2.unique2 between %d and %d and '
            'tenktup1.unique2 = tenktup2.unique2' %
            (start, start + vals - 1), vals, 'q12s', False)

def query14t(options):
    vals = options.scale_factor * 1000
    return ('select tenktup1.* from onektup, tenktup1, tenktup2 '
            'where onektup.unique1 = tenktup1.unique2 and '
            'tenktup1.unique2 = tenktup2.unique2 and '
            'tenktup1.unique2 < %d' % vals, vals * 0.95, 'q14t', True)

def query14s(options):
    vals = options.scale_factor * 1000
    return ('select tenktup1.* from onektup, tenktup1, tenktup2 '
            'where onektup.unique1 = tenktup1.unique2 and '
            'tenktup1.unique2 = tenktup2.unique2 and '
            'tenktup1.unique2 < %d' % vals, vals * 0.95, 'q14s', False)

def query15t(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select tenktup1.* from tenktup1, tenktup2 '
            'where tenktup1.unique1 = tenktup2.unique2 '
            'and tenktup1.unique2 between %d and %d' %
            (start, start + vals - 1), vals-1, 'q15t', True)

def query15s(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select tenktup1.* from tenktup1, tenktup2 '
            'where tenktup1.unique1 = tenktup2.unique2 '
            'and tenktup1.unique2 between %d and %d' %
            (start, start + vals - 1), vals-1, 'q15s', False)

def query16t(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select tenktup1.* from tenktup1, tenktup2 '
            'where tenktup1.unique1 = tenktup2.unique1 and '
            'tenktup2.unique2 between %d and %d' %
            (start, start + vals - 1), vals, 'q16t', True)

def query16s(options):
    vals = options.scale_factor * 1000
    start = random.randrange(options.tenkrows - vals)
    return ('select tenktup1.* from tenktup1, tenktup2 '
            'where tenktup1.unique1 = tenktup2.unique1 and '
            'tenktup2.unique2 between %d and %d' %
            (start, start + vals - 1), vals, 'q16s', False)

def query17t(options):
    vals = options.scale_factor * 1000
    return ('select tenktup1.* from onektup, tenktup1, tenktup2 '
            'where onektup.unique1 = tenktup1.unique1 and '
            'tenktup1.unique1 = tenktup2.unique1 and '
            'tenktup1.unique1 < %d' % vals, 0.95 * vals, 'q17t', True)

def query17s(options):
    vals = options.scale_factor * 1000
    return ('select tenktup1.* from onektup, tenktup1, tenktup2 '
            'where onektup.unique1 = tenktup1.unique1 and '
            'tenktup1.unique1 = tenktup2.unique1 and '
            'tenktup1.unique1 < %d' % vals, 0.95 * vals, 'q17s', False)

def query18t(options):
    return ('select distinct two, five, ten, hundred from tenktup1',
            100, 'q18t', True)

def query18s(options):
    return ('select distinct two, five, ten, hundred from tenktup1',
            100, 'q18s', False)

def query19t(options):
    return ('select distinct two, five, ten, hundred, thousand, tenThousand '
            'from tenktup2', 10000, 'q19t', True)

def query19s(options):
    return ('select distinct two, five, ten, hundred, thousand, tenThousand '
            'from tenktup2', 10000, 'q19s', False)

def query24t(options):
    return ('select min(unique3) from tenktup1 group by hundred',
            100, 'q24t', True)

def query24s(options):
    return ('select min(unique3) from tenktup1 group by hundred',
            100, 'q24s', False)

def query25t(options):
    return ('select min(unique3) from tenktup2 group by hundred',
            100, 'q25t', True)

def query25s(options):
    return ('select min(unique3) from tenktup2 group by hundred',
            100, 'q25s', False)

def query40t(options):
    return ('select min(unique3) from tenktup2 group by million',
            min(options.scale_factor, 1000000), 'q40t', True)

def query40s(options):
    return ('select min(unique3) from tenktup2 group by million',
            min(options.scale_factor, 1000000), 'q40s', False)


class QueryThread(threading.Thread):
    def __init__(self, id, options):
        threading.Thread.__init__(self)
        self.id = id
        self.options = options
        self.times = {}

    def run(self):
        conn = get_conn(self.options)
        cursor = conn.cursor()

        for qf in [query1t, query3t, query2t, query4t, query5t, query6t,
                   query12t, query14t, query15t, query16t, query17t,
                   query18t, query19t, query24t, query25t, query40t,
                   query1s, query3s, query2s, query4s, query5s, query6s,
                   query12s, query14s, query15s, query16s, query17s,
                   query18s, query19s, query24s, query25s, query40s]:
            start = time.time()
            for i in xrange(self.options.loops):
                sql, nrows, name, use_temp = qf(self.options)
                if use_temp:
                    sql = 'create temporary table tt as %s' % sql
                r = cursor.execute(sql)
                if self.options.debug_query and r < nrows:
                    print 'Expected %d from %s, got %d from %s'\
                        % (nrows, name, r, sql)
                    sys.exit(1)
                if use_temp:
                    cursor.execute('drop temporary table tt')
            end = time.time()
            self.times[name] = end - start, sql

        cursor.close()
        conn.close()
        print 'Done %d' % self.id

def run_wisc(options):
    sessions = []
    for i in xrange(options.threads):
        sessions.append(QueryThread(i, options))
    times = {}

    start = time.time()
    for s in sessions:
        s.start()

    done = False
    for s in sessions:
        s.join()
        if not done:
            for k,v in s.times.iteritems():
                times[k] = v[0], v[1]
        else:
            for k,v in s.times.iteritems():
                times[k][0] += v[0]
    end = time.time()
    keys = times.keys()
    keys.sort()
    for k in keys:
        print 'Avg time for %s is %.1f seconds\n    ---- (%s)'\
            % (k, times[k][0] / options.threads, times[k][1])
    print 'Test time is %.1f seconds' % (end - start)

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
  parser.add_option("--engine", action="store",
                    type="string",dest="engine",
                    default="innodb",
                    help="Database engine")
  parser.add_option("--threads", action="store",
                    type="int", dest="threads",
                    default="1",
                    help="Number of concurrent connections")
  parser.add_option("--loops", action="store",
                    type="int", dest="loops",
                    default="10",
                    help="Number of times a query is repeated")
  parser.add_option("--scale_factor", action="store",
                    type="int", dest="scale_factor",
                    default="1",
                    help="Base tables have 10,000 * scale_factor rows")
  parser.add_option("--prepare", action="store_true",
                    default=False, dest="prepare",
                    help="Setup the test tables")
  parser.add_option("--debug_query", action="store_true",
                    default=False, dest="debug_query",
                    help="Check query results")
  parser.add_option("--index_after_load", action="store_true",
                    default=False, dest="index_after_load",
                    help="Create indexes on the test tables")
  # TODO
  parser.add_option('--complex_query', action='store_true',
                    default=False, dest='complex_query',
                    help='Use queries with a complex where clause. '
                    'Not implemented yet.')
                    
  return parser.parse_args(args)

def main(argv=None):
    if argv is None:
        argv = sys.argv

    options, args = parse_opts(argv[1:])
    setattr(options, 'tenkrows', 10000 * options.scale_factor)
    setattr(options, 'onekrows', 1000 * options.scale_factor)
    print options.tenkrows, options.onekrows

    if options.prepare:
        create_wisc(options)
        if not options.index_after_load:
            index_wisc(options)
        insert_wisc(options)
        if options.index_after_load:
            index_wisc(options)

    run_wisc(options)

if __name__ == "__main__":
    sys.exit(main())

