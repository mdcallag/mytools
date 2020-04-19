nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5
dev=$6

for dc in pg12.7 in80.9 in57.9 in56.9 rx56.5 rx56.6 ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt $dev no $mbd
done


