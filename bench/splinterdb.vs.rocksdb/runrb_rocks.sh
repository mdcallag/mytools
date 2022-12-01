valsz=$1
uf=$2
cachegb=$3
nsecs=$4
devname=$5

dbdir=/data/m/rx

if [ $valsz == 100 ]; then
  nr1=50000000   ; nr1nm=50m
  nr2=2000000000 ; nr2nm=2b
  nr3=1000000000 ; nr3nm=1b
  nr4=1500000000 ; nr4nm=1.5b
elif [ $valsz == 200 ]; then
  nr1=25000000   ; nr1nm=25m
  nr2=1000000000 ; nr2nm=1b
  nr3=500000000  ; nr3nm=500m
  nr4=750000000 ; nr4nm=750m
else
  echo valsz must be 100 or 200
  exit 1
fi

for comp in lc uc; do
echo $nr1nm at $( date ) for $comp
bash rb.sh $nr1 $dbdir no $valsz $cachegb 0 $uf $comp $nsecs $devname | tee bm.all
mkdir res.$nr1nm.$comp.${valsz}byte.${cachegb}g
mv bm.* res.$nr1nm.$comp.${valsz}byte.${cachegb}g
done

comp=lc
echo $nr2nm at $( date ) for $comp
bash rb.sh $nr2 $dbdir no $valsz $cachegb 0 $uf $comp $nsecs $devname | tee bm.all
mkdir res.$nr2nm.$comp.${valsz}byte.${cachegb}g
mv bm.* res.$nr2nm.$comp.${valsz}byte.${cachegb}g

for comp in lc uc; do
echo $nr3nm at $( date ) for $c
bash rb.sh $nr3 $dbdir no $valsz $cachegb 0 $uf $comp $nsecs $devname | tee bm.all
mkdir res.$nr3nm.$comp.${valsz}byte.${cachegb}g
mv bm.* res.$nr3nm.$comp.${valsz}byte.${cachegb}g
done

for comp in lc uc; do
echo $nr4nm at $( date ) for $comp
bash rb.sh $nr4 $dbdir no $valsz $cachegb 0 $uf $comp $nsecs $devname | tee bm.all
mkdir res.$nr4nm.$comp.${valsz}byte.${cachegb}g
mv bm.* res.$nr4nm.$comp.${valsz}byte.${cachegb}g
done

