

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

    dbdir=/data/m/rx
    bgflush=4
    bgcomp=8
    subcomp=2
    fillrand=no
    block_align=false

    #rm -rf $dbdir; mkdir $dbdir
    outf="out.runit.l.valsz${valsz}.dir${odirect}.nmkeys${nmkeys}.blob${blob}.part${partition}"
    bash l.sh $dbdir $bgflush $bgcomp $subcomp $nmkeys $fillrand $block_align $valsz $odirect $blob $partition | tee $outf

    for cmb in 0 2048 4096 8192 16384 24576 32768 ; do
      outf="out.runit.q.cmb${cmb}.valsz${valsz}.dir${odirect}.nmkeys${nmkeys}.blob${blob}.part${partition}"
      bash runit.sh $dbdir $bgflush $bgcomp $subcomp $nsecs $cmb $nmkeys $devname $fillrand $block_align $valsz $odirect $blob $partition "$@"  | tee -a $outf
    done
  done
done



