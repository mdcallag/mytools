# read, write and space amp for a clustered b-tree

import sys
import argparse
import math

def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--row_size', type=int, default=128)
    parser.add_argument('--key_size', type=int, default=8)
    parser.add_argument('--block_kb', type=int, default=4)

    # percentage of leaf page that has valid data, rest is empty from fragmentation
    parser.add_argument('--leaf_fill_percent', type=int, default=65)

    # The default is a 6-byte pointer
    parser.add_argument('--bytes_per_block_pointer', type=int, default=6)

    r = parser.parse_args(argv)

    print 'database_gb ', r.database_gb
    print 'row_size ', r.row_size
    print 'key_size ', r.key_size
    print 'block_kb ', r.block_kb
    print 'leaf_fill_percent ', r.leaf_fill_percent
    print 'bytes_per_block_pointer ', r.bytes_per_block_pointer

    nrows = (r.database_gb * 1024 * 1024 * 1024) / r.row_size 
    print 'Mrows %.2f' % (nrows / 1000000.0)

    insert_cmp = hit_cmp = miss_cmp = math.ceil(math.log(nrows, 2))
    range_cmp = 1 # one compare to confirm key is within range

    print '\ninsert %.0f compares, 1 read' % insert_cmp
    print 'Compares point-hit/point-miss/range: %.2f\t%.2f\t%.2f' % (
        hit_cmp, miss_cmp, range_cmp)
    print 'space amp: %.2f' % (1 / (r.leaf_fill_percent / 100.0))

    # this is worst case write amp, assume each dirty page has only one modified row
    write_amp = (r.block_kb * 1024.0) / r.row_size
    print 'write amp: %.1f' % write_amp

    # For each block there is one key and one block pointer in memory.
    # This only counts overhead for the level above the leaf level
    nblocks = (r.database_gb * 1024 * 1024) / r.block_kb
    cache_mb = (nblocks * (r.key_size + r.bytes_per_block_pointer)) / (1024.0 * 1024)
    print 'cache amp: %.4f with %.1f cache_mb' % (cache_mb / (r.database_gb * 1024.0),
        cache_mb)

    return 0

def main(argv):
    return runme(argv)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

