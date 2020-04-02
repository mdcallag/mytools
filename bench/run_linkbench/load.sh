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

  # Old and new output format for iostat
  #Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
  #Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

  printf "\nsamp\tr/s\trkb/s\twkb/s\tr/q\trkb/q\twkb/q\tips\n" >> l.$tag.r.$fn
  iover=$( head -10 l.$tag.io.$fn | grep Device | grep avgrq\-sz | wc -l )
  if [[ $iover -eq 1 ]]; then
    grep $dname l.$tag.io.$fn | awk '{ rs += $4; rkb += $6; wkb += $7; c += 1 } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.6f\t%.6f\t%s\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q }' q=$ips >> l.$tag.r.$fn
  else
    grep $dname l.$tag.io.$fn | awk '{ rs += $2; rkb += $4; wkb += $5; c += 1 } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.6f\t%.6f\t%s\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q }' q=$ips >> l.$tag.r.$fn
  fi

  printf "\nsamp\tcs/s\tcpu/s\tcs/q\tcpu/q\n" >> l.$tag.r.$fn
  grep -v swpd l.$tag.vm.$fn | grep -v procs | awk '{ cs += $12; cpu += $13 + $14; c += 1 } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=$ips >> l.$tag.r.$fn

  echo >> l.$tag.r.$fn
  head -4 l.$tag.sz1.$fn >> l.$tag.r.$fn

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
    $client linkbench $pgauth -c 'show all' > o.pg.conf
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
  $client admin -u root -p pw --host ${dbhost} < $ddl.pre >& l.pre.ddl.$fn

elif [[ $dbms = "mysql" ]]; then
  $client -uroot -ppw -h${dbhost} < $ddl.pre >& l.pre.ddl.$fn
  echo Skip mstat
  # ps aux | grep python | grep mstat\.py | awk '{ print $2 }' | xargs kill -9 2> /dev/null
  # python mstat.py --loops 1000000 --interval 15 --db_user=root --db_password=pw --db_host=${dbhost} >& l.pre.mstat.$fn &
  # mpid=$!
elif [[ $dbms = "postgres" ]]; then
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
elif [[ $dbms = "mysql" ]]; then
  while :; do ps aux | grep "mysqld " | grep basedir | grep datadir | grep -v mysqld_safe | grep -v grep; sleep 30; done >& l.pre.ps.$fn &
  spid=$!
  props=LinkConfigMysql.properties
  $client -uroot -ppw -A -h${dbhost} -e 'reset master'
  logarg="-Duser=root -Dpassword=pw"

  while :; do sleep 300; lh=$( date --date='last hour' +'%Y-%m-%d %H:%M:%S' ); $client -uroot -ppw -h${dbhost} -e "purge binary logs before \"$lh\""; done &
  pblpid=$!
elif [[ $dbms = "postgres" ]]; then
  while :; do ps aux | grep "postgres " | grep -v grep; sleep 30; done >& l.pre.ps.$fn &
  spid=$!
  props=LinkConfigPgsql.properties
  logarg="-Duser=linkbench -Dpassword=pw"
else
  echo dbms :: $dbms :: not supported
  exit 1
fi

echo "background jobs: $ipid $vpid $spid" > l.pre.o.$fn

echo "-c config/${props} -Dloaders=$dop -Dgenerate_nodes=$gennodes -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dload_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb0 -l" >> l.pre.o.$fn

start_secs=$( date +%s )
if ! /usr/bin/time -o l.pre.time.$fn bash bin/linkbench -c config/${props} -Dloaders=$dop -Dgenerate_nodes=$gennodes -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dload_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb0 -l  >> l.pre.o.$fn 2>&1 ; then
  echo Load failed
  exit 1
fi

nodes=$( grep "LOAD PHASE COMPLETED" l.pre.o.$fn | awk '{ print $9 }' )
links=$( grep "LOAD PHASE COMPLETED" l.pre.o.$fn | awk '{ print $13 }' )
counts=$( grep "LOAD PHASE COMPLETED" l.pre.o.$fn | awk '{ print $17 }' )

kill $pblpid
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

if [[ $dbms == "mongo" ]] ; then
  cp -r $data/diagnostic.data l.diag.data.$fn
fi
