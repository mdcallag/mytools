fn=$1
client=$2
ddir=$3
maxid=$4
dname=$5
dop=$6
gennodes=$7
myORmo=$8
ddl=$9
dbhost=${10}

if [[ $myORmo = "mysql" ]]; then
  $client -uroot -ppw -h${dbhost} < $ddl
  echo Skip mstat
  # ps aux | grep python | grep mstat\.py | awk '{ print $2 }' | xargs kill -9 2> /dev/null
  # python mstat.py --loops 1000000 --interval 15 --db_user=root --db_password=pw --db_host=${dbhost} >& l.mstat.$fn &
  # mpid=$!
fi

iostat -kx 5 >& l.io.$fn &
ipid=$!

vmstat 5 >& l.vm.$fn &
vpid=$!

echo "before $ddir" > l.sz.$fn
du -hs $ddir >> l.sz.$fn

if [[ $myORmo = "mongo" ]]; then
  while :; do ps aux | grep mongod | grep -v grep; sleep 180; done >& l.ps.$fn &
  spid=$!
  props=LinkConfigMongoDBv2.properties
  logarg=""
else
  while :; do ps aux | grep mysqld | grep -v grep; sleep 180; done >& l.ps.$fn &
  spid=$!
  props=LinkConfigMysql.properties
  $client -uroot -ppw -A -h${dbhost} -e 'reset master'
  logarg="-Duser=root -Dpassword=pw"

  while :; do sleep 300; lh=$( date --date='last hour' +'%Y-%m-%d %H:%M:%S' ); $client -uroot -ppw -h${dbhost} -e "purge binary logs before \"$lh\""; done &
  pblpid=$!
fi

echo "background jobs: $ipid $vpid $spid" > l.o.$fn

echo "-c config/${props} -Dloaders=$dop -Dgenerate_nodes=$gennodes -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dload_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb -l" >> l.o.$fn

time bash bin/linkbench -c config/${props} -Dloaders=$dop -Dgenerate_nodes=$gennodes -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dload_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb -l  >> l.o.$fn 2>&1

kill $ipid
kill $vpid
kill $spid
kill $pblpid
# kill $mpid

if [[ $myORmo = "mongo" ]]; then
  echo "db.serverStatus()" | $client > l.stat.$fn
  echo "db.link.stats()" | $client graph-linkbench > l.link.$fn
  echo "db.node.stats()" | $client graph-linkbench > l.node.$fn
  echo "db.count.stats()" | $client graph-linkbench > l.count.$fn
else
  $client -uroot -ppw -A -h${dbhost} -e 'reset master'
  $client -uroot -ppw -A -h${dbhost} -e 'show engine innodb status\G' > l.esi.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show engine rocksdb status\G' > l.esr.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show engine tokudb status\G' > l.est.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show global status' > l.gs.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show global variables' > l.gv.$fn
  $client -uroot -ppw -A -h${dbhost} linkdb -e 'show table status' > l.ts.$fn
  $client -uroot -ppw -A -h${dbhost} linkdb -e 'show indexes from linktable' > l.is.$fn
  $client -uroot -ppw -A -h${dbhost} linkdb -e 'show indexes from nodetable' >> l.is.$fn
  $client -uroot -ppw -A -h${dbhost} linkdb -e 'show indexes from counttable' >> l.is.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show memory status\G' > l.mem.$fn
fi

echo "after $ddir" >> l.sz.$fn
du -hs $ddir >> l.sz.$fn
du -hs $ddir/* >> l.sz.$fn

ips=$( grep "LOAD PHASE COMPLETED" l.o.$fn | awk '{ print $NF }' )
grep "LOAD PHASE COMPLETED" l.o.$fn  > l.r.$fn

printf "\nsamp\tr/s\trkb/s\twkb/s\tr/q\trkb/q\twkb/q\tips\n" >> l.r.$fn
grep $dname l.io.$fn | awk '{ rs += $4; rkb += $6; wkb += $7; c += 1 } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.6f\t%.6f\t%s\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q }' q=$ips >> l.r.$fn

printf "\nsamp\tcs/s\tcpu/s\tcs/q\tcpu/q\n" >> l.r.$fn
grep -v swpd l.vm.$fn | grep -v procs | awk '{ cs += $12; cpu += $13 + $14; c += 1 } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=$ips >> l.r.$fn

echo >> l.r.$fn
head -4 l.sz.$fn >> l.r.$fn

echo >> l.r.$fn
head -1 l.ps.$fn >> l.r.$fn
tail -1 l.ps.$fn >> l.r.$fn
