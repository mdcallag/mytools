nr1=$1
nr2=$2
dbfile=$3
usenuma=$4
rowlen=$5
cachegb=$6
nlook=$7
nrange=$8
devname=$9

keylen=20

opts="\
--max-async-inflight 0 \
--num-insert-threads 1 --num-lookup-threads $nlook --num-range-lookup-threads $nrange \
--db-capacity-gib 250 \
--key-size $keylen --data-size $rowlen \
--db-location $dbfile \
 --cache-capacity-gib $cachegb \
"

killall vmstat
killall iostat

function start_stats {
  pfx=$1

  # The xpid variables are global and read elsewhere
  while :; do date; ps aux | grep driver_test | grep -v grep | tail -1; sleep 10; done >& $pfx.ps &
  pspid=$!

  vmstat 1 >& $pfx.vm &
  vpid=$!

  iostat -y -mx 1 >& $pfx.io &
  ipid=$!

  echo forked $vpid and $ipid and $pspid
}

function stop_stats {
  pfx=$1
  nrows=$2

  # SplinterDB doesn't force data to disk. Do that here to get accurate write-amp estimate via iostat
  sync; sync; sync; sleep 60

  kill $vpid
  kill $ipid
  kill $pspid
  echo killed $vpid and $ipid and $pspid

  ls -lh $dbfile >> $pfx.res
  ls -lh $dbfile 
  grep "\/second" $pfx.res | grep -v megabytes

  echo -e "count\tIOwGB\tIOwMB/s\tUwGB\tWamp"
  gbwritten=$( echo $rowlen $keylen $nrows | awk '{ printf "%.1f", (($1 + $2) * $3) / (1024*1024*1024.0) }' )
  grep $devname $pfx.io | awk '{ c += 1; wmb += $9 } END { printf "%s\t%.1f\t%.1f\t%.1f\t%.1f\n", c, wmb/1024.0, wmb / c, gbw, (wmb/1024.0)/gbw }' gbw=$gbwritten
}

if [ $usenuma == "yes" ]; then numactl="numactl --interleave=all" ; else numactl="" ; fi

rm $dbfile
echo Cached at $( date )
start_stats bm.cached
echo "build/release/bin/driver_test splinter_test --perf $opts --num-inserts $nr1" > bm.cached.res
build/release/bin/driver_test splinter_test --perf $opts --num-inserts $nr1 >> bm.cached.res 2>&1
stop_stats bm.cached $nr1

#valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose --log-file=bm.vg \
#valgrind --tool=massif \
#    build/release/bin/driver_test splinter_test --perf $opts --num-inserts $nr1 

rm $dbfile
echo IO-bound at $( date )
start_stats bm.iobuf
echo "build/release/bin/driver_test splinter_test --perf $opts --num-inserts $nr2" > bm.iobuf.res
build/release/bin/driver_test splinter_test --perf $opts --num-inserts $nr2 >> bm.iobuf.res 2>&1
stop_stats bm.iobuf $nr2
