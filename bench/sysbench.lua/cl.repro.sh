
# This works using the Lua scripts at https://github.com/mdcallag/mytools/tree/master/bench/sysbench.lua/lua

########## Edit these: begin

# Path to the Lua scripts from https://github.com/mdcallag/mytools/tree/master/bench/sysbench.lua/lua
luabasepath=/home/mdcallag/git/mytools/bench/sysbench.lua/lua

# Path to the sysbench binary
sysbench=$luabasepath/sysbench

# One of: mysql postgres
#dbms=mysql
dbms=postgres

# For MySQL, one of: innodb, rocksdb
# For Postgres: the value is ignored, set it to anything
#engine=innodb
#engine=rocksdb
engine=postgres

# Number of tables
ntabs=8

# Number of concurrent connections
nthreads=40

# Number of rows per table
nrows=10000000

# Number of seconds to run each read-heavy test
rsecs=630

# Numbmer of seconds to run each write-heavy test
wsecs=930

# IP/hostname for database server
host=127.0.0.1

# Username and password for MySQL
my_user=root
my_pass=pw

# Username and password for Postgres
pg_user=root
pg_pass=pw

# Database directory
use_db=ib

# Path to "mysql" binary for MySQL (or MariaDB) 
# Also path to psql binary for Postgres
client=/home/mdcallag/d/my8408_rel_o2nofp/bin/mysql
#client=/home/mdcallag/d/fbmy8032_rel_o2nofp_250126_c6e4b9f3_971/bin/mysql
#client=/home/mdcallag/d/pg182_o2nofp/bin/psql

########## Edit these: end



# This works using the Lua scripts at https://github.com/mdcallag/mytools/tree/master/bench/sysbench.lua/lua
luapath="$luabasepath/?.lua"

if [[ $dbms == "mysql" ]]; then
  sbcreds=( --mysql-user=${my_user} --mysql-password=${my_pass} --mysql-host=${host} --mysql-db=${use_db} )
  clcreds=( -u${my_user} -p${my_pass} -h 127.0.0.1 )
  extra_flags="--db-driver=mysql --mysql-storage-engine=$engine"
  sqlF=e

  if [[ $engine == "innodb" || $engine == "rocksdb" ]]; then
    echo Using $engine for MySQL
  else
    echo engine must be innodb or rocksdb : $engine
    exit 1
  fi

elif [[ $dbms == "postgres" ]]; then
  sbcreds=( --pgsql-user=${pg_user} --pgsql-password=${pg_pass} --pgsql-host=${host} --pgsql-db=${use_db} )
  clcreds=( -U${pg_user} -h${host} )
  extra_flags="--db-driver=pgsql"
  sqlF=c

else
  echo "dbms must be one of mysql or postgres: $dbms"
  exit 1
fi

#echo sbcreds "${sbcreds[@]}"
#echo clcreds "${clcreds[@]}"

echo "This can fail if the database exists"
echo $client "${clcreds[@]}" -${sqlF} "create database $use_db"
$client "${clcreds[@]}" -${sqlF} "create database $use_db"

for n in $( seq 1 $ntabs ); do
  echo $client "${clcreds[@]}" $use_db -${sqlF} "drop table if exists sbtest${n}"
  $client "${clcreds[@]}" $use_db -${sqlF} "drop table if exists sbtest${n}"
done

echo Run: prepare at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --events=0 --time=60 $luabasepath/oltp_point_select.lua prepare "${sbcreds[@]}" \
>& sb.prepare.range100.pk1.dop${ntabs}

echo Run: point-query.warm at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$ntabs --events=0  --time=$rsecs $luabasepath/oltp_point_select.lua run "${sbcreds[@]}" --rand-type=uniform --skip-trx \
>& sb.o.point-query.warm.range100.pk1.dop${ntabs}

echo Run: scan.warmpre at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=60 $luabasepath/oltp_scan.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.scan.warmpre.range100.pk1.dop${nthreads}

echo Run: point-query.pre at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_point_select.lua run "${sbcreds[@]}" --rand-type=uniform --skip-trx \
>& sb.o.point-query.pre.range100.pk1.dop${nthreads}

echo Run: range-notcovered-si.pre at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false --covered=false \
>& sb.o.range-notcovered-si.pre.range100.pk1.dop${nthreads}

echo Run: update-inlist at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_inlist_update.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.update-inlist.range100.pk1.dop${nthreads}

echo Run: update-index at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_update_index.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.update-index.range100.pk1.dop${nthreads}

echo Run: update-nonindex at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_update_non_index.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.update-nonindex.range100.pk1.dop${nthreads}

echo Run: update-one at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=1 --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_update_non_index.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.update-one.range100.pk1.dop${nthreads}

echo Run: update-zipf at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_update_non_index.lua run "${sbcreds[@]}" --rand-type=zipfian \
>& sb.o.update-zipf.range100.pk1.dop${nthreads}

echo Run: write-only at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=10000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_write_only.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.write-only.range10000.pk1.dop${nthreads}

echo Run: read-write.range10 at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=10 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_read_write.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-write.range10.pk1.dop${nthreads}

echo Run: read-write.range100 at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_read_write.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-write.range100.pk1.dop${nthreads}

# MVCC cleanup

total_nr=$(( nrows * ntabs ))
# Sleep for 60s + 1s per 1M rows, with a max of 1200s
sleep_secs=$( echo $total_nr | awk '{ nsecs = ($1 / 1000000) + 60; if (nsecs > 1200) nsecs = 1200; printf "%.0f", nsecs }' )
start_secs=$( date +%s )
done_secs=$(( start_secs + sleep_secs ))
echo "Start MVCC cleanup and sleep for up to $sleep_secs seconds at $( date )"

if [[ $dbms == "mysql" ]]; then
  echo sleep for $sleep_secs with $total_nr rows > sb.o.myvac

  for x in $( seq 1 $ntabs ); do
    echo Analyze table sbtest${x} >> sb.o.myvac
    /usr/bin/time -o sb.o.myvac.time.$x $client "${clcreds[@]}" $use_db -e "analyze table sbtest${x}" > sb.o.myvac.at.$x 2>&1 &
    apid[${x}]=$!
  done

  if [[ $engine == "innodb" ]]; then
    $client "${clcreds[@]}" -e "show engine innodb status" -E >& sb.o.myvac.es1
    maxDirty=$( $client "${clcreds[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct"' | awk '{ print $2 }' )
    maxDirtyLwm=$( $client "${clcreds[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct_lwm"' | awk '{ print $2 }' )

    # This option is only in 8.0.18+
    idlePct=$( $client "${clcreds[@]}" -N -B -e 'show global variables like "innodb_idle_flush_pct"' 2> /dev/null | awk '{ print $2 }' )

    echo "Reduce max_dirty to 0 to flush InnoDB buffer pool" >> sb.o.myvac
    $client "${clcreds[@]}" -e 'set global innodb_max_dirty_pages_pct_lwm=1' >> sb.o.myvac 2>&1
    $client "${clcreds[@]}" -e 'set global innodb_max_dirty_pages_pct=1' >> sb.o.myvac 2>&1
    echo "Increase idle_pct to 100 to flush InnoDB buffer pool" >> sb.o.myvac
    $client "${clcreds[@]}" -e 'set global innodb_idle_flush_pct=100' >> sb.o.myvac 2>&1
    $client "${clcreds[@]}" -e 'show global variables' >> sb.o.myvac.show.1 2>&1

  else
    $client "${clcreds[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es0
    loop=0
    while :; do
      loop=$(( loop + 1 ))
      echo "Wait for RocksDB compaction to stop at $( date )" | tee -a sb.o.myvac

      $client "${clcreds[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es1.loop${loop}
      $client "${clcreds[@]}" -e "select * from information_schema.rocksdb_active_compaction_stats" -B | grep -v "Using a password" >& sb.o.myvac.rxstats.loop${loop}
      status=$?

      if [[ status -ne 0 ]]; then
        echo "information_schema.rocksdb_active_compaction_stats does not exist, sleep for 30 seconds then continue" | tee -a sb.o.myvac
        sleep 30
        break
      fi

      rowcount=$( wc -l sb.o.myvac.rxstats.loop${loop} | awk '{ print $1 }' )
      if [[ rowcount -gt 0 ]]; then
        echo "compaction running at loop ${loop}, sleep 10 seconds" | tee -a sb.o.myvac
        sleep 10
      else
        echo "compaction not running at loop ${loop}, done" | tee -a sb.o.myvac
        break
      fi
    done

    echo "Done waiting for RocksDB compaction to stop at $( date ) after $loop loops" | tee -a sb.o.myvac

    echo Enable flush memtable and L0 in 2 parts >> sb.o.myvac
    $client "${clcreds[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es1
    echo "Flush memtable at $( date )" >> sb.o.myvac
    $client "${clcreds[@]}" -e 'set global rocksdb_force_flush_memtable_now=1' >> sb.o.myvac 2>&1
    sleep 20
    echo "Flush lzero at $( date )" >> sb.o.myvac
    $client "${clcreds[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es2
    # Not safe to use, see issues 1200 and 1295
    #$client "${clcreds[@]}" -e 'set global rocksdb_force_flush_memtable_and_lzero_now=1' >> sb.o.myvac 2>&1
    # Alas, this only works on releases from mid 2023 or more recent
    $client "${clcreds[@]}" -e 'set global rocksdb_compact_lzero_now=1' >> sb.o.myvac 2>&1
  fi

else

  echo "pg_vac starts at $( date )"
  echo "pg_vac starts at $( date ) with sleep_secs = $sleep_secs" > sb.o.pgvac
  echo nr is :: $total_nr :: and ntabs is :: $ntabs :: >> sb.o.pgvac

  major_version=$( $client "${clcreds[@]}" $use_db -x -c 'show server_version_num' | grep server_version_num | awk '{ print $3 }' )
  echo Postgres major version is $major_version
  vac_args="(verbose, analyze)"
  if [[ $major_version -ge 120000 ]]; then
    vac_args="(verbose, analyze, index_cleanup ON)"
  fi
  echo "vac_args is $vac_args" >> sb.o.pgvac

  echo "Start vacuum at $( date )"
  x=0
  for n in $( seq 1 $ntabs ) ; do
    $client "${clcreds[@]}" $use_db -x -c "vacuum $vac_args sbtest${n}" >& sb.o.pgvac.sbtest${n} &
    vpid[${x}]=$!
    x=$(( $x + 1 ))
  done

  echo "After load: wait for vacuum"
  for n in $( seq 0 $(( $x - 1 )) ) ; do
    echo After load: wait for vacuum $n >> sb.o.pgvac
    wait ${vpid[${n}]}
  done

  echo "Checkpoint started at $( date )"
  echo "Checkpoint started at $( date )" >> sb.o.pgvac
  $client "${clcreds[@]}" $use_db -x -c "checkpoint" 2>&1 >> sb.o.pgvac
  echo "Checkpoint done at $( date )"
  echo "Checkpoint done at $( date )" >> sb.o.pgvac
fi

now_secs=$( date +%s )
if [[ now_secs -lt done_secs ]]; then
  diff_secs=$(( done_secs - now_secs ))
  echo "Sleep for $diff_secs seconds at $( date )"
  sleep $diff_secs
  echo "Sleep done at $( date )"
fi

if [[ $dbms == "mysql" ]]; then

  for x in $( seq 1 $ntabs ); do
    echo After load: wait for analyze $n >> sb.o.myvac
    wait ${apid[${x}]}
  done
  echo "Done waiting for analyze" >> sb.o.myvac

  if [[ $engine == "innodb" ]]; then
    echo "Reset max_dirty to $maxDirty and lwm to $maxDirtyLwm" >> sb.o.myvac
    $client "${clcreds[@]}" -e "set global innodb_max_dirty_pages_pct=$maxDirty" >> sb.o.myvac 2>&1
    $client "${clcreds[@]}" -e "set global innodb_max_dirty_pages_pct_lwm=$maxDirtyLwm" >> sb.o.myvac 2>&1
    echo "Reset idle_pct to $idlePct" >> sb.o.myvac
    $client "${clcreds[@]}" -e "set global innodb_idle_flush_pct=$idlePct" >> sb.o.myvac 2>&1
    $client "${clcreds[@]}" -e 'show global variables' >> sb.o.myvac.show.2 2>&1
    $client "${clcreds[@]}" -e "show engine innodb status" -E >& sb.o.myvac.es3

  else
    $client "${clcreds[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es3
  fi
fi

echo "Done with MVCC cleanup at $( date )"

echo Run: scan.warm at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=60 $luabasepath/oltp_scan.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.scan.warm.range100.pk1.dop${nthreads}

echo Run: scan at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_scan.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.scan.range100.pk1.dop${nthreads}

echo Run: read-only.range10 at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=10 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-only.range10.pk1.dop${nthreads}

echo Run: read-only.range100 at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-only.range100.pk1.dop${nthreads}

echo Run: read-only.range10000 at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=10000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-only.range10000.pk1.dop${nthreads}

echo Run: read-only.simple at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform --simple-ranges=1 --sum-ranges=0 --order-ranges=0 --distinct-ranges=0 \
>& sb.o.read-only-simple.range1000.pk1.dop${nthreads}

echo Run: read-only.sum at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform --simple-ranges=0 --sum-ranges=1 --order-ranges=0 --distinct-ranges=0 \
>& sb.o.read-only-sum.range1000.pk1.dop${nthreads}

echo Run: read-only-order at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform --simple-ranges=0 --sum-ranges=0 --order-ranges=1 --distinct-ranges=0 \
>& sb.o.read-only-order.range1000.pk1.dop${nthreads}

echo Run: read-only-distinct at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform --simple-ranges=0 --sum-ranges=0 --order-ranges=0 --distinct-ranges=1 \
>& sb.o.read-only-distinct.range1000.pk1.dop${nthreads}

echo Run: read-only-count at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only_count.lua run "${sbcreds[@]}" --rand-type=uniform --skip-trx \
>& sb.o.read-only-count.range1000.pk1.dop${nthreads}

echo Run: point-query at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_point_select.lua run "${sbcreds[@]}" --rand-type=uniform --skip-trx \
>& sb.o.point-query.range100.pk1.dop${nthreads}

echo Run: random-points.range10 at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=10 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_inlist_select.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=10 --skip-trx \
>& sb.o.random-points.range10.pk1.dop${nthreads}

echo Run: random-points.range100 at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_inlist_select.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx \
>& sb.o.random-points.range100.pk1.dop${nthreads}

echo Run: random-points.range1000 at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_inlist_select.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=1000 --skip-trx \
>& sb.o.random-points.range1000.pk1.dop${nthreads}

echo Run: hot-points at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_inlist_select.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --hot-points --skip-trx \
>& sb.o.hot-points.range100.pk1.dop${nthreads}

echo Run: points-covered-pk at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx \
>& sb.o.points-covered-pk.range100.pk1.dop${nthreads}

echo Run: points-notcovered-pk at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --covered=false \
>& sb.o.points-notcovered-pk.range100.pk1.dop${nthreads}

echo Run: range-covered-pk at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx \
>& sb.o.range-covered-pk.range100.pk1.dop${nthreads}

echo Run: range-notcovered-pk at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --covered=false \
>& sb.o.range-notcovered-pk.range100.pk1.dop${nthreads}

echo Run: points-covered-si.warm at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false \
>& sb.o.points-covered-si.warm.range100.pk1.dop${nthreads}

echo Run: points-covered-si at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false \
>& sb.o.points-covered-si.range100.pk1.dop${nthreads}

echo Run: points-notcovered-si at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false --covered=false \
>& sb.o.points-notcovered-si.range100.pk1.dop${nthreads}

echo Run: range-covered-si at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false \
>& sb.o.range-covered-si.range100.pk1.dop${nthreads}

echo Run: range-notcovered-si at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false --covered=false \
>& sb.o.range-notcovered-si.range100.pk1.dop${nthreads}

echo Run: delete at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_delete.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.delete.range100.pk1.dop${nthreads}

echo Run: insert at $( date )
LUA_PATH=$luapath $sysbench $extra_flags --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_insert.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.insert.range100.pk1.dop${nthreads}

echo Done at $( date )

