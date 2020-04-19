nrows=$1
nsecs=$2
bdir=$3
dev=$4
wdop=$5
ldop=$6

for d in in80.9b40 pg12.7b40 rx56.5b40 rx56.6b40 ; do
  echo Run $d at $( date ) with $nrows rows and $nsecs secs
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 $ldop $d no $bdir 16 16 16 16 16 16
done
