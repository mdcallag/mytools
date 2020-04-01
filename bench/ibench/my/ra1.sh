nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5
# mbd=/media/ephemeral1

for dc in rx56.5b40 ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt xvde no $mbd
done

for dc in rx56.5s2 ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt xvde no $mbd
done

