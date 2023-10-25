ntabs=$1
nr=$2
secs=$3
dbAndCreds=$4
setup=$5
cleanup=$6
testType=$7
range=$8
client=$9
tableoptions=${10}
sysbdir=${11}
ddir=${12}
dname=${13}
usepk=${14}
postwrite=${15}
prepstmt=${16}

#echo $@
shift 16

samp=1
nsamp=10000000

realdop=$( cat /proc/cpuinfo | grep "^processor" | wc -l )
#echo $realdop CPUs

testArgs=(--rand-type=uniform)

if [[ $testType == "read-only" || $testType == "read-only.pre" ]]; then
  lua="oltp_read_only.lua"
elif [[ $testType == "read-only-count" ]]; then
  lua="oltp_read_only_count.lua"
  testArgs=(--rand-type=uniform --skip-trx)
elif [[ $testType == "read-write" ]]; then
  lua="oltp_read_write.lua"
elif [[ $testType == "write-only" ]]; then
  lua="oltp_write_only.lua"
elif [[ $testType == "delete" ]]; then
  lua="oltp_delete.lua"
elif [[ $testType == "update-inlist" ]]; then
  lua="oltp_inlist_update.lua"
elif [[ $testType == "update-one" ]]; then
  lua="oltp_update_non_index.lua"
  nr=1
elif [[ $testType == "update-nonindex" ]]; then
  lua="oltp_update_non_index.lua"
elif [[ $testType == "update-zipf" ]]; then
  testArgs=(--rand-type=zipfian)
  lua="oltp_update_non_index.lua"
elif [[ $testType == "update-index" ]]; then
  lua="oltp_update_index.lua"
elif [[ $testType == "update-rate" ]]; then
  lua="oltp_update_rate.lua"
  testArgs=(--rand-type=uniform --update-rate=1000)
elif [[ $testType == "point-query" || $testType == "point-query.pre" || $testType == "point-query.warm" ]]; then
  lua="oltp_point_select.lua"
  testArgs=(--rand-type=uniform --skip-trx)
elif [[ $testType == "random-points" || $testType == "random-points.pre" ]]; then
  testArgs=(--rand-type=uniform --random-points=$range --skip-trx)
  lua="oltp_inlist_select.lua"
elif [[ $testType == "hot-points" ]]; then
  testArgs=(--rand-type=uniform --random-points=$range --hot-points --skip-trx)
  lua="oltp_inlist_select.lua"
elif [[ $testType == "points-covered-pk" || $testType == "points-covered-pk.pre" ]]; then
  lua="oltp_points_covered.lua"
  testArgs=(--rand-type=uniform --random-points=$range --skip-trx)
elif [[ $testType == "points-covered-si" || $testType == "points-covered-si.pre" ]]; then
  lua="oltp_points_covered.lua"
  testArgs=(--rand-type=uniform --random-points=$range --skip-trx --on-id=false)
elif [[ $testType == "points-notcovered-pk" || $testType == "points-notcovered-pk.pre" ]]; then
  lua="oltp_points_covered.lua"
  testArgs=(--rand-type=uniform --random-points=$range --skip-trx --covered=false)
elif [[ $testType == "points-notcovered-si" || $testType == "points-notcovered-si.pre" ]]; then
  lua="oltp_points_covered.lua"
  testArgs=(--rand-type=uniform --random-points=$range --skip-trx --on-id=false --covered=false)
elif [[ $testType == "range-covered-pk" || $testType == "range-covered-pk.pre" ]]; then
  lua="oltp_range_covered.lua"
  testArgs=(--rand-type=uniform --random-points=$range --skip-trx)
elif [[ $testType == "range-covered-si" || $testType == "range-covered-si.pre" ]]; then
  lua="oltp_range_covered.lua"
  testArgs=(--rand-type=uniform --random-points=$range --skip-trx --on-id=false)
elif [[ $testType == "range-notcovered-pk" || $testType == "range-notcovered-pk.pre" ]]; then
  lua="oltp_range_covered.lua"
  testArgs=(--rand-type=uniform --random-points=$range --skip-trx --covered=false)
elif [[ $testType == "range-notcovered-si" || $testType == "range-notcovered-si.pre" ]]; then
  lua="oltp_range_covered.lua"
  testArgs=(--rand-type=uniform --random-points=$range --skip-trx --on-id=false --covered=false)
elif [[ $testType == "insert" ]]; then
  lua="oltp_insert.lua"
elif [[ $testType == "scan" ]]; then
  lua="oltp_scan.lua"
else
echo Did not recognize testType $testType
exit 1
fi

oldIFS="$IFS"
IFS=","; read -ra dbA <<< "$dbAndCreds"
IFS="$oldIFS"

if [[ ${dbA[0]} == "mysql" ]]; then
  if [[ ${#dbA[@]} -ne 6 ]]; then
    echo "For MySQL expect 6 args (mysql,user,password,host,db,engine) got ${#dbA[@]} args from $dbAndCreds"
    exit -1
  fi

  sbDbCreds=(--mysql-user=${dbA[1]} --mysql-password=${dbA[2]} --mysql-host=${dbA[3]} --mysql-db=${dbA[4]})
  export MYSQL_PWD=${dbA[2]}
  clientArgs=(-u${dbA[1]} -h${dbA[3]} ${dbA[4]})
  engine=${dbA[5]}
  engineArg="--mysql-storage-engine=$engine"
  sqlF=e
  driver="mysql"
  $client "${clientArgs[@]}" -e 'reset master' 2> /dev/null

elif [[ ${dbA[0]} == "postgres" ]]; then
  if [[ ${#dbA[@]} -ne 5 ]]; then
    echo "For Postgres expect 5 args (postgres,user,password,host,db) got ${#dbA[@]} args from $dbAndCreds"
    exit -1
  fi
  sbDbCreds=(--pgsql-user=${dbA[1]} --pgsql-password=${dbA[2]} --pgsql-host=${dbA[3]} --pgsql-db=${dbA[4]})
  export PGPASSWORD=${dbA[2]}
  clientArgs=(-U${dbA[1]} -h${dbA[3]} ${dbA[4]})
  engine="pgsql"
  engineArg=""
  sqlF=c
  driver="pgsql"

else
  echo Could not parse dbAndCreds :: $dbAndCreds :: and first arg is ${dbA[0]}
  exit -1
fi

prepareArgs=""
if [[ $usepk -eq 0 ]]; then
  prepareArgs="--secondary "
fi

sfx="${testType}.range${range}.pk${usepk}"

# --- Setup ---

if [[ $setup -eq 1 ]]; then

echo Setup for $ntabs tables > sb.prepare.o.$sfx
echo Setup for $ntabs tables

for x in $( seq 1 $ntabs ); do
  echo Drop table sbtest$x >> sb.prepare.o.$sfx
  $client "${clientArgs[@]}" -${sqlF} "drop table if exists sbtest${x}" >> sb.prepare.o.$sfx 2>&1
  echo Done drop >> sb.prepare.o.$sfx
done

killall vmstat >& /dev/null
killall iostat >& /dev/null
vmstat $samp $nsamp >& sb.prepare.vm.$sfx &
vmpid=$!
iostat -y -kx $samp $nsamp >& sb.prepare.io.$sfx &
iopid=$!

if [[ ${dbA[0]} == "mysql" ]]; then
  while :; do date; ps aux | grep mysqld | grep basedir | grep datadir | grep -v mysqld_safe | grep -v grep; sleep 10; done >& sb.ps.$sfx &
  pspid=$!
elif [[ ${dbA[0]} == "postgres" ]]; then
  while :; do date; ps aux | grep postgres | grep -v python | grep -v psql | grep -v grep; sleep 10; done >& sb.ps.$sfx &
  pspid=$!
fi

start_secs=$( date +'%s' )
exA=(--db-driver=$driver $setupArgs $engineArg --range-size=$range --table-size=$nr --tables=$ntabs --events=0 --time=$secs $sysbdir/share/sysbench/$lua $prepareArgs prepare)
if [[ $client == *"oriole"* ]]; then 
  echo $sysbdir/bin/sysbench "${exA[@]}" "${sbDbCreds[@]}" --create-table-options="using orioledb" >> sb.prepare.o.$sfx
  $sysbdir/bin/sysbench "${exA[@]}" "${sbDbCreds[@]}" --create-table-options="using orioledb" >> sb.prepare.o.$sfx 2>&1
else
  echo $sysbdir/bin/sysbench "${exA[@]}" "${sbDbCreds[@]}" >> sb.prepare.o.$sfx
  $sysbdir/bin/sysbench "${exA[@]}" "${sbDbCreds[@]}" >> sb.prepare.o.$sfx 2>&1
fi
status=$?
if [[ $status != 0 ]]; then
  echo sysbench prepare failed, see sb.prepare.o.$sfx
  exit -1
fi

stop_secs=$( date +'%s' )
tot_secs=$(( $stop_secs - $start_secs ))
mrps=$( echo "scale=3; ( $ntabs * $nr ) / $tot_secs / 1000000.0" | bc )
rps=$( echo "scale=0; ( $ntabs * $nr ) / $tot_secs" | bc )
echo "Load seconds is $tot_secs for $ntabs tables, $mrps Mips, $rps ips" >> sb.prepare.o.$sfx

kill $pspid
kill $vmpid
kill $iopid
bash an.sh sb.prepare.io.$sfx sb.prepare.vm.$sfx $dname $rps $realdop > sb.prepare.met.$sfx

fi

# --- run sysbench tests ---

rm -f sb.r.trx.$sfx sb.r.qps.$sfx sb.r.rtavg.$sfx sb.r.rtmax.$sfx sb.r.rt95.$sfx

for nt in "$@"; do

if [[ $testType == "scan" && $nt -gt $ntabs ]]; then
  echo Skip because scan is limited to $ntabs threads
  continue
else
  echo Run for $nt threads at $( date )
fi

sfxn="$sfx.dop${nt}"
killall vmstat >& /dev/null
killall iostat >& /dev/null
vmstat $samp $nsamp >& sb.vm.$sfxn &
vmpid=$!
iostat -y -kx $samp $nsamp >& sb.io.$sfxn &
iopid=$!

if [[ ${dbA[0]} == "mysql" ]]; then
  while :; do date; ps aux | grep mysqld | grep basedir | grep datadir | grep -v mysqld_safe | grep -v grep; sleep 10; done >& sb.ps.$sfxn &
  pspid=$!
elif [[ ${dbA[0]} == "postgres" ]]; then
  while :; do date; ps aux | grep postgres | grep -v python | grep -v psql | grep -v grep; sleep 10; done >& sb.ps.$sfxn &
  pspid=$!
fi

perf=perf
PERF_METRIC=${PERF_METRIC:-cycles}
x=0
perfpid="-1"
if [ $x -gt 0 ]; then
fgp="$HOME/git/FlameGraph"
if [ ! -d $fgp ]; then echo FlameGraph not found; exit 1; fi
echo PERF_METRIC is $PERF_METRIC
while [ $x -eq 0 ]; do
  perf_secs=20
  pause_secs=10
  perf="perf"

  if [ $x -eq 0 ]; then
    sleep 60
  else
    sleep $pause_secs
  fi

  dbbpid=$( ps aux | grep mysqld | grep -v mysqld_safe | grep -v \/usr\/bin\/time | grep -v timeout | grep -v grep | awk '{ print $2 }' )
  if [ -z $dbbpid ]; then echo Cannot get mysqld PID; continue; fi

  hw_secs=10
  outf="sb.perf.hw.$sfx.$x"
  $perf stat -o $outf -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e cpu-clock,cycles,bus-cycles,instructions -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e cache-references,cache-misses,branches,branch-misses -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-icache-loads-misses -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e dTLB-loads,dTLB-load-misses,dTLB-stores,dTLB-store-misses,dTLB-prefetch-misses -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e iTLB-load-misses,iTLB-loads -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,LLC-prefetches -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e alignment-faults,context-switches,migrations,major-faults,minor-faults,faults -p $dbbpid -- sleep $hw_secs ; sleep 2

  outf="sb.perf.rec.g.$sfx.$x"
  echo "$perf record -e $PERF_METRIC -c 500000 -g -p $dbbpid -o $outf -- sleep $perf_secs"
  $perf record -e $PERF_METRIC -c 500000 -g -p $dbbpid -o $outf -- sleep $perf_secs

  sleep $pause_secs
  outf="sb.perf.rec.f.$sfx.$x"
  $perf record -c 500000 -p $dbbpid -o $outf -- sleep $perf_secs

  echo $x > sb.perf.last.$sfx
  x=$(( $x + 1 ))
done &
# This sets a global value
perfpid=$!
fi

# Optionally disable use of prepared statements
useps=""
if [[ $prepstmt == 0 ]]; then
  useps="--db-ps-mode=disable"
fi

if [[ $testType == "scan" ]]; then
  exA=(--db-driver=$driver --range-size=$range --table-size=$nr --tables=$ntabs --threads=$nt --events=1 --warmup-time=0 --time=0 $useps $sysbdir/share/sysbench/$lua run)
else
  exA=(--db-driver=$driver --range-size=$range --table-size=$nr --tables=$ntabs --threads=$nt --events=0 --warmup-time=5 --time=$secs $useps $sysbdir/share/sysbench/$lua run)
fi

if [[ $client == *"oriole"* ]]; then 
  echo $sysbdir/bin/sysbench "${exA[@]}" "${sbDbCreds[@]}" "${testArgs[@]}" --create-table-options="using orioledb"  > sb.o.$sfxn
  echo "$realdop CPUs" >> sb.o.$sfxn
  /usr/bin/time -o sb.time.$sfxn $sysbdir/bin/sysbench "${exA[@]}" "${sbDbCreds[@]}" "${testArgs[@]}" --create-table-options="using orioledb" >> sb.o.$sfxn 2>&1
else
  echo $sysbdir/bin/sysbench "${exA[@]}" "${sbDbCreds[@]}" "${testArgs[@]}"  > sb.o.$sfxn
  echo "$realdop CPUs" >> sb.o.$sfxn
  /usr/bin/time -o sb.time.$sfxn $sysbdir/bin/sysbench "${exA[@]}" "${sbDbCreds[@]}" "${testArgs[@]}" >> sb.o.$sfxn 2>&1
fi

if [ $perfpid -ge 0 ]; then
  kill $perfpid
fi

# Do this after sysbench is done because it can use a lot of CPU

last_loop=""
if [ -f sb.perf.last.$sfx ]; then

read last_loop < sb.perf.last.$sfx
echo last_loop is $last_loop for $sfx

if [[ ! -z $last_loop && $last_loop -ge 0 ]]; then
for x in $( seq 0 $last_loop ); do
  echo forloop $x perf rep for $sfx 
  #$perf report --stdio --no-children -i $outf > sb.perf.rep.g.f0.c0.$sfx.$x
  #$perf report --stdio --children    -i $outf > sb.perf.rep.g.f0.c1.$sfx.$x
  #$perf report --stdio -n -g folded -i $outf > sb.perf.rep.g.f1.cother.$sfx.$x

  outf="sb.perf.rec.g.$sfx.$x"
  $perf report --stdio -n -g folded -i $outf --no-children > sb.perf.rep.g.f1.c0.$sfx.$x
  $perf report --stdio -n -g folded -i $outf --children > sb.perf.rep.g.f1.c1.$sfx.$x
  $perf script -i $outf > sb.perf.rep.g.scr.$sfx.$x
  gzip --fast $outf

  cat sb.perf.rep.g.scr.$sfx.$x | $fgp/stackcollapse-perf.pl > sb.perf.g.fold.$sfx.$x
  $fgp/flamegraph.pl sb.perf.g.fold.$sfx.$x > sb.perf.g.$sfx.$x.svg
  gzip --fast sb.perf.rep.g.scr.$sfx.$x

  outf="sb.perf.rec.f.$sfx.$x"
  $perf report --stdio -i $outf > sb.perf.rep.f.$sfx.$x
  $perf script -i $outf | gzip --fast > sb.perf.rep.f.scr.$sfx.$x.gz
  gzip --fast $outf
done
fi
fi

kill $pspid
kill $vmpid
kill $iopid
qps=$( grep queries: sb.o.$sfxn | awk '{ print $3 }' | tr -d '(' )

if [[ $testType == "scan" ]]; then
  # For scan use rows per second rather than queries per second
  nsecs=$( cat sb.o.$sfx.dop${nt} | grep "time elapsed:" | awk '{ print $3 }' | sed 's/s$//' )
  qps=$( echo $nr $ntabs $nsecs | awk '{ printf "%.3f\t", ($1 * $2) / $3 }' )
fi

bash an.sh sb.io.$sfxn sb.vm.$sfxn $dname $qps $realdop > sb.met.$sfxn

if [[ $driver == "mysql" ]]; then
  $client "${clientArgs[@]}" -e "show engine $engine status\G" >& sb.es.$sfx
  $client "${clientArgs[@]}" -e "show indexes from sbtest1\G" >& sb.is.$sfx
  $client "${clientArgs[@]}" -e "show global variables" >& sb.gv.$sfx
  $client "${clientArgs[@]}" -e "show global status\G" >& sb.gs.$sfx
  $client "${clientArgs[@]}" -e "show table status\G" >& sb.ts.$sfx
  $client "${clientArgs[@]}" -e 'reset master' 2> /dev/null

elif [[ $driver == "pgsql" ]]; then
  $client "${clientArgs[@]}" -c 'show all' > sb.pg.conf.$sfx
  $client "${clientArgs[@]}" -x -c 'select * from pg_stat_io' > sb.pgs.io.$sfx
  $client "${clientArgs[@]}" -x -c 'select * from pg_stat_bgwriter' > sb.pgs.bg.$sfx
  $client "${clientArgs[@]}" -x -c 'select * from pg_stat_database' > sb.pgs.db.$sfx
  $client "${clientArgs[@]}" -x -c "select * from pg_stat_all_tables where schemaname='public'" > sb.pgs.tabs.$sfx
  $client "${clientArgs[@]}" -x -c "select * from pg_stat_all_indexes where schemaname='public'" > sb.pgs.idxs.$sfx
  $client "${clientArgs[@]}" -x -c "select * from pg_statio_all_tables where schemaname='public'" > sb.pgi.tabs.$sfx
  $client "${clientArgs[@]}" -x -c "select * from pg_statio_all_indexes where schemaname='public'" > sb.pgi.idxs.$sfx
  $client "${clientArgs[@]}" -x -c 'select * from pg_statio_all_sequences' > sb.pgi.seq.$sfx
fi

echo "sum of data and index length columns in GB" >> sb.ts.$sfx
cat sb.ts.$sfx  | grep "Data_length"  | awk '{ s += $2 } END { printf "%.3f\n", s / (1024*1024*1024) }' >> sb.ts.$sfx
cat sb.ts.$sfx  | grep "Index_length" | awk '{ s += $2 } END { printf "%.3f\n", s / (1024*1024*1024) }' >> sb.ts.$sfx

done

du -hs $ddir > sb.sz.$sfx
echo "with apparent size " >> sb.sz.$sfx
du -hs --apparent-size $ddir >> sb.sz.$sfx
echo "all" >> sb.sz.$sfx
du -hs ${ddir}/* >> sb.sz.$sfx

# --- Postwrite ---

if [[ $postwrite -eq 1 ]]; then
  # This is optional and can be run after a test step
  # Goals:
  #  1) Flush dirty data (b-tree writeback, LSM compaction), but without shutting down the DBMS
  #  2) Get LSM tree into deterministic state
  #  3) Collect stats

  # Sleep for 60 + 60 seconds per 10M rows
  sleepSecs=$( echo $nr $ntabs | awk '{ printf "%.0f", ((($1 * $2) / 10000000) + 1) * 60 }' )
  echo sleepSecs is $sleepSecs > sb.o.pw.$sfx

  if [[ $driver == "mysql" ]]; then
    $client "${clientArgs[@]}" -e 'reset master' 2> /dev/null

    if [[ $engine == "innodb" ]]; then
      maxDirty=$( $client "${clientArgs[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct"' | awk '{ print $2 }' )
      maxDirtyLwm=$( $client "${clientArgs[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct_lwm"' | awk '{ print $2 }' )
      # This option is only in 8.0.18+
      idlePct=$( $client "${clientArgs[@]}" -N -B -e 'show global variables like "innodb_idle_flush_pct"' 2> /dev/null | awk '{ print $2 }' )

      echo "Reduce max_dirty to 0 to flush InnoDB buffer pool" >> sb.o.pw.$sfx
      $client "${clientArgs[@]}" -e 'set global innodb_max_dirty_pages_pct_lwm=0' >> sb.o.pw.$sfx 2>&1
      $client "${clientArgs[@]}" -e 'set global innodb_max_dirty_pages_pct=0' >> sb.o.pw.$sfx 2>&1
      echo "Increase idle_pct to 100 to flush InnoDB buffer pool" >> sb.o.pw.$sfx
      $client "${clientArgs[@]}" -e 'set global innodb_idle_flush_pct=100' >> sb.o.pw.$sfx 2>&1

    elif [[ $engine == "rocksdb" ]]; then
      echo Enable flush memtable and L0 in 2 parts >> sb.o.pw.$sfx
      $client "${clientArgs[@]}" -e "show engine rocksdb status\G" >& sb.o.pw.es1.$sfx
      $client "${clientArgs[@]}" -e 'set global rocksdb_force_flush_memtable_now=1' >> sb.o.pw.$sfx 2>&1
      sleep 60
      $client "${clientArgs[@]}" -e "show engine rocksdb status\G" >& sb.o.pw.es2.$sfx
      $client "${clientArgs[@]}" -e 'set global rocksdb_force_flush_memtable_and_lzero_now=1' >> sb.o.pw.$sfx 2>&1
      sleep 60
      $client "${clientArgs[@]}" -e "show engine rocksdb status\G" >& sb.o.pw.es3.$sfx
    fi

    for x in $( seq 1 $ntabs ); do
      echo Analyze table sbtest${x} >> sb.o.pw.$sfx
      /usr/bin/time -o sb.o.pw.$sfx.a${x} $client "${clientArgs[@]}" -${sqlF} "analyze table sbtest${x}" >> sb.o.pw.$sfx 2>&1
    done

    echo "Sleep for $sleepSecs with engine $engine" >> sb.o.pw.$sfx
    sleep $sleepSecs

    if [[ $engine == "innodb" ]]; then
      echo "Reset max_dirty to $maxDirty and lwm to $maxDirtyLwm" >> sb.o.pw.$sfx
      $client "${clientArgs[@]}" -e "set global innodb_max_dirty_pages_pct=$maxDirty" >> sb.o.pw.$sfx 2>&1
      $client "${clientArgs[@]}" -e "set global innodb_max_dirty_pages_pct_lwm=$maxDirtyLwm" >> sb.o.pw.$sfx 2>&1
      echo "Reset idle_pct to $idlePct" >> sb.o.pw.$sfx
      $client "${clientArgs[@]}" -e "set global innodb_idle_flush_pct=$idlePct" >> sb.o.pw.$sfx 2>&1

    elif [[ $engine == "rocksdb" ]]; then
      echo Nothing to do for MyRocks after sleep >> sb.o.pw.$sfx
    fi

  elif [[ $driver == "pgsql" ]]; then
    if [[ $client == *"oriole"* ]]; then 
    for x in $( seq 1 $ntabs ); do
      echo analyze sbtest${x} >> sb.o.pw.$sfx
      echo $client "${clientArgs[@]}" -${sqlF} "analyze sbtest${x}" 
      /usr/bin/time -o sb.o.pw.$sfx.a${x} $client "${clientArgs[@]}" -${sqlF} "analyze sbtest${x}" > sb.o.pw.$sfx.a2${x} 2>&1 &
      pids[${n}]=$!
    done
    else
    for x in $( seq 1 $ntabs ); do
      echo Vacuum analyze table sbtest${x} >> sb.o.pw.$sfx
      echo $client "${clientArgs[@]}" -${sqlF} "vacuum (analyze, verbose) sbtest${x}" 
      /usr/bin/time -o sb.o.pw.$sfx.a${x} $client "${clientArgs[@]}" -${sqlF} "vacuum (analyze, verbose) sbtest${x}" > sb.o.pw.$sfx.a2${x} 2>&1 &
      pids[${n}]=$!
    done
    fi

    for x in $( seq 1 $ntabs ); do
      wait ${pids[${n}]}
    done

    if [[ $client == *"oriole"* ]]; then 
    # TODO is checkpoint needed for OrioleDB?
    echo Checkpoint >> sb.o.pw.$sfx
    echo $client "${clientArgs[@]}" -${sqlF} "checkpoint" 
    /usr/bin/time -o sb.o.pw.$sfx.cp $client "${clientArgs[@]}" -${sqlF} "checkpoint" >> sb.o.pw.$sfx.cp2 2>&1 &
    cpid=$!
    echo "Sleep for $sleepSecs" >> sb.o.pw.$sfx
    sleep $sleepSecs
    wait $cpid
    else
    echo Checkpoint >> sb.o.pw.$sfx
    echo $client "${clientArgs[@]}" -${sqlF} "checkpoint" 
    /usr/bin/time -o sb.o.pw.$sfx.cp $client "${clientArgs[@]}" -${sqlF} "checkpoint" >> sb.o.pw.$sfx.cp2 2>&1 &
    cpid=$!
    echo "Sleep for $sleepSecs" >> sb.o.pw.$sfx
    sleep $sleepSecs
    wait $cpid
    fi

  fi

fi # if postwrite ...

if [[ $cleanup == 1 ]]; then

echo Cleanup
echo Cleanup > sb.cleanup.$sfx
for x in $( seq 1 $ntabs ); do
  echo Drop table sbtest${x} >> sb.cleanup.$sfx
  $client "${clientArgs[@]}" -${sqlF} "drop table if exists sbtest${x}" >> sb.prepare.$sfx 2>&1
done

fi

for nt in "$@"; do
  grep transactions: sb.o.$sfx.dop${nt} | awk '{ print $3 }' | tr -d '(' | awk '{ printf "%.0f\t", $1 }' 
done > sb.r.trx.$sfx
echo "$engine $testType range=$range" >> sb.r.trx.$sfx

for nt in "$@"; do
if [[ $testType == "scan" ]]; then
  # For scan print millions of rows per second scanned rather than QPS
  if [[ $nt -gt $ntabs ]]; then
    printf "0\t"
  else
    nsecs=$( cat sb.o.$sfx.dop${nt} | grep "time elapsed:" | awk '{ print $3 }' | sed 's/s$//' )
    echo $nr $ntabs $nsecs | awk '{ printf "%.3f\t", ($1 * $2) / 1000000.0 / $3 }'
  fi
else
  grep queries: sb.o.$sfx.dop${nt} | awk '{ print $3 }' | tr -d '(' | awk '{ printf "%.0f\t", $1 }' 
fi
done > sb.r.qps.$sfx
echo "$engine $testType range=$range" >> sb.r.qps.$sfx

for nt in "$@"; do
  grep avg: sb.o.$sfx.dop${nt} | awk '{ print $2 }' | awk '{ printf "%s\t", $1 }' 
done > sb.r.rtavg.$sfx
echo "$engine $testType range=$range" >> sb.r.rtavg.$sfx

for nt in "$@"; do
  grep max: sb.o.$sfx.dop${nt} | awk '{ print $2 }' | awk '{ printf "%s\t", $1 }' 
done > sb.r.rtmax.$sfx
echo "$engine $testType range=$range" >> sb.r.rtmax.$sfx

for nt in "$@"; do
  grep percentile: sb.o.$sfx.dop${nt} | awk '{ print $3 }' | awk '{ printf "%s\t", $1 }' 
done > sb.r.rt95.$sfx
echo "$engine $testType range=$range" >> sb.r.rt95.$sfx

du -hs $ddir > sb.sz.$sfx
echo "with apparent size " >> sb.sz.$sfx
du -hs --apparent-size $ddir >> sb.sz.$sfx
echo "all" >> sb.sz.$sfx
du -hs ${ddir}/* >> sb.sz.$sfx

ls -asShR $ddir > sb.lsh.r.$sfx

ddirs=( $ddir $ddir/data $ddir/data/.rocksdb $ddir/base $ddir/global )
x=0
for xd in ${ddirs[@]}; do
  if [ -d $xd ]; then
    ls -asS --block-size=1M $xd > sb.ls.${x}.$sfx
    ls -asSh $xd > sb.lsh.${x}.$sfx
    x=$(( $x + 1 ))
  fi
done

cat sb.ls.*.$sfx | grep -v "^total" | sort -rnk 1,1 > sb.lsa.$sfx

