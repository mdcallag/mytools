rmprefix=$1
shift 1

bdir=$( dirname $0 )

farr=("$@")
f1=${farr[0]}

#ips     qps     rps     rkbps   wkbps   rpq     rkbpq   wkbpq   csps    cpups   cspq    cpupq   ccpupq  dbgb    vsz     rss     maxop   p50     p90     tag
#1846.5        0       0.0     0       252327  0.000   0.000   1.315   21711   63.0    0.113   53      2       55      NA      NA      0.458   28103.5 4253.4  pg12.c7b40

for l in 2 3 4; do
  head -1 $f1 > mrg.q$l
  for f in "$@"; do
    if [ $f != "BREAK" ]; then
      head -${l} $f | tail -1 | \
        awk -v FS='\t' -v OFS='\t' '{ $1=sprintf("%.0f", $1); $2=sprintf("%.0f", $2); $3=sprintf("%.0f", $3); $18=sprintf("%.0f", $18); $19=sprintf("%.0f", $19); print $0 }'
    else
      echo "-"
    fi
  done | sed "s/${rmprefix}\.//g" >> mrg.q$l
done

mv mrg.q2 mrg.l
mv mrg.q3 mrg.q1000
mv mrg.q4 mrg.q100

for l in 6 7 8 9 10; do
  head -5 $f1 | tail -1 > mrg.x$l
  for f in "$@"; do
    if [ $f != "BREAK" ]; then
      head -${l} $f | tail -1;
    else
      echo "-"
    fi
  done | sed "s/${rmprefix}\.//g" >> mrg.x$l
done

mv mrg.x6 mrg.s1
mv mrg.x7 mrg.s2
mv mrg.x8 mrg.s3
mv mrg.x9 mrg.s4
mv mrg.x10 mrg.s5

