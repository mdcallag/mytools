
# This works using the Lua scripts at https://github.com/mdcallag/mytools/tree/master/bench/sysbench.lua/lua

sysbench=/home/mdcallag/git/mytools/bench/sysbench.lua/lua/sysbench
# This works using the Lua scripts at https://github.com/mdcallag/mytools/tree/master/bench/sysbench.lua/lua
luabasepath=/home/mdcallag/git/mytools/bench/sysbench.lua/lua
luapath="$luabasepath/?.lua"

# Edit these
ntabs=2
nthreads=10
nrows=1000000
rsecs=10
wsecs=10
sleepsecs=140

#ntabs=8
#nthreads=40
#nrows=10000000
#rsecs=630
#wsecs=930
my_user=root
my_pass=pw
my_db=test
client=/home/mdcallag/d/ma101104_rel_withdbg/bin/mariadb

sbcreds=( --mysql-user=${my_user} --mysql-password=${my_pass} --mysql-host=127.0.0.1 --mysql-db=${my_db} )
clcreds=( -u${my_user} -p${my_pass} -h 127.0.0.1 )
#echo sbcreds "${sbcreds[@]}"
#echo clcreds "${clcreds[@]}"

for n in $( seq 1 $ntabs ); do
  echo $client "${clcreds[@]}" $my_db -e "drop table if exists sbtest${n}"
  $client "${clcreds[@]}" $my_db -e "drop table if exists sbtest${n}"
done

LUA_PATH=$luapath $sysbench --db-driver=mysql --mysql-storage-engine=innodb --range-size=100 --table-size=${nrows} --tables=$ntabs --events=0 --time=60 $luabasepath/oltp_point_select.lua prepare "${sbcreds[@]}" \
>& sb.prepare.range100.pk1.dop${ntabs}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$ntabs --events=0  --time=$rsecs $luabasepath/oltp_point_select.lua run "${sbcreds[@]}" --rand-type=uniform --skip-trx \
>& sb.o.point-query.warm.range100.pk1.dop${ntabs}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=60 $luabasepath/oltp_scan.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.scan.warmpre.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_point_select.lua run "${sbcreds[@]}" --rand-type=uniform --skip-trx \
>& sb.o.point-query.pre.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false --covered=false \
>& sb.o.range-notcovered-si.pre.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_inlist_update.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.update-inlist.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_update_index.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.update-index.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_update_non_index.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.update-nonindex.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=1 --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_update_non_index.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.update-one.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_update_non_index.lua run "${sbcreds[@]}" --rand-type=zipfian \
>& sb.o.update-zipf.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=10000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_write_only.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.write-only.range10000.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=10 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_read_write.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-write.range10.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_read_write.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-write.range100.pk1.dop${nthreads}

# MVCC cleanup

for x in $( seq 1 $ntabs ); do
  echo Analyze table sbtest${x} >> sb.o.myvac
  /usr/bin/time -o sb.o.myvac.time.$x $client "${clcreds[@]}" -e "analyze table sbtest${x}" > sb.o.myvac.at.$x 2>&1 &
  apid[${x}]=$!
done

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

sleep $sleepsecs

for x in $( seq 1 $ntabs ); do
  echo After load: wait for analyze $n >> sb.o.myvac
  wait ${apid[${x}]}
done
echo "Done waiting for analyze" >> sb.o.myvac

echo "Reset max_dirty to $maxDirty and lwm to $maxDirtyLwm" >> sb.o.myvac
$client "${clcreds[@]}" -e "set global innodb_max_dirty_pages_pct=$maxDirty" >> sb.o.myvac 2>&1
$client "${clcreds[@]}" -e "set global innodb_max_dirty_pages_pct_lwm=$maxDirtyLwm" >> sb.o.myvac 2>&1
echo "Reset idle_pct to $idlePct" >> sb.o.myvac
$client "${clcreds[@]}" -e "set global innodb_idle_flush_pct=$idlePct" >> sb.o.myvac 2>&1
$client "${clcreds[@]}" -e 'show global variables' >> sb.o.myvac.show.2 2>&1
$client "${clcreds[@]}" -e "show engine innodb status" -E >& sb.o.myvac.es3

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=60 $luabasepath/oltp_scan.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.scan.warm.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_scan.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.scan.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=10 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-only.range10.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-only.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=10000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.read-only.range10000.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform --simple-ranges=1 --sum-ranges=0 --order-ranges=0 --distinct-ranges=0 \
>& sb.o.read-only-simple.range1000.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform --simple-ranges=0 --sum-ranges=1 --order-ranges=0 --distinct-ranges=0 \
>& sb.o.read-only-sum.range1000.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform --simple-ranges=0 --sum-ranges=0 --order-ranges=1 --distinct-ranges=0 \
>& sb.o.read-only-order.range1000.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only.lua run "${sbcreds[@]}" --rand-type=uniform --simple-ranges=0 --sum-ranges=0 --order-ranges=0 --distinct-ranges=1 \
>& sb.o.read-only-distinct.range1000.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_read_only_count.lua run "${sbcreds[@]}" --rand-type=uniform --skip-trx \
>& sb.o.read-only-count.range1000.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_point_select.lua run "${sbcreds[@]}" --rand-type=uniform --skip-trx \
>& sb.o.point-query.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=10 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_inlist_select.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=10 --skip-trx \
>& sb.o.random-points.range10.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_inlist_select.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx \
>& sb.o.random-points.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=1000 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_inlist_select.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=1000 --skip-trx \
>& sb.o.random-points.range1000.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_inlist_select.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --hot-points --skip-trx \
>& sb.o.hot-points.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx \
>& sb.o.points-covered-pk.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --covered=false \
>& sb.o.points-notcovered-pk.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx \
>& sb.o.range-covered-pk.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --covered=false \
>& sb.o.range-notcovered-pk.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false \
>& sb.o.points-covered-si.warm.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false \
>& sb.o.points-covered-si.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_points_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false --covered=false \
>& sb.o.points-notcovered-si.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false \
>& sb.o.range-covered-si.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$rsecs $luabasepath/oltp_range_covered.lua run "${sbcreds[@]}" --rand-type=uniform --random-points=100 --skip-trx --on-id=false --covered=false \
>& sb.o.range-notcovered-si.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_delete.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.delete.range100.pk1.dop${nthreads}

LUA_PATH=$luapath $sysbench --db-driver=mysql --range-size=100 --table-size=${nrows} --tables=$ntabs --threads=$nthreads --events=0  --time=$wsecs $luabasepath/oltp_insert.lua run "${sbcreds[@]}" --rand-type=uniform \
>& sb.o.insert.range100.pk1.dop${nthreads}

