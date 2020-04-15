
bdir=$( dirname $0 )

farr=("$@")
f1=${farr[0]}

#ips     qps     rps     rkbps   wkbps   rpq     rkbpq   wkbpq   csps    cpups   cspq    cpupq   	dbgb    vsz     rss     maxop   p50     p99     tag
#5041.3	0       0.3     3       197213  0.000   0.000   3.910   18387   71.1    0.365   0.001409        64      25.1    23.3    0.477   8348.6  3050.4  80m.mo425.c5b

for l in 2 3 4; do
  head -1 $f1 > mrg.q$l
  for f in "$@"; do
    if [ $f != "BREAK" ]; then
      head -${l} $f | tail -1 | \
        awk -v FS='\t' -v OFS='\t' '{ $1=sprintf("%.0f", $1); $2=sprintf("%.0f", $2); $3=sprintf("%.0f", $3); $12=sprintf("%.0f", $12 * 1000000); $17=sprintf("%.0f", $17); $18=sprintf("%.0f", $18); print $0 }'
    else
      echo "-"
    fi
  done  >> mrg.q$l
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
  done  >> mrg.x$l
done

mv mrg.x6 mrg.s1
mv mrg.x7 mrg.s2
mv mrg.x8 mrg.s3
mv mrg.x9 mrg.s4
mv mrg.x10 mrg.s5

