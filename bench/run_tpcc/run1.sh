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

# use partitioning
part=${15}

# path to mysql install
mybase=${16}

run_mysql="$mysql -u$myu -p$myp -h$dbh $myd -A"

if [[ $prepare == "yes" ]]; then
  echo prepare: drop and create db
  $run_mysql -e "drop database test; create database test"
  echo prepare: create tables
  if [ $part != "yes" ] ; then 
    echo Create without partitioning
    $run_mysql < create_table.sql
  else
    echo Create with partitioning
    $run_mysql < create_table_part.sql
  fi

  echo Running tpcc_load
  echo ./tpcc_load $dbh $myd $myu $myp $nw
  if ! ./tpcc_load $dbh $myd $myu $myp $nw  ; then
    echo Load failed
    exit 1
  fi

  echo Pre compression size
  ssh $dbh ls -lh ${mybase}/var/${myd} | grep ibd

  if [[ ${compress} == "yes" || ${compress} == "yespad" ]]; then
    if [ ${compress} == "yespad" ]; then
      echo "Pad for innodb compression"
      $run_mysql -e "alter table history add column pad char(30) default ''"
      $run_mysql -e "alter table stock add column pad char(150) default ''"
      $run_mysql -e "alter table item add column pad char(60) default ''"
      $run_mysql -e "alter table customer add column pad char(255) default ''"
      $run_mysql -e "alter table orders add column pad char(20) default ''"
      $run_mysql -e "alter table new_orders add column pad char(20) default ''"
      $run_mysql -e "alter table order_line add column pad char(40) default ''"
    
      echo Post pad size
      ssh $dbh ls -lh ${mybase}/var/${myd} | grep ibd
    fi

    echo "Use innodb compression"
    for t in customer history new_orders orders order_line item stock  ; do
      $run_mysql -e "alter table $t engine=innodb key_block_size=8"
    done
    echo Post compression size
    ssh $dbh ls -lh ${mybase}/var/${myd} | grep ibd
  else
    echo "Do not use innodb compression"
  fi
  echo Sleep 10 seconds after running load
  sleep 10
fi

dop=16
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

  $run_mysql -e 'show mutex status' > tpc.ms.${dop}
  dop=$(( $dop * 4 ))

done

for t in warehouse district customer history new_orders orders order_line item stock  ; do
  $run_mysql -e "show table status like \"$t\"\G"
done

for t in warehouse district customer history new_orders orders order_line item stock  ; do
  $run_mysql -e "show create table $t\G"
done

$run_mysql -e 'select * from information_schema.innodb_cmp'

for t in warehouse district customer history new_orders orders order_line item stock  ; do
  $run_mysql -e "select COMPRESS_OPS, COMPRESS_OPS_OK, COMPRESS_USECS, COMPRESS_OK_USECS, UNCOMPRESS_OPS, UNCOMPRESS_USECS, TABLE_NAME \
  from information_schema.table_statistics where TABLE_NAME like \"$t%\""
done

$run_mysql -e 'select (COMPRESS_OPS - COMPRESS_OPS_OK) as cfail, ((compress_ops - compress_ops_ok)/compress_ops) as failratio, TABLE_NAME from information_schema.table_statistics where COMPRESS_OPS > 0 order by cfail desc'

for t in warehouse district customer history new_orders orders order_line item stock ; do
  $run_mysql -e "select ROWS_READ, ROWS_INSERTED, ROWS_UPDATED, ROWS_DELETED, TABLE_NAME \
  from information_schema.table_statistics where TABLE_NAME like \"$t%\""
done

$run_mysql -e 'select * from information_schema.table_statistics\G'

echo Post run size
ssh $dbh ls -lh ${mybase}/var/${myd} | grep ibd

if [[ $drop == "yes" ]]; then
  $run_mysql -e "drop database test; create database test"
fi

