fn=$1
client=$2
ddir=$3
maxid=$4
dname=$5
dop=$6
gennodes=$7
dbms=$8
ddl=$9
dbhost=${10}
heap=${11}
jdbc=${12}

# The default for the jdbc arg is "FacebookLinkBench.jar"

pgauth="--host 127.0.0.1"

function dt2s {
  ts=$1
  min=$( echo $ts | tr ':' ' ' | awk '{ print $1 }' )
  sec=$( echo $ts | tr ':' ' ' | awk '{ print $2 }' )
  d2nsecs=$( echo "$min * 60 + $sec" | bc )
  echo $d2nsecs
}

function process_stats {
  tag=$1
  start_secs=$2
  nodes=$3
  links=$4
  counts=$5

  touch l.$tag.r.$fn

  # This ignores inserts and updates to linkcount
  nr=$( echo "$3 + $4 + $5" | bc )

  end_secs=$( date +%s )
  tsecs=$( echo "$end_secs - $start_secs" | bc )
  ips=$( echo "scale=1; $nr / $tsecs" | bc )

  kill $ipid
  kill $vpid
  kill $spid
  # kill $mpid

  echo "after $ddir" >> l.$tag.sz1.$fn
  du -sm $ddir >> l.$tag.sz1.$fn
  echo "after $ddir" >> l.$tag.sz2.$fn
  du -sm $ddir/* >> l.$tag.sz2.$fn
  echo "after apparent $ddir" >> l.$tag.asz1.$fn
  du -sm --apparent-size $ddir >> l.$tag.asz1.$fn
  echo "after apparent $ddir" >> l.$tag.asz2.$fn
  du -sm --apparent-size $ddir/* >> l.$tag.asz2.$fn

  ls -asShR $ddir > l.$tag.lsh.r.$fn
  ddirs=( $ddir $ddir/data $ddir/data/.rocksdb $ddir/base $ddir/global )
  x=0
  for xd in ${ddirs[@]}; do
    if [ -d $xd ]; then
      ls -asS --block-size=1M $xd > l.$tag.ls.${x}.$fn
      ls -asSh $xd > l.$tag.lsh.${x}.$fn
      x=$(( $x + 1 ))
    fi
  done
  cat l.$tag.ls.*.$fn | grep -v "^total" | sort -rnk 1,1 > l.$tag.lsa.$fn

  bash ios.sh l.$tag.io.$fn $dname $ips >> l.$tag.r.$fn

  printf "\nsamp\tcs/s\tcpu/s\tcs/q\tcpu/q\n" >> l.$tag.r.$fn
  grep -v swpd l.$tag.vm.$fn | grep -v procs | awk '{ cs += $12; cpu += $13 + $14; c += 1 } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=$ips >> l.$tag.r.$fn

  echo >> l.$tag.r.$fn
  bash dbsize.sh $client $dbhost l.$tag.dbsz.$fn $dbid $dbms $ddir
  x0=$( cat l.$tag.dbsz.$fn )
  printf "dbGB\t%.3f\n" $x0 >> l.$tag.r.$fn

  du -bs $ddir > l.$tag.dbdirsz.$fn
  x1=$( awk '{ printf "%.3f", $1 / (1024*1024*1024) }' l.$tag.dbdirsz.$fn )
  printf "dbdirGB\t%s\t${ddir}\n" $x1 >> l.$tag.r.$fn

  echo >> l.$tag.r.$fn
  head -1 l.$tag.ps.$fn >> l.$tag.r.$fn
  tail -1 l.$tag.ps.$fn >> l.$tag.r.$fn

  echo >> l.$tag.r.$fn
  echo "Inserted in $tsecs seconds: $nodes node, $links link, $counts count" >> l.$tag.r.$fn

  # client CPU seconds
  cus=$( cat l.$tag.time.$fn | head -1 | awk '{ print $1 }' | sed 's/user//g' )
  csy=$( cat l.$tag.time.$fn | head -1 | awk '{ print $2 }' | sed 's/system//g' )
  csec=$( echo "$cus $csy" | awk '{ printf "%.1f", $1 + $2 }' )

  # dbms CPU seconds
  # TODO make this work for Postgres
  dh=$( cat l.$tag.ps.$fn | head -1 | awk '{ print $10 }' )
  dt=$( cat l.$tag.ps.$fn | tail -1 | awk '{ print $10 }' )
  hsec=$( dt2s $dh )
  tsec=$( dt2s $dt )
  dsec=$( echo "$hsec $tsec" | awk '{ printf "%.1f", $2 - $1 }' )

  echo >> l.$tag.r.$fn
  echo "CPU seconds" >> l.$tag.r.$fn
  echo "client: $cus user, $csy system, $csec total" >> l.$tag.r.$fn
  echo "dbms: $dsec " >> l.$tag.r.$fn

  if [[ $dbms = "mongo" ]]; then
    cred="-u root -p pw --authenticationDatabase=admin"
    echo "db.serverStatus()" | $client $cred > l.$tag.srvstat.$fn
    echo "db.serverStatus({tcmalloc:2}).tcmalloc" | $client $cred > l.$tag.srvstat1.$fn
    echo "db.serverStatus({tcmalloc:2}).tcmalloc.tcmalloc.formattedString" | $client $cred > l.$tag.srvstat2.$fn
    echo "db.stats()" | $client $cred > l.$tag.dbstats.$fn
    echo "db.linktable.stats({indexDetails: true})" | $client $cred linkdb0 > l.$tag.stats.link.$fn
    echo "db.nodetable.stats({indexDetails: true})" | $client $cred linkdb0 > l.$tag.stats.node.$fn
    echo "db.counttable.stats({indexDetails: true})" | $client $cred linkdb0 > l.$tag.stats.count.$fn
    echo "db.linktable.latencyStats({histograms: true}).pretty()" | $client $cred linkdb0 > l.$tag.lat.link.$fn
    echo "db.nodetable.latencyStats({histograms: true}).pretty()" | $client $cred linkdb0 > l.$tag.lat.node.$fn
    echo "db.counttable.latencyStats({histograms: true}).pretty()" | $client $cred linkdb0 > l.$tag.lat.count.$fn
    echo "db.oplog.rs.stats()" | $client $cred local > l.$tag.oplog.$fn
    echo "show dbs" | $client $cred linkdb0 > l.$tag.dbs.$fn
  elif [[ $dbms == "mysql" ]]; then
    $client -uroot -ppw -A -h${dbhost} -e 'reset master'
    $client -uroot -ppw -A -h${dbhost} -e 'show engine innodb status\G' > l.$tag.esi.$fn
    $client -uroot -ppw -A -h${dbhost} -e 'show engine rocksdb status\G' > l.$tag.esr.$fn
    $client -uroot -ppw -A -h${dbhost} -e 'show engine tokudb status\G' > l.$tag.est.$fn
    $client -uroot -ppw -A -h${dbhost} -e 'show global status' > l.$tag.gs.$fn
    $client -uroot -ppw -A -h${dbhost} -e 'show global variables' > l.$tag.gv.$fn
    $client -uroot -ppw -A -h${dbhost} linkdb0 -e 'show table status' > l.$tag.ts.$fn
    $client -uroot -ppw -A -h${dbhost} linkdb0 -e 'show indexes from linktable' > l.$tag.is.$fn
    $client -uroot -ppw -A -h${dbhost} linkdb0 -e 'show indexes from nodetable' >> l.$tag.is.$fn
    $client -uroot -ppw -A -h${dbhost} linkdb0 -e 'show indexes from counttable' >> l.$tag.is.$fn
    $client -uroot -ppw -A -h${dbhost} -e 'show memory status\G' > l.$tag.mem.$fn
    $client -uroot -ppw -A -h${dbhost} performance_schema -E -e 'SELECT * FROM table_io_waits_summary_by_table WHERE OBJECT_NAME IN ("linktable", "nodetable", "counttable")' > l.$tag.tstat1.$fn
    $client -uroot -ppw -A -h${dbhost} performance_schema -E -e 'SELECT * FROM events_statements_summary_by_account_by_event_name WHERE USER="root"' > l.$tag.ustat1.$fn
    $client -uroot -ppw -A -h${dbhost} -E -e 'SELECT * FROM sys.schema_table_statistics WHERE table_name IN ("linktable", "nodetable", "counttable")' > l.$tag.tstat2.$fn
    $client -uroot -ppw -A -h${dbhost} -E -e 'SELECT * FROM sys.user_summary' > l.$tag.ustat2.$fn
    $client -uroot -ppw -A -h${dbhost} -E -e 'SELECT * FROM information_schema.user_statistics' > l.$tag.ustat3.$fn
    $client -uroot -ppw -A -h${dbhost} -E -e 'SELECT * FROM information_schema.table_statistics WHERE TABLE_NAME IN ("linktable", "nodetable", "counttable")' > l.$tag.tstat3.$fn
    $client -uroot -ppw -A -h${dbhost} -E -e 'SELECT * FROM information_schema.index_statistics' > l.$tag.istat3.$fn

  elif [[ $dbms == "postgres" ]]; then
    $client linkbench $pgauth -c 'show all' > l.$tag.pg.conf
    $client linkbench $pgauth -x -c 'select * from pg_stat_bgwriter' > l.$tag.pgs.bg
    $client linkbench $pgauth -x -c 'select * from pg_stat_database' > l.$tag.pgs.db
    $client linkbench $pgauth -x -c 'select * from pg_stat_all_tables' > l.$tag.pgs.tabs
    $client linkbench $pgauth -x -c 'select * from pg_stat_all_indexes' > l.$tag.pgs.idxs
    $client linkbench $pgauth -x -c 'select * from pg_statio_all_tables' > l.$tag.pgi.tabs
    $client linkbench $pgauth -x -c 'select * from pg_statio_all_indexes' > l.$tag.pgi.idxs
    $client linkbench $pgauth -x -c 'select * from pg_statio_all_sequences' > l.$tag.pgi.seq
  else
    echo dbms :: $dbms :: not supported
    exit 1
  fi
}

if [[ $dbms = "mongo" ]]; then
  dbid=linkdb0
  $client admin -u root -p pw --host ${dbhost} < $ddl.pre >& l.pre.ddl.$fn

elif [[ $dbms = "mysql" ]]; then
  dbid=linkdb0
  $client -uroot -ppw -h${dbhost} < $ddl.pre >& l.pre.ddl.$fn
  echo Skip mstat
  # ps aux | grep python | grep mstat\.py | awk '{ print $2 }' | xargs kill -9 2> /dev/null
  # python mstat.py --loops 1000000 --interval 15 --db_user=root --db_password=pw --db_host=${dbhost} >& l.pre.mstat.$fn &
  # mpid=$!
elif [[ $dbms = "postgres" ]]; then
  dbid=linkbench
  echo PG drop database
  $client me $pgauth -c "drop database if exists linkdb"
  sleep 5
  echo PG create database
  #$client me $pgauth -c "create database linkdb0 encoding='latin1'"
  $client me $pgauth -c "create database linkbench"
  echo PG pre DDL
  $client linkbench $pgauth < $ddl.pre >& l.pre.ddl.$fn
else
  echo dbms :: $dbms :: not supported
  exit 1
fi

iostat -y -kx 5 >& l.pre.io.$fn &
ipid=$!
vmstat 5 >& l.pre.vm.$fn &
vpid=$!

echo "before $ddir" > l.pre.sz1.$fn
du -sm $ddir >> l.pre.sz1.$fn
echo "before $ddir" > l.pre.sz2.$fn
du -sm $ddir/* >> l.pre.sz2.$fn
echo "before apparent $ddir" > l.pre.asz1.$fn
du -sm --apparent-size $ddir >> l.pre.asz1.$fn
echo "before apparent $ddir" > l.pre.asz2.$fn
du -sm --apparent-size $ddir/* >> l.pre.asz2.$fn

if [[ $dbms = "mongo" ]]; then
  while :; do ps aux | grep "mongod " | grep "\-\-config" | grep -v grep; sleep 30; done >& l.pre.ps.$fn &
  spid=$!
  props=LinkConfigMongoDb2.properties
  logarg=""
  dbpid=$( pidof mongod )
elif [[ $dbms = "mysql" ]]; then
  while :; do ps aux | grep "mysqld " | grep basedir | grep datadir | grep -v mysqld_safe | grep -v grep; sleep 30; done >& l.pre.ps.$fn &
  spid=$!
  props=LinkConfigMysql.properties
  $client -uroot -ppw -A -h${dbhost} -e 'reset master'
  logarg="-Duser=root -Dpassword=pw"
  dbpid=$( pidof mysqld )

  while :; do sleep 300; lh=$( date --date='last hour' +'%Y-%m-%d %H:%M:%S' ); $client -uroot -ppw -h${dbhost} -e "purge binary logs before \"$lh\""; done &
  pblpid=$!
elif [[ $dbms = "postgres" ]]; then
  while :; do ps aux | grep "postgres " | grep -v grep; sleep 30; done >& l.pre.ps.$fn &
  spid=$!
  props=LinkConfigPgsql.properties
  logarg="-Duser=linkbench -Dpassword=pw"
  dbpid=-1
else
  echo dbms :: $dbms :: not supported
  exit 1
fi

while :; do ps aux | grep FacebookLinkBench | grep -v grep; sleep 30; done >& l.pre.ps2.$fn &
spid2=$!

COLUMNS=400 LINES=40 top -b -d 60 -c -w >& l.pre.top.$fn &
tpid=$!

echo "background jobs: $ipid $vpid $spid $spid2 $tpid" > l.pre.o.$fn

echo "-c config/${props} -Dloaders=$dop -Dgenerate_nodes=$gennodes -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dload_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb0 -l" >> l.pre.o.$fn

dbpid=-1 # remove this to use perf
if [ $dbpid -ne -1 ] ; then
  while :; do ts=$( date +'%b%d.%H%M%S' ); tsf=l.pre.perf.data.$fn.$ts; perf record -a -F 99 -g -p $dbpid -o $tsf -- sleep 10; perf report --no-children --stdio -i $tsf > $tsf.rep ; perf script -i $tsf | gzip -9 | $tsf.scr ; rm -f $tsf; sleep 60; done >& l.pre.perf.$fn &
  fpid=$!
fi

# Script for getting flamegraphs
# for f in $( ls l.post.perf.data.* | grep -v \.rep | tail -50 ); do echo $f; perf script -i $f > $f.ps; ~/git/FlameGraph/stackcollapse-perf.pl $f.ps | ~/git/FlameGraph/flamegraph.pl > $f.svg ; done

start_secs=$( date +%s )
if ! HEAPSIZE=$heap LINKBENCH_JAR=$jdbc /usr/bin/time -o l.pre.time.$fn bash bin/linkbench -c config/${props} -Dloaders=$dop -Dgenerate_nodes=$gennodes -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dload_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb0 -l  >> l.pre.o.$fn 2>&1 ; then
  echo Load failed
  exit 1
fi

if [ $dbpid -ne -1 ] ; then kill $fpid ; fi

nodes=$( grep "LOAD PHASE COMPLETED" l.pre.o.$fn | awk '{ print $9 }' )
links=$( grep "LOAD PHASE COMPLETED" l.pre.o.$fn | awk '{ print $13 }' )
counts=$( grep "LOAD PHASE COMPLETED" l.pre.o.$fn | awk '{ print $17 }' )

kill $pblpid
kill $spid2
kill $tpid
gzip -9 l.pre.top.$fn
process_stats pre $start_secs $nodes $links $counts

#
# Now create the covering index on Link
#

iostat -y -kx 5 >& l.post.io.$fn &
ipid=$!
vmstat 5 >& l.post.vm.$fn &
vpid=$!

echo "before secondary $ddir" > l.post.sz1.$fn
du -sm $ddir >> l.post.sz1.$fn
echo "before secondary $ddir" > l.post.sz2.$fn
du -sm $ddir/* >> l.post.sz2.$fn
echo "before secondary apparent $ddir" > l.post.asz1.$fn
du -sm --apparent-size $ddir >> l.post.asz1.$fn
echo "before secondary apparent $ddir" > l.post.asz2.$fn
du -sm --apparent-size $ddir/* >> l.post.asz2.$fn

dbpid=-1 # remove this to use perf
if [ $dbpid -ne -1 ] ; then
  while :; do ts=$( date +'%b%d.%H%M%S' ); tsf=l.post.perf.data.$fn.$ts; perf record -a -F 99 -g -p $dbpid -o $tsf -- sleep 10; perf report --no-children --stdio -i $tsf > $tsf.rep ; perf script -i $tsf | gzip -9 | $tsf.scr ; rm -f $tsf; sleep 60; done >& l.post.perf.$fn &
  fpid=$!
fi

COLUMNS=400 LINES=40 top -b -d 60 -c -w >& l.post.top.$fn &
tpid=$!

start_secs=$( date +%s )
if [[ $dbms = "mongo" ]]; then
  while :; do ps aux | grep mongod | grep -v grep; sleep 30; done >& l.post.ps.$fn &
  spid=$!
  /usr/bin/time -o l.post.time.$fn $client admin -u root -p pw --host ${dbhost} < $ddl.post >& l.post.ddl.$fn

elif [[ $dbms = "mysql" ]]; then
  while :; do ps aux | grep mysqld | grep -v grep; sleep 30; done >& l.post.ps.$fn &
  spid=$!
  /usr/bin/time -o l.post.time.$fn $client -uroot -ppw -h${dbhost} < $ddl.post >& l.post.ddl.$fn
  echo Skip mstat
  # ps aux | grep python | grep mstat\.py | awk '{ print $2 }' | xargs kill -9 2> /dev/null
  # python mstat.py --loops 1000000 --interval 15 --db_user=root --db_password=pw --db_host=${dbhost} >& l.mstat.$fn &
  # mpid=$!

elif [[ $dbms = "postgres" ]]; then
  while :; do ps aux | grep mysqld | grep -v grep; sleep 30; done >& l.post.ps.$fn &
  spid=$!
  /usr/bin/time -o l.post.time.$fn $client linkbench $pgauth < $ddl.post >& l.post.ddl.$fn
else
  echo dbms :: $dbms :: not supported
  exit 1
fi

kill $tpid
gzip -9 l.post.top.$fn
if [ $dbpid -ne -1 ] ; then kill $fpid ; fi

process_stats post $start_secs $nodes $links $counts

rm -f l.linux.$fn l.mount.$fn l.sysblock.$dname.$fn l.sysvm.$fn
touch l.linux.$fn l.mount.$fn l.sysblock.$dname.$fn l.sysvm.$fn

for d in \
/proc/sys/vm/dirty_background_ratio \
/proc/sys/vm/dirty_ratio \
/proc/sys/vm/dirty_expire_centisecs \
/sys/block/${dname}/queue/read_ahead_kb ; do
  v=$( cat $d )
  printf "%s\t\t%s\n" "$v" $d >> l.linux.$fn
done

for d in /sys/block/${dname}/queue/* ; do
  v=$( cat $d )
  printf "%s\t\t%s\n" "$v" $d >> l.sysblock.$dname.$fn
done

for d in /proc/sys/vm/* ; do
  v=$( cat $d )
  printf "%s\t\t%s\n" "$v" $d >> l.sysvm.$fn
done

mount -v > l.mount.$fn

