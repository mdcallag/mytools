nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5

#mbd=/media/ephemeral1

dc=mo40.5b40

for ver in mo4017 mo4016 ; do
  rm $mbd/mo40
  ln -s $mbd/$ver $mbd/mo40
  mkdir perf.${ver}
  bash rall1.sh $dc $dop $nsecs $mbd/ibench/perf.${ver} $nr $nrt xvde no $mbd
done
