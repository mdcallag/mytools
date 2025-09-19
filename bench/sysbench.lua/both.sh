tag=$1
dev=$2
p2=$3

bash r.sh 1 50000000 600 900 $dev 1 1 1
mkdir res.dop1.$tag
mv x.* res.dop1.$tag

bash r.sh 8 10000000 600 900 $dev 1 1 $p2
mkdir res.dop${p2}.$tag
mv x.* res.dop${p2}.$tag
