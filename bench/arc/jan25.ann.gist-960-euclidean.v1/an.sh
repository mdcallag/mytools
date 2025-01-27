
while read a1 a2 ; do 
  echo
  for efs in 10 20 40 80 120 200 400 800 ; do
    grep PGVector o.plot.3 | grep -v halfvec | grep "m=$a1" | grep "ion=$a2" | grep "search=$efs)" | \
        awk '{ printf "%s %.1f     %s %s %s\n", $4, $5, $1, $2, $3 }'
  done
done < ../args.pg > qr.pgvector
sort -rnk 1,1 qr.pgvector | awk '{ if (NF == 5) { print $0 }}' > qr.pgvector.recall
sort -rnk 2,2 qr.pgvector | awk '{ if (NF == 5) { print $0 }}' > qr.pgvector.qps

while read a1 a2 ; do 
  echo
  for efs in 10 20 40 80 120 200 400 800 ; do
    grep PGVector o.plot.3 | grep halfvec | grep "m=$a1" | grep "ion=$a2" | grep "search=$efs)" | \
        awk '{ printf "%s %.1f     %s %s %s\n", $4, $5, $1, $2, $3 }'
  done
done < ../args.pg > qr.pgvector_halfvec
sort -rnk 1,1 qr.pgvector_halfvec | awk '{ if (NF == 5) { print $0 }}' > qr.pgvector_halfvec.recall
sort -rnk 2,2 qr.pgvector_halfvec | awk '{ if (NF == 5) { print $0 }}' > qr.pgvector_halfvec.qps

for M in 4 5 6 8 12 16 24 32 48 ; do
  echo
  for efs in 10 20 40 80 120 200 400 800 ; do
    pat=$( printf "m=%d" $M )
    grep MariaDB o.plot.3 | grep "$pat" | grep "search=$efs)" | \
        awk '{ printf "%s %.1f     %s %s\n", $3, $4, $1, $2 }'
  done
done > qr.maria
sort -rnk 1,1 qr.maria | awk '{ if (NF == 4) { print $0 }}' > qr.maria.recall
sort -rnk 2,2 qr.maria | awk '{ if (NF == 4) { print $0 }}' > qr.maria.qps

for topN in 1 3; do
for lim in 1.000 0.99 0.98 0.97 0.96 0.95 ; do
  echo "Best QPS with recall >= $lim"
  for inf in qr.pgvector.qps qr.pgvector_halfvec.qps qr.maria.qps ; do
    cat $inf | awk '{ if ($1 >= lim) { print $0 } }' lim=$lim | head -${topN}
    if [[ topN -gt 1 ]]; then echo; fi
  done
  if [[ topN -eq 1 ]]; then echo; fi
done > qr.topN.$topN
done 
