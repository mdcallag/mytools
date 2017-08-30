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

concurrency="1 2 4 8 16 24 32 40 48 64"
concurrency="1"

echo update-index
bash run.sh $ntabs $nrows $writesecs $engine $setup 0        update-index    100    $client $tableoptions $sysbdir 16

echo point-query
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        point-query     100    $client $tableoptions $sysbdir $concurrency

echo random-points
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        random-points   100    $client $tableoptions $sysbdir $concurrency

echo hot-points
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        hot-points      100    $client $tableoptions $sysbdir $concurrency

