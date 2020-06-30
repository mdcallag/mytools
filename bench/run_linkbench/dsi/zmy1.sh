nrows=$1
nsecs=$2
bdir=$3
dev=$4
wdop=$5
ldop=$6

shift 7

for ver in my8018 my8020 ; do
for cnf in 9b40s1 ; do
  echo Run $cnf and $ver at $( date ) with $nrows rows and $nsecs secs
  rm $bdir/my80; ln -s $bdir/$ver $bdir/my80
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop in80.${cnf} no $bdir $heap "$@"
  mv a.in80.c${cnf} a.${ver}.c${cnf}
done
done

for ver in pg123 pg120 ; do
for cnf in 7b40s1 ; do
  echo Run $cnf and $ver at $( date ) with $nrows rows and $nsecs secs
  rm $bdir/pg12; ln -s $bdir/$ver $bdir/pg12
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop pg12.${cnf} no $bdir $heap "$@"
  mv a.pg12.c${cnf} a.${ver}.c${cnf}
done
done

for d in rx56.5b40s1 ; do
  echo Run $d at $( date ) with $nrows rows and $nsecs secs
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $d no $bdir $heap "$@"
done
