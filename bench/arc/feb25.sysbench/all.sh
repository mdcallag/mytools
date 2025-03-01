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

concurrency="1 2 4 8 16 24 32 40 48 64"

# warm the cache but results will wiped
echo point-query.pre
bash run.sh $ntabs $nrows $readsecs  $engine $setup 0        point-query.pre 100    $client $tableoptions $sysbdir $ddir $dname $usepk "48"
rm -rf sb.*.point-query.pre.*

echo point-query.pre
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        point-query.pre 100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo read-only.pre range 10000
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        read-only.pre   10000  $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo random-points.pre
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        random-points.pre 100  $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

if [[ $usepk -eq 1 ]]; then
echo full-scan.pre
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        full-scan.pre   100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency
fi

echo update-inlist
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-inlist   100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo update-one
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-one      100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo update-index
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-index    100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo update-nonindex
bash run.sh $ntabs $nrows $writesecs $engine 0      0        update-nonindex 100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo delete
bash run.sh $ntabs $nrows $writesecs $engine 0      0        delete          100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

for range in 100 10000 ; do
echo read-write range $range
bash run.sh $ntabs $nrows $writesecs  $engine 0     0        read-write      $range $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency
done

for range in 100 10000 ; do
echo read-only range $range
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        read-only       $range $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency
done

echo point-query
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        point-query     100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo random-points
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        random-points   100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

echo hot-points
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        hot-points      100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency

if [[ $usepk -eq 1 ]]; then
echo full-scan.post
bash run.sh $ntabs $nrows $readsecs  $engine 0      0        full-scan.post 100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency
fi

echo insert
bash run.sh $ntabs $nrows $insertsecs $engine 0     $cleanup insert          100    $client $tableoptions $sysbdir $ddir $dname $usepk $concurrency
