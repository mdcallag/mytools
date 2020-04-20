nrows=$1
nsecs=$2
bdir=$3
dev=$4
wdop=$5
ldop=$6

for d in pg12.7 in80.9 in57.9 in56.9 rx56.5 ; do
  echo Run $d at $( date ) with $nrows rows and $nsecs secs
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $d no $bdir 1 1 1 1 1 1
  sleep 1200
done
