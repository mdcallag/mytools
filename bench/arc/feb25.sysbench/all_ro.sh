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

concurrency="1 2 4 8 16 24 32 40 48 64 80 96 128"

# Query after load
echo point-query
bash run.sh $ntabs $nrows $readsecs  $engine $setup 0        point-query     100    $client $tableoptions $sysbdir $concurrency

for range in 10 100 1000 10000 ; do
echo read-only range $range
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        read-only       $range $client $tableoptions $sysbdir $concurrency
done
mkdir sb1; mv sb.* sb1

# fragment database
echo update-index
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-index    100    $client $tableoptions $sysbdir $concurrency

# Query after fragment
echo point-query
bash run.sh $ntabs $nrows $readsecs  $engine $setup 0        point-query     100    $client $tableoptions $sysbdir $concurrency

for range in 10 100 1000 10000 ; do
echo read-only range $range
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        read-only       $range $client $tableoptions $sysbdir $concurrency
done
mkdir sb2; mv sb.* sb2

# Flush L0 & memtable for myrocks
if [[ $engine -eq "rocksdb" ]]; then
echo "flush rocksdb memtable and l0" > sb.flush
$client -uroot -ppw -e 'set global rocksdb_force_flush_memtable_and_lzero_now = 1' >> sb.flush 2>& 1
echo "flush rocksdb memtable and l0" >> sb.flush
fi


# Query after flush
echo point-query
bash run.sh $ntabs $nrows $readsecs  $engine $setup 0        point-query     100    $client $tableoptions $sysbdir $concurrency

for range in 10 100 1000 10000 ; do
echo read-only range $range
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        read-only       $range $client $tableoptions $sysbdir $concurrency
done
mkdir sb3; mv sb.* sb3

# TODO optionally cleanup?
