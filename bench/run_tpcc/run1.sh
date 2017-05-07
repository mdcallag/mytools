nw=$1
engine=$2
mysql=$3
ddir=$4
myu=$5
myp=$6
myd=$7
rt=$8
mt=$9

prepare=${10}
run=${11}

dbh=${12}

# extra options for create table
create_opt=${13}

# number of concurrent clients
dop=${14}

# suffix for output files
sfx=${15}

sla=${16}

# name of storage device in iostat for database IO
dname=${17}

repint=3

run_mysql="$mysql -u$myu -p$myp -h$dbh -A"
echo $run_mysql

$run_mysql -e "reset master"

killall iostat
killall vmstat

python mstat.py --loops 1000000 --interval $repint --db_user=root --db_password=pw --db_host=${dbhost} >& tpc.mstat.$sfx &
mpid=$!
vmstat $repint >& tpc.vm.$sfx &
vpid=$!
iostat -kx $repint >& tpc.io.$sfx &
ipid=$!

if [[ $prepare == "yes" ]]; then
  echo prepare: drop and create db
  $run_mysql -e "drop database ${myd}"
  $run_mysql -e "create database ${myd}"

  echo prepare: create tables

  cat create_table.sql | sed -e "s/Engine=InnoDB/Engine=${engine} ${create_opt} DEFAULT COLLATE=latin1_bin/g" > create_table_${engine}.sql
  cat add_fkey_idx.sql | grep -v "FOREIGN KEY" > add_fkey_idx_${engine}.sql

  $run_mysql $myd < create_table_${engine}.sql
  $run_mysql $myd < add_fkey_idx_${engine}.sql

  echo Running tpcc_load
  echo ./tpcc_load -h $dbh -d $myd -u $myu -p $myp -w $nw
  if ! ./tpcc_load -h $dbh -d $myd -u $myu -p $myp -w $nw > tpc.l.o.$sfx 2> tpc.l.e.$sfx  ; then
    echo Load failed
    exit 1
  fi
fi

if [[ $run == "yes" ]]; then

  echo "before" > tpc.r.sz.$sfx
  du -hs $ddir >> tpc.r.sz.$sfx

  echo ./tpcc_start $dbh $myd $myu $myp $nw $dop $rt $mt
  echo ./tpcc_start -h $dbh -d $myd -u $myu -p $myp -w $nw -c $dop -r $rt -l $mt -0 $sla -1 $sla -2 $sla -3 $sla -4 $sla
  ./tpcc_start -h $dbh -d $myd -u $myu -p $myp -w $nw -c $dop -r $rt -l $mt -i $repint -0 $sla -1 $sla -2 $sla -3 $sla -4 $sla > tpc.r.o.$sfx 2> tpc.r.e.$sfx

  echo "after" >> tpc.r.sz.$sfx
  du -hs $ddir >> tpc.r.sz.$sfx
  awk '/^MEASURING START/,/^STOPPING THREAD/' tpc.r.o.$sfx | \
    awk '{ (if (NF == 13) { print $3 } }' | \
    sed 's/,//' > tpc.r.qps.$sfx
fi

kill $mpid
kill $ipid
kill $vpid

if [[ $run == "yes" ]]; then

  tpmc=$( tail -1 tpc.r.o.$sfx | awk '{ print $1 }' ) > tpc.r.res.$sfx

  printf "samp\tr/s\trkb/s\twkb/s\tr/tpmc\trkb/t\twkb/t\ttpmc\t\n" >> tpc.r.res.$sfx
  grep $dname tpc.io.$sfx | awk '{ rs += $4; rkb += $6; wkb += $7; c += 1 } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.3f\t%.3f\t%s\t\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q, (p*r)/q }' q=${tpmc} p=$dop r=$rpc  >> tpc.r.res.$sfx

  printf "\nsamp\tcs/s\tcpu/s\tcs/tpmc\tcpu/tpmc\n" >> tpc.r.res.$sfx
  grep -v swpd tpc.vm.$sfx | awk '{ cs += $12; cpu += $13 + $14; c += 1 } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=${tpmc} >> tpc.r.res.$sfx

  cat tpc.r.sz.$sfx >> tpc.r.res.$sfx

  echo >> tpc.r.res.$sfx
  awk '/\<Raw Results/,/\<Raw Results2/' tpc.r.o.$sfx >> tpc.r.res.$sfx
  echo >> tpc.r.res.$sfx
  awk '/\<Constraint Check/,/\<TpmC/' tpc.r.o.$sfx >> tpc.r.res.$sfx
fi

for t in warehouse district customer history new_orders orders order_line item stock  ; do
  $run_mysql $myd -e "show table status like \"$t\"\G" >> tpc.extra.$sfx
done

for t in warehouse district customer history new_orders orders order_line item stock  ; do
  $run_mysql $myd -e "show create table $t\G" >> tpc.extra.$sfx
done

for t in warehouse district customer history new_orders orders order_line item stock ; do
  $run_mysql -e "select ROWS_READ, ROWS_INSERTED, ROWS_UPDATED, ROWS_DELETED, TABLE_NAME \
  from information_schema.table_statistics where TABLE_NAME like \"$t%\"" >> tpc.extra.$sfx
done

$run_mysql -e "show engine ${engine} status\G" > tpc.ts.$sfx
$run_mysql -e "show global status" > tpc.gs.$sfx
$run_mysql -e "show global variables" > tpc.gv.$sfx
$run_mysql -e "show memory status" > tpc.ms.$sfx
$run_mysql -e "reset master"


