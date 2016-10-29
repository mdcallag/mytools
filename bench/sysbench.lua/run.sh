ntabs=$1
nr=$2
secs=$3
engine=$4
setup=$5
cleanup=$6
testType=$7
range=$8
client=$9

if [[ $testType == "read-only" ]]; then
  testArgs="--oltp-read-only=on"
  lua="oltp.lua"
elif [[ $testType == "read-write" ]]; then
  testArgs="--oltp-read-only=off --oltp-index-updates=1 --oltp-non-index-updates=1 --oltp-delete-inserts=1"
  lua="oltp.lua"
elif [[ $testType == "update-nonindex" ]]; then
  testArgs="--oltp-write-only=on --oltp-index-updates=0 --oltp-non-index-updates=1 --oltp-delete-inserts=0"
  lua="oltp.lua"
elif [[ $testType == "update-index" ]]; then
  testArgs="--oltp-write-only=on --oltp-index-updates=1 --oltp-non-index-updates=0 --oltp-delete-inserts=0"
  lua="oltp.lua"
elif [[ $testType == "point-query" ]]; then
  testArgs="--oltp-read-only=on --oltp-point-selects=1 --oltp-range-selects=off --oltp-skip-trx=on"
  lua="oltp.lua"
elif [[ $testType == "select" ]]; then
  testArgs=""
  lua="select.lua"
elif [[ $testType == "insert" ]]; then
  testArgs=""
  lua="insert.lua"
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

if [[ $setup == 1 ]]; then
echo Setup
time ./sysbench --test=tests/db/oltp.lua --db-driver=mysql --mysql-engine-trx=$etrx $dbcreds --mysql-table-engine=$engine --oltp-range-size=$range --oltp-table-size=$nr --oltp-tables-count=$ntabs --max-requests=0 --max-time=$secs prepare >& sb.prepare.$sfx
fi

shift 9

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
echo sysbench --test=tests/db/${lua} --db-driver=mysql --mysql-engine-trx=$etrx $dbcreds --mysql-table-engine=$engine --oltp-range-size=$range --oltp-table-size=$nr --oltp-tables-count=$ntabs --num-threads=$nt --max-requests=0 --max-time=$secs $testArgs run > sb.o.nt${nt}.${sfx}
./sysbench --test=tests/db/${lua} --db-driver=mysql --mysql-engine-trx=$etrx $dbcreds --mysql-table-engine=$engine --oltp-range-size=$range --oltp-table-size=$nr --oltp-tables-count=$ntabs --num-threads=$nt --max-requests=0 --max-time=$secs $testArgs run >> sb.o.nt${nt}.${sfx} 2>&1

kill $vmpid
kill $iopid

$client -uroot -ppw test -e "show engine $engine status\G" > sb.es.nt${nt}.$sfx
$client -uroot -ppw test -e "show table status" > sb.ts.nt${nt}.$sfx

done

if [[ $cleanup == 1 ]]; then
echo Cleanup
./sysbench --test=tests/db/oltp.lua --db-driver=mysql --mysql-engine-trx=$etrx $dbcreds --mysql-table-engine=$engine --oltp-table-size=$nr --oltp-tables-count=$ntabs cleanup
fi

for nt in "$@"; do
  grep transactions: sb.o.nt${nt}.$sfx | awk '{ print $3 }' | tr '(' ' ' | awk '{ printf "%.0f\t", $1 }' 
done > sb.r.trx.$sfx
echo "$engine $testType range=$range" >> sb.r.trx.$sfx

for nt in "$@"; do
  grep read\/write sb.o.nt${nt}.$sfx | awk '{ print $4 }' | tr '(' ' ' | awk '{ printf "%.0f\t", $1 }' 
done > sb.r.qps.$sfx
echo "$engine $testType range=$range" >> sb.r.qps.$sfx

for nt in "$@"; do
  grep avg: sb.o.nt${nt}.$sfx | awk '{ print $2 }' | tr 'ms' ' ' | awk '{ printf "%s\t", $1 }' 
done > sb.r.rtavg.$sfx
echo "$engine $testType range=$range" >> sb.r.rtavg.$sfx

for nt in "$@"; do
  grep max: sb.o.nt${nt}.$sfx | awk '{ print $2 }' | tr 'ms' ' ' | awk '{ printf "%s\t", $1 }' 
done > sb.r.rtmax.$sfx
echo "$engine $testType range=$range" >> sb.r.rtmax.$sfx

for nt in "$@"; do
  grep percentile: sb.o.nt${nt}.$sfx | awk '{ print $4 }' | tr 'ms' ' ' | awk '{ printf "%s\t", $1 }' 
done > sb.r.rt95.$sfx
echo "$engine $testType range=$range" >> sb.r.rt95.$sfx

