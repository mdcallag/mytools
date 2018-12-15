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
tname=${12}

concurrency="1"

echo update-index
bash run.sh $ntabs $nrows $writesecs $engine $setup 0        $tname       100    $client $tableoptions $sysbdir $concurrency

