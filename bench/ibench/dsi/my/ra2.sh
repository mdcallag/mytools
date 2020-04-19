nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5
dev=$6

for dc in pg12.7b40 in80.9b40 rx56.5b40 rx56.6b40 ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt $dev no $mbd
done


