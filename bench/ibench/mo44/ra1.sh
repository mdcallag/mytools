nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5
# mbd=/media/ephemeral1

#for dc in pg12.7b in80.9b rx56.5b ; do
for dc in pg12.7b ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt xvde no $mbd
done

#for dc in pg12.7s in80.9s rx56.5s ; do
for dc in pg12.7s ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt xvde no $mbd
done


