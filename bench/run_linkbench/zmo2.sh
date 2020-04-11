nrows=$1
nsecs=$2
mbd=$3

for ver in mo4016 mo4017 ; do
  dcnf=mo40.5
  echo Run $dcnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm ~/d/mo40
  ln -s ~/d/$ver ~/d/mo40
  bash rall.sh $nrows nvme0n1 1 $nsecs 127.0.0.1 1 $dcnf no $mbd 1 1 1 1 1 1 1 1 1 1 1 1 
  mv a.mo40.c5 a.${ver}.c5
done

for ver in mo421 mo422 mo423 mo424 mo425 ; do
  dcnf=mo42.5
  echo Run $dcnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm ~/d/mo42
  ln -s ~/d/$ver ~/d/mo42
  bash rall.sh $nrows nvme0n1 1 $nsecs 127.0.0.1 1 $dcnf no $mbd 1 1 1 1 1 1 1 1 1 1 1 1 
  mv a.mo42.c5 a.${ver}.c5
done

for ver in mo44pre mo44dh.0315 ; do
  dcnf=mo44.5
  echo Run $dcnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm ~/d/mo44
  ln -s ~/d/$ver ~/d/mo44
  bash rall.sh $nrows nvme0n1 1 $nsecs 127.0.0.1 1 $dcnf no $mbd 1 1 1 1 1 1 1 1 1 1 1 1 
  mv a.mo44.c5 a.${ver}.c5
done

