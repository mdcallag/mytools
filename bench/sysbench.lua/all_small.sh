ntabs=$1
nrows=$2
readsecs=$3
writesecs=$4
engine=$5
setup=$6
cleanup=$7
client=$8
tableoptions=$9
sysbdir=${10}

concurrency="1 2 4"

echo update-index
bash run.sh $ntabs $nrows $writesecs $engine $setup 0        update-index    100    $client $tableoptions $sysbdir $concurrency

echo update-nonindex
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-nonindex 100    $client $tableoptions $sysbdir $concurrency

# TODO no concurrency until it uses transactions
echo delete
bash run.sh $ntabs $nrows $writesecs $engine 0      0        delete          100    $client $tableoptions $sysbdir 1

echo write-only
bash run.sh $ntabs $nrows $writesecs $engine 0      0        write-only      100    $client $tableoptions $sysbdir $concurrency

echo read-write
bash run.sh $ntabs $nrows $writesecs $engine 0      0        read-write      100    $client $tableoptions $sysbdir $concurrency

for range in 10 100 1000 10000 ; do
echo read-only range $range
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        read-only       $range $client $tableoptions $sysbdir $concurrency
done

echo point-query
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        point-query     100    $client $tableoptions $sysbdir $concurrency

echo insert
bash run.sh $ntabs $nrows $writesecs $engine 0      $cleanup insert          100    $client $tableoptions $sysbdir $concurrency
