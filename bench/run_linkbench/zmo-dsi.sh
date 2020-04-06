nrows=$1
nsecs=$2
bdir=$3
dev=$4
wdop=$5
ldop=$6

for ver in mo4016 mo4017 ; do
  dcnf=mo40.5b40
  echo Run $dcnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo40
  ln -s $bdir/$ver $bdir/mo40
  #bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $dcnf no $bdir 16 16 16 16 16 16
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $dcnf no $bdir 16 
  mv a.mo40.c5 a.${ver}.c5
done

for ver in mo421 mo423 mo425 ; do
  dcnf=mo42.5b40
  echo Run $dcnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo42
  ln -s $bdir/$ver $bdir/mo42
  #bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $dcnf no $bdir 16 16 16 16 16 16
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $dcnf no $bdir 16 
  mv a.mo42.c5 a.${ver}.c5
done

for ver in mo44pre ; do
  dcnf=mo44.5b40
  echo Run $dcnf and $ver at $( date ) for $nrows rows and $nsecs secs
  rm $bdir/mo44
  ln -s $bdir/$ver $bdir/mo44
  #bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $dcnf no $bdir 16 16 16 16 16 16
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $dcnf no $bdir 16 
  mv a.mo44.c5 a.${ver}.c5
done

