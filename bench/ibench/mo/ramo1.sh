nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5

#mbd=/media/ephemeral1

dc=mo40.6b20
for ver in mo4017 mo4016 ; do
  rm $mbd/mo40
  ln -s $mbd/$ver $mbd/mo40
  mkdir perf.${ver}
  bash rall1.sh $dc $dop $nsecs $mbd/ibench/perf.${ver} $nr $nrt xvde no $mbd
done

dc=mo42.6b20
for ver in mo425 mo423 mo421 ; do
  rm $mbd/mo42
  ln -s $mbd/$ver $mbd/mo42
  mkdir perf.${ver}
  bash rall1.sh $dc $dop $nsecs $mbd/ibench/perf.${ver} $nr $nrt xvde no $mbd
done

dc=mo44.6b20
for ver in mo44pre mo440rc0 ; do
  rm $mbd/mo44
  ln -s $mbd/$ver $mbd/mo44
  mkdir perf.${ver}
  bash rall1.sh $dc $dop $nsecs $mbd/ibench/perf.${ver} $nr $nrt xvde no $mbd
done

