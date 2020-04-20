nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5
dev=$6
rdir=$7

for dc in pg12.7 in80.9 in57.9 in56.9 rx56.5 rx56.6 ; do
  bash rall1.sh $dc $dop $nsecs $rdir $nr $nrt $dev no $mbd
  echo Sleep 20 minutes to let HW rest
  sleep 1200
done


