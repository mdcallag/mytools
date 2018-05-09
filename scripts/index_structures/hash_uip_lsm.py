# read, write and space amp for a clustered b-tree

import sys
import argparse
import math

def uip_metrics(args):
    res = {}

    if args.linear_load_factor == 75:
      res['linear_hit'] = 1.02
      res['linear_miss'] = 1.12
    elif args.linear_load_factor == 80:
      res['linear_hit'] = 1.03
      res['linear_miss'] = 1.24
    elif args.linear_load_factor == 85:
      res['linear_hit'] = 1.07
      res['linear_miss'] = 1.46
    elif args.linear_load_factor == 90:
      res['linear_hit'] = 1.14
      res['linear_miss'] = 1.94
    else:    
      print 'load factor must be one of 75, 80, 85, 90'
      sys.exit(-1)

    res['rows_per_block'] = args.block_bytes / args.row_size
    print 'Rows_per_block %d' % res['rows_per_block']

    # This assumes binary search within a block
    res['block_search_cost'] = math.ceil(math.log(res['rows_per_block'], 2))

    # Cost to find block in which key might exist for linear, extendible/array
    # and extendible/trie. Cost is expressed in terms of comparisons to be
    # comparable to tree-based perf models.
    res['block_find'] = [0, 1, args.key_size]

    # Cost to find the block and then find the place in the block to put the record
    # for linear, extendible/array, extendible/trie
    res['basic_cmp'] = [
      res['block_find'][0] + res['block_search_cost'],
      res['block_find'][1] + res['block_search_cost'],
      res['block_find'][2] + res['block_search_cost']
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
    res['write_amp'] = (args.block_bytes * 1.0) / args.row_size

    # With extendible for each block there is one key and one block pointer in memory.
    # This only counts overhead for the level above the leaf level
    nblocks = (args.database_gb * 1024 * 1024 * 1024) / args.block_bytes
    ext_cache_mb = (args.directory_size_factor * nblocks * (args.key_size + args.bytes_per_block_pointer))
    ext_cache_mb /= (1024.0 * 1024)
    res['ext_cache_mb'] = ext_cache_mb

    # With linear assume that most (1/2) of the overflow block must stay in cache to meet the SLA of 
    # at most 1 storage read per point query. The estimate for the number of overflow blocks
    # is (linear_miss - 1) * nblocks
    lin_cache_mb = (args.database_gb * 1024) * (res['linear_miss'] - 1) * args.linear_cached_overflow
    res['lin_cache_mb'] = lin_cache_mb

    return res

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

    r = parser.parse_args(argv)

    print 'database_gb ', r.database_gb
    print 'row_size ', r.row_size
    print 'key_size ', r.key_size
    print 'block_bytes ', r.block_bytes
    print 'bytes_per_block_pointer ', r.bytes_per_block_pointer
    print 'directory_size_factor ', r.directory_size_factor

    nrows = (r.database_gb * 1024 * 1024 * 1024) / r.row_size 
    print 'Mrows %.2f' % (nrows / 1000000.0)

    print 'linear_load_factor %d' % r.linear_load_factor
    print 'linear_cached_overflow %.2f' % r.linear_cached_overflow

    uip = uip_metrics(r)

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
        1 / (r.linear_load_factor / 100.0),
        1 / 0.7, 1 / 0.7)

    # this is worst case write amp, assume each dirty page has only one modified row
    print 'write-amp:\t\t%.2f' % uip['write_amp']

    # With extendible for each block there is one key and one block pointer in memory.
    # This only counts overhead for the level above the leaf level
    print 'cache-amp extendible:\t%.4f with %.1f cache_mb' % (
        uip['ext_cache_mb'] / (r.database_gb * 1024.0),
        uip['ext_cache_mb'])

    # With linear assume that most (1/2) of the overflow block must stay in cache to meet the SLA of 
    # at most 1 storage read per point query. The estimate for the number of overflow blocks
    # is (linear_miss - 1) * nblocks
    print 'cache-amp linear:\t%.4f with %.1f cache_mb' % (
        uip['lin_cache_mb'] / (r.database_gb * 1024.0),
        uip['lin_cache_mb'])

    return 0

def main(argv):
    return runme(argv)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

