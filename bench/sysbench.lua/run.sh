ntabs=$1
nr=$2
secs=$3
engine=$4
setup=$5
cleanup=$6
testType=$7
range=$8
client=$9
tableoptions=${10}
sysbdir=${11}
ddir=${12}
dname=${13}

testArgs="--rand-type=uniform"

if [[ $testType == "read-only" || $testType == "read-only.pre" ]]; then
  lua="oltp_read_only.lua"
elif [[ $testType == "read-write" ]]; then
  lua="oltp_read_write.lua"
elif [[ $testType == "write-only" ]]; then
  lua="oltp_write_only.lua"
elif [[ $testType == "delete" ]]; then
  lua="oltp_delete.lua"
elif [[ $testType == "update-inlist" ]]; then
  lua="oltp_inlist_update.lua"
elif [[ $testType == "update-one" ]]; then
  lua="oltp_update_non_index.lua"
  nr=1
elif [[ $testType == "update-nonindex" ]]; then
  lua="oltp_update_non_index.lua"
elif [[ $testType == "update-special" ]]; then
  testArgs="--rand-type=special"
  lua="oltp_update_non_index.lua"
elif [[ $testType == "update-index" ]]; then
  lua="oltp_update_index.lua"
elif [[ $testType == "point-query" || $testType == "point-query.pre" ]]; then
  lua="oltp_point_select.lua"
elif [[ $testType == "random-points" || $testType == "random-points.pre" ]]; then
  testArgs="--rand-type=uniform --random-points=$range"
  lua="oltp_inlist_select.lua"
elif [[ $testType == "hot-points" ]]; then
  testArgs="--rand-type=uniform --random-points=$range --hot-points"
  lua="oltp_inlist_select.lua"
elif [[ $testType == "insert" ]]; then
  lua="oltp_insert.lua"
elif [[ $testType == "full-scan.pre" || $testType == "full-scan.post" ]]; then
  lua=none
else
echo Did not recognize testType $testType
exit 1
fi

if [[ $engine == "myisam" ]]; then
  testArgs="$testArgs --skip-trx"
fi

dbcreds="--mysql-user=root --mysql-password=pw --mysql-host=127.0.0.1 --mysql-db=test"
sfx="nr${nr}.range${range}.${engine}.${testType}"

hp=127.0.0.1
$client -uroot -ppw -h$hp -e 'reset master' 2> /dev/null

# --- Setup ---

if [[ $setup == 1 ]]; then
echo Setup

topt=""
if [[ $tableoptions != none ]]; then
topt="--mysql-table-options=$tableoptions"
fi

ex="$sysbdir/bin/sysbench --db-driver=mysql $dbcreds --mysql-storage-engine=$engine $topt --range-size=$range --table-size=$nr --tables=$ntabs --events=0 --time=$secs $sysbdir/share/sysbench/$lua prepare"
echo $ex > sb.prepare.$sfx
time $ex >> sb.prepare.$sfx 2>&1

$client -uroot -ppw -h$hp -e 'reset master' 2> /dev/null
fi

shift 13

samp=2

# --- Do full scan without sysbench and then finish ---
if [[ $testType == "full-scan.pre" || $testType == "full-scan.post" ]]; then
  #for nt in "$@"; do
  #  maxconcur=$nt
  #done
  #if [[ $ntabs -lt $maxconcur ]]; then maxconcur=$ntabs; fi

  killall vmstat
  killall iostat
  vmstat $samp 10000 >& sb.vm.nt${ntabs}.$sfx &
  vmpid=$!
  iostat -kx $samp 10000 >& sb.io.nt${ntabs}.$sfx &
  iopid=$!

  for n in $( seq 1 $ntabs ); do
    $client -uroot -ppw -h$hp test -e "select count(*) from sbtest$n where length(pad) < 0" > sb.o.nt$n.$sfx &
    pids[${n}]=$!
  done
  start_secs=$( date +'%s' )

  for n in $( seq 1 $ntabs ); do
    echo Wait for ${pids[${n}]} at $( date )
    wait ${pids[${n}]}
  done
  stop_secs=$( date +'%s' )
  tot_secs=$(( $stop_secs - $start_secs ))
  echo Scan seconds is $tot_secs for $ntabs tables > sb.r.qps.$sfx

  kill $vmpid
  kill $iopid
  bash an.sh sb.io.nt${ntabs}.$sfx sb.vm.nt${ntabs}.$sfx $samp $dname $nr > sb.met.nt${ntabs}.$sfx

  for n in $( seq 1 $ntabs ); do
    $client -uroot -ppw -h$hp test -e "explain select count(*) from sbtest$n where length(pad) < 0" >> sb.o.nt$n.$sfx &
    pids[${n}]=$!
  done

  du -hs $ddir > sb.sz.$sfx
  echo "with apparent size " >> sb.sz.$sfx
  du -hs --apparent-size $ddir >> sb.sz.$sfx
  echo "all" >> sb.sz.$sfx
  du -hs ${ddir}/* >> sb.sz.$sfx
  exit 0
fi

# --- Otherwise run sysbench tests ---

rm -f sb.r.trx.$sfx sb.r.qps.$sfx sb.r.rtavg.$sfx sb.r.rtmax.$sfx sb.r.rt95.$sfx

for nt in "$@"; do
echo Run for $nt threads

echo Run for nt $nt at $( date )
killall vmstat
killall iostat
vmstat $samp 10000 >& sb.vm.nt${nt}.$sfx &
vmpid=$!
iostat -kx $samp 10000 >& sb.io.nt${nt}.$sfx &
iopid=$!

ex="$sysbdir/bin/sysbench --db-driver=mysql $dbcreds --mysql-storage-engine=$engine --range-size=$range --table-size=$nr --tables=$ntabs --threads=$nt --events=0 --time=$secs $testArgs $sysbdir/share/sysbench/$lua run"
echo $ex > sb.o.nt${nt}.${sfx}
$ex >> sb.o.nt${nt}.${sfx} 2>&1

kill $vmpid
kill $iopid
queries=$( grep queries: sb.o.nt${nt}.$sfx | awk '{ print $2 }' )
bash an.sh sb.io.nt${nt}.$sfx sb.vm.nt${nt}.$sfx $samp $dname $queries > sb.met.nt${nt}.$sfx

$client -uroot -ppw -h$hp test -e "show engine $engine status\G" > sb.es.nt${nt}.$sfx
$client -uroot -ppw -h$hp test -e "show table status\G" > sb.ts.nt${nt}.$sfx
$client -uroot -ppw -h$hp test -e "show indexes from sbtest1\G" > sb.is.nt${nt}.$sfx
$client -uroot -ppw -h$hp test -e "show global variables" > sb.gv.nt${nt}.$sfx
$client -uroot -ppw -h$hp test -e "show global status\G" > sb.gs.nt${nt}.$sfx
$client -uroot -ppw -h$hp -e 'reset master' 2> /dev/null

done

du -hs $ddir > sb.sz.$sfx
echo "with apparent size " >> sb.sz.$sfx
du -hs --apparent-size $ddir >> sb.sz.$sfx
echo "all" >> sb.sz.$sfx
du -hs ${ddir}/* >> sb.sz.$sfx

if [[ $cleanup == 1 ]]; then
echo Cleanup
./sysbench --test=$sysbdir/${lua} --db-driver=mysql $dbcreds --mysql-storage-engine=$engine --table-size=$nr --tables=$ntabs cleanup
fi

for nt in "$@"; do
  grep transactions: sb.o.nt${nt}.$sfx | awk '{ print $3 }' | tr '(' ' ' | awk '{ printf "%.0f\t", $1 }' 
done > sb.r.trx.$sfx
echo "$engine $testType range=$range" >> sb.r.trx.$sfx

for nt in "$@"; do
  grep queries: sb.o.nt${nt}.$sfx | awk '{ print $3 }' | tr '(' ' ' | awk '{ printf "%.0f\t", $1 }' 
done > sb.r.qps.$sfx
echo "$engine $testType range=$range" >> sb.r.qps.$sfx

for nt in "$@"; do
  grep avg: sb.o.nt${nt}.$sfx | awk '{ print $2 }' | awk '{ printf "%s\t", $1 }' 
done > sb.r.rtavg.$sfx
echo "$engine $testType range=$range" >> sb.r.rtavg.$sfx

for nt in "$@"; do
  grep max: sb.o.nt${nt}.$sfx | awk '{ print $2 }' | awk '{ printf "%s\t", $1 }' 
done > sb.r.rtmax.$sfx
echo "$engine $testType range=$range" >> sb.r.rtmax.$sfx

for nt in "$@"; do
  grep percentile: sb.o.nt${nt}.$sfx | awk '{ print $3 }' | awk '{ printf "%s\t", $1 }' 
done > sb.r.rt95.$sfx
echo "$engine $testType range=$range" >> sb.r.rt95.$sfx

