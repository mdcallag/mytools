
import sys
import random
from collections import deque

def heap_val(h, x):
  return h[x][0]

def heap_swap(h, x1, x2):
  tmp = h[x1]
  h[x1] = h[x2]
  h[x2] = tmp

def heap_fixup(h, x):
  while x > 1 and heap_val(h, x/2) > heap_val(h, x):
    heap_swap(h, x/2, x)
    x = x/2

def heap_next(h):
  v = heap_val(h, 1)

  done = run_pop(h[1])
  if done:
    # run is finished, remove from heap
    if len(h) > 2:
      # more runs
      h[1] = h.pop()
      # uncache outcome
      h[0] = 0
    else:
      # no more runs
      h.pop()
      return v, 0, 0

  ncmp = 0
  ocmp = 0

  # run not finished, fix heap
  #print 'before fix', h
  k = 1
  nruns = len(h) - 1
  while 2*k <= nruns:
    j = 2*k

    if j < nruns:
      ncmp += 1
      if k > 1 or h[0] == 0:
        # cached comparison can't be used
        ocmp += 1
      if k == 1:
        # cache outcome
        h[0] = 1
      if heap_val(h, j) > heap_val(h,j+1):
        j += 1

    ncmp += 1
    ocmp += 1
    if heap_val(h,k) <= heap_val(h,j):
      break

    if k == 1:
      # uncache outcome
      h[0] = 0

    heap_swap(h, k, j)
    k = j

  #print 'after fix', h
  return v, ncmp, ocmp

def heap_insert(h, v):
  h.append(v)
  heap_fixup(h, len(h)-1)

def run_pop(run):
  run.popleft()
  if len(run):
    return False
  else:
    return True
    
def estimate_compares(sizes):
  h = [0]
  nval = 0
  
  for s in sizes:
    nval += s
    run = [random.randint(0, 1000000000) for x in xrange(s)]
    run.sort()
    d = deque()
    for x in run:
      d.append(x)
    #print run
    heap_insert(h, d)
    #print h

  lastv = -1
  ncmp = 0
  ocmp = 0
  while len(h) > 1:
    (v, c1, c2) = heap_next(h)
    ncmp += c1
    ocmp += c2
    #print 'produce %d' % v
    assert v >= lastv
    lastv = v

  return ncmp, ocmp, nval

def fill_levels(lsm_type, maxvals, maxiters, rplto):
  fanout_arr = [2, 4, 5, 8, 10, 15, 20]
  
  print("niters\t"),
  for fanout in fanout_arr:
    print("fo=%d\t" % fanout),
  print("")

  for niters in xrange(1, maxiters+1):
    print("%d\t" % niters),
    for fanout in fanout_arr:
      curvals = maxvals
      sizes = []
      ok = True
      for n in xrange(1, niters+1):
        if curvals < 1:
          # print 'curvals < 1 for fanout %d, vals %d, iters %d' % (fanout, maxvals, niters)
          ok = False
          break
        sizes.append(curvals)
        curvals //= fanout

      if ok:
        sizes.reverse()
        if lsm_type == 'rpl':
          newsizes = []
          for x, s in enumerate(sizes):
            newsizes.append(s)
            if (x+1) <= rplto and (x+1) < len(sizes):
              for x2 in xrange(fanout-1):
                newsizes.append(s)
          sizes = newsizes

        # print 'vals %d, iters %d, fanout %d, sizes %s' % (maxvals, niters, fanout, sizes)
        ncmp, ocmp, nval = estimate_compares(sizes)
        ncmp_val = (1.0*ncmp) / nval
        ocmp_val = (1.0*ocmp) / nval
      else:
        ncmp = ocmp = nval = ncmp_val = ocmp_val = -9
         
      # print '%d fo, %d niter, %d nval, %d ncmp, %d ocmp, %.2f ncmp/v, %.2f ocmp/v' % (
      # fanout, niters, nval, ncmp, ocmp, (1.0*ncmp) / nval, (1.0*ocmp) / nval)
      print("%.2f\t" % ncmp_val),
    print("")

def main(argv):
  sizes = []
  if argv[0] == 'one':
    for a in argv[1:]:
      sizes.append(int(a))

    ncmp, ocmp, nval = estimate_compares(sizes)
    print '%d nval, %d ncmp, %d ocmp, %.2f ncmp/v, %.2f ocmp/v' % (
      nval, ncmp, ocmp, (1.0*ncmp) / nval, (1.0*ocmp) / nval)

  elif argv[0] == 'leveled':
    assert(len(argv) == 3)
    maxvals = int(argv[1])
    maxiters = int(argv[2])
    fill_levels('leveled', maxvals, maxiters, -1)
    
  elif argv[0] == 'rpl':
    assert(len(argv) == 4)
    maxvals = int(argv[1])
    maxiters = int(argv[2])
    rplto = int(argv[3])
    fill_levels('rpl', maxvals, maxiters, rplto)

  else:
    print 'arg 0 must be "one" or "leveled" or "rpl"'
    sys.exit(-1)
    
if __name__ == '__main__':
  sys.exit(main(sys.argv[1:]))


