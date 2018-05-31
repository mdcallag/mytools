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

    # Number of keys per hash bucket
    parser.add_argument('--index_bucket_size', type=int, default=4)
    # Load factor for in-memory hash
    parser.add_argument('--index_load_factor', type=int, default=80)

    parser.add_argument('--index_write_amp', type=float, default=2.0)

    r = parser.parse_args(argv)

    print 'database_gb ', r.database_gb
    print 'row_size ', r.row_size
    print 'key_size ', r.key_size
    print 'bytes_per_block_pointer ', r.bytes_per_block_pointer

    # Percentage of live data in the log segments that store data
    print 'log_percent_live ', r.log_percent_live

    print 'index_bucket_size ', r.index_bucket_size
    print 'index_load_factor %.2f' % r.index_load_factor
    print 'index_write_amp %.2f' % r.index_write_amp

    nrows = (r.database_gb * 1024 * 1024 * 1024) / r.row_size
    print 'Mrows %.2f' % (nrows / 1000000.0)

    index_adjust = (1.0 * r.key_size + r.bytes_per_block_pointer) / r.row_size
    index_adjust *= 100.0 / r.index_load_factor
    print 'index adjust %.3f' % index_adjust

    fix_index_wa = r.index_write_amp * index_adjust
    fix_index_sa = index_adjust

    # this is worst case write amp, assume each dirty page has only one modified row
    log_write_amp = 100 / (100.0 - r.log_percent_live)
    print 'write amp: %.2f, log %.2f, index %.2f' % (
        log_write_amp + fix_index_wa, log_write_amp, fix_index_wa)

    log_space_amp = 100 / (r.log_percent_live * 1.0)
    print 'space amp: %.2f, log %.2f, index %.2f' % (
        log_space_amp + fix_index_sa, log_space_amp, fix_index_sa)

    search_cmp = math.ceil(math.log(r.index_bucket_size, 2))
    insert_gc_cmp = log_write_amp * search_cmp
    print 'compares: search %.2f, insert %.2f, insert+gc %.2f' % (
        search_cmp, search_cmp, search_cmp * (log_write_amp + 1))

    cache_gb = ((r.key_size + r.bytes_per_block_pointer) * nrows) / (1024.0 * 1024 * 1024)
    cache_gb *= 100.0 / r.index_load_factor
    print 'cache-amp: %.3f, cache_gb %.2f' % (cache_gb / r.database_gb, cache_gb)

    return 0

def main(argv):
    return runme(argv)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

