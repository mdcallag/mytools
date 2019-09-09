import argparse
import sys
import math
import copy

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

def cost_p(params, bloom_rows, debug):
  q_cmp = 0
  cum = 1

  for x, p in enumerate(params):
    cum *= p

    if x == 0 or x == (len(params)-1):
      # for memtable or max level
      x = math.log(cum, 2)
    elif bloom_rows == 0:
      # bloom per level, assume bloom costs 1 cmp
      x = 1
    else:
      # number of compares to find chunk of rows covered by bloom
      # +1 cmp for using bloom
      x = math.log(cum / bloom_rows, 2) + 1
      
    if debug: print('q_cmp for %s += %s, bloom chunk = %d' % (cum, x, bloom_rows))
    q_cmp += x
  
  u_cmp = math.log(params[0], 2)
  if debug: print('u_cmp for %s = %s' % (params[0], u_cmp))
  for p in params[1:]:
    if debug: print('u_cmp += %s' % p)
    u_cmp += p

  return q_cmp, u_cmp

def format_p(params):
  return '-'.join(['%.2f' % p for p in params])

def init_p(num_b, min_fanout, total_fanout, nlevels, nrows):
  params = [num_b] + [min_fanout] * (nlevels-1)
  cum_fanout = num_b * (min_fanout ** (nlevels-1))
  last_fanout = float(nrows) / cum_fanout
  params.append(last_fanout)
  return params, last_fanout

def inc_p(params, num_b, min_fanout, total_fanout, nrows, f_step, max_level_fo):
  cur_x = len(params) - 2

  while True:
    while cur_x >= 1:
      params[cur_x] += f_step
      if params[cur_x] > max_level_fo:
        params[cur_x] = min_fanout
        cur_x = cur_x - 1
      else:
        break

    if cur_x == 0:
      return False
    
    cum_fanout = product(params[0:-1])
    params[-1] = float(nrows) / cum_fanout
    if params[-1] >= min_fanout:
      return True

    cur_x = len(params) - 2
    params[cur_x] = max_level_fo + 1

def compute_wa(params):
  return sum(params[1:])
  
def run_all(args):
  mins = []

  # Used to determine how much of the search is skipped by bloom
  if args.bloom == 0:
    # no bloom
    bloom_rows = 1
  elif args.bloom == 1:
    # bloom per block
    bloom_rows = args.bytes_block / args.bytes_row
  elif args.bloom == 2:
    # bloom per SST
    bloom_rows = (1024 * 1024 * args.mb_sst) / args.bytes_row
  else:
    # bloom per level
    bloom_rows = 0

  b_frac = args.b_pct / 100.0
  num_b = int(round(b_frac * args.nrows))
  total_fanout = float(args.nrows) / num_b

  level_fanout = total_fanout ** (1/float(args.nlevels))

  def_params = [num_b] + [level_fanout] * args.nlevels
  def_qcmp, def_ucmp = cost_p(def_params, bloom_rows, args.debug)

  print('N=%d, b_pct=%.3f, nlv=%d, params=%s, costs(%.3f, %.3f)' %
        (args.nrows, args.b_pct, args.nlevels, format_p(def_params),
         def_qcmp, def_ucmp))

  q_cmp_arr = [0, 0.2, 0.4, 0.5, 0.6, 0.8, 1.0]
  def_cmp = []
  min_cmp = []
  min_params = []
  def_wa = compute_wa(def_params)
  min_wa = []
  
  t_cmp = []
  for x, q_frac in enumerate(q_cmp_arr):
    c = q_frac * def_qcmp + (1-q_frac) * def_ucmp
    def_cmp.append(c)
    min_cmp.append(c)
    min_params.append(def_params)
    min_wa.append(compute_wa(def_params))

  params, max_level_fo = init_p(num_b, args.min_fanout, total_fanout, args.nlevels, args.nrows)
  ok = True
  while ok:
    if args.debug:
      print('params is %s' % format_p(params))
    qcmp, ucmp = cost_p(params, bloom_rows, args.debug)
    p_key = None
    
    for x, q_frac in enumerate(q_cmp_arr):
      c = q_frac * qcmp + (1-q_frac) * ucmp
      if c < min_cmp[x]:
        if p_key is None:
          p_key = format_p(params)
        min_cmp[x] = c
        min_params[x] = copy.copy(params)
        min_wa[x] = compute_wa(params)

    ok = inc_p(params, num_b, args.min_fanout, total_fanout, args.nrows, args.f_step, max_level_fo)

  for x, p in enumerate(min_params):
    print('nl=%d, qpct=%.0f : %.3f vs %.3f rat=%.2f, wa is %.1f vs %.1f, from %s' %
          (args.nlevels, 100*q_cmp_arr[x], min_cmp[x], def_cmp[x], min_cmp[x]/def_cmp[x],
           min_wa[x], def_wa, format_p(p)))


def main(argv):
  parser = argparse.ArgumentParser()
  parser.add_argument('--f_step', type=float, default=0.25)
  parser.add_argument('--nrows', type=int, default=2**30)
  parser.add_argument('--nlevels', type=int, default=1)
  parser.add_argument('--b_pct', type=float, default=100.0/1024)
  parser.add_argument('--min_fanout', type=int, default=2)
  parser.add_argument('--debug', type=int, default=0)
  
  # 0 = none, 1 = per block, 2 = per sst, 3 = per level
  parser.add_argument('--bloom', type=int, default=0)
  parser.add_argument('--bytes_row', type=int, default=128)
  parser.add_argument('--bytes_block', type=int, default=4096)
  parser.add_argument('--mb_sst', type=int, default=32)
  
  args = parser.parse_args(argv)
  assert args.f_step > 0
  assert args.nlevels >= 1
  assert args.nlevels <= 10
  assert args.nrows >= 1000000
  assert args.b_pct > 0
  assert args.min_fanout >= 2
  assert args.bloom >= 0
  assert args.bloom <= 3
  assert args.bytes_row >= 1
  assert args.bytes_block >= 128
  assert args.mb_sst > 0

  run_all(args)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

