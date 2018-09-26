import argparse
import sys
import math

def closeto(v, p, f):
  return (p/v) > f[0] and (p/v) < f[1]

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

def check(args, va, fudge, mins):
  if closeto(args.fanout, product(va), fudge):
    new_sum = sum(va)
    if new_sum < mins[0][0]:
      mins[0][0] = new_sum
      mins[0][1] = va

    maxlv = len(va)
    prefix = 0
    for x in range(1,maxlv):
      prefix += va[x-1] / args.runs_per_level
      new_sum = prefix + sum(va[x:])
      if new_sum < mins[x][0]:
        mins[x][0] = new_sum
        mins[x][1] = va

def runlevel(args, lv_orig):
  fudge=[0.999, 1.001]
  mins = []
  for x in range(8):
    mins.append([999999, (-1)])
  lv = lv_orig - 1
  stop = args.fanout ** (1/float(lv))
  stop *= 4

  x1 = 1
  while x1 < stop:
    if lv > 2:
      x2 = 1
      while x2 < stop:
        if lv > 3:
          x3 = 1
          while x3 < stop:
            if lv > 4:
              x4 = 1
              while x4 < stop:
                if lv > 5:
                  x5 = 1
                  while x5 < stop:
                    if lv > 6:
                      x6 = 1
                      while x6 < stop:
                        if lv > 7:
                          x7 = 1
                          while x7 < stop:
                            x8 = args.fanout / product([x1, x2, x3, x4, x5, x6, x7])
                            check(args, [x1, x2, x3, x4, x5, x6, x7, x8], fudge, mins)
                            x7 += args.step
                        else:
                          x7 = args.fanout / product([x1, x2, x3, x4, x5, x6])
                          check(args, [x1, x2, x3, x4, x5, x6, x7], fudge, mins)
                        x6 += args.step
                    else:
                      x6 = args.fanout / product([x1, x2, x3, x4, x5])
                      check(args, [x1, x2, x3, x4, x5, x6], fudge, mins)
                    x5 += args.step
                else:
                  x5 = args.fanout / product([x1, x2, x3, x4])
                  check(args, [x1, x2, x3, x4, x5], fudge, mins)
                x4 += args.step
            else:
              x4 = args.fanout / product([x1, x2, x3])
              check(args, [x1, x2, x3, x4], fudge, mins)
            x3 += args.step
        else:
          x3 = args.fanout / product([x1, x2])
          check(args, [x1, x2, x3], fudge, mins)
        x2 += args.step
    else:
      x2 = args.fanout / x1
      check(args, [x1, x2], fudge, mins)
    x1 += args.step

  print("Nlevels: %d, stop at %d" % (lv_orig, stop))
  for x in range(lv):
    fpa = ["%.2f" % v for v in mins[x][1]]
    print("  %d: min %.3f at %s" % (x, mins[x][0], fpa))

def runit(args):
  for lv in range(args.min_level, args.max_level+1):
    runlevel(args, lv)

def main(argv):
  parser = argparse.ArgumentParser()
  parser.add_argument('--fanout', type=int, default=1000)
  parser.add_argument('--min_level', type=int, default=2)
  parser.add_argument('--max_level', type=int, default=10)
  parser.add_argument('--runs_per_level', type=int, default=2)
  parser.add_argument('--step', type=float, default=0.5)

  args = parser.parse_args(argv)
  assert args.min_level >= 3
  assert args.max_level <= 9
  assert args.runs_per_level >= 2
  assert args.step > 0
  assert args.fanout >= 2
  runit(args)

if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))

