ntabs=$1
nrows=$2
readsecs=$3
writesecs=$4
insertsecs=$5
engine=$6
setup=$7
cleanup=$8
client=$9
tableoptions=${10}
sysbdir=${11}
ddir=${12}
dname=${13}
usepk=${14}

concurrency="2"

echo update-index
bash run.sh $ntabs $nrows $writesecs $engine $setup      0        update-index    100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo update-nonindex
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-nonindex 100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

concur2="4"
bash run.sh $ntabs $nrows 9999999 $engine 0      0        update-rate    100    $client $tableoptions $sysbdir $ddir $dname $usepk $concur2 &
urpid=$!
echo update-rate running with pid $urpid " sleeping at " $( date )
sleep $writesecs
echo woke after update-rate sleep at $( date )

for range in 1 10 100 1000 ; do
echo read-only count range $range
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        read-only-count $range $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency
done

echo random-points
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        random-points   100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo kill update-rate at $( date ) with pid $urpid
kill $urpid
killall sysbench

mkdir pre
mv sb.* pre

sleep 10
$client -uroot -ppw -e 'set global rocksdb_force_flush_memtable_and_lzero_now=1'
#$client -uroot -ppw -e 'set global rocksdb_force_flush_memtable_now=1'
sleep 60
$client -uroot -ppw -e 'set global rocksdb_force_flush_memtable_and_lzero_now=1'
#$client -uroot -ppw -e 'set global rocksdb_force_flush_memtable_now=1'
sleep 300

for range in 1 10 100 1000 ; do
echo read-only count range $range
bash run.sh $ntabs $nrows 180  $engine 0      0        read-only-count $range $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency
done

echo random-points
bash run.sh $ntabs $nrows 180  $engine 0      0        random-points   100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

mkdir post
mv sb.* post

