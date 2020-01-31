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

function process_stats {
  tag=$1
  start_secs=$2
  nodes=$3
  links=$4

  touch l.$tag.r.$fn

  # This ignores inserts and updates to linkcount
  nr=$( echo "$3 + $4" | bc )

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

  printf "\nsamp\tr/s\trkb/s\twkb/s\tr/q\trkb/q\twkb/q\tips\n" >> l.$tag.r.$fn
  grep $dname l.$tag.io.$fn | awk '{ rs += $2; rkb += $4; wkb += $5; c += 1 } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.6f\t%.6f\t%s\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q }' q=$ips >> l.$tag.r.$fn

  printf "\nsamp\tcs/s\tcpu/s\tcs/q\tcpu/q\n" >> l.$tag.r.$fn
  grep -v swpd l.$tag.vm.$fn | grep -v procs | awk '{ cs += $12; cpu += $13 + $14; c += 1 } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=$ips >> l.$tag.r.$fn

  echo >> l.$tag.r.$fn
  head -4 l.$tag.sz1.$fn >> l.$tag.r.$fn

  echo >> l.$tag.r.$fn
  head -1 l.$tag.ps.$fn >> l.$tag.r.$fn
  tail -1 l.$tag.ps.$fn >> l.$tag.r.$fn

  echo >> l.$tag.r.$fn
  echo "Inserted in $tsecs seconds: $nodes node, $links link" >> l.$tag.r.$fn
  echo "This excludes updates to linkcount" >> l.$tag.r.$fn

  if [[ $dbms = "mongo" ]]; then
    cred="-u root -p pw --authenticationDatabase=admin"
    echo "db.serverStatus()" | $client $cred > l.$tag.stat.$fn
    echo "db.linktable.stats()" | $client $cred linkdb0 > l.$tag.link.$fn
    echo "db.nodetable.stats()" | $client $cred linkdb0 > l.$tag.node.$fn
    echo "db.counttable.stats()" | $client $cred linkdb0 > l.$tag.count.$fn
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
  elif [[ $dbms == "postgres" ]]; then
    $client linkdb $pgauth -c 'show all' > o.pg.conf
    $client linkdb $pgauth -x -c 'select * from pg_stat_bgwriter' > l.$tag.pgs.bg
    $client linkdb $pgauth -x -c 'select * from pg_stat_database' > l.$tag.pgs.db
    $client linkdb $pgauth -x -c 'select * from pg_stat_all_tables' > l.$tag.pgs.tabs
    $client linkdb $pgauth -x -c 'select * from pg_stat_all_indexes' > l.$tag.pgs.idxs
    $client linkdb $pgauth -x -c 'select * from pg_statio_all_tables' > l.$tag.pgi.tabs
    $client linkdb $pgauth -x -c 'select * from pg_statio_all_indexes' > l.$tag.pgi.idxs
    $client linkdb $pgauth -x -c 'select * from pg_statio_all_sequences' > l.$tag.pgi.seq
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
  $client me $pgauth -c "create database linkdb"
  echo PG pre DDL
  $client linkdb $pgauth < $ddl.pre >& l.pre.ddl.$fn
else
  echo dbms :: $dbms :: not supported
  exit 1
fi

iostat -kx 5 >& l.pre.io.$fn &
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
  while :; do ps aux | grep mongod | grep -v grep; sleep 5; done >& l.pre.ps.$fn &
  spid=$!
  props=LinkConfigMongoDb2.properties
  logarg=""
elif [[ $dbms = "mysql" ]]; then
  while :; do ps aux | grep mysqld | grep -v grep; sleep 5; done >& l.pre.ps.$fn &
  spid=$!
  props=LinkConfigMysql.properties
  $client -uroot -ppw -A -h${dbhost} -e 'reset master'
  logarg="-Duser=root -Dpassword=pw"

  while :; do sleep 300; lh=$( date --date='last hour' +'%Y-%m-%d %H:%M:%S' ); $client -uroot -ppw -h${dbhost} -e "purge binary logs before \"$lh\""; done &
  pblpid=$!
elif [[ $dbms = "postgres" ]]; then
  while :; do ps aux | grep postgres | grep -v grep; sleep 5; done >& l.pre.ps.$fn &
  spid=$!
  props=LinkConfigPgsql.properties
  logarg="-Duser=linkdb -Dpassword=pw"
else
  echo dbms :: $dbms :: not supported
  exit 1
fi

echo "background jobs: $ipid $vpid $spid" > l.pre.o.$fn

echo "-c config/${props} -Dloaders=$dop -Dgenerate_nodes=$gennodes -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dload_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb0 -l" >> l.pre.o.$fn

start_secs=$( date +%s )
/usr/bin/time -o l.pre.time.$fn bash bin/linkbench -c config/${props} -Dloaders=$dop -Dgenerate_nodes=$gennodes -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dload_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb0 -l  >> l.pre.o.$fn 2>&1

nodes=$( grep "LOAD PHASE COMPLETED" l.pre.o.$fn | awk '{ print $9 }' )
links=$( grep "LOAD PHASE COMPLETED" l.pre.o.$fn | awk '{ print $14 }' )

kill $pblpid
process_stats pre $start_secs $nodes $links

#
# Now create the covering index on Link
#

iostat -kx 5 >& l.post.io.$fn &
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
  while :; do ps aux | grep mongod | grep -v grep; sleep 5; done >& l.post.ps.$fn &
  spid=$!
  /usr/bin/time -o l.post.time.$fn $client admin -u root -p pw --host ${dbhost} < $ddl.post >& l.post.ddl.$fn

elif [[ $dbms = "mysql" ]]; then
  while :; do ps aux | grep mysqld | grep -v grep; sleep 5; done >& l.post.ps.$fn &
  spid=$!
  /usr/bin/time -o l.post.time.$fn $client -uroot -ppw -h${dbhost} < $ddl.post >& l.post.ddl.$fn
  echo Skip mstat
  # ps aux | grep python | grep mstat\.py | awk '{ print $2 }' | xargs kill -9 2> /dev/null
  # python mstat.py --loops 1000000 --interval 15 --db_user=root --db_password=pw --db_host=${dbhost} >& l.mstat.$fn &
  # mpid=$!

elif [[ $dbms = "postgres" ]]; then
  while :; do ps aux | grep mysqld | grep -v grep; sleep 5; done >& l.post.ps.$fn &
  spid=$!
  /usr/bin/time -o l.post.time.$fn $client me $pgauth linkdb < $ddl.post >& l.post.ddl.$fn
else
  echo dbms :: $dbms :: not supported
  exit 1
fi

process_stats post $start_secs $nodes $links

