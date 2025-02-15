
plotf=$1

for M in 4 5 6 8 12 16 24 32 48 ; do
  echo
  for efs in 10 20 30 40 80 120 200 400 800 ; do
    pat=$( printf "m=%d" $M )
    grep MariaDB $plotf | grep "$pat" | grep "search=$efs)" | \
        awk '{ printf "%s %.1f     %s %s\n", $3, $4, $1, $2 }'
  done
done > qr.maria
sort -rnk 1,1 qr.maria | awk '{ if (NF == 4) { print $0 }}' > qr.maria.recall
sort -rnk 2,2 qr.maria | awk '{ if (NF == 4) { print $0 }}' > qr.maria.qps

