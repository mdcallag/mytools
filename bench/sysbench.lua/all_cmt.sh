ntabs=$1
nrows=$2
readsecs=$3
writesecs=$4
engine=$5
setup=$6
cleanup=$7
client=$8
tableoptions=$9

concurrency="1 2 4 8 16 24 32 40 48 64 80 96 128 256 512 1024"

echo update-index
bash run.sh $ntabs $nrows $writesecs $engine $setup 0        update-index    100    $client $tableoptions $concurrency

echo read-write
bash run.sh $ntabs $nrows $writesecs $engine 0      0        read-write      100    $client $tableoptions $concurrency

echo insert
bash run.sh $ntabs $nrows $writesecs $engine 0      $cleanup insert          100    $client $tableoptions $concurrency
