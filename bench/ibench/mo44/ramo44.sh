nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5

#mbd=/media/ephemeral1

dc=mo44.5b40

for ver in mo44pre mo44dhsp mo44 ; do
  rm $mbd/mo44
  ln -s $mbd/$ver $mbd/mo44
  mkdir perf.${ver}
  bash rall1.sh $dc $dop $nsecs $mbd/ibench/perf.${ver} $nr $nrt xvde no $mbd
done
