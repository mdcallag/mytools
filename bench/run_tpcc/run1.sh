nw=$1
engine=$2
mysql=$3
maxdop=$4
myu=$5
myp=$6
myd=$7
mysock=$8
rt=$9
mt=${10}

# if yes then prepare the sbtest table else ignore
prepare=${11}

# if yes then drop the sbtest table at test end else ignore
drop=${12}

run_mysql="$mysql -u$myu -p$myp -S$mysock $myd -A"

dop=1
while [[ $dop -le $maxdop ]]; do

  if [[ $prepare == "yes" ]]; then
    $run_mysql < create_table.sql
    echo Running tpcc_load
    echo ./tpcc_load 127.0.0.1 $myd $myu $myp $nw 1 1 $nw
    ./tpcc_load 127.0.0.1 $myd $myu $myp $nw 1 1 $nw
    ./tpcc_load 127.0.0.1 $myd $myu $myp $nw 2 1 $nw
    ./tpcc_load 127.0.0.1 $myd $myu $myp $nw 3 1 $nw
    ./tpcc_load 127.0.0.1 $myd $myu $myp $nw 4 1 $nw
    echo Sleep 30 seconds after running load
    sleep 30
  fi

  echo ./tpcc_start 127.0.0.1 $myd $myu $myp $nw $dop $rt $mt
  ./tpcc_start 127.0.0.1 $myd $myu $myp $nw $dop $rt $mt

  dop=$(( $dop * 2 ))

done

$run_mysql -e 'show table status'

if [[ $drop == "yes" ]]; then
  echo TODO implement drop
fi

