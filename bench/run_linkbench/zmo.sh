nrows=$1
nsecs=$2
mbd=$3

for d in mo40.5 mo42.5 mo44.5 ; do
  echo Run $d at $( date ) for $nrows rows and $nsecs secs
  bash rall.sh $nrows nvme0n1 1 $nsecs 127.0.0.1 1 $d no $mbd 1 1 1 1 1 1 1 1 1 1 1 1 
done
