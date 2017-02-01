
import sys
import argparse
import math

def range_compares(lsm, args):
    print '\nrange compares'

    my_cmp = math.ceil(math.log((1024 * 1024 * args.memtable_mb) / args.row_bytes, 2))
    cum_cmp = my_cmp
    print 'memtable: %.3f my_cmp, %.3f cum_cmp' % (my_cmp, cum_cmp)

    if args.use_l0:
      for x in xrange(args.l0_trigger):
        my_cmp = lsm['cmp_block_index_l0'] + lsm['cmp_per_block']
        cum_cmp += my_cmp
        print 'l0 file %d: %.3f my_cmp, %.3f cum_cmp' % (x+1, my_cmp, cum_cmp)

    for x in xrange(len(lsm['level_mb'])):
      my_cmp = lsm['level_files_cmp'][x] + lsm['cmp_block_index'] + lsm['cmp_per_block']
      cum_cmp += my_cmp
      print 'level %d: %.3f my_cmp, %.3f cum_cmp' % (x+1, my_cmp, cum_cmp)
    return cum_cmp

def point_compares(lsm, args, blooms):
    print '\npoint compares type=%d' % blooms

    # blooms
    # = 0 -> no bloom filter
    # = 1 -> bloom filter per data block
    # = 2 -> bloom filter per SST

    # compares for a point query
    # first search memtable
    cum_cmp = math.ceil(math.log((1024 * 1024 * args.memtable_mb) / args.row_bytes, 2))
    prob = (1.0 * args.memtable_mb) / lsm['total_mb']
    point_cmp = prob * cum_cmp
    print 'memtable: %.6f prob, %.3f hit_cmp, %.3f cum_cmp' % (prob, point_cmp, cum_cmp)

    if args.use_l0:
      for x in xrange(args.l0_trigger):
        my_cmp_hit = lsm['cmp_block_index_l0'] + lsm['cmp_per_block']

        if blooms == 0:
          my_cmp_miss = my_cmp_hit
        elif blooms == 1:
          my_cmp_miss = lsm['cmp_block_index_l0']
        else:
          my_cmp_miss = 0

        prob = (1.0 * args.memtable_mb) / lsm['total_mb']
        point_cmp += prob * (cum_cmp + my_cmp_hit)
        cum_cmp += my_cmp_miss
        print 'l0 file %d: %.6f prob, %.3f hit_cmp, %.3f cum_cmp, %.3f/%.3f my_cmp hit/miss' % (
            x+1, prob, point_cmp, cum_cmp, my_cmp_hit, my_cmp_miss)

    for x in xrange(len(lsm['level_mb'])):
      my_cmp_hit = lsm['level_files_cmp'][x] + lsm['cmp_block_index'] + lsm['cmp_per_block']

      if blooms == 0:
        my_cmp_miss = my_cmp_hit
      elif blooms == 1:
        my_cmp_miss = lsm['level_files_cmp'][x] + lsm['cmp_block_index'];
      else:
        my_cmp_miss = lsm['level_files_cmp'][x];

      if x == len(lsm['level_mb']):
        prob = 1.0
      else:
        prob = (1.0 * lsm['level_mb'][x]) / lsm['total_mb']

      point_cmp += prob * (cum_cmp + my_cmp_hit)
      cum_cmp += my_cmp_miss
      print 'level %d: %.6f prob, %.3f hit_cmp, %.3f cum_cmp, %.3f/%.3f my_cmp hit/miss' % (
          x+1, prob, point_cmp, cum_cmp, my_cmp_hit, my_cmp_miss)

    return (point_cmp, cum_cmp)

def config_lsm_tree(args):
    cur_level_mb = 1.0 * args.database_gb * 1024
    level_mb = []
    level_files = []
    level_files_cmp = []

    lsm = {}
    lsm['blocks_per_file_l0'] = math.ceil((1024 * args.memtable_mb) / args.block_kb)
    lsm['cmp_block_index_l0'] = math.ceil(math.log(lsm['blocks_per_file_l0'], 2))

    lsm['blocks_per_file'] = math.ceil((1024 * args.file_mb) / args.block_kb)
    lsm['cmp_block_index'] = math.ceil(math.log(lsm['blocks_per_file'], 2))

    lsm['rows_per_block'] = math.ceil((1024 * args.block_kb) / args.row_bytes)
    lsm['cmp_per_block'] = math.ceil(math.log(lsm['rows_per_block'], 2))

    print 'blocks per file l0 %d' % lsm['blocks_per_file_l0']
    print 'compare block index l0 %d' % lsm['cmp_block_index_l0']
    print 'blocks per file %d' % lsm['blocks_per_file']
    print 'compare block index %d' % lsm['cmp_block_index']
    print 'rows_per_block %d' % lsm['rows_per_block']
    print 'compare per block: %d' % lsm['cmp_per_block']

    done = False
    while not done:
      if cur_level_mb <= args.l1_mb:
        done = True

      level_mb.append(cur_level_mb)

      nfiles = math.ceil(cur_level_mb / args.file_mb)

      # file_rem = cur_level_mb - (args.file_mb * nfiles)
      # nblocks_rem = math.ceil(args.file_mb / args.block_kb)

      level_files.append(nfiles)
      level_files_cmp.append(math.ceil(math.log(nfiles, 2)))

      cur_level_mb = cur_level_mb / args.level_growth

    level_mb.reverse()
    level_files.reverse()
    level_files_cmp.reverse()

    for x in xrange(len(level_mb)):
      print 'level %d, level_mb %d, level_files %d, file_cmp %f' % (
          x+1, level_mb[x], level_files[x], level_files_cmp[x])

    lsm['level_mb'] = level_mb
    lsm['level_files'] = level_files
    lsm['level_files_cmp'] = level_files_cmp    

    total_mb = 1.0 * args.memtable_mb
    total_mb += (args.memtable_mb * args.l0_trigger)
    for mb in lsm['level_mb']:
      total_mb += mb
    print '%f total_mb, %.2f space-amp' % (total_mb, total_mb / (args.database_gb * 1024.0))
    lsm['total_mb'] = total_mb
 
    return lsm

def runme(argv):
    parser = argparse.ArgumentParser()

    parser.add_argument('--memtable_mb', type=int, default=32)
    parser.add_argument('--l0_trigger', type=int, default=4)
    parser.add_argument('--l1_mb', type=int, default=128)
    parser.add_argument('--database_gb', type=int, default=1024)
    parser.add_argument('--level_growth', type=int, default=10)
    parser.add_argument('--row_bytes', type=int, default=128)
    parser.add_argument('--file_mb', type=int, default=32)
    parser.add_argument('--block_kb', type=int, default=8)
    parser.add_argument('--use_l0', type=int, default=1)

    r = parser.parse_args(argv)
    print 'memtable_mb ', r.memtable_mb
    print 'l0_trigger ', r.l0_trigger
    print 'l1_mb ', r.l1_mb
    print 'database_gb ', r.database_gb
    print 'level_growth ', r.level_growth
    print 'row_bytes ', r.row_bytes
    print 'file_mb ', r.file_mb
    print 'block_kb ', r.block_kb
    print 'use_l0 ', r.use_l0

    lsm = config_lsm_tree(r)

    results = []
    for x in [0, 1, 2]:   
      results.append(point_compares(lsm, r, x))
     
    range_cmp = range_compares(lsm, r) 

    # compares for an insert
    insert_cmp = math.ceil(math.log((1024 * 1024 * r.memtable_mb) / r.row_bytes, 2))
    print '\n%.3f insert compares' % insert_cmp
    print 'Compares: %.0f\t%.0f\t%.0f\t%.0f\t%.0f' % (
        results[0][0], results[1][0], results[2][0], range_cmp, insert_cmp)

    return 0

def main(argv):
    return runme(argv)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

