
# for t in link node count; do cp r.stats.$t.*.L6.* o.$t.x; vi o.$t.x; cat o.$t.x | sed -r 's/NumberLong\("([0-9][0-9]*)"\)/\1/' | sed -r 's/NumberLong\(([0-9][0-9]*)\)/\1/' | python3 ~/git/mytools/bench/wtsz.py > o.$t.x2; cat o.$t.x2 ; done
# cp o.es1.dop8.ns3 o.tcm1; vi o.tcm1; cat o.tcm1 | sed -r 's/NumberLong\("([0-9][0-9]*)"\)/\1/' | sed -r 's/NumberLong\(([0-9][0-9]*)\)/\1/' > o.tcm2; cat o.tcm2 | python3 ../../tcm.py > o.tcm3; cat o.tcm3

# wiredTiger
#   block-manager
#     "file bytes available for reuse"
#     "file size in bytes" 
#   cache
#     "bytes currently in the cache"
#     "pages read into cache"
#     "pages written from cache"
#   indexDetails : { name : dict, ... }

import json
import sys

remap = {
  "file bytes available for reuse" : "Mreuse",
  "file size in bytes" : "Msize",
  "bytes currently in the cache" : "Mcache",
  "bytes read into cache" : "GBread",
  "bytes written from cache" : "GBwrite",
  "pages read into cache" : "Mpread",
  "pages written from cache" : "Mpwrite" }

def print_one(n, o):
  print('%.0f\t' % (o['block-manager']['file bytes available for reuse'] / (1024 * 1024)), end='')
  print('%.0f\t' % (o['block-manager']['file size in bytes'] / (1024 * 1024)), end='')
  print('%.0f\t' % (o['cache']['bytes currently in the cache'] / (1024 * 1024)), end='')
  print('%.1f\t' % (o['cache']['bytes read into cache'] / (1024 * 1024 * 1024)), end='')
  print('%.1f\t' % (o['cache']['bytes written from cache'] / (1024 * 1024 * 1024)), end='')
  print('%.1f\t' % (o['cache']['pages read into cache'] / (1024 * 1024)), end='')
  print('%.1f\t' % (o['cache']['pages written from cache'] / (1024 * 1024)), end='')
  print('%s\t' % n, end='')
  print()

def main(argv):
  j = json.load(sys.stdin) 

  for k,v in remap.items():
    print('%s\t:\t%s' % (v,k))
  print()

  print('Mreuse\tMsize\tMcache\tMbread\tMbwrite\tMpread\tMpwrite\tname')

  print_one(j['ns'], j['wiredTiger'])

  if 'indexDetails' in j:
    for k, v in j['indexDetails'].items():
      print_one(k, v)

  return 0

if __name__ == '__main__':
  sys.exit(main(sys.argv))

