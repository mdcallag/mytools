

#nmkeys=800
nmkeys=$1
#nsecs=600
nsecs=$2
#odirect=no
odirect=$3
# yes to use partitioned index and filters
partition=$4
devname=$5

shift 5

# 1 5 10 20 30 40

for blob in no yes ; do
for valsz in 3000 4096 ; do
for cmb in 0 2048 4096 8192 16384 24576 32768 ; do
  bash runit.sh /data/m/rx 4 8 2 $nsecs $cmb $nmkeys $devname no false $valsz $odirect $blob $partition "$@"  | tee out.runit.cmb${cmb}.valsz${valsz}.dir${odirect}.nmkeys${nmkeys}.blob${blob}.part${partition}
done
done
done
