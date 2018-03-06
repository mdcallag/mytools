# read, write and space amp for a clustered b-tree

import sys
import argparse
import math

def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--row_size', type=int, default=128)
    parser.add_argument('--key_size', type=int, default=8)
    parser.add_argument('--bytes_per_block_pointer', type=int, default=6)

    # percentage of leaf page that has valid data, rest is empty from fragmentation
    parser.add_argument('--log_percent_live', type=int, default=80)

    # Number of comparisons per point lookup based on index data structure
    parser.add_argument('--index_point_compares', type=int, default=-1)

    parser.add_argument('--index_write_amp', type=float, default=0.0)
    parser.add_argument('--index_space_amp', type=float, default=0.0)

    r = parser.parse_args(argv)

    if r.index_point_compares == -1:
      print 'must specify value for --index_point_compares'
      sys.exit(-1)

    if r.index_write_amp == 0 or r.index_space_amp == 0:
      print 'index_write_amp, index_space_amp must be > 0'
      sys.exit(-1)

    print 'database_gb ', r.database_gb
    print 'row_size ', r.row_size
    print 'key_size ', r.key_size

    # Percentage of live data in the log segments that store data
    print 'log_percent_live', r.log_percent_live

    print 'index_point_compares', r.index_point_compares
    print 'index_write_amp %.2f' % r.index_write_amp
    print 'index_space_amp %.2f' % r.index_space_amp

    nrows = (r.database_gb * 1024 * 1024 * 1024) / r.row_size
    print 'Mrows %.2f' % (nrows / 1000000.0)

    index_adjust = (1.0 * r.key_size + r.bytes_per_block_pointer) / r.row_size
    fix_index_wa = r.index_write_amp * index_adjust
    fix_index_sa = r.index_space_amp * index_adjust

    # this is worst case write amp, assume each dirty page has only one modified row
    log_write_amp = 100 / (100.0 - r.log_percent_live)
    print 'write amp: %.1f, log %.1f, index %.1f' % (
        log_write_amp + fix_index_wa, log_write_amp, fix_index_wa)

    log_space_amp = 100 / (r.log_percent_live * 1.0)
    print 'space amp: %.1f, log %.1f, index %.1f' % (
        log_space_amp + fix_index_sa, log_space_amp, fix_index_sa)

    # Do index_point_compares search on the insert and then GC does more compares
    # to determine whether entries can be removed
    insert_gc_cmp = math.ceil(log_write_amp * r.index_point_compares)
    print 'insert cmp %d, search %d, gc %d' % (insert_gc_cmp + r.index_point_compares,
        r.index_point_compares, insert_gc_cmp)

    return 0

def main(argv):
    return runme(argv)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

