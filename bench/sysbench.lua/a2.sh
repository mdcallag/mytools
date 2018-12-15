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

concurrency="1 2"

echo update-inlist
bash run.sh $ntabs $nrows $writesecs $engine $setup 0        update-inlist   100    $client $tableoptions $sysbdir $concurrency

echo update-one
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-one      100    $client $tableoptions $sysbdir $concurrency

echo update-index
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-index    100    $client $tableoptions $sysbdir $concurrency

echo update-nonindex
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-nonindex 100    $client $tableoptions $sysbdir $concurrency

echo update-special
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-special  100    $client $tableoptions $sysbdir $concurrency

echo delete
bash run.sh $ntabs $nrows $writesecs $engine 0      0        delete          100    $client $tableoptions $sysbdir $concurrency

for range in 100 10000 ; do
echo read-write range $range
bash run.sh $ntabs $nrows $writesecs $engine 0      0        read-write      $range $client $tableoptions $sysbdir $concurrency
done

for range in 100 10000 ; do
echo read-only range $range
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        read-only       $range $client $tableoptions $sysbdir $concurrency
done

echo point-query
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        point-query     100    $client $tableoptions $sysbdir $concurrency

echo random-points
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        random-points   100    $client $tableoptions $sysbdir $concurrency

echo hot-points
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        hot-points      100    $client $tableoptions $sysbdir $concurrency

