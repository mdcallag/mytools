# computes read, write and space amp for a non-clustered btree

import sys
import argparse
import math

def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--row_size', type=int, default=128)
    parser.add_argument('--key_size', type=int, default=8)
    parser.add_argument('--block_bytes', type=int, default=4096)

    # percentage of index page that has live data
    parser.add_argument('--index_fill_percent', type=int, default=65)

    # percentage of index page that is dirty when written back
    parser.add_argument('--index_dirty_percent', type=int, default=20)

    # percentage of data pages that have live data
    parser.add_argument('--data_fill_percent', type=int, default=75)

    # The default is a 6-byte pointer
    parser.add_argument('--bytes_per_block_pointer', type=int, default=6)

    r = parser.parse_args(argv)

    print 'database_gb ', r.database_gb
    print 'row_size ', r.row_size
    print 'key_size ', r.key_size
    print 'block_bytes ', r.block_bytes
    print 'index_fill_percent', r.index_fill_percent
    print 'index_dirty_percent ', r.index_dirty_percent
    print 'data_fill_percent ', r.data_fill_percent
    print 'bytes_per_block_pointer ', r.bytes_per_block_pointer

    nrows = (r.database_gb * 1024 * 1024 * 1024) / r.row_size 
    print 'Mrows %.2f' % (nrows / 1000000.0)

    insert_cmp = hit_cmp = miss_cmp = math.ceil(math.log(nrows, 2))
    range_cmp = 1 # one compare to confirm key is within range

    print '\ninsert %.0f compares, 1 read' % insert_cmp
    print 'Compares point-hit/point-miss/range: %.2f\t%.2f\t%.2f' % (
        hit_cmp, miss_cmp, range_cmp)

    index_mb = ((r.key_size + r.bytes_per_block_pointer) * nrows) / (1024.0 * 1024)
    data_files_mb = (r.database_gb * 1024) / (r.data_fill_percent / 100.0)
    print 'space amp: %.2f, space(mb) for data %.1f, index %.1f' % (
      ((data_files_mb + index_mb) / 1024.0) / r.database_gb, data_files_mb, index_mb)

    # this is worst case write amp, assume each dirty data page has only one modified row
    data_write_amp = (r.block_bytes * 1.0) / r.row_size
    # then add write amp for index
    index_write_amp = 1 / (1 - (r.index_dirty_percent / 100.0))
    print 'write amp: %.2f, data %.2f, index %.2f' % (
        data_write_amp + index_write_amp, data_write_amp, index_write_amp)

    # The index must be in RAM. So there is one key + block pointer per key. Compare
    # this to a clustered b-tree that needs one key + block pointer per block.
    cache_mb = (nrows * (r.key_size + r.bytes_per_block_pointer)) / (1024.0 * 1024)
    print 'cache amp: %.4f with %.1f cache_mb' % (cache_mb / (r.database_gb * 1024.0),
        cache_mb)

    return 0

def main(argv):
    return runme(argv)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

