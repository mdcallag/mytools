# Notes:
#   edit values in the "Edit these" section below
#   get iibench.py from https://github.com/mdcallag/mytools/blob/master/bench/ibench/iibench.py



#
# Edit these
#

# The number of seconds for which the qp* and qr* steps run
# I usually use 1800 or 3600
nsecs=1800

my_user=root
my_pass=pw
my_db=ib
my_host=127.0.0.1
my_sock="/tmp/mysql.sock"

# To get IO-bound workloads on the servers that I use ...
#
# 8 cores, 32G of RAM:   nclients=1  load_rows=800000000 i1_rows=4000000 i2_rows=1000000
# 24 cores, 64G of RAM:  nclients=8  load_rows=250000000 i1_rows=4000000 i2_rows=1000000
# 32 cores, 128G of RAM: nclients=12 load_rows=300000000 i1_rows=4000000 i2_rows=1000000
# 48 cores, 128G of RAM: nclients=20 load_rows=200000000 i1_rows=4000000 i2_rows=1000000

# There are up to 3 connections per client, and at most 2 busy connections per client
# I usually set this to be between number-of-cores/3 and number-of-cores/2
nclients=1

# note that these are per client
load_rows=8000000
i1_rows=1000000
i2_rows=1000000

# full path to mariadb or mysql client
client=/home/mdcallag/d/ma101104_rel_withdbg/bin/mariadb




#
# You shouldn't have to edit anything below
#

clcreds=( -u${my_user} -p${my_pass} -h ${my_host} )

# This can fail if the database already exists
echo Create database ${my_db} in case it does not exist at $( date )
echo $client "${clcreds[@]}" -e "create database ${my_db}"
$client "${clcreds[@]}" -e "create database ${my_db}"

echo Drop tables pi1 to pi${nclients} at $( date )
for n in $( seq 1 $nclients ); do
  echo $client "${clcreds[@]}" $my_db -e "drop table if exists pi${n}"
  $client "${clcreds[@]}" $my_db -e "drop table if exists pi${n}"
done

# l.i0
echo run l.i0 at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run l.i0.$x at $( date ) > ib.res.l.i0.$x
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --max_rows=${load_rows} --table_name=pi${x} --setup --num_secondary_indexes=0 --data_length_min=10 --data_length_max=20 --rows_per_commit=100 --inserts_per_second=0 --query_threads=0 --seed=1764399001 --dbopt=none --my_id=$x >> ib.res.l.i0.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for l.i0 client $x at $( date )
  wait ${apid[${x}]}
done

# l.x
echo run l.x at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run l.x.$x at $( date ) > ib.res.l.x.$x
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --secondary_at_end --max_rows=100 --table_name=pi${x} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=100 --inserts_per_second=0 --query_threads=0 --seed=1764404127 --dbopt=none --my_id=$x >> ib.res.l.x.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for l.x client $x at $( date )
  wait ${apid[${x}]}
done

# l.i1
echo run l.i1 at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run l.i1.$x at $( date ) > ib.res.l.i1.$x
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --delete_per_insert --max_rows=${i1_rows} --table_name=pi${x} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=50 --inserts_per_second=0 --query_threads=0 --seed=1764410161 --dbopt=none --my_id=$x >> ib.res.l.i1.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for l.i1 client $x at $( date )
  wait ${apid[${x}]}
done

# l.i2
echo run l.i2 at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run l.i2.$x at $( date ) > ib.res.l.i2.$x
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --delete_per_insert --max_rows=${i2_rows} --table_name=pi${x} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=5 --inserts_per_second=0 --query_threads=0 --seed=1764411776 --dbopt=none --my_id=$x >> ib.res.l.i2.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for l.i2 client $x at $( date )
  wait ${apid[${x}]}
done

# MVCC cleanup

echo Start MVCC cleanup at $( date )
for x in $( seq 1 $nclients ); do
  echo Analyze table pi${x} at $( date ) >> ib.o.myvac
  /usr/bin/time -o ib.o.myvac.time.$x $client "${clcreds[@]}" -e "analyze table pi${x}" > ib.o.myvac.at.$x 2>&1 &
  apid[${x}]=$!
done

$client "${clcreds[@]}" -e "show engine innodb status" -E >& ib.o.myvac.es1
maxDirty=$( $client "${clcreds[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct"' | awk '{ print $2 }' )
maxDirtyLwm=$( $client "${clcreds[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct_lwm"' | awk '{ print $2 }' )

# This option is only in mysql 8.0.18+
idlePct=$( $client "${clcreds[@]}" -N -B -e 'show global variables like "innodb_idle_flush_pct"' 2> /dev/null | awk '{ print $2 }' )

echo "Reduce max_dirty to 0 to flush InnoDB buffer pool" >> ib.o.myvac
$client "${clcreds[@]}" -e 'set global innodb_max_dirty_pages_pct_lwm=1' >> ib.o.myvac 2>&1
$client "${clcreds[@]}" -e 'set global innodb_max_dirty_pages_pct=1' >> ib.o.myvac 2>&1
echo "Increase idle_pct to 100 to flush InnoDB buffer pool" >> ib.o.myvac
$client "${clcreds[@]}" -e 'set global innodb_idle_flush_pct=100' >> ib.o.myvac 2>&1
$client "${clcreds[@]}" -e 'show global variables' >> ib.o.myvac.show.1 2>&1

# Sleep for 60s + 1s per 1M rows, with a max of 1200s
sleepsecs=$( echo $load_rows | awk '{ nsecs = ($1 / 1000000) + 60; if (nsecs > 1200) nsecs = 1200; printf "%.0f", nsecs }' )

echo "Sleep for $sleepsecs at $( date )" >> ib.o.myvac
sleep $sleepsecs

for x in $( seq 1 $nclients ); do
  echo wait for analyze $n at $( date ) >> ib.o.myvac
  wait ${apid[${x}]}
done
echo "Done waiting for analyze at $( date )" >> ib.o.myvac

echo "Reset max_dirty to $maxDirty and lwm to $maxDirtyLwm" >> ib.o.myvac
$client "${clcreds[@]}" -e "set global innodb_max_dirty_pages_pct=$maxDirty" >> ib.o.myvac 2>&1
$client "${clcreds[@]}" -e "set global innodb_max_dirty_pages_pct_lwm=$maxDirtyLwm" >> ib.o.myvac 2>&1
echo "Reset idle_pct to $idlePct" >> ib.o.myvac
$client "${clcreds[@]}" -e "set global innodb_idle_flush_pct=$idlePct" >> ib.o.myvac 2>&1
$client "${clcreds[@]}" -e 'show global variables' >> ib.o.myvac.show.2 2>&1
$client "${clcreds[@]}" -e "show engine innodb status" -E >& ib.o.myvac.es3

# qr100.L1
echo run qr100.L1 at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run qr100.L1.$x at $( date ) > ib.res.qr100.L1.$x
  maxr=$(( 100 * $nsecs ))
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --delete_per_insert --max_rows=${maxr} --table_name=pi${x} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=50 --inserts_per_second=100 --query_threads=1 --seed=1764412963 --dbopt=none --my_id=$x >> ib.res.qr100.L1.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for qr100.L1 client $x at $( date )
  wait ${apid[${x}]}
done

# qp100.L1
echo run qp100.L2 at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run qp100.L2.$x at $( date ) > ib.res.qp100.L2.$x
  maxr=$(( 100 * $nsecs ))
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --delete_per_insert --query_pk_only --max_rows=${maxr} --table_name=pi${x} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=50 --inserts_per_second=100 --query_threads=1 --seed=1764414765 --dbopt=none --my_id=$x >> ib.res.qp100.L2.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for qp100.L2 client $x at $( date )
  wait ${apid[${x}]}
done

# qr500.L3
echo run qr500.L3 at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run qr500.L3.$x at $( date ) > ib.res.qr500.L3.$x
  maxr=$(( 500 * $nsecs ))
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --delete_per_insert --max_rows=${maxr} --table_name=pi${x} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=50 --inserts_per_second=500 --query_threads=1 --seed=1764416567 --dbopt=none --my_id=$x >> ib.res.qr500.L3.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for qr500.L3 client $x at $( date )
  wait ${apid[${x}]}
done

# qp500.L4
echo run qp500.L4 at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run qp500.L4.$x at $( date ) > ib.res.qp500.L4.$x
  maxr=$(( 500 * $nsecs ))
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --delete_per_insert --query_pk_only --max_rows=${maxr} --table_name=pi${x} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=50 --inserts_per_second=500 --query_threads=1 --seed=1764418369 --dbopt=none --my_id=$x >> ib.res.qp500.L4.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for qp500.L4 client $x at $( date )
  wait ${apid[${x}]}
done

# qr1000.L5
echo run qr1000.L5 at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run qr1000.L5.$x at $( date ) > ib.res.qr1000.L5.$x
  maxr=$(( 1000 * $nsecs ))
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --delete_per_insert --max_rows=${maxr} --table_name=pi${x} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=50 --inserts_per_second=1000 --query_threads=1 --seed=1764420170 --dbopt=none --my_id=$x >> ib.res.qr1000.L5.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for qr1000.L5 client $x at $( date )
  wait ${apid[${x}]}
done

# qp1000.L6
echo run qp1000.L6 at $( date ) 

for x in $( seq 1 $nclients ); do
  echo run qp1000.L6.$x at $( date ) > ib.res.qp1000.L6.$x
  maxr=$(( 1000 * $nsecs ))
  python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=${my_host} --db_user=${my_user} --db_password=${my_pass} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --db_socket=${my_sock} --delete_per_insert --query_pk_only --max_rows=${maxr} --table_name=pi${x} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=50 --inserts_per_second=1000 --query_threads=1 --seed=1764421973 --dbopt=none --my_id=$x >> ib.res.qp1000.L6.$x 2>&1 &
  apid[${x}]=$!
done
for x in $( seq 1 $nclients ); do
  echo wait for qp1000.L6 client $x at $( date )
  wait ${apid[${x}]}
done

