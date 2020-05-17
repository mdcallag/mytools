
# cat o.tab1.id.dop8.ns3 | sed -r 's/NumberLong\("([0-9][0-9]*)"\)/\1/' | sed -r 's/NumberLong\(([0-9][0-9]*)\)/\1/' > o.tab1.x; vi o.tab1.x; cat o.tab1.x | python3 ~/git/mytools/bench/wtsz.py > o.tab1.x2; cat o.tab1.x2
# for t in link node count; do cp r.stats.$t.*.L6.* o.$t.x; vi o.$t.x; cat o.$t.x | sed -r 's/NumberLong\("([0-9][0-9]*)"\)/\1/' | sed -r 's/NumberLong\(([0-9][0-9]*)\)/\1/' | python3 ~/git/mytools/bench/wtsz.py > o.$t.x2; done ; cat o.link.x2 o.count.x2 o.node.x2

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
  "file size in MB" : "Msize",
  "file MB available for reuse" : "Mreuse",
  "MB currently in the cache" : "Mcache",
  "GB read into cache" : "GBread",
  "GB written from cache" : "GBwrite",
  "million pages read into cache" : "Mpread",
  "million pages written from cache" : "Mpwrite" }

def print_one(n, o):
  print('%.0f\t' % (o['block-manager']['file size in bytes'] / (1024 * 1024)), end='')
  print('%.0f\t' % (o['block-manager']['file bytes available for reuse'] / (1024 * 1024)), end='')
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

  print('Msize\tMreuse\tMcache\tMbread\tMbwrite\tMpread\tMpwrite\tname')

  print_one(j['ns'], j['wiredTiger'])

  if 'indexDetails' in j:
    for k, v in j['indexDetails'].items():
      print_one(k, v)

  return 0

if __name__ == '__main__':
  sys.exit(main(sys.argv))

