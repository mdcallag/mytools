
r=1000000

# for n in 750000 1000000 7500000 10000000 75000000 100000000 ; do
# for k in 330000 320000 310000 275000 250000 225000 200000 100000 ; do

m1=$(( 1000 * 1000 ))
m10=$(( $m1 * 10 ))
m100=$(( $m10 * 10 ))
m1000=$(( $m100 * 10 ))

for n in $m1 $m10 $m100 ; do
for k in 275000 ; do
  echo run for $n $k at $( date )
  bash r.sh $n $k $r > o.$n.$k.$r
  mkdir r.$n.$k.$r
  mv o.all o.range* o.point* o.$n.$k.$r r.$n.$k.$r
done
done

