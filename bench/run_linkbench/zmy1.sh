nrows=$1
nsecs=$2
bdir=$3
dev=$4
wdop=$5
ldop=$6
heap=$7

shift 7

for ver in fbmy5635 ; do
#for cnf in y9a y9b y9c y9c0 y9c1 y9c2 y13a y13b ; do
for cnf in  y9c ; do
  echo Run $cnf and $ver at $( date ) with $nrows rows and $nsecs secs
  rm $bdir/fbmy56; ln -s $bdir/$ver $bdir/fbmy56
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop rx56.${cnf} no $bdir $heap "$@"
  mv a.rx56.c${cnf} a.${ver}.c${cnf}
done
done

for ver in fbmy8020 ; do
for cnf in y9c ; do
  echo Run $cnf and $ver at $( date ) with $nrows rows and $nsecs secs
  rm $bdir/fbmy80; ln -s $bdir/$ver $bdir/fbmy80
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop rx80.${cnf} no $bdir $heap "$@"
  mv a.rx80.c${cnf} a.${ver}.c${cnf}
done
done

for ver in my5649 ; do
for cnf in y8 ; do
  echo Run $cnf and $ver at $( date ) with $nrows rows and $nsecs secs
  rm $bdir/my56; ln -s $bdir/$ver $bdir/my56
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop in56.${cnf} no $bdir $heap "$@"
  mv a.in56.c${cnf} a.${ver}.c${cnf}
done
done

for ver in my5735 ; do
for cnf in y8 ; do
  echo Run $cnf and $ver at $( date ) with $nrows rows and $nsecs secs
  rm $bdir/my57; ln -s $bdir/$ver $bdir/my57
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop in57.${cnf} no $bdir $heap "$@"
  mv a.in57.c${cnf} a.${ver}.c${cnf}
done
done

for ver in my8027 my8026 my8023 my8022 my8020 ; do
for cnf in y8 ; do
  echo Run $cnf and $ver at $( date ) with $nrows rows and $nsecs secs
  rm $bdir/my80; ln -s $bdir/$ver $bdir/my80
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop in80.${cnf} no $bdir $heap "$@"
  mv a.in80.c${cnf} a.${ver}.c${cnf}
done
done

for ver in pg124 pg134 pg140 ; do
for cnf in x5 ; do
  echo Run $cnf and $ver at $( date ) with $nrows rows and $nsecs secs
  rm $bdir/pg12; ln -s $bdir/$ver $bdir/pg12
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop pg12.${cnf} no $bdir $heap "$@"
  mv a.pg12.c${cnf} a.${ver}.c${cnf}
done
done

