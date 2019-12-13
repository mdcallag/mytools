first_file=$( ls o.sum.* | head -1 )

for l in 2 3 4; do
  head -1 $first_file > mrg.q$l
  for f in o.sum.*; do
    head -${l} $f | tail -1;
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

