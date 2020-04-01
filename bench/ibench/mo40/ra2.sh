nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5

#for dc in pg12.7b in80.9b rx56.5b ; do
for dc in pg12.7b ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt xvde no $mbd
done

