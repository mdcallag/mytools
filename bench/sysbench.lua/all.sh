ntabs=$1
nrows=$2
readsecs=$3
writesecs=$4
engine=$5
setup=$6
cleanup=$7
client=$8

concurrency="1 2 4 8 16 24 32 40 48 64 80 96 128"

echo update-index
bash run.sh $ntabs $nrows $writesecs $engine $setup 0        update-index    100    $client $concurrency

echo update-nonindex
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-nonindex 100    $client $concurrency

echo read-write
bash run.sh $ntabs $nrows $writesecs $engine 0      0        read-write      100    $client $concurrency

for range in 10 100 1000 10000 ; do
echo read-only range $range
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        read-only       $range $client $concurrency
done

echo point-query
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        point-query     100    $client $concurrency

echo select
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        select          100    $client $concurrency

echo insert
bash run.sh $ntabs $nrows $writesecs $engine 0      $cleanup insert          100    $client $concurrency
