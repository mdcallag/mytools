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
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo44.${cnf} no $bdir 16 16 16 16 16 16
  mv a.mo44.c${cnf} a.${ver}.c${cnf}
done

for ver in mo421 mo423 mo425 ; do
  cnf=5
  echo Run $cnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo42
  ln -s $bdir/$ver $bdir/mo42
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo42.${cnf} no $bdir 16 16 16 16 16 16
  mv a.mo42.c${cnf} a.${ver}.c${cnf}
done

for ver in mo4016 mo4017 mo4018 ; do
  cnf=5
  echo Run $cnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo40
  ln -s $bdir/$ver $bdir/mo40
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo40.${cnf} no $bdir 16 16 16 16 16 16
  mv a.mo40.c${cnf} a.${ver}.c${cnf}
done

for ver in mo425 ; do
  cnf=6
  echo Run $cnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo42
  ln -s $bdir/$ver $bdir/mo42
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo42.${cnf} no $bdir 16 16 16 16 16 16
  mv a.mo42.c${cnf} a.${ver}.c${cnf}
done


