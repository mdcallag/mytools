nrows=$1
nsecs=$2
bdir=$3
dev=$4
wdop=$5
ldop=$6

for d in in80.9 pg12.7 rx56.5 rx56.6 ; do
  echo Run $d at $( date ) with $nrows rows and $nsecs secs
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $d no $bdir 1 1 1 1 1 1
done
