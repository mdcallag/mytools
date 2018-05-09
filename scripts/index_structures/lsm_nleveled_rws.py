# Computes read, write and space metrics for a leveled LSM
# but in this case the script assumes the class leveled LSM where compaction is all to all
# per level rather than 1 file on level N to ~10 files on level N+1.
# 
# This LSM has:
#   write buffer
#   level 1
#   ...
#   level max -- max is >= 2

import sys
import argparse
import math

def range_compares(lsm, args):
    # returns number of comparisons per row produced by a range scan. So this counts
    # the number of comparisons done by the merge iterator, plus one comparison done
    # to confirm the value is still within the range (which might be done by SQL layer)

    n_sources = args.max_level
    n_sources += 1 # memtable

    iter_cmp = math.ceil(math.log(n_sources, 2))
    iter_cmp += 1 # to confirm output is within range

    return iter_cmp

def point_compares(lsm, args):
    # returns the number of comparisons on a point query (hit,miss)

    # first search memtable, cost is same for hit and miss
    if args.bloom_on_memtable:
      miss_cum_cmp = args.bloom_filter_compares
      hit_cmp = lsm['memtable_cmp'] + args.bloom_filter_compares
    else:
      miss_cum_cmp = lsm['memtable_cmp']
      hit_cmp = lsm['memtable_cmp']

    prob_hit =  args.memtable_mb / (1024.0 * args.database_gb)
    hit_cum_cmp = (hit_cmp * prob_hit) + (miss_cum_cmp * (1 - prob_hit))

    print '\nmemtable miss/hit/ehit %.2f/%.2f/%.2f, phit %.5f' % (
          miss_cum_cmp, hit_cmp, hit_cum_cmp, prob_hit)

    # then search each level, unlike in the write-amp case I assume each level is full 
    for x in xrange(args.max_level):
      # no bloom
      #  hit, miss - cmp for all rows
      # bloom
      #  hit - cmp for bloom, then for all rows
      #  miss - cmp for bloom

      if x != len(lsm['level_mb']) - 1 or args.bloom_on_max:
        # use bloom : either not max level or max level with bloom on max
        hit_cmp = args.bloom_filter_compares + lsm['level_blocks_cmp'][x] + lsm['cmp_per_block']
        miss_cmp = args.bloom_filter_compares
      else:
        # no bloom
        hit_cmp = miss_cmp = lsm['level_blocks_cmp'][x] + lsm['cmp_per_block']
   
      miss_cum_cmp += miss_cmp
      prob_hit =  lsm['level_mb'][x] / (1024.0 * args.database_gb)
      exp_hit_cmp = (hit_cmp * prob_hit) + (miss_cmp * (1 - prob_hit))
      hit_cum_cmp += exp_hit_cmp
      print 'L%d cum miss/hit  %.2f/%.2f, level miss/hit/ehit %.2f/%.2f/%.2f, phit %.5f' % (
          x+1, miss_cum_cmp, hit_cum_cmp, miss_cmp, hit_cmp, exp_hit_cmp, prob_hit)

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
    lsm = {}

    lsm['rows_per_block'] = math.ceil((args.block_bytes * 1.0) / args.row_size)
    lsm['cmp_per_block'] = math.ceil(math.log(lsm['rows_per_block'], 2))
    print 'rows_per_block %d' % lsm['rows_per_block']
    print 'compare per block: %d' % lsm['cmp_per_block']

    l1_mb = args.memtable_mb * args.memtable_l1_fanout
    database_mb = args.database_gb * 1024
    total_fanout = database_mb / (l1_mb * 1.0) 
    level_fanout = total_fanout ** (1.0 / (args.max_level - 1)) 
    print '%.1f total fanout, %.1f level fanout' % (total_fanout, level_fanout)

    level_mb = []
    level_rows = []
    level_rows_cmp = []
    level_blocks = []
    level_blocks_cmp = []

    cur_level = args.max_level
    cur_level_mb = database_mb * 1.0
    while cur_level > 0:
      level_mb.append(cur_level_mb)
      nrows = math.ceil((cur_level_mb * 1024.0 * 1024) / args.row_size)
      level_rows.append(nrows)
      level_rows_cmp.append(math.ceil(math.log(nrows, 2)))
      
      nblocks = (cur_level_mb * 1024.0 * 1024) / args.block_bytes
      level_blocks.append(nblocks)
      level_blocks_cmp.append(math.ceil(math.log(nblocks, 2)))

      cur_level_mb = cur_level_mb / level_fanout
      cur_level -= 1

    level_mb.reverse()
    level_rows.reverse()
    level_rows_cmp.reverse()
    level_blocks.reverse()
    level_blocks_cmp.reverse()

    lsm['level_mb'] = level_mb
    lsm['level_rows'] = level_rows
    lsm['level_rows_cmp'] = level_rows_cmp
    lsm['level_blocks'] = level_blocks
    lsm['level_blocks_cmp'] = level_blocks_cmp

    lsm['memtable_rows'] = (args.memtable_mb * 1024.0 * 1024) / args.row_size
    lsm['memtable_cmp'] = math.ceil(math.log(lsm['memtable_rows'], 2))

    print '\nmemtable: %d mb, %d rows, %d cmp' % (args.memtable_mb, lsm['memtable_rows'],
        lsm['memtable_cmp'])
    for x, mb in enumerate(lsm['level_mb']):
      print 'L%d: %d mb, %d rows, %d row_cmp, %d blocks, %d block_cmp' % (x+1, mb,
          lsm['level_rows'][x], lsm['level_rows_cmp'][x],
          lsm['level_blocks'][x], lsm['level_blocks_cmp'][x])

    write_amp = []
    comp_cmp = []
    wa_sum = comp_cmp_sum = 0.0
    print ''
    for x, mb in enumerate(lsm['level_mb']):
      lnum = x + 1

      if lnum == 1:
        # for memtable if memtable_l1_fanout == 1 then assume memtable flush is new L1 run
        # otherwise assume there is a merge between memtable and current L1 run and current L1
        # is half-full (on average)
        if args.memtable_l1_fanout == 1:
          write_amp.append(1.0)
          comp_cmp.append(1) # comparisons for duplicate elimination
        else:
          write_amp.append((args.memtable_mb + (lsm['level_mb'][x]/2.0)) / args.memtable_mb)
          comp_cmp.append(2) # 1 for merge, 1 for duplicate elimination

      elif lnum == args.max_level:
        write_amp.append(level_fanout)
        comp_cmp.append(level_fanout) # merge 2 streams, larger is level_fanout times larger

      else:
        # assume larger level is half full on average during compaction into it
        write_amp.append(level_fanout / 2.0)
        comp_cmp.append(level_fanout / 2.0)

      wa_sum += write_amp[-1]
      comp_cmp_sum += comp_cmp[-1]
      print 'compaction to L%d: %.2f write-amp, %.2f comp-cmp' % (x+1, write_amp[-1], comp_cmp[-1])

    print 'total compaction %.2f write-amp, %.2f comp-cmp' % (wa_sum, comp_cmp_sum)

    # compares for an insert
    if args.bloom_on_memtable:
      insert_cmp = args.bloom_filter_compares # assume no match
    else:
      insert_cmp = lsm['memtable_cmp']
    print 'insert compares: %.2f memtable, %.2f memtable + compaction' % (
        insert_cmp, insert_cmp + comp_cmp_sum)

    # space-amp is size-on-disk / logical-size where...
    #   size-on-disk is sum of database file sizes
    #   logical-size is size of live data - assume it is the same
    #     the size of the max LSM level
    total_mb = 0.0
    for mb in lsm['level_mb']:
      total_mb += mb
    print 'space-amp: %.2f' % (total_mb / (args.database_gb * 1024.0))
    lsm['total_mb'] = total_mb

    # Fraction of database that must be in cache so that <= 1 disk reads are done
    # per point lookup. This assumes that everything except max level data blocks
    # are cached.

    # memtable is in memory
    print ''
    cache_mb = args.memtable_mb
    if args.bloom_on_memtable:
      cache_mb += cache_overhead(args, args.memtable_mb, 0, True, 1)

    for num, mb in enumerate(lsm['level_mb']):
      # block indexes are in memory
      # bloom filters (if they exist) are in memory
      cache_mb += cache_overhead(args, mb,
                                 lsm['level_blocks'][num],
                                 (num+1) != args.max_level or args.bloom_on_max,
                                 1)

    cache_amp = cache_mb / (args.database_gb * 1024.0)
    print 'cache_amp %.4f, cache_mb %d' % (cache_amp, cache_mb)
 
    return lsm

def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--memtable_mb', type=int, default=64)
    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--max_level', type=int, default=2)
    parser.add_argument('--memtable_l1_fanout', type=int, default=10)
    parser.add_argument('--row_size', type=int, default=128)
    parser.add_argument('--key_size', type=int, default=8)
    parser.add_argument('--block_bytes', type=int, default=4096)

    parser.add_argument('--bloom_on_max', dest='bloom_on_max', action='store_true')
    parser.add_argument('--no_bloom_on_max', dest='bloom_on_max', action='store_false')
    parser.set_defaults(bloom_on_max=False)

    parser.add_argument('--bloom_on_memtable', dest='bloom_on_memtable', action='store_true')
    parser.add_argument('--no_bloom_on_memtable', dest='bloom_on_memtable', action='store_false')
    parser.set_defaults(bloom_on_memtable=False)

    parser.add_argument('--bloom_filter_bits', type=int, default=10)

    # Assume each bloom filter probe is equivalent to a fraction of a key compare
    #
    # RocksDB does bloom_filter_bits * 0.69 probes, rounded down. With
    # bloom_filter_bits=10 there are 6 probes
    parser.add_argument('--bloom_filter_compares', type=int, default=3)

    # The default is a 6-byte pointer
    parser.add_argument('--bytes_per_block_pointer', type=int, default=6)

    r = parser.parse_args(argv)
    print 'memtable_mb ', r.memtable_mb
    print 'database_gb ', r.database_gb
    print 'max_level ', r.max_level
    print 'memtable_l1_fanout ', r.memtable_l1_fanout
    print 'row_size ', r.row_size
    print 'key_size ', r.key_size
    print 'block_bytes ', r.block_bytes
    print 'bloom_on_max ', r.bloom_on_max
    print 'bloom_on_memtable ', r.bloom_on_memtable
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

