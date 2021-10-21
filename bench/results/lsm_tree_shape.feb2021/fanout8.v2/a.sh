
r=1000000

m1=$(( 1000 * 1000 ))
m10=$(( $m1 * 10 ))
m100=$(( $m10 * 10 ))
m200=$(( $m10 * 20 ))

for n in $m1 $m10 $m100 $m200 ; do
for k in 275000 ; do
  echo run for $n $k at $( date )
  bash r.sh $n $k $r > o.$n.$k.$r
  mkdir r.$n.$k.$r
  mv o.all o.range* o.point* o.$n.$k.$r r.$n.$k.$r
done
done

