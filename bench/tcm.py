
# cp o.es1.dop8.ns3 o.tcm1; vi o.tcm1; cat o.tcm1 | sed -r 's/NumberLong\("([0-9][0-9]*)"\)/\1/' | sed -r 's/NumberLong\(([0-9][0-9]*)\)/\1/' > o.tcm2; cat o.tcm2 | python3 ../../tcm.py > o.tcm3; cat o.tcm3

import json
import sys

remap = { 'bytes_per_object' : 'bpo',
          'pages_per_span' : 'ppspan',
          'num_spans' : 'Mnspan',
          'num_thread_objs' : 'Mntobj',
          'num_central_objs' : 'Mncobj',
          'num_transfer_objs' : 'Mntobj',
          'free_bytes' : 'Mfrbyte',
          'allocated_bytes' : 'Malbyte' }

def main(argv):
  print("main")
  j = json.load(sys.stdin) 
  if 'tcmalloc' in j:
    t = j['tcmalloc']
    if 'size_classes' in t:
      sc = t['size_classes']

      for k,v in remap.items():
        print('%s\t:\t%s' % (v,k))
      print()

      for k,v in remap.items():
        print('%s\t' % v, end='')
      print()

      for x in sc:
        for k,v in x.items():
          if k in ('num_spans', 'num_thread_objs', 'num_central_objs', 'num_transfer_objs'):
            print("%.3f\t" % (v/(1024*1024)), end='')
          elif k in ('free_bytes', 'allocated_bytes'):
            print("%.0f\t" % (v/(1024*1024)), end='')
          else:
            print("%s\t" % v, end='')
        print()
  return 0

if __name__ == '__main__':
  sys.exit(main(sys.argv))

