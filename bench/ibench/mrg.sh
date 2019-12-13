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
