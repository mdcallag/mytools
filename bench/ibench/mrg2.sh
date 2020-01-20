first_file=$( ls o.sum.* | head -1 )

#ips     qps     rps     rkbps   wkbps   rpq     rkbpq   wkbpq   csps    cpups   cspq    cpupq   dbgb    maxop   p50     p99     tag
#99.8    7071.3  0.0     0       93      0.000   0.000   0.013   27192   26.1    3.845   0.003690        2.3     0.019   7074.6  7032.9  5m.in57.c8

for l in 2 3 4; do
  head -1 $first_file > mrg.q$l
  for f in o.sum.*; do
    head -${l} $f | tail -1 | \
      awk -v FS='\t' -v OFS='\t' '{ $1=sprintf("%.0f", $1); $2=sprintf("%.0f", $2); $12=sprintf("%.0f", $12 * 1000000); $15=sprintf("%.0f", $15); $16=sprintf("%.0f", $16); print $0 }'
  done  >> mrg.q$l
done

mv mrg.q2 mrg.l
mv mrg.q3 mrg.q1000
mv mrg.q4 mrg.q100

for l in 6 7 8 9 10; do
  head -5 $first_file | tail -1 > mrg.x$l
  for f in o.sum.*; do
    head -${l} $f | tail -1;
  done  >> mrg.x$l
done

mv mrg.x6 mrg.s1
mv mrg.x7 mrg.s2
mv mrg.x8 mrg.s3
mv mrg.x9 mrg.s4
mv mrg.x10 mrg.s5

