# Computes read, write and space metrics for row-blocks, a hybrid of index+log and LSM.

import sys
import argparse
import math

def config_l0(args, d):
    l0_max_mb_usable = args.l0_max_mb * (args.l0_index_load_factor / 100.0)
    print 'l0 max mb %.3f usable with %3f load factor' % (l0_max_mb_usable, args.l0_index_load_factor)
    max_entries = (l0_max_mb_usable * 1024 * 1024) / (args.bytes_per_block_pointer + args.key_size)
    if d['nrows'] > max_entries:
      d['l0_entries'] = max_entries
    else:
      d['l0_entries'] = d['nrows']
    print 'l0 entries %d, l0 Mentries %.1f, fraction of total %.3f' % (
        d['l0_entries'], d['l0_entries'] / 1000000.0, (d['l0_entries'] * 1.0) / d['nrows'])

    gb = 1024.0 * 1024 * 1024
    index_gb = ((args.key_size + args.bytes_per_block_pointer) * d['l0_entries']) / gb
    index_gb *= (100.0 / args.l0_index_load_factor)
    d['l0_cache_gb'] = index_gb
    print 'l0 cache-amp: %.3f, cache_gb %.2f' % (d['l0_cache_gb'] / args.database_gb, d['l0_cache_gb'])

    d['l0_point_cmp'] = math.ceil(math.log(d['l0_entries'], 2))
    d['l0_range_cmp'] = 1
    print 'l0 compares: point %d, range %d, insert %d' % (
        d['l0_point_cmp'], d['l0_range_cmp'], d['l0_point_cmp'])

    d['l0_insert_cmp'] = d['l0_point_cmp']
    index_sa = index_gb / args.database_gb
    index_wa = (args.l0_index_rewrite * args.key_size) / args.row_size
               
    log_gb = (d['l0_entries'] * args.row_size) / gb
    d['l0_data_gb'] = log_gb
    log_wa = 1
    log_sa = log_gb / args.database_gb
    print 'l0 gb %.3f index, %.3f log' % (index_gb, log_gb)

    d['l0_write_amp'] = index_wa + log_wa
    d['l0_space_amp'] = index_sa + log_sa
    print 'l0 write amp: %.3f index, %.3f log, %.3f total' % (index_wa, log_wa, d['l0_write_amp'])
    print 'l0 space amp: %.3f index, %.3f log, %.3f total' % (index_sa, log_sa, d['l0_space_amp'])

    run_mb = args.l0_log_segment_mb

    if args.l0_log_merge_max > 0:
      # determine size of a log segment such that there will be l0_log_merge_width
      # runs after l0_log_merge_max merges
      run_mb = max_run_mb = (log_gb * 1024.0) / args.l0_log_merge_width
      for x in xrange(args.l0_log_merge_max):
        run_mb /= args.l0_log_merge_width
      print 'l0 log segment mb: %.1f max, %.1f initial' % (max_run_mb, run_mb)
      d['l0_ordered_runs'] = args.l0_log_merge_width
    elif args.l0_log_merge_max == 0:
      d['l0_ordered_runs'] = math.ceil((log_gb * 1024.0) / args.l0_log_segment_mb)
    else:
      d['l0_ordered_runs'] = 1

    print 'using log segment mb %.1f, %d ordered runs' % (run_mb, d['l0_ordered_runs'])
    if args.l0_log_merge_max >= 0:
      # rows per log segment
      nr = (run_mb * 1024.0 * 1024) / args.row_size

      # first add cost to sort unordered log segments -- logN compares, 1 write,
      # ignore IO overhead for updating index, but index must also be updated to
      # reference new location per record.
      wa1 = math.ceil(math.log(nr, 2))  # for sort
      wa2 = d['l0_point_cmp']
      print 'cmp %d sort, %d modify index' % (wa1, wa2)
      merge_wa_cmp = wa1 + wa2
      merge_wa_io = 1

      # then add costs to merge ordered log segments
      for x in xrange(args.l0_log_merge_max):
        # IO and CPU cost for doing the merge
        merge_wa_io += 1
        merge_wa_cmp += math.ceil(math.log(args.l0_log_merge_width, 2))

        # CPU cost for updating the index
        merge_wa_cmp += d['l0_point_cmp']
        # TODO -- ignoring IO cost for now of updating the index

      d['l0_insert_cmp'] += merge_wa_cmp
      d['l0_write_amp'] += merge_wa_io
      print 'l0 log segment merge %.3f cmp, %.3f io' % (merge_wa_cmp, merge_wa_io)
      print 'after ordering insert_cmp %.3f, write_amp %.3f' % (d['l0_insert_cmp'], d['l0_write_amp'])
      run_merge_cmp = math.ceil(math.log(d['l0_ordered_runs'], 2))
      d['l0_insert_cmp'] += run_merge_cmp
      print 'l0 cmp to merge runs is %d, new insert_cmp is %.3f' % (run_merge_cmp, d['l0_insert_cmp'])

def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--l0_max_mb', type=int, default=1024)
    parser.add_argument('--l0_index_load_factor', type=int, default=70)
    # number of times byte written into l0 index is rewritten
    parser.add_argument('--l0_index_rewrite', type=float, default=2.0)

    # size of a log segment
    parser.add_argument('--l0_log_segment_mb', type=int, default=1024)

    # merge this many log segments at a time
    parser.add_argument('--l0_log_merge_width', type=int, default=8)

    # When =0 then sort log segments. When > 0 then merge sorted log segments.
    # When -1 then do neither. When log segments are sorted then they don't
    # have to be cached and the L0 can be larger which helps to reduce the
    # number of levels in the LSM tree. When they are not sorted then they must
    # be cached # or the compaction into L1 uses too much random IO. Sorting
    # also reduces random IO for range queries. 
    #
    # The cost is more IO from rewriting log segments and more CPU from sorting
    # them the first time (logN compares) and then some CPU from doing compares
    # for merges and CPU from searching/modifying the index to point to new
    # locations for merge output.
    parser.add_argument('--l0_log_merge_max', type=int, default=0)

    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--max_level', type=int, default=2)
    parser.add_argument('--row_size', type=int, default=128)
    parser.add_argument('--key_size', type=int, default=8)
    parser.add_argument('--block_bytes', type=int, default=4096)

    parser.add_argument('--bloom_filter_bits', type=int, default=10)

    # Assume each bloom filter probe is equivalent to a fraction of a key compare
    #
    # RocksDB does bloom_filter_bits * 0.69 probes, rounded down. With
    # bloom_filter_bits=10 there are 6 probes
    parser.add_argument('--bloom_filter_compares', type=int, default=2)

    # size of pointer to location in LSM or log segment
    parser.add_argument('--bytes_per_block_pointer', type=int, default=6)

    r = parser.parse_args(argv)
    print 'l0_max_mb ', r.l0_max_mb
    print 'l0_index_load_factor ', r.l0_index_load_factor
    print 'l0_index_rewrite ', r.l0_index_rewrite
    print 'l0: log_segment_mb %d, log_merge_width %d, log_merge_max %d' % (
        r.l0_log_segment_mb, r.l0_log_merge_width, r.l0_log_merge_max)
    print 'database_gb ', r.database_gb
    print 'max_level ', r.max_level
    print 'row_size ', r.row_size
    print 'key_size ', r.key_size
    print 'block_bytes ', r.block_bytes
    print 'bloom_filter_bits ', r.bloom_filter_bits
    print 'bloom_filter_compares ', r.bloom_filter_compares
    print 'bytes_per_block_pointer ', r.bytes_per_block_pointer

    d = {}
    d['nrows'] = (r.database_gb * 1024 * 1024 * 1024) / r.row_size
    print 'rows %d, Mrows %.1d' % (d['nrows'], d['nrows'] / 1000000.0)

    d['cmp_per_block'] = math.ceil(math.log(r.block_bytes / r.row_size, 2))
    print 'cmp_per_block %d' % d['cmp_per_block']

    config_l0(r, d)
    if d['l0_entries'] == d['nrows']:
      print 'l0 is sufficient'
      sys.exit(0)

    d['total_fanout'] = d['nrows'] / d['l0_entries']
    d['level_fanout'] = d['total_fanout'] ** (1.0 / r.max_level)
    print 'fanout: %.3f total, %.1f per level' % (d['total_fanout'], d['level_fanout'])

    #
    # per-level : compute size, space-amp, write-amp
    #

    gb = 1024.0 * 1024 * 1024
    level_rows = d['l0_entries']
    level_gb = (level_rows * r.row_size) / gb
    d['level_rows'] = []
    d['level_gb'] = []
    insert_cmp = d['l0_insert_cmp']
    space_amp = d['l0_space_amp']
    write_amp = d['l0_write_amp']

    print 'memtable: %.3f write-amp, %.3f space-amp, %.1f insert-cmp' % (write_amp, space_amp, insert_cmp)
    level = 1
    while level <= r.max_level:

      if level < r.max_level:
        level_rows *= d['level_fanout']
        level_gb *= d['level_fanout']
        sa = level_gb / r.database_gb
        # assume non-max level is half full on average when compaction done into it
        wa = d['level_fanout'] / 2.0
      else:
        # assume max level is always full when compaction done into it
        level_rows = d['nrows']
        level_gb = r.database_gb
        sa = 1
        wa = d['level_fanout']

      print 'per-level %d: %.3f write-amp, %.3f space-amp, %.3f gb' % (level, wa, sa, level_gb)
      write_amp += wa
      space_amp += sa
      insert_cmp += wa

      d['level_rows'].append(level_rows)
      d['level_gb'].append(level_gb)
      level += 1

    d['level_rows'][-1] = d['nrows']
    d['level_gb'][-1] = r.database_gb
    print 'total space-amp %.3f' % space_amp
    print 'total write-amp %.3f' % write_amp
    print 'total insert-cmp %.1f' % insert_cmp

    #
    # per-level : compute cache-amp
    #
    cache_gb = level_gb = d['l0_cache_gb']
    print 'cache-amp: L0 gb %.3f, amp %.4f' % (cache_gb, cache_gb / r.database_gb)

    level = 1
    while level <= r.max_level:
      level_rows = d['level_rows'][level-1]
      if level < r.max_level:
        bf_bits = level_rows * r.bloom_filter_bits
      else:
        bf_bits = 0

      bf_gb = bf_bits / 8 / gb
      # memory overhead for block indexes
      lblocks = (gb * d['level_gb'][level-1]) / r.block_bytes
      block_index_gb = (lblocks * (r.key_size + r.bytes_per_block_pointer)) / gb

      level_gb = bf_gb + block_index_gb
      cache_gb += level_gb
      print 'cache-amp: L%d gb %.3f, amp %.4f' % (level, level_gb, level_gb / r.database_gb)

      level += 1

    print 'cache-amp: total gb %.3f, amp %.4f' % (cache_gb, cache_gb / r.database_gb)

    #
    # per-level : compute read-amp
    #

    hit_cmp = miss_cmp = d['l0_point_cmp']
    cum_prob_hit = prob_hit =  d['l0_data_gb'] / r.database_gb
    exp_cmp = (prob_hit * hit_cmp) + ((1 - prob_hit) * miss_cmp)
    hit_cum_cmp = exp_cmp
    miss_cum_cmp = miss_cmp
    print 'L0 cum hit/miss %.3f/%.3f, level hit/miss/ehit %.3f/%.3f/%.3f, cum/level phit %.5f/%.5f' % (
        hit_cum_cmp, miss_cum_cmp, hit_cmp, miss_cmp, exp_cmp, cum_prob_hit, prob_hit)

    level = 1
    while level <= r.max_level:
      level_rows = d['level_rows'][level-1]
      level_gb = d['level_gb'][level-1]
 
      lblocks = (gb * level_gb) / r.block_bytes
      lblocks_cmp = math.ceil(math.log(lblocks, 2))

      # no bloom
      #  hit, miss - cmp for all rows
      # bloom
      #  hit - cmp for bloom, then for all rows
      #  miss - cmp for bloom

      if level < r.max_level:
        # use bloom : not max level 
        hit_cmp = r.bloom_filter_compares + lblocks_cmp + d['cmp_per_block']
        miss_cmp = r.bloom_filter_compares
        prob_hit =  level_gb / r.database_gb
        exp_cmp = (prob_hit * hit_cmp) + ((1 - prob_hit) * miss_cmp)
        cum_prob_hit += prob_hit
      else:
        # no bloom : max level
        hit_cmp = miss_cmp = lblocks_cmp + d['cmp_per_block']
        # for hit-cmp, this is a hit on the max level (always)
        prob_hit = 1.0 - cum_prob_hit
        exp_cmp = hit_cmp * prob_hit
        cum_prob_hit += prob_hit
   
      miss_cum_cmp += miss_cmp
      hit_cum_cmp += exp_cmp
      print 'L%d cum hit/miss  %.2f/%.2f, level hit/miss/ehit %.2f/%.2f/%.2f, cum/level phit %.5f/%.5f' % (
          level, hit_cum_cmp, miss_cum_cmp, hit_cmp, miss_cmp, exp_cmp, cum_prob_hit, prob_hit)

      level += 1

    # Number of search trees
    ntrees = 1 + r.max_level
    print 'Range cmp: %d with %d trees' % (math.ceil(math.log(ntrees, 2)), ntrees)

    for x in xrange(r.max_level):
      print 'level %d: %.1f Mrows, %.3f gb' % (x+1, d['level_rows'][x] / 1000000.0, d['level_gb'][x])

    return 0

def main(argv):
    return runme(argv)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

