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
elif [[ $testType == "read-only-simple" ]]; then
  testArgs=( --rand-type=uniform --simple-ranges=1 --sum-ranges=0 --order-ranges=0 --distinct-ranges=0 )
  lua="oltp_read_only.lua"
elif [[ $testType == "read-only-sum" ]]; then
  testArgs=( --rand-type=uniform --simple-ranges=0 --sum-ranges=1 --order-ranges=0 --distinct-ranges=0 )
  lua="oltp_read_only.lua"
elif [[ $testType == "read-only-order" ]]; then
  testArgs=( --rand-type=uniform --simple-ranges=0 --sum-ranges=0 --order-ranges=1 --distinct-ranges=0 )
  lua="oltp_read_only.lua"
elif [[ $testType == "read-only-distinct" ]]; then
  testArgs=( --rand-type=uniform --simple-ranges=0 --sum-ranges=0 --order-ranges=0 --distinct-ranges=1 )
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
elif [[ $testType == "points-covered-si" || $testType == "points-covered-si.pre" || $testType == "points-covered-si.warm" ]]; then
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
elif [[ $testType == "scan" || $testType == "scan.warm" || $testType == "scan.warmpre" ]]; then
  lua="oltp_scan.lua"
else
echo Did not recognize testType $testType
exit 1
fi

oldIFS="$IFS"
IFS=","; read -ra dbA <<< "$dbAndCreds"
IFS="$oldIFS"

if [[ ${dbA[0]} == "mysql" || ${dbA[0]} == "mariadb" ]]; then
  if [[ ${#dbA[@]} -ne 6 ]]; then
    echo "For MySQL expect 6 args (mysql,user,password,host,db,engine) got ${#dbA[@]} args from $dbAndCreds"
    exit -1
  fi

  sbDbCreds=(--mysql-user=${dbA[1]} --mysql-password=${dbA[2]} --mysql-host=${dbA[3]} --mysql-db=${dbA[4]})
  export MYSQL_PWD=${dbA[2]}
  clientArgs=(-u${dbA[1]} -p${dbA[2]} -h${dbA[3]} ${dbA[4]})
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
lua_path="$sysbdir/?.lua"

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
  while :; do date; ps aux | grep mysqld | grep basedir | grep datadir | grep -v mysqld_safe | grep -v grep; sleep 10; done >& sb.prepare.ps.$sfx &
  pspid=$!
elif [[ ${dbA[0]} == "mariadb" ]]; then
  while :; do date; ps aux | grep mariadbd | grep basedir | grep datadir | grep -v mariadbd-safe | grep -v grep; sleep 10; done >& sb.prepare.ps.$sfx &
  pspid=$!
elif [[ ${dbA[0]} == "postgres" ]]; then
  while :; do date; ps aux | grep postgres | grep -v python | grep -v psql | grep -v grep; sleep 10; done >& sb.prepare.ps.$sfx &
  pspid=$!
fi

start_secs=$( date +'%s' )
exA=(--db-driver=$driver $setupArgs $engineArg --range-size=$range --table-size=$nr --tables=$ntabs --events=0 --time=$secs $sysbdir/$lua $prepareArgs prepare)
if [[ $client == *"oriole"* ]]; then 
  echo LUA_PATH="$lua_path" $sysbdir/sysbench "${exA[@]}" "${sbDbCreds[@]}" --create-table-options="using orioledb" >> sb.prepare.o.$sfx
  LUA_PATH="$lua_path" $sysbdir/sysbench "${exA[@]}" "${sbDbCreds[@]}" --create-table-options="using orioledb" >> sb.prepare.o.$sfx 2>&1
else
  echo LUA_PATH="$lua_path" $sysbdir/sysbench "${exA[@]}" "${sbDbCreds[@]}" >> sb.prepare.o.$sfx
  LUA_PATH="$lua_path" $sysbdir/sysbench "${exA[@]}" "${sbDbCreds[@]}" >> sb.prepare.o.$sfx 2>&1
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

echo Run for $nt threads at $( date )

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
  while :; do date; $client "${clientArgs[@]}" -e 'show processlist'; sleep 30; done > sb.espl.$sfx &
  splid=$!
  while :; do date; $client "${clientArgs[@]}" -e "show engine $engine status" -E ; sleep 30; done > sb.sei.$sfx &
  seid=$!
elif [[ ${dbA[0]} == "mariadb" ]]; then
  while :; do date; ps aux | grep mariadbd | grep basedir | grep datadir | grep -v mariadbd-safe | grep -v grep; sleep 10; done >& sb.ps.$sfxn &
  pspid=$!
  while :; do date; $client "${clientArgs[@]}" -e 'show processlist'; sleep 30; done > sb.espl.$sfx &
  splid=$!
  while :; do date; $client "${clientArgs[@]}" -e "show engine $engine status" -E ; sleep 30; done > sb.sei.$sfx &
  seid=$!
elif [[ ${dbA[0]} == "postgres" ]]; then
  while :; do date; ps aux | grep postgres | grep -v python | grep -v psql | grep -v grep; sleep 10; done >& sb.ps.$sfxn &
  pspid=$!
fi

COLUMNS=400 LINES=50 top -b -d 60 -c -w >& sb.top.$sfxn &
topid=$!

perf=perf

PERF_METRIC=${PERF_METRIC:-cycles}
if [[ $PERF_METRIC != "cycles" ]]; then
  counter=$( echo $PERF_METRIC | tr ':' ' ' | awk '{ print $3 }' )
  F_or_c=$( echo $PERF_METRIC | tr ':' ' ' | awk '{ print $2}' )
  perf_event_list=$( echo $PERF_METRIC | tr ':' ' ' | awk '{ print $1 }' )
  perf_event_str="-e $perf_event_list -${F_or_c} $counter"
else
  perf_event_list="cycles"
  perf_event_str="-e cycles -F 999"
fi

doperf1=0 ; perf_loop_sleep=30
doperf2=1 ; perf_loop_sleep=50
doperf3=0 ; perf_loop_sleep=50
doperf4=0 ; perf_loop_sleep=30

x=0
perfpid="-1"
if [ $x -gt 0 ]; then
fgp="$HOME/git/FlameGraph"
if [ ! -d $fgp ]; then echo FlameGraph not found; exit 1; fi
echo PERF_METRIC is $PERF_METRIC used as $perf_event_str
while :; do
  perf="perf"

  #echo sleep at start
  sleep $perf_loop_sleep

  if [[ ${dbA[0]} == "mysql" ]]; then
    dbbpid=$( ps aux | grep mysqld | grep -v mysqld_safe | grep -v \/usr\/bin\/time | grep -v timeout | grep -v grep | awk '{ print $2 }' )
  elif [[ ${dbA[0]} == "mariadb" ]]; then
    dbbpid=$( ps aux | grep mariadbd | grep -v mariadbd-safe | grep -v \/usr\/bin\/time | grep -v timeout | grep -v grep | awk '{ print $2 }' )
    if [ -z $dbbpid ]; then
      dbbpid=$( ps aux | grep mysqld | grep -v mysqld_safe | grep -v \/usr\/bin\/time | grep -v timeout | grep -v grep | awk '{ print $2 }' )
    fi
  else
    fn="sb.pgid.0"
    dbbpid=$( cat $fn | awk '{ print $2 }' )
    echo Using Postgres backend PID :: $dbbpid :: from $fn
  fi

  echo dbbpid is :: $dbbpid ::
  if [ -z $dbbpid ]; then echo Cannot get mysqld PID; continue; fi

  hw_secs=10
  if [[ doperf1 -eq 1 ]]; then
  outf="sb.perf.hw.$sfx.$x"
  $perf stat -o $outf -e cpu-clock,cycles,bus-cycles,instructions,branches,branch-misses -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e cache-references,cache-misses,stalled-cycles-backend,stalled-cycles-frontend -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e dTLB-loads,dTLB-load-misses,dTLB-stores,dTLB-store-misses -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e iTLB-load-misses,iTLB-loads,L1-icache-loads-misses,L1-icache-loads -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,LLC-prefetches -p $dbbpid -- sleep $hw_secs ; sleep 2
  $perf stat -o $outf --append -e alignment-faults,context-switches,migrations,major-faults,minor-faults,faults -p $dbbpid -- sleep $hw_secs ; sleep 2

  # dTLB-prefetch-misses
  # $perf stat -o $outf --append -e mem-stores,mem-loads -p $dbbpid -- sleep $hw_secs ; sleep 2
  fi

  if [[ doperf2 -eq 1 ]]; then
  perf_get_secs=10
  outf="sb.perf.rec.g.$sfx.$x"
  #$perf record -e $PERF_METRIC -c 500000 -g -p $dbbpid -o $outf -- sleep $perf_get_secs
  echo "$perf record $perf_event_str -g -p $dbbpid -o $outf -- sleep $perf_get_secs"
  $perf record $perf_event_str -g -p $dbbpid -o $outf -- sleep $perf_get_secs
  fi

  if [[ doperf3 -eq 1 ]]; then
  perf_get_secs=10
  outf="sb.perf.rec.f.$sfx.$x"
  #$perf record -c 500000 -p $dbbpid -o $outf -- sleep $perf_get_secs
  $perf record $perf_event_str -p $dbbpid -o $outf -- sleep $perf_get_secs
  fi

  if [[ doperf4 -eq 1 ]]; then
    outf="sb.pmp.$sfx.$x"
    bash pmpf.sh $dbbpid $outf
  fi

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

pgid=""
if [[ ${dbA[0]} == "postgres" ]]; then
pgid="--pgsql_conn_id=true "
fi

repint=""
#repint="--report-interval=10"
#repint="--report-checkpoints=30,60,90,120,150,180"

exA=(--db-driver=$driver --range-size=$range --table-size=$nr --tables=$ntabs --threads=$nt --events=0 --warmup-time=5 --time=$secs $useps $repint $pgid $sysbdir/$lua run)

if [[ $client == *"oriole"* ]]; then 
  echo LUA_PATH="$lua_path" $sysbdir/sysbench "${exA[@]}" "${sbDbCreds[@]}" "${testArgs[@]}" --create-table-options="using orioledb"  > sb.o.$sfxn
  echo "$realdop CPUs" >> sb.o.$sfxn
  LUA_PATH="$lua_path" /usr/bin/time -o sb.time.$sfxn $sysbdir/sysbench "${exA[@]}" "${sbDbCreds[@]}" "${testArgs[@]}" --create-table-options="using orioledb" >> sb.o.$sfxn 2>&1
else
  echo LUA_PATH="$lua_path" $sysbdir/sysbench "${exA[@]}" "${sbDbCreds[@]}" "${testArgs[@]}"  > sb.o.$sfxn
  echo "$realdop CPUs" >> sb.o.$sfxn
  LUA_PATH="$lua_path" /usr/bin/time -o sb.time.$sfxn $sysbdir/sysbench "${exA[@]}" "${sbDbCreds[@]}" "${testArgs[@]}" >> sb.o.$sfxn 2>&1
fi

if [ $perfpid -ge 0 ]; then
  kill $perfpid
fi

kill $pspid
kill $vmpid
kill $iopid
kill $topid
if [[ ${dbA[0]} != "postgres" ]]; then
  kill $seid
  kill $splid
fi

# Do this after sysbench is done because it can use a lot of CPU

last_loop=""
if [ -f sb.perf.last.$sfx ]; then

read last_loop < sb.perf.last.$sfx
echo last_loop is $last_loop for $sfx

if [[ ! -z $last_loop && $last_loop -ge 0 ]]; then
for x in $( seq 1 $last_loop ); do
  #echo forloop $x perf rep for $sfx 

  if [[ doperf1 -eq 1 ]]; then
    # post-processing for "perf stat"
    inf="sb.perf.hw.$sfx.$x"
    bash grep_perfstat.sh $inf > ${inf}.raw ; sort -k 1,1 ${inf}.raw > ${inf}.sorted
  fi

  if [[ doperf2 -eq 1 ]]; then
    perf_record_outf="sb.perf.rec.g.$sfx.$x"

    $perf report --stdio -g graph -i ${perf_record_outf} > sb.perf.rep.g.graph.$sfx.$x
    gzip --fast sb.perf.rep.g.graph.$sfx.$x

    $perf report --stdio -g flat -i ${perf_record_outf} > sb.perf.rep.g.flat.$sfx.$x
    gzip --fast sb.perf.rep.g.flat.$sfx.$x

    #$perf script -i ${perf_record_outf} > sb.perf.rep.g.scr.$sfx.$x
    $perf script -i ${perf_record_outf} --per-event-dump
    # gzip --fast ${perf_record_outf}
    rm ${perf_record_outf}

    parsed_events=$( echo $perf_event_list | tr ',' ' ' )

    for event in $( echo $parsed_events ) ; do
      echo SVG for $event
      cat  ${perf_record_outf}.${event}.dump | $fgp/stackcollapse-perf.pl > sb.perf.g.fold.${event}.$sfx.$x
      $fgp/flamegraph.pl sb.perf.g.fold.${event}.$sfx.$x > sb.perf.g.${event}.$sfx.$x.svg
      gzip --fast sb.perf.g.${event}.$sfx.$x.svg
      rm ${perf_record_outf}.${event}.dump
    done

  fi

  if [[ doperf3 -eq 1 ]]; then
    outf="sb.perf.rec.f.$sfx.$x"
    $perf report --stdio -i $outf > sb.perf.rep.f.$sfx.$x
    rm $outf
  fi

done

if [[ doperf2 -eq 1 ]]; then
  parsed_events=$( echo $perf_event_list | tr ',' ' ' )
  for event in $( echo $parsed_events ) ; do
    cat sb.perf.g.fold.${event}.$sfx.* | $fgp/flamegraph.pl > sb.perf.g.${event}.$sfx.all.svg
    rm sb.perf.g.fold.${event}.$sfx.*
    rm -f sb.perf.rec.g.$sfx.*
  done
fi

if [[ doperf4 -eq 1 ]]; then
  # post-processing for PMP
  outf="sb.pmp.$sfx.$x"
  cat sb.pmp.$sfx.*.flat \
    | awk 'BEGIN { s = ""; }  /^Thread/ { print s; s = ""; } /^#/ { x=index($2, "0x"); if (x == 1) { n=$4 } else { n=$2 }; if (s != "" ) { s = s "," n} else { s = n } } END { print s }' -  \
    | sort \
    | uniq -c \
    | sort -r -n -k 1,1 > sb.pmp.$sfx.all.hier
fi

fi
fi

if [[ $testType == "scan" || $testType == "scan.warm" || $testType == "scan.warmpre" ]]; then
  # avg:                              1731583.13
  scan_latency_ms=$( cat sb.o.$sfx.dop${nt} | grep avg: | awk '{ printf $2 }' )
  Krps=$( echo $nr $scan_latency_ms | awk '{ printf "%.0f", (( $1 / 1000.0 ) / ( $2 / 1000.0 )) }' )
  qps=$Krps
  echo Krps $Krps and scan_latency_ms $scan_latency_ms and qps $qps
else
  qps=$( grep queries: sb.o.$sfxn | awk '{ print $3 }' | tr -d '(' )
fi

bash an.sh sb.io.$sfxn sb.vm.$sfxn $dname $qps $realdop > sb.met.$sfxn

ps aux > sb.end.ps.$sfx

if [[ $driver == "mysql" ]]; then
  if [[ $engine == "rocksdb" ]]; then
    $client "${clientArgs[@]}" < frag.sql >& sb.frag.$sfx
  fi
  $client "${clientArgs[@]}" -e "show memory status" -E >& sb.mem.$sfx
  $client "${clientArgs[@]}" -e "show engine $engine status" -E >& sb.es.$sfx
  $client "${clientArgs[@]}" -e "show indexes from sbtest1" -E >& sb.is.$sfx
  $client "${clientArgs[@]}" -e "show global variables" >& sb.gv.$sfx
  $client "${clientArgs[@]}" -e "show global status" -E >& sb.gs.$sfx
  $client "${clientArgs[@]}" -e "show table status" -E >& sb.ts.$sfx
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

  total_nr=$(( nr * ntabs ))
  # Sleep for 60s + 1s per 1M rows, with a max of 1200s
  sleep_secs=$( echo $total_nr | awk '{ nsecs = ($1 / 1000000) + 60; if (nsecs > 1200) nsecs = 1200; printf "%.0f", nsecs }' )
  start_secs=$( date +%s )
  done_secs=$(( start_secs + sleep_secs ))

  if [[ $driver == "mysql" ]]; then
    $client "${clientArgs[@]}" -e 'reset master' 2> /dev/null

    echo "vac_my starts at $( date ) with sleep_secs = $sleep_secs" > sb.o.myvac
    echo nr is :: $total_nr :: and ntabs is :: $ntabs :: >> sb.o.myvac

    for x in $( seq 1 $ntabs ); do
      echo Analyze table sbtest${x} >> sb.o.myvac
      /usr/bin/time -o sb.o.myvac.time.$x $client "${clientArgs[@]}" -e "analyze table sbtest${x}" > sb.o.myvac.at.$x 2>&1 &
      apid[${x}]=$!
    done

    if [[ $engine == "innodb" ]]; then
      $client "${clientArgs[@]}" -e "show engine innodb status" -E >& sb.o.myvac.es1
      maxDirty=$( $client "${clientArgs[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct"' | awk '{ print $2 }' )
      maxDirtyLwm=$( $client "${clientArgs[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct_lwm"' | awk '{ print $2 }' )
      # This option is only in 8.0.18+
      idlePct=$( $client "${clientArgs[@]}" -N -B -e 'show global variables like "innodb_idle_flush_pct"' 2> /dev/null | awk '{ print $2 }' )

      echo "Reduce max_dirty to 0 to flush InnoDB buffer pool" >> sb.o.myvac
      $client "${clientArgs[@]}" -e 'set global innodb_max_dirty_pages_pct_lwm=1' >> sb.o.myvac 2>&1
      $client "${clientArgs[@]}" -e 'set global innodb_max_dirty_pages_pct=1' >> sb.o.myvac 2>&1
      echo "Increase idle_pct to 100 to flush InnoDB buffer pool" >> sb.o.myvac
      $client "${clientArgs[@]}" -e 'set global innodb_idle_flush_pct=100' >> sb.o.myvac 2>&1
      $client "${clientArgs[@]}" -e 'show global variables' >> sb.o.myvac.show.1 2>&1

    elif [[ $engine == "rocksdb" ]]; then

      $client "${clientArgs[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es0
      loop=0
      while :; do
        loop=$(( loop + 1 ))
	echo "Wait for RocksDB compaction to stop at $( date )" | tee -a sb.o.myvac

        $client "${clientArgs[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es1.loop${loop}
        $client "${clientArgs[@]}" -e "select * from information_schema.rocksdb_active_compaction_stats" -B >& sb.o.myvac.rxstats.loop${loop}
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
      $client "${clientArgs[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es1
      echo "Flush memtable at $( date )" >> sb.o.myvac
      $client "${clientArgs[@]}" -e 'set global rocksdb_force_flush_memtable_now=1' >> sb.o.myvac 2>&1
      sleep 20
      echo "Flush lzero at $( date )" >> sb.o.myvac
      $client "${clientArgs[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es2
      # Not safe to use, see issues 1200 and 1295
      #$client "${clientArgs[@]}" -e 'set global rocksdb_force_flush_memtable_and_lzero_now=1' >> sb.o.myvac 2>&1
      # Alas, this only works on releases from mid 2023 or more recent
      $client "${clientArgs[@]}" -e 'set global rocksdb_compact_lzero_now=1' >> sb.o.myvac 2>&1
    fi

    now_secs=$( date +%s )
    if [[ now_secs -lt done_secs ]]; then
      diff_secs=$(( done_secs - now_secs ))
      echo Sleep $diff_secs >> sb.o.myvac
      sleep $diff_secs
    fi

    for x in $( seq 1 $ntabs ); do
      echo After load: wait for analyze $n >> sb.o.myvac
      wait ${apid[${x}]}
    done
    echo "Done waiting for analyze" >> sb.o.myvac

    if [[ $engine == "innodb" ]]; then
      echo "Reset max_dirty to $maxDirty and lwm to $maxDirtyLwm" >> sb.o.myvac
      $client "${clientArgs[@]}" -e "set global innodb_max_dirty_pages_pct=$maxDirty" >> sb.o.myvac 2>&1
      $client "${clientArgs[@]}" -e "set global innodb_max_dirty_pages_pct_lwm=$maxDirtyLwm" >> sb.o.myvac 2>&1
      echo "Reset idle_pct to $idlePct" >> sb.o.myvac
      $client "${clientArgs[@]}" -e "set global innodb_idle_flush_pct=$idlePct" >> sb.o.myvac 2>&1
      $client "${clientArgs[@]}" -e 'show global variables' >> sb.o.myvac.show.2 2>&1
      $client "${clientArgs[@]}" -e "show engine innodb status" -E >& sb.o.myvac.es3
    elif [[ $engine == "rocksdb" ]]; then
      $client "${clientArgs[@]}" -e "show engine rocksdb status" -E >& sb.o.myvac.es3
    fi

    now_secs=$( date +%s )
    diff_secs=$(( now_secs - start_secs ))
    echo "vac_my done after $diff_secs at $( date )" >> sb.o.myvac

  elif [[ $driver == "pgsql" ]]; then

    # if [[ $client == *"oriole"* ]]; then
    # TODO is checkpoint needed for OrioleDB?

    echo "pg_vac starts at $( date ) with sleep_secs = $sleep_secs" > sb.o.pgvac
    echo nr is :: $total_nr :: and ntabs is :: $ntabs :: >> sb.o.pgvac

    major_version=$( PGPASSWORD="pw" $client "${clientArgs[@]}" -x -c 'show server_version_num' | grep server_version_num | awk '{ print $3 }' )
    vac_args="(verbose, analyze)"
    if [[ $major_version -ge 120000 ]]; then
      vac_args="(verbose, analyze, index_cleanup ON)"
    fi
    echo "vac_args is $vac_args" >> sb.o.pgvac

    x=0
    for n in $( seq 1 $ntabs ) ; do
      if [[ $npart -eq 0 ]]; then
        PGPASSWORD="pw" $client "${clientArgs[@]}" -x -c "vacuum $vac_args sbtest${n}" >& sb.o.pgvac.sbtest${n} &
        vpid[${x}]=$!
        x=$(( $x + 1 ))
      else
        for p in $( seq 0 $(( $npart - 1 )) ); do
          PGPASSWORD="pw" $client "${clientArgs[@]}" -x -c "vacuum $vac_args sbtest${n}_p${p}" >& sb.o.pgvac.sbttest${n}.p${p} &
          vpid[${x}]=$!
          x=$(( $x + 1 ))
        done
      fi
    done

    for n in $( seq 0 $(( $x - 1 )) ) ; do
      echo After load: wait for vacuum $n >> sb.o.pgvac
      wait ${vpid[${n}]}
    done

    echo "Checkpoint started at $( date )" >> sb.o.pgvac
    PGPASSWORD="pw" $client "${clientArgs[@]}" -x -c "checkpoint" 2>&1 >> sb.o.pgvac
    echo "Checkpoint done at $( date )" >> sb.o.pgvac

    now_secs=$( date +%s )
    if [[ now_secs -lt done_secs ]]; then
      diff_secs=$(( done_secs - now_secs ))
      echo Sleep $diff_secs >> sb.o.pgvac
      sleep $diff_secs
    fi

    now_secs=$( date +%s )
    diff_secs=$(( now_secs - start_secs ))
    echo "vac_pg done after $diff_secs at $( date )" >> sb.o.pgvac

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
if [[ $testType == "scan" || $testType == "scan.warm" || $testType == "scan.warmpre" ]]; then
  # avg:                              1731583.13
  scan_latency_ms=$( cat sb.o.$sfx.dop${nt} | grep avg: | awk '{ printf $2 }' )
  Krps=$( echo $nr $scan_latency_ms | awk '{ printf "%.0f", (( $1 / 1000.0 ) / ( $2 / 1000.0 )) }' )
  echo -n -e "$Krps\t"
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

ddirs=( $ddir $ddir/data $ddir/data/.rocksdb $ddir/base $ddir/global /data/m/my /data/m/pg /data/m/fbmy )
x=0
for xd in ${ddirs[@]}; do
  if [ -d $xd ]; then
    ls -asS --block-size=1M $xd > sb.ls.${x}.$sfx
    ls -asSh $xd > sb.lsh.${x}.$sfx
    x=$(( $x + 1 ))
  fi
done

cat sb.ls.*.$sfx | grep -v "^total" | sort -rnk 1,1 > sb.lsa.$sfx

