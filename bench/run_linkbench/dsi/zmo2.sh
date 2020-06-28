nrows=$1
nsecs=$2
bdir=$3
dev=$4
wdop=$5
ldop=$6

for cnf in 5b40 6b40 7b40 ; do
for ver in mo440rc11 mo440rc10 mo440rc9 ; do
  echo Run $cnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo44
  ln -s $bdir/$ver $bdir/mo44
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo44.${cnf} no $bdir 1 4 8 12 16 16
  mv a.mo44.c${cnf} a.${ver}.c${cnf}
done
done

for cnf in 5b40 6b40 7b40 ; do
for ver in mo428 mo427 mo426 mo425 mo423 mo422 mo421 ; do
  echo Run $cnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo42
  ln -s $bdir/$ver $bdir/mo42
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo42.${cnf} no $bdir 1 4 8 12 16 16
  mv a.mo42.c${cnf} a.${ver}.c${cnf}
done
done

for cnf in 5b40 6b40 7b40 ; do
for ver in mo4019 mo4018 mo4017 mo4016 ; do
  echo Run $cnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo40
  ln -s $bdir/$ver $bdir/mo40
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop mo40.${cnf} no $bdir 1 4 8 12 16 16
  mv a.mo40.c${cnf} a.${ver}.c${cnf}
done
done

