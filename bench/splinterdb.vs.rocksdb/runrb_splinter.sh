nlook=$1
devname=$2

dbf=/data/m/db
cachegb=10
nrange=1

rm $dbf
echo 1b x 200 at $( date )
bash rb.sh 25000000 1000000000 $dbf no 200 $cachegb $nlook $nrange $devname | tee bm.all
mkdir res.25m.1b.200byte.${cachegb}g
mv bm.* res.25m.1b.200byte.${cachegb}g

rm $dbf
echo 750m x 200 at $( date )
bash rb.sh 25000000 750000000 $dbf no 200 $cachegb $nlook $nrange $devname | tee bm.all
mkdir res.25m.750m.200byte.${cachegb}g
mv bm.* res.25m.750m.200byte.${cachegb}g

rm $dbf
echo 500m x 200 at $( date )
bash rb.sh 25000000 500000000 $dbf no 200 $cachegb $nlook $nrange $devname | tee bm.all
mkdir res.25m.500m.200byte.${cachegb}g
mv bm.* res.25m.500m.200byte.${cachegb}g

rm $dbf
echo 2b x 100 at $( date )
bash rb.sh 50000000 2000000000 $dbf no 100 $cachegb $nlook $nrange $devname | tee bm.all
mkdir res.50m.2b.100byte.${cachegb}g
mv bm.* res.50m.2b.100byte.${cachegb}g

rm $dbf
echo 1.5b x 100 at $( date )
bash rb.sh 50000000 1500000000 $dbf no 100 $cachegb $nlook $nrange $devname | tee bm.all
mkdir res.50m.1.5b.100byte.${cachegb}g
mv bm.* res.50m.1.5b.100byte.${cachegb}g

rm $dbf
echo 1b x 100 at $( date )
bash rb.sh 50000000 1000000000 $dbf no 100 $cachegb $nlook $nrange $devname | tee bm.all
mkdir res.50m.1b.100byte.${cachegb}g
mv bm.* res.50m.1b.100byte.${cachegb}g

rm $dbf

