nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5

#mbd=/media/ephemeral1

dc=mo42.5b40

for ver in mo425 mo423 mo421 ; do
  rm $mbd/mo42
  ln -s $mbd/$ver $mbd/mo42
  mkdir perf.${ver}
  bash rall1.sh $dc $dop $nsecs $mbd/ibench/perf.${ver} $nr $nrt xvde no $mbd
done

