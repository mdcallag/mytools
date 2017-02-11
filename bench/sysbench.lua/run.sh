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

if [[ $testType == "read-only" ]]; then
  testArgs=""
  lua="oltp_read_only.lua"
elif [[ $testType == "read-write" ]]; then
  testArgs=""
  lua="oltp_read_write.lua"
elif [[ $testType == "write-only" ]]; then
  testArgs=""
  lua="oltp_write_only.lua"
elif [[ $testType == "delete" ]]; then
  testArgs=""
  lua="oltp_delete.lua"
elif [[ $testType == "update-nonindex" ]]; then
  testArgs=""
  lua="oltp_update_non_index.lua"
elif [[ $testType == "update-index" ]]; then
  testArgs=""
  lua="oltp_update_index.lua"
elif [[ $testType == "point-query" ]]; then
  testArgs=""
  lua="oltp_point_select.lua"
elif [[ $testType == "insert" ]]; then
  testArgs=""
  lua="oltp_insert.lua"
else
echo Did not recognize testType $testType
exit 1
fi

if [[ $engine == "myisam" ]]; then
  etrx="no"
else
  etrx="yes"
fi

dbcreds="--mysql-user=root --mysql-password=pw --mysql-host=127.0.0.1 --mysql-db=test"
sfx="nr${nr}.range${range}.${engine}.${testType}"

$client -uroot -ppw -e 'reset master' 2> /dev/null

if [[ $setup == 1 ]]; then
echo Setup

topt=""
if [[ $tableoptions != none ]]; then
topt="--mysql-table-options=$tableoptions"
fi

ex="./sysbench --test=$sysbdir/${lua} --db-driver=mysql $dbcreds --mysql-storage-engine=$engine $topt --range-size=$range --table-size=$nr --tables=$ntabs --events=0 --time=$secs prepare"
echo $ex > sb.prepare.$sfx
time $ex >> sb.prepare.$sfx 2>&1

$client -uroot -ppw -e 'reset master' 2> /dev/null
fi

shift 11

rm -f sb.r.trx.$sfx sb.r.qps.$sfx sb.r.rtavg.$sfx sb.r.rtmax.$sfx sb.r.rt95.$sfx

for nt in "$@"; do
echo Run for $nt threads

echo Run for nt $nt at $( date )
killall vmstat
killall iostat
vmstat 10 10000 >& sb.vm.nt${nt}.$sfx &
vmpid=$!
iostat -kx 10 10000 >& sb.io.nt${nt}.$sfx &
iopid=$!

#LD_PRELOAD=/usr/lib64/libjemalloc.so.1
ex="./sysbench --test=$sysbdir/${lua} --db-driver=mysql $dbcreds --mysql-storage-engine=$engine --range-size=$range --table-size=$nr --tables=$ntabs --threads=$nt --events=0 --time=$secs $testArgs run"
echo $ex > sb.o.nt${nt}.${sfx}
$ex >> sb.o.nt${nt}.${sfx} 2>&1

kill $vmpid
kill $iopid

$client -uroot -ppw test -e "show engine $engine status\G" > sb.es.nt${nt}.$sfx
$client -uroot -ppw test -e "show table status\G" > sb.ts.nt${nt}.$sfx
$client -uroot -ppw test -e "show indexes from sbtest1\G" > sb.is.nt${nt}.$sfx
$client -uroot -ppw test -e "show global variables" > sb.gv.nt${nt}.$sfx
$client -uroot -ppw test -e "show global status" > sb.gs.nt${nt}.$sfx
$client -uroot -ppw -e 'reset master' 2> /dev/null

done

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

