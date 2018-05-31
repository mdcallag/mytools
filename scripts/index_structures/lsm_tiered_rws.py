# Computes read, write and space metrics for a tiered LSM

import sys
import argparse
import math

def range_compares(lsm, args):
    # returns number of comparisons per row produced by a range scan. So this counts
    # the number of comparisons done by the merge iterator, plus one comparison done
    # to confirm the value is still within the range (which might be done by SQL layer)

    n_sources = lsm['nruns']
    n_sources += 1 # memtable

    iter_cmp = math.ceil(math.log(n_sources, 2))
    iter_cmp += 1 # to confirm output is within range

    return iter_cmp

def point_compares(lsm, args):
    # returns the number of comparisons on a point query (hit,miss)

    # first search memtable, cost is same for hit and miss
    lcmp = math.ceil(math.log((1024.0 * 1024 * args.memtable_mb) / args.row_size, 2))
    miss_cum_cmp = lcmp
    hit_cum_cmp = lcmp
    print '\nmemtable: %.0f cmp' % lcmp

    # then search each level
    for x, has_bloom in enumerate(lsm['has_bloom']):
      # no bloom
      #  hit, miss - +2, block index, block
      # bloom
      #  hit - +2, bloom, block index, block
      #  miss - +2, bloom
      #
      # +2 is to confirm search key is within min/max key per run

      if has_bloom:
        run_hit_cmp = 2 + args.bloom_filter_compares + lsm['block_index_cmp_per_run'][x] + lsm['cmp_per_block']
        run_miss_cmp = 2 + args.bloom_filter_compares
      else:
        run_hit_cmp = 2 + lsm['block_index_cmp_per_run'][x] + lsm['cmp_per_block']
        run_miss_cmp = run_hit_cmp
    
      level_miss_cmp = lsm['runs_per_level'][x] * run_miss_cmp

      # assume hit occur after half of L0 runs checked
      prob_hit = lsm['mb_per_level'][x] / (1024.0 * args.database_gb)
      run_that_hits = math.ceil(lsm['runs_per_level'][x] / 2.0)

      # then add cost for runs that miss
      level_hit_cmp = (run_that_hits - 1) * run_miss_cmp
      # then add cost for run that hits
      level_hit_cmp += run_hit_cmp

      miss_cum_cmp += level_miss_cmp
      exp_hit_cmp = (level_hit_cmp * prob_hit) + (level_miss_cmp * (1 - prob_hit))
      hit_cum_cmp += exp_hit_cmp
      print 'L%d cum miss/hit  %.2f/%.2f, level miss/hit/ehit %.2f/%.2f/%.2f, phit %.5f' % (
          x+1, miss_cum_cmp, hit_cum_cmp, level_miss_cmp, level_hit_cmp, exp_hit_cmp, prob_hit)

    return (hit_cum_cmp, miss_cum_cmp)

def cache_overhead(args, mb_per_run, blocks_per_run, uses_bloom, nruns):
  cache_mb = 0.0

  print 'cache_overhead with mb_per_run %d, blocks_per_file %d, bloom %s, nruns %d' % (
      mb_per_run, blocks_per_run, uses_bloom, nruns)

  # memory overhead for bloom filter per run
  bf_mb = 0

  if uses_bloom:
    rows_per_run = math.ceil((mb_per_run * 1024.0 * 1024) / args.row_size)
    bf_bits_per_run = rows_per_run * args.bloom_filter_bits
    bf_mb = bf_bits_per_run / 8 / (1024.0 * 1024)
    cache_mb += bf_mb

  # memory overhead for block indexes per run
  block_index_mb = (blocks_per_run * (args.key_size + args.bytes_per_block_pointer)) / (1024.0 * 1024)
  cache_mb += block_index_mb

  cache_mb *= nruns
  print '  cache mb per run: %.2f bf, %.2f block index :: %.2f total' % (
      bf_mb, block_index_mb, cache_mb)

  return cache_mb

def config_lsm_tree(args):
    mb_per_run = []
    blocks_per_run = []
    block_index_cmp_per_run = []

    mb_per_level = []
    blocks_per_level = []
    block_index_cmp_per_level = []

    runs_per_level = []
    has_bloom = []
    lsm = {}

    lsm['rows_per_block'] = math.ceil((args.block_bytes * 1.0) / args.row_size)
    lsm['cmp_per_block'] = math.ceil(math.log(lsm['rows_per_block'], 2))
    print 'rows_per_block: %d' % lsm['rows_per_block']
    print 'compare per block: %d' % lsm['cmp_per_block']

    nlevels = 0
    nruns = 0
    database_mb = args.database_gb * 1024.0

    # Setup levels prior to max level
    total_mb = 0
    cur_level_mb = args.memtable_mb

    while (cur_level_mb * args.tier_fanout * args.last_extra_fanout) <= database_mb:
      nlevels = nlevels + 1
      nruns += args.tier_fanout
      runs_per_level.append(args.tier_fanout)
      has_bloom.append(True)

      mb_per_run.append(cur_level_mb)
      mb_per_level.append(cur_level_mb * args.tier_fanout)

      bpr = math.ceil((1024.0 * 1024 * cur_level_mb) / args.block_bytes)
      blocks_per_run.append(bpr)
      blocks_per_level.append(bpr * args.tier_fanout)

      bic = math.ceil(math.log(bpr, 2))
      block_index_cmp_per_run.append(bic)
      block_index_cmp_per_level.append(bic * args.tier_fanout)

      total_level_mb = cur_level_mb * args.tier_fanout
      total_mb += total_level_mb

      print 'L%d per run: %d mb, %d blocks, %d block_idx_cmp, rpl=%d, sa=%.3f' % (nlevels,
          cur_level_mb, bpr, bic, args.tier_fanout, total_level_mb / database_mb)

      cur_level_mb = total_level_mb
 
    # Setup max level
    total_mb += database_mb
    nlevels += 1
    nruns += 1
    runs_per_level.append(1)
    has_bloom.append(args.bloom_on_max)

    mb_per_run.append(database_mb)
    mb_per_level.append(database_mb)

    bpr = math.ceil((1024.0 * 1024 * database_mb) / args.block_bytes)
    blocks_per_run.append(bpr)
    blocks_per_level.append(bpr)

    bic = math.ceil(math.log(bpr, 2))
    block_index_cmp_per_run.append(bic)
    block_index_cmp_per_level.append(bic)

    print 'L%d per run: %d mb, %d blocks, %d block_idx_cmp, rpl=1' % (nlevels,
        database_mb, bpr, bic)

    # compute write-amp
    wa_sum = 0
    comp_cmp = [1.0] # compares per key during memtable flush (dup elim)

    print "\nwrite-amp: ",
    for x, mb in enumerate(mb_per_level):
      if x == len(mb_per_level) - 1:
        # last level
        wa = (mb_per_level[-2] + database_mb) / (mb_per_level[-2] * 1.0)
        comp_cmp.append(math.ceil(math.log(args.tier_fanout, 2)) * wa)
        comp_read = wa
      else:
        # not last level
        wa = 1
        comp_cmp.append(math.ceil(math.log(args.tier_fanout, 2)))

      print "\t%.2f" % wa,
      wa_sum += wa

    print " :: %.2f\n" % wa_sum
    print "compaction read: %.1f"  % comp_read

    comp_cmp_sum = 0
    print "compaction cmp: ",
    for c in comp_cmp:
      comp_cmp_sum += c
      print '%.2f\t' % c,
    print ':: total is %.2f' % comp_cmp_sum

    # compares for an insert
    insert_cmp = math.ceil(math.log((1024.0 * 1024 * args.memtable_mb) / args.row_size, 2))
    print 'insert compares: %.2f memtable, %.2f memtable + compaction' % (
        insert_cmp, insert_cmp + comp_cmp_sum)

    lsm['mb_per_run'] = mb_per_run
    lsm['blocks_per_run'] = blocks_per_run
    lsm['block_index_cmp_per_run'] = block_index_cmp_per_run

    lsm['mb_per_level'] = mb_per_level
    lsm['blocks_per_level'] = blocks_per_level
    lsm['block_index_cmp_per_level'] = block_index_cmp_per_level

    lsm['runs_per_level'] = runs_per_level
    lsm['has_bloom'] = has_bloom
    lsm['nruns'] = nruns

    # space-amp is size-on-disk / logical-size where...
    #   size-on-disk is sum of database file sizes
    #   logical-size is size of live data - assume it is the same
    #     the size of the max LSM level
    print 'space-amp: %.2f' % (total_mb / (args.database_gb * 1024.0))
    lsm['total_mb'] = total_mb

    # Fraction of database that must be in cache so that <= 1 disk reads are done
    # per point lookup. This assumes that everything except max level data blocks
    # are cached.

    # memtable is in memory
    cache_mb = args.memtable_mb

    for x in xrange(nlevels):
      cache_mb += cache_overhead(args, mb_per_run[x], blocks_per_run[x],
                                 has_bloom[x], runs_per_level[x])

    cache_amp = cache_mb / (args.database_gb * 1024.0)
    print 'cache_amp %.4f, cache_mb %d' % (cache_amp, cache_mb)
 
    return lsm

def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--memtable_mb', type=int, default=32)
    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--tier_fanout', type=int, default=4)
    parser.add_argument('--last_extra_fanout', type=float, default=1.0)
    parser.add_argument('--row_size', type=int, default=128)
    parser.add_argument('--key_size', type=int, default=8)
    parser.add_argument('--block_bytes', type=int, default=4096)
    parser.add_argument('--bloom_on_max', dest='bloom_on_max', action='store_true')
    parser.add_argument('--no_bloom_on_max', dest='bloom_on_max', action='store_false')
    parser.set_defaults(bloom_on_max=False)
    parser.add_argument('--bloom_filter_bits', type=int, default=10)

    # Assume each bloom filter probe is equivalent to a key comparison
    #
    # RocksDB does bloom_filter_bits * 0.69 probes, rounded down. With
    # bloom_filter_bits=10 this is 6
    parser.add_argument('--bloom_filter_compares', type=int, default=3)

    # The default is a 6-byte pointer into block
    parser.add_argument('--bytes_per_block_pointer', type=int, default=6)

    r = parser.parse_args(argv)
    print 'memtable_mb ', r.memtable_mb
    print 'database_gb ', r.database_gb
    print 'tier_fanout ', r.tier_fanout
    print 'last_extra_fanout ', r.last_extra_fanout
    print 'row_size ', r.row_size
    print 'key_size ', r.key_size
    print 'block_bytes ', r.block_bytes
    print 'bloom_on_max ', r.bloom_on_max
    print 'bloom_filter_bits ', r.bloom_filter_bits
    print 'bloom_filter_compares ', r.bloom_filter_compares
    print 'bytes_per_block_pointer ', r.bytes_per_block_pointer
    print 'Mrows %.2f' % (((r.database_gb * 1024 * 1024 * 1024) / r.row_size) / 1000000.0)

    lsm = config_lsm_tree(r)

    hit_cmp, miss_cmp = point_compares(lsm, r)
    range_cmp = range_compares(lsm, r)

    print '\nCompares point-hit/point-miss/range: %.2f\t%.2f\t%.2f' % (
        hit_cmp, miss_cmp, range_cmp)

    return 0

def main(argv):
    return runme(argv)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

