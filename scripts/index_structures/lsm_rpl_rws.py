# Computes read, write and space metrics for a leveled LSM

import sys
import argparse
import math

def range_compares(lsm, args, miss_nobf):
    # returns (seek_cmp, next_cmp)
    #   seek_cmp is number of comparisons to position an iterator per sorted run
    #   next_cmp is number of comparisons per row produced by merging iterator 

    # For now use miss_nobf, computed in point_compares, as value for seek_cmp
    seek_cmp = miss_nobf

    next_cmp = 0
    x = 1
    while lsm['lvl_type'][x] != 'l':
      runs_per_level = lsm['lvl_rpl'][x]
      # print 'L%d type(%s) rpl(%d)' % (x, lsm['lvl_type'][x], lsm['lvl_rpl'][x])
      assert runs_per_level > 1
      # k-way merge within level, log2(k) compares
      next_cmp += math.log(runs_per_level, 2)
      x += 1
    print 'range_compares next_cmp = %d after tiered and partial-tiered prior to L%d' % (
        next_cmp, x)
# See optimizations in merging iterator. Values determined by simulation.
    # Each entry is (niters, ncmps) where ncmps is the expected number of comparisons
    # per row produced by merging iterator with optimized heap.
    nc = [(1, 0), (2,1), (3,1.18), (4,1.30), (5,1.45), (6,1.47), (7,1.54),
          (9,1.55), (10,1.56)]

    nlevels = lsm['max_level'] + 1
    next_cmp = nc[-1][1]
    for niter,ncmp in nc:
      if niter >= nlevels:
        next_cmp += ncmp
        break
    next_cmp += 1 # Comparison to determine when scan can stop

    return seek_cmp, next_cmp

def point_compares(lsm, args):
    # returns the number of comparisons on a point query (hit,miss,miss_nobf)
    # where miss_nobf is number of compares on a miss without bloom filters

    database_mb = 1024.0 * args.database_gb
    hit_cum_cmp = miss_cum_cmp = miss_nobf_cum_cmp = 0
    cum_prob_hit = 0

    # search levels
    for x in xrange(0, lsm['max_level'] + 1):
      if x == lsm['max_level']:
        prob_hit = 1 - cum_prob_hit
      else:
        prob_hit =  lsm['lvl_mb'][x] / database_mb

      runs_per_level = lsm['lvl_rpl'][x]
      if runs_per_level > 1:
        miss_cmp = lsm['run_cmp_miss'][x] * runs_per_level
        miss_nobf_cmp = lsm['run_cmp_miss_nobf'][x] * runs_per_level
        # assume that the hit occurs after half of the runs are checked
        hit_cmp = (runs_per_level / 2.0) * lsm['run_cmp_miss'][x] + lsm['run_cmp_hit'][x]
      else:
        miss_cmp = lsm['run_cmp_miss'][x]
        miss_nobf_cmp = lsm['run_cmp_miss_nobf'][x]
        hit_cmp = lsm['run_cmp_hit'][x]

      exp_cmp = (prob_hit * hit_cmp) + ((1 - prob_hit) * miss_cmp)
      hit_cum_cmp += exp_cmp
      miss_cum_cmp += miss_cmp
      miss_nobf_cum_cmp += miss_nobf_cmp
      cum_prob_hit += prob_hit
      print 'L%d rpl=%d cum hit/miss/mnbf %.2f/%.2f/%.2f, level hit/miss/mnbf/ehit %.2f/%.2f/%.2f/%.2f, '\
            'cum/level phit %.5f/%.5f' % (
          x, runs_per_level,
          hit_cum_cmp, miss_cum_cmp, miss_nobf_cum_cmp,
          hit_cmp, miss_cmp, miss_nobf_cmp, exp_cmp,
          cum_prob_hit, prob_hit)

    return (hit_cum_cmp, miss_cum_cmp, miss_nobf_cum_cmp)

def cache_overhead(args, mb_per_run, blocks_per_run, uses_bloom, nruns):
  cache_mb = 0.0

  # print 'cache_overhead with mb_per_run %d, blocks_per_file %d, bloom %s, nruns %d' % (
  #    mb_per_run, blocks_per_run, uses_bloom, nruns)

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
  return cache_mb, bf_mb, block_index_mb

def config_lsm_tree(args, level_config):

    lsm = {}
    lsm['max_level'] = max_level = len(level_config)

    blocks_per_file = math.ceil((args.file_mb * 1024.0 * 1024) / args.block_bytes)
    block_index_cmp = math.ceil(math.log(blocks_per_file, 2))
    print 'blocks per file %d, block index compares %d' % (blocks_per_file, block_index_cmp)
    
    rows_per_block = math.ceil((args.block_bytes * 1.0) / args.row_size)
    cmp_per_block = math.ceil(math.log(rows_per_block, 2))
    print 'rows_per_block %d, compare_per_block %d' % (rows_per_block, cmp_per_block)

    database_mb = args.database_gb * 1024.0
    total_fanout = database_mb / (args.memtable_mb * 1.0)
    lsm['total_fanout'] = total_fanout
    print 'total_fanout %.2f' % total_fanout

    fo_prod = 1 # product of fanout for all but max level
    for e in level_config[0:-1]:
      fo_prod *= e[1]
      print 'fo prod %.2f' % fo_prod

    last_fo = total_fanout / fo_prod  # actual fanout needed for max level

    if last_fo < 2:
      print 'fanout needed for max level is too small %.2f' % last_fo
      sys.exit(-1)
    elif last_fo > (level_config[-1][1] * 1.2):
      print 'last level fanout was too small %.2f, should be %.2f' % (level_config[-1][1], last_fo)
      sys.exit(-1)
    elif last_fo < (level_config[-1][1] * 0.8):
      print 'last level fanout was too big %.2f, should be %.2f' % (level_config[-1][1], last_fo)
      sys.exit(-1)

    if level_config[-1][1] != last_fo:
      print 'last level fanout was %.2f adjusted to %.2f to match total_fanout' % (
          level_config[-1][1], last_fo)
      level_config[-1][1] = last_fo

    # Copy things from level_config
    lvl_fanout = []
    lvl_rpl = []
    lvl_type = []
    lsm['lvl_fanout'] = lvl_fanout
    lsm['lvl_rpl'] = lvl_rpl
    lsm['lvl_type'] = lvl_type

    # for memtable
    lvl_type.append('x')
    lvl_fanout.append(1)
    lvl_rpl.append(1)

    # for levels after memtable
    sorted_runs = 1  # memtable is one sorted run
    for e in level_config:
      lvl_type.append(e[0])
      lvl_fanout.append(e[1])
      lvl_rpl.append(e[2])
      sorted_runs += e[2]
    lsm['sorted_runs'] = sorted_runs

    run_mb = []
    run_files = []
    run_files_cmp = []
    run_cmp_hit = []
    run_cmp_miss = []
    run_cmp_miss_nobf = []
    run_nrows = []

    lvl_mb = []
    lvl_nrows = []
    lvl_has_bloom = []

    lsm['run_mb'] = run_mb
    lsm['run_files'] = run_files
    lsm['run_files_cmp'] = run_files_cmp
    lsm['run_cmp_hit'] = run_cmp_hit
    lsm['run_cmp_miss'] = run_cmp_miss
    lsm['run_cmp_miss_nobf'] = run_cmp_miss_nobf
    lsm['run_nrows'] = run_nrows

    lsm['lvl_mb'] = lvl_mb
    lsm['lvl_nrows'] = lvl_nrows
    lsm['lvl_has_bloom'] = lvl_has_bloom
    
    # the memtable is L0
    lvl_mb.append(args.memtable_mb)
    run_mb.append(args.memtable_mb)
    run_files.append(0)
    run_files_cmp.append(0)

    mt_nrows = math.ceil((args.memtable_mb * 1024 * 1024) / args.row_size)
    mt_cmp = math.ceil(math.log(mt_nrows, 2))
    if args.bloom_on_memtable:
      mt_miss_cmp = args.bloom_filter_compares
      mt_hit_cmp = mt_cmp + args.bloom_filter_compares
    else:
      mt_miss_cmp = mt_hit_cmp = mt_cmp

    run_cmp_hit.append(mt_hit_cmp)
    run_cmp_miss.append(mt_miss_cmp)
    run_cmp_miss_nobf.append(mt_cmp)

    lvl_has_bloom.append(args.bloom_on_memtable)

    run_nrows.append(mt_nrows)
    lvl_nrows.append(mt_nrows)

    # setup levels 1 to max
    cur_run_mb = args.memtable_mb
    disk_mb = 0

    for cur_level in xrange(1, max_level+1):
      # print 'cur_level %d, fo %s, rpl %s, mb %s' % (
      #    cur_level, lvl_fanout[cur_level], lvl_rpl[cur_level], cur_run_mb)
      cur_run_mb *= lvl_fanout[cur_level]

      # fix for rounding
      if (cur_level == max_level):
        cur_run_mb = database_mb

      run_mb.append(cur_run_mb)
      lvl_mb.append(cur_run_mb * lvl_rpl[cur_level])
      disk_mb += lvl_mb[-1]

      rfiles = math.ceil(run_mb[-1] / args.file_mb)
      run_files.append(rfiles)
      run_files_cmp.append(math.ceil(math.log(rfiles, 2)))

      if cur_level < max_level:
        has_bloom = True
      else:
        has_bloom = args.bloom_on_max
      lvl_has_bloom.append(has_bloom)

      files_only_cmp = run_files_cmp[-1]
      all_cmp = run_files_cmp[-1] + block_index_cmp + cmp_per_block

      if has_bloom:
        hit_cmp = all_cmp + args.bloom_filter_compares
        miss_cmp = files_only_cmp + args.bloom_filter_compares
      else:
        hit_cmp = miss_cmp = all_cmp

      run_cmp_hit.append(hit_cmp)
      run_cmp_miss.append(miss_cmp)
      run_cmp_miss_nobf.append(all_cmp)
      run_nrows.append(math.ceil((cur_run_mb * 1024 * 1024) / args.row_size))
      lvl_nrows.append(run_nrows[-1] * lvl_rpl[cur_level])

    for x in xrange(0, max_level + 1):
        print 'L%d /run: %.1f Mrows, %.1f MB, %d/%d Nfiles/cmp, %d/%d/%d cmp hit/miss/m_nobf '\
              ':: /level %.1f Mrows, %.1f MB, %d bloom' % (
            x, run_nrows[x] / 1000000.0, run_mb[x], run_files[x], run_files_cmp[x],
            run_cmp_hit[x], run_cmp_miss[x], run_cmp_miss_nobf[x],
            lvl_nrows[x] / 1000000.0, lvl_mb[x], lvl_has_bloom[x])

    # determine CPU and IO write-amp during compaction. CPU is number of compares,
    wa_io_sum = 0
    wa_cpu_sum = 0

    for x in xrange(0, max_level + 1):
      if x == 0:
        wa_io = 1                     # IO to WAL
        wa_cpu = 0
      elif lvl_type[x] == 't':
        # Cost to merge runs from previous level and write new run in this level
        wa_io = 1
        if x == 1: wa_cpu = 1         # comparison for duplicate elimination on memtable flush
        else: wa_cpu = math.ceil(math.log(lvl_fanout[x], 2))
      elif lvl_type[x] == 'p':
        # Cost to merge runs from previous level into one run from this level.
        # Assume runs in Lx are half full.

        # Relative size of the run ln Lx after the merge
        size_after = (lvl_fanout[x] * 0.5) + lvl_rpl[x-1]
        wa_io = size_after / lvl_rpl[x-1]
        # +1 for the merge with the run already on Lx
        wa_cpu = math.ceil(math.log(lvl_fanout[x], 2)) + 1
      elif lvl_type[x] == 'l':
        wa_io = lvl_fanout[x] * args.wa_fudge
        wa_cpu = wa_io                # cmp per KV pair re-written
      else:
        print 'bad type %s at %d' % (lvl_comp_type[x], x)
        assert 0

      wa_io_sum += wa_io
      wa_cpu_sum += wa_cpu
      print 'L%d: write-amp %.2f, comp-cmp %.2f' % (x, wa_io, wa_cpu)

    print 'Compaction total write-amp: io %.2f, cpu %.2f' % (wa_io_sum, wa_cpu_sum)

    # compares for an insert
    insert_cmp = math.ceil(math.log((1024.0 * 1024 * args.memtable_mb) / args.row_size, 2))
    print 'insert compares: %.2f memtable, %.2f memtable + compaction' % (
        insert_cmp, insert_cmp + wa_cpu_sum)
    lsm['write_amp_io'] = wa_io_sum
    lsm['write_amp_cpu'] = wa_cpu_sum + insert_cmp

    # space-amp is size-on-disk / logical-size where...
    #   size-on-disk is sum of database file sizes
    #   logical-size is size of live data - assume it is the same
    #     the size of the max LSM level
    print 'space-amp: %.2f' % (disk_mb / database_mb)
    lsm['disk_mb'] = disk_mb
    lsm['space_amp'] = disk_mb / database_mb

    # Fraction of database that must be in cache so that <= 1 disk read is done
    # per point lookup. This assumes that everything except max level data blocks
    # are cached.

    # memtable is in memory
    cache_mb = args.memtable_mb
    bf_mb = 0
    if lvl_has_bloom[0]:
      bf_bits = level_nrows[0] * args.bloom_filter_bits
      bf_mb = bf_bits / 8 / (1024.0 * 1024)
      cache_mb += bf_mb
    print 'L0: cache_mb %.1f, bf_mb %.1f' % (cache_mb, bf_mb)

    # For runs after L0:
    #  block indexes are in memory
    #  bloom filters (if they exist) are in memory
    cache_mb_sum = cache_mb
    for x in xrange(1, max_level + 1):
      cache_mb, bf_mb, bi_mb = cache_overhead(args, run_mb[x],
                                              blocks_per_file * run_files[x],
                                              lvl_has_bloom[x], lsm['lvl_rpl'][x])
      cache_mb_sum += cache_mb
      print 'L%d: cache_mb %.1f, bf_mb %.1f, bi_mb %.1f' % (x, cache_mb, bf_mb, bi_mb)

    cache_amp = cache_mb_sum / database_mb
    print 'cache_amp %.4f, cache_mb %d' % (cache_amp, cache_mb_sum)
    lsm['cache_amp'] = cache_amp
 
    return lsm

def isFloat(s):
  try:
    float(s)
  except ValueError:
    return 0
  else:
    return 1

# runs-per-level < fanout
# fanout >= 2 * runs-per-level from previous level
def validate_partial_tiered(r, x, e, prev_rpl):
  if e[2] >= e[1]:
    print 'L%d: t2l runs-per-level must be < fanout was %d,%d' % (x+1, e[1], e[2])
    sys.exit(-1)

  if e[2] < 2:
    print 'L%d: t2l runs-per-level must be >= 2 but was %d' % (x+1, e[2])
    sys.exit(-1)

  if e[1] < (2 * prev_rpl):
    print 'L%d: t2l, fanout was %d and must be >= 2*runs-per-level from prev level (%d)' % (
        x+1, e[1], prev_rpl)
    sys.exit(-1)

# For all levels fanout >= 2 and runs-per-level = 1
def validate_leveled(r, x, e):
  if e[1] < 2:
    print 'L%d: leveled, fanout must be >= 2 was %d' % (x+1, e[1])
    sys.exit(-1)
  if e[2] != 1:
    print 'L%d: leveled, runs-per-level must be 1 was %d' % (x+1, e[2])
    sys.exit(-1)

# For the first t level (L1) fanout is 1 and runs-per-level is k where k > 1
# For the last t level runs-per-level <= fanout and fanout == k
# For all in between levels runs-per-level and fanout == k
def validate_tiered(r, x, e, fo_rpl, last_tiered):
  if e[2] < 2:
    print 'L%d: tiered runs-per-level must be >= 2 but was %d' % (x+1, e[2])
    sys.exit(-1)

  if x == 0:
    if e[1] != 1:
      print 'L0: tiered fanout was %d, must be 1' % e[1]
      sys.exit(-1) 
  elif not last_tiered:
    if e[1] != fo_rpl or e[2] != fo_rpl:
      print 'L%d: tiered not last, fanout & runs-per-level were %d, %d and must be %d' % (x, e[1], e[2], fo_rpl)
      sys.exit(-1) 
  else:
    if e[1] != fo_rpl:
      print 'L%d: tiered last, fanout was %d, must be %d' % (x, e[1], fo_rpl)
      sys.exit(-1) 
    if e[2] > fo_rpl:
      print 'L%d: tiered last, runs-per-level was %d, must be <= %d' % (x, e[2], fo_rpl)
      sys.exit(-1) 

def validate_level_config(r, level_cnf):
  max_level = len(level_cnf)

  if level_cnf[-1][0] != 'l':
    print 'L%d is Lmax and must be l but was %s' % (len(level_cnf), level_cnf[-1][0])
    sys.exit(-1)

  if level_cnf[0][0] == 'l':
    # this is easy -- all levels must use 'l'
    for x,e in enumerate(level_cnf):
      if e[0] != 'l':
        print 'L%d: all leveled, must be l was %s' % (x+1, e[0])
        sys.exit(-1)
      validate_leveled(r, x, e)
  elif level_cnf[0][0] == 't':
    # this is less easy -- look for t+ p* l+
    x = 0
    fo_rpl = level_cnf[0][2]
    # first parse the sequence of t
    while x < max_level and level_cnf[x][0] == 't':
      if x+1 == max_level:
        print 'max_level must be p or l'
        sys.exit(-1)
      validate_tiered(r, x, level_cnf[x], fo_rpl, level_cnf[x+1][0] != 't')
      x = x + 1
    # next parse the optional sequence of p
    while x < max_level and level_cnf[x][0] == 'p':
      validate_partial_tiered(r, x, level_cnf[x], level_cnf[x-1][2])
      x = x + 1
    # next parse the required sequence of l
    while x < max_level and level_cnf[x][0] == 'l':
      validate_leveled(r, x, level_cnf[x])
      x = x + 1
    # we should be done
    if x != max_level:
      print 'Unable to parse starting with t'
      sys.exit(-1)
  else:
    print 'L1 must be one of t,l but was ' % level_cnf[0][0]
    sys.exit(-1)

def parse_level_config(r):
  # Expects:
  #   The LSM tree has N persistent levels from L1 to Lmax, L0 is the memtable
  #
  #   L1 to Lmax can be described using the following:
  #     There is an entry per level, entries are comma separated
  #     Each entry has 3 parts and is ':' separated
  #
  #   For each entry
  #     field 1 is 't', 'p' or 'l' for tiered, partial-tiered and leveled
  #     field 2 is fanout, a float
  #     field 3 is runs-per-level, a float
  #     With max_level=2, then --level_config='t:1:8,2:8:1' is valid
  #
  #   A regex specifies the patterns that are valid for field 1 from L1 to Lmax: (t+ p*)? l+
  #     These restrictions might be removed in the future, but reduce complexity for now
  #       last level must be l to reduce space-amp
  #       t cannot follow p or l -> tl is valid, lt is not
  #       p cannot follow l -> pl is valid, lp is not
  #       to avoid confusion, L1 cannot be p, use t in that case
  #       these are valid: tpl, tl, ll
  #       these are invalid: pl (L1 can't be p)
  #
  #   And there are rules specific to l, t and 2. First, for t:
  #     For the first t level (L1) fanout is 1 and runs-per-level is k where k > 1
  #     For the last t level runs-per-level <= fanout and fanout == k and runs-per-level >= 2
  #     For all in between levels runs-per-level and fanout == k
  #     So this is valid: 't:1:10,t:10:10,t:10:10,t:10:2,...'
  #   Next the rules for p:
  #     runs-per-level < fanout and runs-per-level >= 2
  #     fanout >= 2 * runs-per-level from previous level - to make sorted run on this level
  #       sufficiently larger than data that will be merged into it.
  #   Next the rules for l:
  #     For all levels fanout >= 2 and runs-per-level = 1

  level_cnf = []

  cfgs = r.level_config.split(',')

  for lv, cfg in enumerate(cfgs):
    opts = cfg.split(':')
    if len(opts) != 3:
      print '%s must have 3 fields like a:b:c' % cfg
      sys.exit(-1)
    elif opts[0] not in ['t', 'p', 'l']:
      print 'from %s first field must be one of t, p, l' % opts[0]
      sys.exit(-1)
    elif not isFloat(opts[1]) or not isFloat(opts[2]):
      print 'from second(%s) and third(%s) fields must be integers' % (opts[1], opts[2])
      sys.exit(-1)

    level_cnf.append([opts[0], float(opts[1]), float(opts[2])])

  return level_cnf

def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--label', default='RES')
    parser.add_argument('--memtable_mb', type=int, default=256)
    parser.add_argument('--wa_fudge', type=float, default=0.7)
    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--level_config', default="")
    parser.add_argument('--row_size', type=int, default=128)
    parser.add_argument('--key_size', type=int, default=8)
    parser.add_argument('--file_mb', type=int, default=32)
    parser.add_argument('--block_bytes', type=int, default=4096)

    parser.add_argument('--bloom_on_max', dest='bloom_on_max', action='store_true')
    parser.add_argument('--no_bloom_on_max', dest='bloom_on_max', action='store_false')
    parser.set_defaults(bloom_on_max=False)

    parser.add_argument('--bloom_on_memtable', dest='bloom_on_memtable', action='store_true')
    parser.add_argument('--no_bloom_on_memtable', dest='bloom_on_memtable', action='store_false')
    parser.set_defaults(bloom_on_memtable=False)

    parser.add_argument('--bloom_filter_bits', type=int, default=10)

    # Assume each bloom filter probe is equivalent to a key comparison
    #
    # RocksDB does bloom_filter_bits * 0.69 probes, rounded down. With
    # bloom_filter_bits=10 this is 6
    parser.add_argument('--bloom_filter_compares', type=int, default=2)

    # The default is a 6-byte pointer
    parser.add_argument('--bytes_per_block_pointer', type=int, default=6)

    # Determines whether read,write,space,cache amp metrics are comma or tab separated
    parser.add_argument('--csv', dest='csv', action='store_true')
    parser.set_defaults(csv=False)

    r = parser.parse_args(argv)

    x = r.memtable_mb // r.file_mb
    if (r.file_mb * x) != r.memtable_mb:
      print 'file_mb adjusted from %d to %d with mult %d' % (r.file_mb, r.memtable_mb // x, x)
      r.file_mb = r.memtable_mb // x

    print 'memtable_mb ', r.memtable_mb
    print 'wa_fudge ', r.wa_fudge
    print 'database_gb %d, database_mb %d' % (r.database_gb, r.database_gb * 1024)
    print 'level_config ', r.level_config
    print 'row_size %d, key_size %d' % (r.row_size, r.key_size)
    print 'file_mb ', r.file_mb
    print 'block_bytes ', r.block_bytes
    print 'bloom_on_max %d, bloom_on_memtable %d' % (r.bloom_on_max, r.bloom_on_memtable)
    print 'bloom_filter_bits %d, bloom_filter_compares %d' % (r.bloom_filter_bits, r.bloom_filter_compares)
    print 'bytes_per_block_pointer ', r.bytes_per_block_pointer
    print 'Mrows %.2f' % (((r.database_gb * 1024 * 1024 * 1024) / r.row_size) / 1000000.0)

    level_config = parse_level_config(r)
    validate_level_config(r, level_config)

    lsm = config_lsm_tree(r, level_config)

    hit_cmp, miss_cmp, miss_nobf_cmp = point_compares(lsm, r)
    range_seek, range_next = range_compares(lsm, r, miss_nobf_cmp) 
    lsm['hit_cmp'] = hit_cmp
    lsm['miss_cmp'] = miss_cmp
    lsm['miss_nobf_cmp'] = miss_nobf_cmp
    lsm['range_seek'] = range_seek
    lsm['range_next'] = range_next

    print '\nCompares point hit/miss/mnbf: %.2f\t%.2f\t%.2f, %d sorted runs' % (
        hit_cmp, miss_cmp, miss_nobf_cmp, lsm['sorted_runs'])
    print 'Compares range seek/next: %.2f\t%.2f' % (range_seek, range_next)

    return lsm, r

def print_result(lsm, args):
    # Results on one line, comma or tab separated
    #   write-amp CPU
    #   write-amp IO
    #   space-amp
    #   cache-amp
    #   N sorted runs
    #   point-hit
    #   point-miss
    #   range-seek
    #   range-next
    if args.csv:
      print '%s,%.1f,%.1f,%.2f,%.3f,%d,%.1f,%.1f,%.1f,%.1f' % (
        args.label,
        lsm['write_amp_io'], lsm['write_amp_cpu'], lsm['space_amp'], lsm['cache_amp'],
        lsm['sorted_runs'],
        lsm['hit_cmp'], lsm['miss_cmp'],
        lsm['range_seek'], lsm['range_next'])
    else:
      print '%s\t%.1f\t%.1f\t%.2f\t%.3f\t%d\t%.1f\t%.1f\t%.1f\t%.1f' % (
        args.label,
        lsm['write_amp_io'], lsm['write_amp_cpu'], lsm['space_amp'], lsm['cache_amp'],
        lsm['sorted_runs'],
        lsm['hit_cmp'], lsm['miss_cmp'],
        lsm['range_seek'], lsm['range_next'])

def main(argv):
    lsm, args = runme(argv)
    print_result(lsm, args)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

