nrows=$1
nsecs=$2
bdir=$3
dev=$4
wdop=$5
ldop=$6

for ver in mo44pre mo440rc0 mo440rc1 ; do
  cnf=5
  echo Run $cnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo44
  ln -s $bdir/$ver $bdir/mo44
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo44.${cnf} no $bdir 1 1 1 1 1 1
  mv a.mo44.c${cnf} a.${ver}.c${cnf}
  echo Sleep 20 minutes to let HW rest
  sleep 1200
done

for ver in mo426 mo425 mo424 mo423 mo422 mo421 ; do
  cnf=5
  echo Run $cnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo42
  ln -s $bdir/$ver $bdir/mo42
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo42.${cnf} no $bdir 1 1 1 1 1 1
  mv a.mo42.c${cnf} a.${ver}.c${cnf}
  echo Sleep 20 minutes to let HW rest
  sleep 1200
done

for ver in mo4018 mo4017 mo4016 ; do
  cnf=5
  echo Run $cnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo40
  ln -s $bdir/$ver $bdir/mo40
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo40.${cnf} no $bdir 1 1 1 1 1 1
  mv a.mo40.c${cnf} a.${ver}.c${cnf}
  echo Sleep 20 minutes to let HW rest
  sleep 1200
done

