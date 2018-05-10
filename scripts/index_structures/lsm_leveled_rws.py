# Computes read, write and space metrics for a leveled LSM

import sys
import argparse
import math

def range_compares(lsm, args):
    # returns number of comparisons per row produced by a range scan. So this counts
    # the number of comparisons done by the merge iterator, plus one comparison done
    # to confirm the value is still within the range (which might be done by SQL layer)

    n_sources = len(lsm['level_mb'])
    n_sources += 1 # memtable
    n_sources += args.l0_trigger

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
 
    # then search L0
    # check min/max key per L0 file, then check bloom filter
    # and cost for bloom filter check is args.bloom_filter_compares
    miss_cmp = args.l0_trigger * (2 + args.bloom_filter_compares)

    # assume hit occur after half of L0 runs checked
    prob_hit = (args.l0_trigger * args.memtable_mb) / (1024.0 * args.database_gb)
    run_that_hits = math.ceil(args.l0_trigger / 2.0)
    # then add cost for runs that miss
    hit_cmp = (run_that_hits - 1) * (2 + args.bloom_filter_compares)
    # then add cost for run that hits
    hit_cmp += (2 + args.bloom_filter_compares + lsm['cmp_block_index_l0'] +
                lsm['cmp_per_block'])

    miss_cum_cmp += miss_cmp
    exp_hit_cmp = (hit_cmp * prob_hit) + (miss_cmp * (1 - prob_hit))
    hit_cum_cmp += exp_hit_cmp
    print 'L0 cum miss/hit  %.2f/%.2f, level miss/hit/ehit %.2f/%.2f/%.2f, phit %.5f' % (
        miss_cum_cmp, hit_cum_cmp, miss_cmp, hit_cmp, exp_hit_cmp, prob_hit)

    # then search remaining levels
    for x in xrange(len(lsm['level_mb'])):
      # no bloom
      #  hit, miss - cmp for files, block index, block
      # bloom
      #  hit - cmp for files, block index, block, bloom
      #  miss - cmp for files, bloom

      files_only_cmp = lsm['level_files_cmp'][x]
      all_cmp = lsm['level_files_cmp'][x] + lsm['cmp_block_index'] + lsm['cmp_per_block']

      if x != len(lsm['level_mb']) - 1 or args.bloom_on_max:
        # use bloom : either not max level or max level with bloom on max
        hit_cmp = all_cmp + args.bloom_filter_compares
        miss_cmp = files_only_cmp + args.bloom_filter_compares
      else:
        # no bloom
        hit_cmp = all_cmp
        miss_cmp = all_cmp
   
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
    level_mb = []
    level_files = []
    level_files_cmp = []

    lsm = {}
    lsm['blocks_per_file_l0'] = math.ceil((args.memtable_mb * 1024.0 * 1024) / args.block_bytes)
    lsm['cmp_block_index_l0'] = math.ceil(math.log(lsm['blocks_per_file_l0'], 2))

    lsm['blocks_per_file'] = math.ceil((args.file_mb * 1024.0 * 1024) / args.block_bytes)
    lsm['cmp_block_index'] = math.ceil(math.log(lsm['blocks_per_file'], 2))

    lsm['rows_per_block'] = math.ceil((args.block_bytes * 1.0) / args.row_size)
    lsm['cmp_per_block'] = math.ceil(math.log(lsm['rows_per_block'], 2))

    print 'blocks per file l0 %d' % lsm['blocks_per_file_l0']
    print 'compare block index l0 %d' % lsm['cmp_block_index_l0']
    print 'blocks per file %d' % lsm['blocks_per_file']
    print 'compare block index %d' % lsm['cmp_block_index']
    print 'rows_per_block %d' % lsm['rows_per_block']
    print 'compare per block: %d' % lsm['cmp_per_block']

    cur_level_mb = args.database_gb * 1024.0
    done = False
    while not done:
      if cur_level_mb <= (args.l1_mb * args.l1_fudge):
        done = True

      level_mb.append(cur_level_mb)

      nfiles = math.ceil(cur_level_mb / args.file_mb)
      level_files.append(nfiles)
      level_files_cmp.append(math.ceil(math.log(nfiles, 2)))

      cur_level_mb = cur_level_mb / args.level_fanout

    level_mb.reverse()
    level_files.reverse()
    level_files_cmp.reverse()

    # determine CPU and write-amp during compaction. CPU is number of compares,
    write_amp = [1.0] # memtable flush
    comp_cmp = [1.0] # compares done to remove duplicates on memtable flush

    for x, mb in enumerate(level_mb):
      if x == 0:
        # write-amp for L1
        l0_mb = args.memtable_mb * args.l0_trigger
        wa = (mb + l0_mb + 0.0) / l0_mb
        write_amp.append(wa)
        # merge 1 stream from L1 with l0_trigger streams from L0
        comp_cmp.append(math.ceil(math.log(args.l0_trigger + 1, 2) * wa))
      else:
        wa = args.level_fanout * args.wa_fudge
        write_amp.append(wa)
        comp_cmp.append(1.0 * wa) # merge 2 streams

    wa_sum = 0
    print "\nwrite-amp: ",
    for w in write_amp:
      wa_sum += w
      print '%.2f\t' % w,
    print ':: total is %.2f' % wa_sum
    print "compaction read: %.1f" % args.level_fanout

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

    lsm['level_mb'] = level_mb
    lsm['level_files'] = level_files
    lsm['level_files_cmp'] = level_files_cmp    

    # space-amp is size-on-disk / logical-size where...
    #   size-on-disk is sum of database file sizes
    #   logical-size is size of live data - assume it is the same
    #     the size of the max LSM level
    total_mb = (args.memtable_mb * args.l0_trigger)
    for mb in lsm['level_mb']:
      total_mb += mb
    print 'space-amp: %.2f' % (total_mb / (args.database_gb * 1024.0))
    lsm['total_mb'] = total_mb

    # Fraction of database that must be in cache so that <= 1 disk reads are done
    # per point lookup. This assumes that everything except max level data blocks
    # are cached.

    # memtable is in memory
    cache_mb = args.memtable_mb

    # bloom filters and block indexes for L0 runs are in memory
    cache_mb += cache_overhead(args, args.memtable_mb, lsm['blocks_per_file_l0'],
        True, args.l0_trigger)

    # For runs after L0:
    #  block indexes are in memory
    #  bloom filters (if they exist) are in memory
    for x in xrange(len(lsm['level_mb'])):
      cache_mb += cache_overhead(args, lsm['level_mb'][x],
                                 lsm['blocks_per_file'] * lsm['level_files'][x],
                                 x != len(lsm['level_mb']) - 1 or args.bloom_on_max,
                                 1)

    cache_amp = cache_mb / (args.database_gb * 1024.0)
    print 'cache_amp %.4f, cache_mb %d' % (cache_amp, cache_mb)
 
    return lsm

def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--memtable_mb', type=int, default=64)
    parser.add_argument('--l0_trigger', type=int, default=4)
    parser.add_argument('--l1_mb', type=int, default=512)
    parser.add_argument('--l1_fudge', type=float, default=1.5)
    parser.add_argument('--wa_fudge', type=float, default=0.8)
    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--level_fanout', type=int, default=10)
    parser.add_argument('--row_size', type=int, default=128)
    parser.add_argument('--key_size', type=int, default=8)
    parser.add_argument('--file_mb', type=int, default=32)
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

    # The default is a 6-byte pointer
    parser.add_argument('--bytes_per_block_pointer', type=int, default=6)

    r = parser.parse_args(argv)
    print 'memtable_mb ', r.memtable_mb
    print 'l0_trigger ', r.l0_trigger
    print 'l0 mb ', (r.l0_trigger * r.memtable_mb)
    print 'l1_mb ', r.l1_mb
    print 'l1_fudge ', r.l1_fudge
    print 'wa_fudge ', r.wa_fudge
    print 'database_gb ', r.database_gb
    print 'level_fanout ', r.level_fanout
    print 'row_size ', r.row_size
    print 'key_size ', r.key_size
    print 'file_mb ', r.file_mb
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

