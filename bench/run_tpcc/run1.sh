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

dbh=${13}

# use innodb compression (yes|no)
compress=${14}

run_mysql="$mysql -u$myu -p$myp -h$dbh $myd -A"

if [[ $prepare == "yes" ]]; then
  echo prepare: drop and create db
  $run_mysql -e "drop database test; create database test"
  echo prepare: create tables
  $run_mysql < create_table.sql
  if [ ${compress} == "yes" ]; then
    echo "Use innodb compression"
    for t in warehouse district customer history new_orders orders order_line item stock  ; do
      $run_mysql -e "alter table $t engine=innodb key_block_size=8"
    done
  else
    echo "Do not use innodb compression"
  fi
  echo Running tpcc_load
  echo ./tpcc_load $dbh $myd $myu $myp $nw
  if ! ./tpcc_load $dbh $myd $myu $myp $nw  ; then
    echo Load failed
    exit 1
  fi
  echo Sleep 30 seconds after running load
  sleep 30
fi

dop=1
while [[ $dop -le $maxdop ]]; do

  lag=1000000
  lag_sleep=1
  while [[ $lag -gt 1000 ]]; do
    sleep $lag_sleep
    lag=$( $run_mysql -e "show engine innodb status\G" | grep History | awk '{ print $4 }' )
    echo Wait for purge lag to drop from $lag to 1000 with dop $dop
    lag_sleep=10
  done

  echo ./tpcc_start $dbh $myd $myu $myp $nw $dop $rt $mt
  ./tpcc_start $dbh $myd $myu $myp $nw $dop $rt $mt > tpc.o.$dop

  dop=$(( $dop * 2 ))

done

$run_mysql -e 'show table status\G'

$run_mysql -e "select COMPRESS_OPS, COMPRESS_OPS_OK, COMPRESS_USECS, COMPRESS_OK_USECS, UNCOMPRESS_OPS, UNCOMPRESS_USECS \
from information_schema.table_statistics where SCHEMA_NAME=${myd}"

$run_mysql -e 'select * from information_schema.table_statistics\G'


if [[ $drop == "yes" ]]; then
  $run_mysql -e "drop database test; create database test"
fi

