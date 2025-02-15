
plotf=$1

while read a1 a2 ; do 
  echo
  for efs in 10 20 30 40 80 120 200 300 400 ; do
    grep PGVector $plotf | grep -v halfvec | grep "m=$a1" | grep "ion=$a2" | grep "search=$efs)" | \
        awk '{ printf "%s %.1f     %s %s %s\n", $4, $5, $1, $2, $3 }'
  done
done < ../args.pg > qr.pgvector
sort -rnk 1,1 qr.pgvector | awk '{ if (NF == 5) { print $0 }}' > qr.pgvector.recall
sort -rnk 2,2 qr.pgvector | awk '{ if (NF == 5) { print $0 }}' > qr.pgvector.qps

while read a1 a2 ; do 
  echo
  for efs in 10 20 30 40 80 120 200 300 400 ; do
    grep PGVector $plotf | grep halfvec | grep "m=$a1" | grep "ion=$a2" | grep "search=$efs)" | \
        awk '{ printf "%s %.1f     %s %s %s\n", $4, $5, $1, $2, $3 }'
  done
done < ../args.pg > qr.pgvector_halfvec
sort -rnk 1,1 qr.pgvector_halfvec | awk '{ if (NF == 5) { print $0 }}' > qr.pgvector_halfvec.recall
sort -rnk 2,2 qr.pgvector_halfvec | awk '{ if (NF == 5) { print $0 }}' > qr.pgvector_halfvec.qps

