nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5

for dc in in80.9b40 rx56.5b40 ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt xvde no $mbd
done

