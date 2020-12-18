ntabs=$1
nrows=$2
readsecs=$3
writesecs=$4
insertsecs=$5
dbAndCreds=$6
setup=$7
cleanup=$8
client=$9
tableoptions=${10}
sysbdir=${11}
ddir=${12}
dname=${13}
usepk=${14}

# The remaining args are the number of concurrent users per test run, for example "1 2 4"
shift 14

# warm the cache 
echo point-query.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds $setup 0        point-query.warm 100    $client $tableoptions $sysbdir $ddir $dname $usepk "2"

echo point-query.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        point-query.pre 100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo random-points.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        random-points.pre 100  $client $tableoptions $sysbdir $ddir $dname $usepk $@

for range in 10 100 10000 ; do
echo read-only.pre range $range
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        read-only.pre   $range $client $tableoptions $sysbdir $ddir $dname $usepk $@
done

echo update-inlist
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-inlist   100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo update-index
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-index    100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo update-nonindex
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-nonindex 100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo update-nonindex
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-nonindex 100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo update-one
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-one      100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo update-zipf
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-zipf      100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

for range in 10 100 ; do
echo read-write range $range
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        read-write      $range $client $tableoptions $sysbdir $ddir $dname $usepk $@
done

for range in 10 100 10000 ; do
echo read-only range $range
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        read-only       $range $client $tableoptions $sysbdir $ddir $dname $usepk $@
done

bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        write-only      $range $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo point-query
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        point-query     100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo random-points
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        random-points   100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo hot-points
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        hot-points      100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo delete
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        delete          100    $client $tableoptions $sysbdir $ddir $dname $usepk $@

echo insert
bash run.sh $ntabs $nrows $insertsecs $dbAndCreds 0     $cleanup insert          100    $client $tableoptions $sysbdir $ddir $dname $usepk $@
