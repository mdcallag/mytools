# read, write and space amp for a clustered b-tree

import sys
import argparse
import math

def uip_metrics(args):
    res = {}

    if args['linear_load_factor'] == 75:
      res['linear_hit'] = 1.02
      res['linear_miss'] = 1.12
    elif args['linear_load_factor'] == 80:
      res['linear_hit'] = 1.03
      res['linear_miss'] = 1.24
    elif args['linear_load_factor'] == 85:
      res['linear_hit'] = 1.07
      res['linear_miss'] = 1.46
    elif args['linear_load_factor'] == 90:
      res['linear_hit'] = 1.14
      res['linear_miss'] = 1.94
    else:    
      print 'load factor must be one of 75, 80, 85, 90'
      sys.exit(-1)

    # Cost to find block in which key might exist for linear, extendible/array
    # and extendible/trie. Cost is expressed in terms of comparisons to be
    # comparable to tree-based perf models.
    res['block_find'] = [0, 1, args['key_size']]

    # Cost to find the block and then find the place in the block to put the record
    # for linear, extendible/array, extendible/trie
    res['basic_cmp'] = [
      res['block_find'][0] + args['block_search_cmp'],
      res['block_find'][1] + args['block_search_cmp'],
      res['block_find'][2] + args['block_search_cmp']
    ]

    res['insert_cmp'] = [
        res['basic_cmp'][0] * res['linear_miss'],
        res['basic_cmp'][1],
        res['basic_cmp'][2] ]
    res['insert_read'] = [res['linear_miss'], 1.0, 1.0]

    res['point_hit_cmp'] = [
        res['basic_cmp'][0] * res['linear_hit'],
        res['basic_cmp'][1],
        res['basic_cmp'][2] ]
    res['point_hit_read'] = [res['linear_hit'], 1.0, 1.0]

    res['point_miss_cmp'] = [
        res['basic_cmp'][0] * res['linear_miss'],
        res['basic_cmp'][1],
        res['basic_cmp'][2] ]
    res['point_miss_read'] = [res['linear_miss'], 1.0, 1.0]

    # this is worst case write amp, assume each dirty page has only one modified row
    res['write_amp'] = (args['block_bytes'] * 1.0) / args['row_size']

    # With extendible for each block there is one key and one block pointer in memory.
    # This only counts overhead for the level above the leaf level
    nblocks = (args['database_gb'] * 1024 * 1024 * 1024) / args['block_bytes']
    ext_cache_mb = (args['directory_size_factor'] * nblocks * (args['key_size'] + args['bytes_per_block_pointer']))
    ext_cache_mb /= (1024.0 * 1024)
    res['ext_cache_mb'] = ext_cache_mb

    # With linear assume that most (1/2) of the overflow block must stay in cache to meet the SLA of 
    # at most 1 storage read per point query. The estimate for the number of overflow blocks
    # is (linear_miss - 1) * nblocks
    lin_cache_mb = (args['database_gb'] * 1024) * (res['linear_miss'] - 1) * args['linear_cached_overflow']
    res['lin_cache_mb'] = lin_cache_mb

    return res

def do_uip(args):
    uip = uip_metrics(args)

    print '\ncosts for linear, extendible/array, extendible/trie'
    print 'insert compares:\t%.2f\t%.2f\t%.2f' % (
        uip['insert_cmp'][0], uip['insert_cmp'][1], uip['insert_cmp'][2])
    print 'insert read:\t\t%.2f\t%.2f\t%.2f' % (
        uip['insert_read'][0], uip['insert_read'][1], uip['insert_read'][2])

    print 'point-hit compares:\t%.2f\t%.2f\t%.2f' % (
        uip['point_hit_cmp'][0], uip['point_hit_cmp'][1], uip['point_hit_cmp'][2])
    print 'point-hit read:\t\t%.2f\t%.2f\t%.2f' % (
        uip['point_hit_read'][0], uip['point_hit_read'][1], uip['point_hit_read'][2])

    print 'point-miss compares:\t%.2f\t%.2f\t%.2f' % (
        uip['point_miss_cmp'][0], uip['point_miss_cmp'][1], uip['point_miss_cmp'][2])
    print 'point-miss read:\t%.2f\t%.2f\t%.2f' % (
        uip['point_miss_read'][0], uip['point_miss_read'][1], uip['point_miss_read'][2])
        
    print 'space-amp:\t\t%.2f\t%.2f\t%.2f' % (
        1 / (args['linear_load_factor'] / 100.0),
        1 / 0.7, 1 / 0.7)

    # this is worst case write amp, assume each dirty page has only one modified row
    print 'write-amp:\t\t%.2f' % uip['write_amp']

    # With extendible for each block there is one key and one block pointer in memory.
    # This only counts overhead for the level above the leaf level
    print 'cache-amp extendible:\t%.4f with %.1f cache_mb' % (
        uip['ext_cache_mb'] / (args['database_gb'] * 1024.0),
        uip['ext_cache_mb'])

    # With linear assume that most (1/2) of the overflow block must stay in cache to meet the SLA of 
    # at most 1 storage read per point query. The estimate for the number of overflow blocks
    # is (linear_miss - 1) * nblocks
    print 'cache-amp linear:\t%.4f with %.1f cache_mb' % (
        uip['lin_cache_mb'] / (args['database_gb'] * 1024.0),
        uip['lin_cache_mb'])

def do_lsm(args):
    print '\ncosts for LSM with linear hashing per level'

    database_mb = args['database_gb'] * 1024
    total_fanout = database_mb / (args['lsm_memtable_mb'] * 1.0) 
    level_fanout = total_fanout ** (1.0 / args['lsm_max_level']) 
    print '%.1f total fanout, %.1f level fanout, %d max level' % (
        total_fanout, level_fanout, args['lsm_max_level'])

    level_mb = []
    level_uip = []
    cur_level = args['lsm_max_level']
    cur_level_mb = database_mb * 1.0
    cache_mb = args['lsm_memtable_mb']
    used_mb = 0 # includes space amp from wasted space in blocks

    nrows_memtable = (args['lsm_memtable_mb'] * 1024 * 1024.0) / args['row_size']
    cmp_memtable = math.ceil(math.log(args['lsm_rows_per_memtable_bucket'], 2))

    while cur_level > 0:
      level_mb.append(cur_level_mb)
      largs = args.copy()
      largs['database_gb'] = cur_level_mb / 1024.0
      largs['nrows'] = (largs['database_gb'] * 1024 * 1024 * 1024) / largs['row_size']
      print 'level %d, data_gb %.1f, Mrows %.2f' % (
          cur_level, largs['database_gb'], largs['nrows'] / 1000000.0)

      uip = uip_metrics(largs)
      level_uip.append(uip)

      cache_mb += uip['lin_cache_mb']
      if cur_level < args['lsm_max_level'] or args['lsm_bloom_on_max']:
        cache_mb += (largs['nrows'] * largs['lsm_bloom_filter_bits']) / 8 / (1024.0 * 1024)

      used_mb += (largs['database_gb'] * 1024) / (args['linear_load_factor'] / 100.0)

      cur_level_mb = cur_level_mb / level_fanout
      cur_level -= 1

    level_mb.reverse()
    level_uip.reverse()

    print 'cache-amp:\t%.4f with %.1f cache_mb' % (
        cache_mb / (args['database_gb'] * 1024.0), cache_mb)

    print 'space-amp:\t%.2f' % (used_mb / 1024.0 / args['database_gb'])

    prob_hit = (args['lsm_memtable_mb'] * 1.0) / database_mb
    cum_hit_cmp = prob_hit * cmp_memtable
    cum_miss_cmp = cmp_memtable
    print 'level 0: hit/miss level %.3f/%.3f' % (cum_hit_cmp, cum_miss_cmp)

    for x, mb in enumerate(level_mb):
      uip = level_uip[x]

      prob_hit = (mb * 1.0) / database_mb

      # The +1 in a few places below is the cost of using linear hashing
      if (x+1) < args['lsm_max_level'] or args['lsm_bloom_on_max']:
        bf_cmp = args['lsm_bloom_filter_cmp']
        miss_cmp = 1 + bf_cmp
      else:
        miss_cmp = (1 + args['block_search_cmp']) * uip['linear_miss']

      hit_cmp1 = (1 + bf_cmp + args['block_search_cmp']) * uip['linear_hit']
      hit_cmp2 = (hit_cmp1 + cum_miss_cmp) * prob_hit
      cum_hit_cmp += hit_cmp2
      cum_miss_cmp += miss_cmp
      print 'level %d: hit1/hit2/miss level %.3f/%.3f/%.3f and cum %.3f/%.3f' % (
          x+1, hit_cmp1, hit_cmp2, miss_cmp, cum_hit_cmp, cum_miss_cmp)

    write_amp = comp_cmp = 0
    for x, mb in enumerate(level_mb):
      lnum = x + 1

      if lnum == args['lsm_max_level']:
        write_amp += level_fanout
        comp_cmp += level_fanout # merge 2 streams, larger is level_fanout times larger

      else:
        # assume larger level is half full on average during compaction into it
        write_amp += level_fanout / 2.0
        comp_cmp += level_fanout / 2.0

    print 'write-amp:\t%.2f' % write_amp
    print 'compares: insert %.1f, compaction %.1f, total %.1f\n' % (
        cmp_memtable, comp_cmp, cmp_memtable + comp_cmp)


def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--row_size', type=int, default=128)
    parser.add_argument('--key_size', type=int, default=8)
    parser.add_argument('--block_bytes', type=int, default=4096)

    # The default is a 6-byte pointer
    parser.add_argument('--bytes_per_block_pointer', type=int, default=6)

    # The extendible hash directory is this many times larger than optimal 
    parser.add_argument('--directory_size_factor', type=float, default=4.0)

    # load factor is for linear hashing. Supported values are 75, 80, 85, 90
    # 80 means hash table is 80% full
    parser.add_argument('--linear_load_factor', type=int, default=80)

    # Fraction of overflow blocks that must be cached so that at most one
    # disk read is done per point query
    parser.add_argument('--linear_cached_overflow', type=float, default=0.25)

    parser.add_argument('--lsm_memtable_mb', type=int, default=1024)
    parser.add_argument('--lsm_max_level', type=int, default=3)
    parser.add_argument('--lsm_bloom_filter_bits', type=int, default=10)
    # Cost of checking bloom filter using "comparisons" as unit
    parser.add_argument('--lsm_bloom_filter_cmp', type=int, default=3)
    parser.add_argument('--lsm_bloom_on_max', type=int, default=0)
    parser.add_argument('--lsm_rows_per_memtable_bucket', type=int, default=4)

    a = vars(parser.parse_args(argv))

    print 'database_gb ', a['database_gb']
    print 'row_size ', a['row_size']
    print 'key_size ', a['key_size']
    print 'block_bytes ', a['block_bytes']
    print 'bytes_per_block_pointer ', a['bytes_per_block_pointer']
    print 'directory_size_factor ', a['directory_size_factor']

    a['nrows'] = (a['database_gb'] * 1024 * 1024 * 1024) / a['row_size']
    print 'Mrows %.2f' % (a['nrows'] / 1000000.0)

    a['rows_per_block'] = a['block_bytes'] / a['row_size']
    print 'rows_per_block ', a['rows_per_block']

    # This assumes binary search within a block
    a['block_search_cmp'] = math.ceil(math.log(a['rows_per_block'], 2))
    print 'block_search_cmp ', a['block_search_cmp']

    print 'linear_load_factor ', a['linear_load_factor']
    print 'linear_cached_overflow %.2f' % a['linear_cached_overflow']

    print 'lsm_memtable_mb ', a['lsm_memtable_mb']
    print 'lsm_max_level ', a['lsm_max_level']
    print 'lsm_bloom_filter_bits', a['lsm_bloom_filter_bits']
    print 'lsm_bloom_filter_cmp', a['lsm_bloom_filter_cmp']
    print 'lsm_bloom_on_max', a['lsm_bloom_on_max']
    print 'lsm_rows_per_memtable_bucket', a['lsm_rows_per_memtable_bucket']

    do_uip(a)
    do_lsm(a)

    return 0

def main(argv):
    return runme(argv)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

