

#nmkeys=800
nmkeys=$1
#nsecs=600
nsecs=$2
#odirect=no
odirect=$3

for blob in no yes ; do
for valsz in 3000 4096 ; do
for cmb in 0 2048 ; do
  bash runit.sh /data/m/rx 4 8 2 $nsecs $cmb $nmkeys md2 no false $valsz $odirect $blob 1 2 5 10 20 30 40 60 80 | tee out.runit.cmb${cmb}.valsz${valsz}.dir${odirect}.nmkeys${nmkeys}.blob${blob}
done
done
done
