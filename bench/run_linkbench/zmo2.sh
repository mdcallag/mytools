nrows=$1
nsecs=$2
mbd=$3

for ver in mo44pre mo440rc0 ; do
  dcnf=mo44.5
  echo Run $dcnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm ~/d/mo44
  ln -s ~/d/$ver ~/d/mo44
  bash rall.sh $nrows nvme0n1 1 $nsecs 127.0.0.1 1 $dcnf no $mbd 1 1 1 1 1 1
  mv a.mo44.c5 a.${ver}.c5
done

for ver in mo425 mo424 mo423 mo422 mo421 ; do
  dcnf=mo42.5
  echo Run $dcnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm ~/d/mo42
  ln -s ~/d/$ver ~/d/mo42
  bash rall.sh $nrows nvme0n1 1 $nsecs 127.0.0.1 1 $dcnf no $mbd 1 1 1 1 1 1
  mv a.mo42.c5 a.${ver}.c5
done

for ver in mo4017 mo4016 ; do
  dcnf=mo40.5
  echo Run $dcnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm ~/d/mo40
  ln -s ~/d/$ver ~/d/mo40
  bash rall.sh $nrows nvme0n1 1 $nsecs 127.0.0.1 1 $dcnf no $mbd 1 1 1 1 1 1
  mv a.mo40.c5 a.${ver}.c5
done
