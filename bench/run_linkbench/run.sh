fn=$1
client=$2
ddir=$3
maxid=$4
dname=$5
dop=$6
secs=$7
myORmo=$8
dbhost=$9

if [[ $myORmo = "mysql" ]]; then
  echo Skip mstat
  # ps aux | grep python | grep mstat\.py | awk '{ print $2 }' | xargs kill -9 2> /dev/null
  # python mstat.py --loops 1000000 --interval 15 --db_user=root --db_password=pw --db_host=${dbhost} >& r.mstat.$fn &
  # mpid=$!
fi

killall vmstat
killall iostat
iostat -kx 5 >& r.io.$fn &
ipid=$!

vmstat 5 >& r.vm.$fn &
vpid=$!

echo "before $ddir" > r.sz1.$fn
du -sm $ddir >> r.sz1.$fn
echo "before $ddir" > r.sz2.$fn
du -sm $ddir/* >> r.sz2.$fn
echo "before apparent $ddir" > r.asz1.$fn
du -sm --apparent-size $ddir >> r.asz1.$fn
echo "before apparent $ddir" > r.asz2.$fn
du -sm --apparent-size $ddir/* >> r.asz2.$fn

if [[ $myORmo = "mongo" ]]; then
  while :; do ps aux | grep mongod | grep -v grep; sleep 5; done >& r.ps.$fn &
  spid=$!
  props=LinkConfigMongoDb2.properties
  logarg=""
else
  while :; do ps aux | grep mysqld | grep -v grep; sleep 5; done >& r.ps.$fn &
  spid=$!
  props=LinkConfigMysql.properties
  $client -uroot -ppw -A -h${dbhost} -e 'reset master'
  logarg="-Duser=root -Dpassword=pw"
fi

echo "background jobs: $ipid $vpid $spid" > r.o.$fn
echo " config/${props} -Drequests=5000000000 -Drequesters=$dop -Dmaxtime=$secs -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dreq_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb0 -r" >> r.o.$fn

/usr/bin/time -o r.time.$fn bash bin/linkbench -c config/${props} -Drequests=5000000000 -Drequesters=$dop -Dmaxtime=$secs -Dmaxid1=$maxid -Dprogressfreq=10 -Ddisplayfreq=10 -Dreq_progress_interval=100000 -Dhost=${dbhost} $logarg -Ddbid=linkdb0 -r >> r.o.$fn 2>&1

kill $ipid
kill $vpid
kill $spid
# kill $mpid

if [[ $myORmo = "mongo" ]]; then
  cred="-u root -p pw --authenticationDatabase=admin"
  echo "db.serverStatus()" | $client $cred linkdb0 > r.stat.$fn
  echo "db.linktable.stats()" | $client $cred linkdb0 > r.link.$fn
  echo "db.nodetable.stats()" | $client $cred linkdb0 > r.node.$fn
  echo "db.counttable.stats()" | $client $cred linkdb0 > r.count.$fn
  echo "db.oplog.rs.stats()" | $client $cred local > r.oplog.$fn
  echo "show dbs" | $client $cred linkdb0 > r.dbs.$fn

else
  $client -uroot -ppw -A -h${dbhost} -e 'reset master'
  $client -uroot -ppw -A -h${dbhost} -e 'show engine innodb status\G' > r.esi.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show engine rocksdb status\G' > r.esr.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show engine tokudb status\G' > r.est.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show global status' > r.gs.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show global variables' > r.gv.$fn
  $client -uroot -ppw -A -h${dbhost} linkdb0 -e 'show table status' > r.ts.$fn
  $client -uroot -ppw -A -h${dbhost} linkdb0 -e 'show indexes from linktable' > r.is.$fn
  $client -uroot -ppw -A -h${dbhost} linkdb0 -e 'show indexes from nodetable' >> r.is.$fn
  $client -uroot -ppw -A -h${dbhost} linkdb0 -e 'show indexes from counttable' >> r.is.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'show memory status\G' > r.mem.$fn
fi

echo "after $ddir" >> r.sz1.$fn
du -sm $ddir >> r.sz1.$fn
echo "after $ddir" >> r.sz2.$fn
du -sm $ddir/* >> r.sz2.$fn
echo "after $ddir" >> r.asz1.$fn
du -sm --apparent-size $ddir >> r.asz1.$fn
echo "after $ddir" >> r.asz2.$fn
du -sm --apparent-size $ddir/* >> r.asz2.$fn

ips=$( grep "REQUEST PHASE COMPLETED" r.o.$fn | awk '{ print $NF }' )
grep "REQUEST PHASE COMPLETED" r.o.$fn  > r.r.$fn

printf "\nsamp\tr/s\trkb/s\twkb/s\tr/q\trkb/q\twkb/q\tips\n" >> r.r.$fn
grep $dname r.io.$fn | awk '{ rs += $2; rkb += $4; wkb += $5; c += 1 } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.6f\t%.6f\t%s\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q }' q=$ips >> r.r.$fn

printf "\nsamp\tcs/s\tcpu/s\tcs/q\tcpu/q\n" >> r.r.$fn
grep -v swpd r.vm.$fn | grep -v procs | awk '{ cs += $12; cpu += $13 + $14; c += 1 } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=$ips >> r.r.$fn

echo >> r.r.$fn
head -4 r.sz1.$fn >> r.r.$fn

echo >> r.r.$fn
head -1 r.ps.$fn >> r.r.$fn
tail -1 r.ps.$fn >> r.r.$fn

for op in UPDATE_NODE GET_NODE UPDATE_LINK GET_LINKS_LIST ; do tail -20 r.o.$fn | grep $op | grep main ; done >> r.r.$fn

