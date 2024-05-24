nr=$1
e=$2
eo=$3
ns=$4
client=$5
ddir=$6
dop=$7
dlmin=$8
dlmax=$9
dokill=${10}
dname=${11}
only1t=${12}
unique=${13}
rpc=${14}
ips=${15}
nqt=${16}
setup=${17}
dbms=${18}
short=${19}
bulk=${20}
secatend=${21}
dbopt=${22}
extra_insert=${23}
npart=${24}
perpart=${25}
delete_per_insert=${26}
# one of point, range
querypk=${27}

mypy=python3
#mypy="/media/ephemeral1/pypy-36-al2/bin/pypy3"
#mypypy="LD_LIBRARY_PATH=/media/ephemeral1/pypy-36-al2/site-packages/psycopg2 /media/ephemeral1/pypy-36-al2/bin/pypy3"

host=127.0.0.1

if [[ $short == "yes" ]]; then
names="--name_cash=caid --name_cust=cuid --name_ts=ts --name_price=prid --name_prod=prod"
else
names=""
fi

ntabs=$dop
if [[ $only1t == "yes" ]]; then
  ntabs=1
fi

sfx=dop${dop}

rm -f o.res.$sfx

moauth="--authenticationDatabase admin -u root -p pw"
pgauth="--host $host"
uses_oriole=0

if [[ $dbms == "mongo" ]]; then
  dbid=ib
  echo "no need to reset MongoDB replication as oplog is capped"
  while :; do ps aux | grep mongod | grep "\-\-config" | grep -v grep; sleep 30; done >& o.ps.$sfx &
  spid=$!
  splid="-1"
  top -b -d 20 > o.top.$sfx &
  topid=$!
  idbms="mongo"
elif [[ $dbms == "mysql" || $dbms == "mariadb" ]]; then
  dbid=ib
  $client -uroot -ppw -A -h$host -e 'reset master'
  if [[ $dbms == "mysql" ]]; then
    while :; do ps aux | grep mysqld | grep basedir | grep datadir | grep -v mysqld_safe | grep -v grep; sleep 30; done >& o.ps.$sfx &
    spid=$!
  else
    while :; do ps aux | grep mariadbd | grep basedir | grep datadir | grep -v mariadbd-safe | grep -v grep; sleep 30; done >& o.ps.$sfx &
    spid=$!
  fi
  while :; do date; $client -uroot -ppw -A -h$host -e 'show processlist'; sleep 20; done > o.espl.$sfx &
  splid=$!
  top -b -d 20 > o.top.$sfx &
  topid=$!
  idbms="mysql"
elif [[ $dbms == "postgres" ]]; then
  if [[ $client == *"oriole"* ]]; then uses_oriole=1; fi
  dbid=ib
  echo "TODO: reset Postgres replication"
  while :; do ps aux | grep postgres | grep -v python | grep -v psql | grep -v grep; sleep 30; done >& o.ps.$sfx &
  spid=$!
  top -b -d 20 > o.top.$sfx &
  topid=$!
  idbms="postgres"
else
  echo "dbms must be one of mongodb, mysql, mariadb, postgres but was $dbms"
  exit -1
fi

if [[ $setup == "yes" ]] ; then
  if [[ $dbms == "mongo" ]]; then
    $client $moauth ib --eval 'db.dropDatabase()'
    # echo "show databases" | $client $moauth 
    sleep 5
    $client $moauth ib --eval 'db.createCollection("foo")'
  elif [[ $dbms == "mysql" || $dbms == "mariadb" ]]; then
    $client -uroot -ppw -A -h$host -e 'drop database ib'
    sleep 5
    $client -uroot -ppw -A -h$host -e 'create database ib'
  else
    $client me -c 'drop database ib' $pgauth
    sleep 5
    $client me -c 'create database ib' $pgauth
  fi
fi

killall vmstat
killall iostat
killall top

# $mypy mstat.py --db_user=root --db_password=pw --db_host=$host --loops=10000000 --interval=5 2> /dev/null > o.mstat.$sfx &
# mpid=$!

vmstat 5 >& o.vm.$sfx &
vpid=$!
iostat -y -kx 5 >& o.io.$sfx &
ipid=$!
COLUMNS=400 LINES=50 top -b -d 60 -c -w >& o.top.$sfx &
tpid=$!

PERF_METRIC=${PERF_METRIC:-cycles}
x=0
perfpid=0
if [ $x -gt 0 ]; then
fgp="$HOME/git/FlameGraph"
#if [ ! -d $fgp ]; then echo FlameGraph not found; exit 1; fi
echo PERF_METRIC is $PERF_METRIC
while :; do
  if [ $nqt -ge 1 ]; then
    pause_secs=30
  else
    pause_secs=20
  fi
  perf="perf"

  sleep $pause_secs

  if [[ $dbms == "postgres" ]]; then
    # postgres: mdcallag ib 127.0.0.1(56000) CREATE INDEX
    if [ $nqt -ge 1 ]; then
      fn="o.pgid.1.query.pi1"
    else
      odd_or_even=$( echo $x | awk '{ if (( $1 % 2 ) == 0) { print "even" } else { print "odd" }}' )
      if [[ $odd_or_even == "even" ]]; then
        fn="o.pgid.1.insert.pi1"
      else
	if [ -f o.pgid.1.delete.pi1 ]; then
          fn="o.pgid.1.delete.pi1"
        else
          fn="o.pgid.1.insert.pi1"
        fi
      fi
    fi
    # dbpid=$( ps aux | grep "postgres: mdcallag" | grep -v grep | tail -1 | awk '{ print $2 }' )
    dbpid=$( cat $fn | awk '{ print $2 }' )
    echo Using Postgres backend PID $dbpid from $fn
  elif [[ $dbms == "mysql" ]]; then
    # mysql
    dbpid=$( ps aux  | grep -v mysqld_safe | grep mysqld | grep -v grep | awk '{ print $2 }' )
  elif [[ $dbms == "mariadb" ]]; then
    dbpid=$( ps aux | grep mariadbd | grep -v mariadbd-safe | grep -v \/usr\/bin\/time | grep -v timeout | grep -v grep | awk '{ print $2 }' )
    if [ -z $dbbpid ]; then
      dbpid=$( ps aux | grep mysqld | grep -v mysqld_safe | grep -v \/usr\/bin\/time | grep -v timeout | grep -v grep | awk '{ print $2 }' )
    fi
  fi

  if [ -z $dbpid ]; then
    echo Cannot get PID for $dbms
    continue;
  else
    echo Using PID $dbpid for perf
  fi

  doit=0
  if [[ doit -eq 1 ]]; then
  perf_secs=10
  ts=$( date +'%b%d.%H%M%S' )
  sfx="$x.$ts"
  outf="o.perf.rec.g.$sfx"
  #echo "$perf record -e $PERF_METRIC -c 500000 -g -p $dbpid -o $outf -- sleep $perf_secs"
  #$perf record -e $PERF_METRIC -c 500000 -g -p $dbpid -o $outf -- sleep $perf_secs
  echo "$perf record -e $PERF_METRIC -g -p $dbpid -o $outf -- sleep $perf_secs"
  $perf record -e $PERF_METRIC -g -p $dbpid -o $outf -- sleep $perf_secs

  $perf report --stdio -n -g folded -i $outf --no-children > o.perf.rep.g.f1.c0.$sfx
  $perf report --stdio -n -g folded -i $outf --children > o.perf.rep.g.f1.c1.$sfx
  $perf script -i $outf > o.perf.rep.g.scr.$sfx
  gzip --fast $outf
  cat o.perf.rep.g.scr.$sfx | $fgp/stackcollapse-perf.pl > o.perf.g.fold.$sfx
  $fgp/flamegraph.pl o.perf.g.fold.$sfx > o.perf.g.$sfx.svg
  gzip --fast o.perf.rep.g.scr.$sfx
  fi

  doit=0
  if  [[ doit -eq 1 ]]; then
  perf_secs=10
  ts=$( date +'%b%d.%H%M%S' )
  sfx="$x.$ts"
  outf="o.perf.rec.f.$sfx"
  #echo "$perf record -e $PERF_METRIC -c 500000 -p $dbpid -o $outf -- sleep $perf_secs"
  #$perf record -e $PERF_METRIC -c 500000 -p $dbpid -o $outf -- sleep $perf_secs
  echo "$perf record -e $PERF_METRIC -p $dbpid -o $outf -- sleep $perf_secs"
  $perf record -e $PERF_METRIC -p $dbpid -o $outf -- sleep $perf_secs
  $perf report --stdio -i $outf > o.perf.rep.f.$sfx
  fi

  doit=0
  if  [[ doit -eq 1 ]]; then
  perf_secs=5
  ts=$( date +'%b%d.%H%M%S' )
  sfx="$x.$ts"
  outf="o.perfstat.$sfx"

  $perf stat -o $outf -e cpu-clock,cycles,bus-cycles,instructions -p $dbpid -- sleep $perf_secs ; sleep 2
  $perf stat -o $outf --append -e cache-references,cache-misses,branches,branch-misses -p $dbpid -- sleep $perf_secs ; sleep 2
  $perf stat -o $outf --append -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores,L1-icache-loads-misses -p $dbpid -- sleep $perf_secs ; sleep 2
  $perf stat -o $outf --append -e dTLB-loads,dTLB-load-misses,dTLB-stores,dTLB-store-misses,dTLB-prefetch-misses -p $dbpid -- sleep $perf_secs ; sleep 2
  $perf stat -o $outf --append -e iTLB-load-misses,iTLB-loads -p $dbpid -- sleep $perf_secs ; sleep 2
  $perf stat -o $outf --append -e LLC-loads,LLC-load-misses,LLC-stores,LLC-store-misses,LLC-prefetches -p $dbpid -- sleep $perf_secs ; sleep 2
  $perf stat -o $outf --append -e alignment-faults,context-switches,migrations,major-faults,minor-faults,faults -p $dbpid -- sleep $perf_secs ; sleep 2
  fi

  doit=0
  if [[ doit -eq 1 ]]; then
    ts=$( date +'%b%d.%H%M%S' )
    sfx="$x.$ts"
    outf="o.pmp.$sfx"
    bash pmpf.sh $dbpid $outf
  fi

  x=$(( $x + 1 ))
done &
# This sets a global value
perfpid=$!
fi

start_secs=$( date +%s )

if [[ $secatend == "yes" && $only1t == "yes" ]]; then
 # When there is only 1 table and indexes are to be created after inserts then only start
 # the one client that will create the indexes. 
 realdop=1
else
 realdop=$dop
fi

maxr=$(( $nr / $realdop ))

for n in $( seq 1 $realdop ) ; do

  if [[ $setup == "yes" ]]; then
    setstr="--setup"
  else
    setstr=""
  fi

  if [[ $only1t == "yes" && $n -gt 1 ]]; then
    setstr=""
  fi  

  if [[ $only1t == "yes" ]]; then
    tn="pi1"
  else
    tn="pi${n}"
  fi

  if [[ $npart -gt 0 ]]; then
    setstr+=" --num_partitions=$npart --rows_per_partition=$perpart"
  fi

  if [[ $dbms == "mongo" ]]; then
    db_args="--mongo_w=1 --db_user=root --db_password=pw"
  elif [[ $dbms == "mysql" || $dbms == "mariadb" ]]; then
    db_args="--db_user=root --db_password=pw --engine=$e --engine_options=$eo --unique_checks=${unique} --bulk_load=${bulk}"
  else
    #db_args="--db_user=root --db_password=pw --engine=pg --engine_options=$eo --unique_checks=${unique} --bulk_load=${bulk}"
    db_args="--db_user=root --db_password=pw --engine=pg --unique_checks=${unique} --bulk_load=${bulk}"
  fi

  upq=""
  if [ $dbms == "postgres" ] ; then
    upq="--use_prepared_query"
  fi

  if [[ $secatend == "yes" ]]; then
    db_args+=" --secondary_at_end"
  fi

  if [[ $delete_per_insert == "yes" || $delete_per_insert == "1" ]]; then
    db_args+=" --delete_per_insert"
  fi

  if [[ $querypk == "point" ]]; then
    db_args+=" --query_pk_only"
  fi

  spr=1
  cmdline="$mypy iibench.py --dbms=$idbms --db_name=ib --secs_per_report=$spr --db_host=$host ${db_args} --max_rows=${maxr} --table_name=${tn} $setstr --num_secondary_indexes=$ns --data_length_min=$dlmin --data_length_max=$dlmax --rows_per_commit=${rpc} --inserts_per_second=${ips} --query_threads=${nqt} --seed=$(( $start_secs + $n )) --dbopt=$dbopt --my_id=$n $upq $names"

  if [[ uses_oriole -eq 1 ]]; then
    echo $cmdline --engine_options="using orioledb" > o.ib.dop${dop}.${n} 
    /usr/bin/time -o o.ctime.${sfx}.${n} $cmdline --engine_options="using orioledb" >> o.ib.dop${dop}.${n} 2>&1 &
    pids[${n}]=$!
  else 
    echo $cmdline > o.ib.dop${dop}.${n} 
    /usr/bin/time -o o.ctime.${sfx}.${n} $cmdline >> o.ib.dop${dop}.${n} 2>&1 &
    pids[${n}]=$!
  fi

  # This is a hack. The longer sleep (10) is done to give the first client enough time to create the tables
  if [[ $setup == "yes" && $n -eq 1 ]]; then
    sleep 10
  else 
    sleep 1
  fi
 
done

for n in $( seq 1 $realdop ) ; do
  # echo Wait for ${pids[${n}]} $n
  wait ${pids[${n}]} 
done

if [ $perfpid -ne 0 ]; then kill $perfpid ; fi

stop_secs=$( date +%s )
tot_secs=$(( $stop_secs - $start_secs ))
if [[ $tot_secs -eq 0 ]]; then tot_secs=1; fi

insert_rate=$( echo "scale=1; $nr / $tot_secs" | bc )
delete_rate=0
ins_and_del_rate=$insert_rate
insert_per=$( echo "scale=1; $insert_rate / $realdop" | bc )

if [[ $delete_per_insert == "yes" || $delete_per_insert == "1" ]]; then
  delete_rate=$insert_rate
  ins_and_del_rate=$( echo "scale=1; 2 * ( $nr / $tot_secs )" | bc )
fi

if [[ $extra_insert -gt 0 ]]; then
  # Account for rows indexed if this step creates the index
  # Don't worry about delete_per_insert as it wouldn't be used in this case
  insert_rate=$( echo "scale=1; ( $nr + $extra_insert ) / $tot_secs" | bc )
  ins_and_del_rate=$insert_rate
  maxr=$(( ( $nr + $extra_insert ) / $realdop ))
fi

echo rates
total_query=$( for n in $( seq 1 $realdop ); do awk '{ if (NF==17) print $0 }' o.ib.dop${dop}.$n | tail -1 ; done | awk '{ tq += $14; } END { print tq }' )
query_rate=$( echo "scale=1; $total_query / $tot_secs" | bc )

# echo $dop processes, $maxr rows-per-process, $tot_secs seconds, $insert_rate rows-per-second, $insert_per rows-per-second-per-user
echo $realdop processes, $maxr rows-per-process, $tot_secs seconds, $insert_rate rows-per-second, $insert_per rows-per-second-per-user, $total_query queries, $query_rate queries-per-second, $delete_per_insert deletes > o.res.$sfx

echo per interval
# Compute average rates per interval using 10 intervals
# Get the per-interval value: 3 is insert, 5 is delete, 7 is queries
for x in 3 5 7 ; do
for n in $( seq 1 $realdop ); do
  f=o.ib.dop${dop}.$n
  # Get the number of lines for which per-interval metrics are printed
  xa=$( cat $f | awk '{ if (NF == 17) { print $0 }}' | wc -l | awk '{ print $1 }' )
  xm=$(( $xa - 2 ))
  xp=$(( $xm / 10 ))
  for s in $( seq 0 9 ); do
    ha=$(( ($s * $xp) + $xp + 2 ))
    head -${ha} $f | tail -${xp} | awk '{ c += 1; s += $x } END { printf "%.0f,", s/c }' x=$x
  done
  printf "%s:DBMS\n" $n
done > o.rate.c.$x
cat o.rate.c.$x | tr ',' '\t' > o.rate.t.$x
done 

# kill $mpid >& /dev/null
kill $vpid >& /dev/null
kill $ipid >& /dev/null
kill $tpid >& /dev/null
kill $spid >& /dev/null
kill $splid >& /dev/null
kill $topid >& /dev/null
gzip -9 o.top.$sfx 

if [[ $dbms == "mongo" ]]; then
echo "db.serverStatus()" | $client $moauth > o.es.$sfx
echo "db.serverStatus({tcmalloc:2}).tcmalloc" | $client $moauth > o.es1.$sfx
echo "db.serverStatus({tcmalloc:2}).tcmalloc.tcmalloc.formattedString" | $client $moauth > o.es2.$sfx

for n in $( seq 1 $ntabs ) ; do
  echo "db.pi${n}.stats()" | $client $moauth ib > o.tab${n}.$sfx
  echo "db.pi${n}.stats({indexDetails: true})" | $client $moauth ib > o.tab${n}.id.$sfx
  echo "db.pi${n}.latencyStats({histograms: true})" | $client $moauth ib > o.tab${n}.ls.$sfx
  echo "db.pi${n}.latencyStats({histograms: true}).pretty()" | $client $moauth ib > o.tab${n}.lsp.$sfx
done

echo "db.stats()" | $client $moauth > o.dbstats.$sfx
echo "db.oplog.rs.stats()" | $client $moauth local > o.oplog.$sfx
echo "show dbs" | $client $moauth $dbid > o.dbs.$sfx

elif [[ $dbms == "mysql" || $dbms == "mariadb" ]]; then
$client -uroot -ppw -A -h$host -e 'show engine innodb status\G' > o.esi.$sfx
$client -uroot -ppw -A -h$host -e 'show engine rocksdb status\G' > o.esr.$sfx
$client -uroot -ppw -A -h$host -e 'show engine tokudb status\G' > o.est.$sfx
$client -uroot -ppw -A -h$host -e 'show global status' > o.gs.$sfx
$client -uroot -ppw -A -h$host -e 'show global variables' > o.gv.$sfx
$client -uroot -ppw -A -h$host -e 'show memory status\G' > o.mem.$sfx
$client -uroot -ppw -A -h$host information_schema -e 'select * from rocksdb_perf_context' > o.rx.perfctx

$client -uroot -ppw -A -h$host ib -e 'show table status\G' > o.ts.$sfx
$client -uroot -ppw -A -h$host ib -e 'show create table pi1\G' > o.create.$sfx
$client -uroot -ppw -A -h$host information_schema -e 'select table_name, partition_name, table_rows from partitions where table_schema="ib"' > o.parts.$sfx

# TODO: used to dump innodb_buffer_page and innodb_buffer_page_lru but that can be too much outpout
for tname in \
  innodb_buffer_pool_stats \
  innodb_cached_indexes innodb_indexes innodb_metrics \
  innodb_tables innodb_tablespaces innodb_tablespaces_brief innodb_tablestats ; do
  $client -uroot -ppw -A -h$host information_schema -e "select * from $tname\G" > o.is.$tname
done

for tname in \
  table_io_waits_summary_by_index_usage table_io_waits_summary_by_table \
  file_summary_by_event_name file_summary_by_instance ; do
  $client -uroot -ppw -A -h$host performance_schema -e "select * from $tname\G" > o.ps.$tname
done

#for t in $( seq 1 $ntabs ); do
#for n in $( seq 0 $(( $npart - 1 )) ) ; do
#  $client -uroot -ppw -A -h$host ib -e "select count(*) from pi${t} partition(p${n})"
#done > o.partct.$sfx.$t
#done

echo "sum of data and index length columns in GB" >> o.ts.$sfx
cat o.ts.$sfx  | grep "Data_length"  | awk '{ s += $2 } END { printf "%.3f\n", s / (1024*1024*1024) }' >> o.ts.$sfx
cat o.ts.$sfx  | grep "Index_length" | awk '{ s += $2 } END { printf "%.3f\n", s / (1024*1024*1024) }' >> o.ts.$sfx

$client -uroot -ppw -A -h$host -e 'reset master'
#$client -uroot -ppw -A -h$host ib -e "select count(*) from pi1" > o.my.pi1.count

elif [[ $dbms == "postgres" ]]; then
echo "TODO reset replication state"
#echo Count for pi1
#$client ib -c "select count(*) from pi1" > o.pg.pi1.count
$client ib -c 'show all' > o.pg.conf
$client ib -x -c 'select * from pg_stat_io' > o.pgs.io
$client ib -x -c 'select * from pg_stat_bgwriter' > o.pgs.bg
$client ib -x -c 'select * from pg_stat_database' > o.pgs.db
$client ib -x -c 'select * from pg_stat_wal' > o.pgs.wal
$client ib -x -c "select * from pg_stat_all_tables where schemaname='public'" > o.pgs.tabs
$client ib -x -c "select * from pg_stat_all_indexes where schemaname='public'" > o.pgs.idxs
$client ib -x -c "select * from pg_statio_all_tables where schemaname='public'" > o.pgi.tabs
$client ib -x -c "select * from pg_statio_all_indexes where schemaname='public'" > o.pgi.idxs
$client ib -x -c 'select * from pg_statio_all_sequences' > o.pgi.seq

$client ib -x -c "select pg_size_pretty(pg_indexes_size('pi1')), pg_indexes_size('pi1')" > o.pg.szs
$client ib -x -c "select pg_size_pretty(pg_relation_size('pi1')), pg_relation_size('pi1')" >> o.pg.szs
$client ib -x -c "select pg_size_pretty(pg_total_relation_size('pi1')), pg_total_relation_size('pi1')" >> o.pg.szs

for n in $( seq 1 $ntabs ) ; do
  $client ib -x -c "SELECT * FROM pg_stat_user_tables" > o.pgs.sut${n}
done

$client ib -c '\d+ pi1' > o.pg.dplus
if [[ $npart -gt 0 ]]; then
  $client ib -c '\d pi1_p0' > o.pg.d
fi

else
  echo "dbms unknown: $dbms"
  exit -1
fi

du -hs $ddir > o.sz.$sfx
echo "with apparent size " >> o.sz.$sfx
du -hs --apparent-size $ddir >> o.sz.$sfx
echo "all" >> o.sz.$sfx
du -hs ${ddir}/* >> o.sz.$sfx

ls -asShR $ddir > o.lsh.r.$sfx

ddirs=( $ddir $ddir/data $ddir/data/.rocksdb $ddir/base $ddir/global )
x=0
for xd in ${ddirs[@]}; do
  if [ -d $xd ]; then
    ls -asS --block-size=1M $xd > o.ls.${x}.$sfx
    ls -asSh $xd > o.lsh.${x}.$sfx
    x=$(( $x + 1 ))
  fi
done

cat o.ls.*.$sfx | grep -v "^total" | sort -rnk 1,1 > o.lsa.$sfx

bash ios.sh o.io.$sfx o.vm.$sfx $dname $insert_rate $query_rate $realdop $rpc >> o.res.$sfx

echo >> o.res.$sfx
bash dbsize.sh $client $host o.dbsz.$sfx $dbid $dbms $ddir
x0=$( cat o.dbsz.$sfx )
printf "dbGB\t%.3f\n" $x0 >> o.res.$sfx

du -bs $ddir > o.dbdirsz.$sfx
x1=$( awk '{ printf "%.3f", $1 / (1024*1024*1024) }' o.dbdirsz.$sfx )
printf "dbdirGB\t%s\t${ddir}\n" $x1 >> o.res.$sfx

echo >> o.res.$sfx
if [[ $dbms == "postgres" ]]; then
  # Sort by vsz because rss won't show shared buffers
  sort -nk 5,5 o.ps.$sfx | tail -1 >> o.res.$sfx
else
  sort -nk 6,6 o.ps.$sfx | tail -1 >> o.res.$sfx
fi

echo >> o.res.$sfx
echo "Max insert" >> o.res.$sfx
grep -h "Insert rt" o.ib.dop${dop}.* | grep -v max | awk '{ printf "%.3f\n", $13 }' | sort -rnk 1 | head -3 >> o.res.$sfx
echo "Max delete" >> o.res.$sfx
grep -h "Delete rt" o.ib.dop${dop}.* | grep -v max | awk '{ printf "%.3f\n", $13 }' | sort -rnk 1 | head -3 >> o.res.$sfx
echo "Max query" >> o.res.$sfx
grep -h "Query rt" o.ib.dop${dop}.* | grep -v max | awk '{ printf "%.3f\n", $13 }' | sort -rnk 1 | head -3 >> o.res.$sfx

echo >> o.res.$sfx
for n in $( seq 1 $realdop ) ; do
  grep "Insert rt" o.ib.dop${dop}.${n} >> o.res.$sfx
done

echo >> o.res.$sfx
for n in $( seq 1 $realdop ) ; do
  grep "Delete rt" o.ib.dop${dop}.${n} >> o.res.$sfx
done

echo >> o.res.$sfx
for n in $( seq 1 $realdop ) ; do
  grep "Query rt" o.ib.dop${dop}.${n} >> o.res.$sfx
done

printf "\ninsert, delete and query rate at nth percentile\n" >> o.res.$sfx
for n in $( seq 1 $realdop ) ; do
  lines=$( awk '{ if (NF == 17) { print $3 } }' o.ib.dop${dop}.${n} | grep -v i_ips | wc -l )
  for x in 50 75 90 95 99 ; do
    if [[ $lines -ge 10 ]]; then
      off=$( printf "%.0f" $( echo "scale=3; ($x / 100.0 ) * $lines " | bc ) )
      i_nth=$( cat o.ib.dop${dop}.$n | awk '{ if (NF == 17) { print $3 } }' | grep -v i_ips | sort -rnk 1,1 | head -${off} | tail -1 )
      d_nth=$( cat o.ib.dop${dop}.$n | awk '{ if (NF == 17) { print $5 } }' | grep -v i_ips | sort -rnk 1,1 | head -${off} | tail -1 )
      q_nth=$( cat o.ib.dop${dop}.$n | awk '{ if (NF == 17) { print $7 } }' | grep -v i_ips | sort -rnk 1,1 | head -${off} | tail -1 )
      echo ${x}th, ${off} / ${lines} = $i_nth insert, $d_nth delete, $q_nth query >> o.res.$sfx
    else
      # not enough input lines
      echo ${x}th, 0 / ${lines} = NA insert, NA delete, NA query >> o.res.$sfx
    fi
  done
done

bash rth.sh . . $dop "Insert rt"               > o.rt.c.insert
bash rth.sh . . $dop "Insert rt" | tr ',' '\t' > o.rt.t.insert
if [[ $delete_per_insert == "yes" || $delete_per_insert == "1" ]]; then
  bash rth.sh . . $dop "Delete rt"               > o.rt.c.delete
  bash rth.sh . . $dop "Delete rt" | tr ',' '\t' > o.rt.t.delete
fi
bash rth.sh . . $dop "Query rt"                > o.rt.c.query
bash rth.sh . . $dop "Query rt" | tr ',' '\t'  > o.rt.t.query

echo >> o.res.$sfx
echo "CPU seconds" >> o.res.$sfx

# Client CPU seconds
cat o.ctime.${sfx}.* | head -1 | awk '{ print $1 }' | sed 's/user//g' > o.utime.$sfx
cat o.ctime.${sfx}.* | head -1 | awk '{ print $2 }' | sed 's/system//g' > o.stime.$sfx
paste o.utime.$sfx o.stime.$sfx > o.atime.$sfx
us=$( cat o.atime.$sfx | awk '{ s += $1 } END { printf "%.2f\n", s }' )
sy=$( cat o.atime.$sfx | awk '{ s += $2 } END { printf "%.2f\n", s }' )
echo "client: $us user, $sy system, $( echo "$us $sy" | awk '{ printf "%.1f", $1 + $2 }' ) total" >> o.res.$sfx

function dt2s {
  ts=$1
  min=$( echo $ts | tr ':' ' ' | awk '{ print $1 }' )
  sec=$( echo $ts | tr ':' ' ' | awk '{ print $2 }' )
  d2nsecs=$( echo "$min * 60 + $sec" | bc )
  echo $d2nsecs
}

# dbms CPU seconds
# TODO -- make this work for postgres which uses many processes
dh=$( cat o.ps.$sfx | head -1 | awk '{ print $10 }' )
dt=$( cat o.ps.$sfx | tail -1 | awk '{ print $10 }' )
hsec=$( dt2s $dh )
tsec=$( dt2s $dt )
dsec=$( echo "$hsec $tsec" | awk '{ printf "%.1f", $2 - $1 }' )
dsec0=$( echo "$hsec $tsec" | awk '{ printf "%.0f", $2 - $1 }' )
echo "dbms: $dsec" >> o.res.$sfx

cat o.res.$sfx
