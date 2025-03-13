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
prepstmt=${15}

# value for "postwrite" option for most tests
pwr=0

# The remaining args are the number of concurrent users per test run, for example "1 2 4"
shift 15

# This does load, runs a query test and then does "postwrite" work
echo point-query.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds $setup 0        point-query.warm 100    $client $tableoptions $sysbdir $ddir $dname $usepk 1 $prepstmt $ntabs

echo point-query.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        point-query.pre 100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

for range in 10 100 1000 ; do
echo random-points.pre range $range
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        random-points.pre $range  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@
done

for range in 10 100 10000 ; do
echo read-only.pre range $range
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        read-only.pre   $range $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@
done

echo points-covered-pk.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        points-covered-pk.pre    100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo points-notcovered-pk.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        points-notcovered-pk.pre 100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo points-covered-si.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        points-covered-si.pre    100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo points-notcovered-si.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        points-notcovered-si.pre 100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo range-covered-pk.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        range-covered-pk.pre    100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo range-notcovered-pk.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        range-notcovered-pk.pre 100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo range-covered-si.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        range-covered-si.pre    100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo range-notcovered-si.pre
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        range-notcovered-si.pre 100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo update-inlist
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-inlist   100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo update-index
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-index    100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo update-nonindex
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-nonindex 100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo update-one
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-one      100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo update-zipf
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        update-zipf      100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo write-only
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        write-only      10000 $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo read-write range 10
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        read-write      10  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@
echo read-write range 100 and do postwrite
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        read-write      100 $client $tableoptions $sysbdir $ddir $dname $usepk 1    $prepstmt $@

for range in 10 100 10000 ; do
echo read-only range $range
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        read-only       $range $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@
done

echo point-query
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        point-query     100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

for range in 10 100 1000 ; do
echo random-points range $range
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        random-points $range   $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@
done

echo hot-points
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        hot-points      100    $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo points-covered-pk
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        points-covered-pk    100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo points-notcovered-pk
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        points-notcovered-pk 100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo points-covered-si
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        points-covered-si    100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo points-notcovered-si
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        points-notcovered-si 100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo range-covered-pk
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        range-covered-pk     100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo range-notcovered-pk
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        range-notcovered-pk  100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo range-covered-si
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        range-covered-si     100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo range-notcovered-pk
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        range-covered-pk     100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo range-notcovered-si
bash run.sh $ntabs $nrows $readsecs  $dbAndCreds 0      0        range-notcovered-si  100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo scan
bash run.sh $ntabs $nrows $readsecs $dbAndCreds 0     0        scan                 100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo delete
bash run.sh $ntabs $nrows $writesecs $dbAndCreds 0      0        delete               100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo insert
bash run.sh $ntabs $nrows $insertsecs $dbAndCreds 0     $cleanup insert               100  $client $tableoptions $sysbdir $ddir $dname $usepk $pwr $prepstmt $@

echo Done
