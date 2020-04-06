nrows=$1
nsecs=$2
dev=$3
wdop=$4
bdir=$5

for d in in80.9b40s1 pg12.7b40s1 rx56.5b40s1 rx56.6b40s1 ; do
  echo Run $d at $( date ) with $nrows rows and $nsecs secs
  #bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 1 $d no $bdir 16 16 16 16 16 16 16 16
  bash rall.sh $nrows $dev $wdop $nsecs 127.0.0.1 1 $d no $bdir 16
done
