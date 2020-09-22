import argparse
import sys
import math

def product(list):
    p = 1
    for i in list:
        p *= i
    return p

def sum(list):
    p = 0
    for i in list:
        p += i
    return p

def runlevel(args, num_levels, last_n):
  if last_n == 0:
    wa_pl = args.fanout ** (1.0 / (num_levels - 1.0))
    wa_sum = wa_pl * (num_levels - 1)
    nruns = num_levels
    fo_arr = [wa_pl] * (num_levels - 1)
  else:
    wa_pl = (args.fanout/(last_n * args.runs_per_level)) ** (1.0 / (num_levels - 1.0))
    wa_sum = wa_pl * (num_levels - 1)
    nruns = last_n * args.runs_per_level
    nruns += num_levels - last_n
    fo_arr = ([wa_pl * args.runs_per_level] * last_n) + ([wa_pl] * (num_levels - last_n - 1))

  return wa_sum, wa_pl, nruns, fo_arr

def get_ph_rs(args, num_levels, fo_arr, last_n):
    assert num_levels == len(fo_arr) + 1
    assert last_n >= 0
    assert last_n < num_levels

    ph = rs = 0
    db_bytes = args.db_gb * 1024.0 * 1024 * 1024
    sst_bytes = args.sst_mb * 1024.0 * 1024
    blocks_per_sst = sst_bytes / args.block_size
    block_index_cmp = math.ceil(math.log(blocks_per_sst, 2))
    block_search_cmp = math.ceil(math.log(args.block_size / args.row_size, 2))

    l = num_levels
    while l > 0:
 
      nrows = db_bytes / args.row_size
      rs_pl = math.ceil(math.log(nrows, 2))
      if l <= last_n:
        rs_pl *= args.runs_per_level
      rs += rs_pl

      nsst = db_bytes / sst_bytes

      # sst search, bloom access
      ph_pl = math.ceil(math.log(nsst, 2)) + args.bloom_cost

      if l == num_levels:
        # add block index search, block search
        ph_pl += block_index_cmp + block_search_cmp
      elif l <= last_n:
        ph_pl *= args.runs_per_level
      ph += ph_pl

      #print('%d of %d: %.2f,%.2f ph, %.2f,%.2f rs, %.1f Mrows, %d nsst' % (
      #    l, num_levels, ph, ph_pl, rs, rs_pl, nrows/(1024.0*1024), nsst))
     
      l -= 1
      if l > 0:
        db_bytes /= fo_arr[l-1]
      
    return ph, rs

def runit(args):

  if not args.print_all:
    print('Nlvls\twa.0\t%s' % "\t".join(['wa.%d' % lvl for lvl in range(1, args.max_level)]))
  else:
    print('Nlvls\tlastN\twa\tNruns\tpoint\trange\tfanout/level')

  for lv in range(args.min_level, args.max_level+1):
    wa_sum, wa_pl, nruns, fo_arr = runlevel(args, lv, 0)
    if not args.print_all:
      sys.stdout.write('%d\t%.2f' % (lv, wa_sum))
    else:
      ph, rs = get_ph_rs(args, lv, fo_arr, 0)
      print('%d\t%d\t%.2f\t%d\t%.2f\t%.2f\t%s' % (lv, 0, wa_sum, nruns, ph, rs, ",".join(["%.2f" % x for x in fo_arr])))
    for last_n in range(1, lv):
      wa_sum, wa_pl, nruns, fo_arr = runlevel(args, lv, last_n)
      if not args.print_all:
        sys.stdout.write('\t%.2f' % wa_sum)
      else:
        ph, rs = get_ph_rs(args, lv, fo_arr, last_n)
        print('%d\t%d\t%.2f\t%d\t%.2f\t%.2f\t%s' % (lv, last_n, wa_sum, nruns, ph, rs, ",".join(["%.2f" % x for x in fo_arr])))
    if not args.print_all: sys.stdout.write('\n')
  sys.stdout.flush()

def main(argv):
  parser = argparse.ArgumentParser()
  parser.add_argument('--fanout', type=int, default=1000)
  parser.add_argument('--min_level', type=int, default=2)
  parser.add_argument('--max_level', type=int, default=12)
  parser.add_argument('--runs_per_level', type=int, default=2)
  parser.add_argument('--print_all', type=int, default=0)
  parser.add_argument('--db_gb', type=int, default=1024)
  parser.add_argument('--row_size', type=int, default=128)
  parser.add_argument('--block_size', type=int, default=4096)
  parser.add_argument('--sst_mb', type=int, default=64)
  parser.add_argument('--bloom_cost', type=int, default=3)

  args = parser.parse_args(argv)
  assert args.min_level >= 2
  assert args.max_level > args.min_level
  assert args.runs_per_level >= 2
  assert args.fanout >= 2
  runit(args)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

