# max value for --num-threads
maxdop=$1

# base directory for mysql install
ibase=$2

# if yes then run mysql as root else ignore
runasroot=$3

# user, password and database to use
myu=$4
myp=$5
myd=$6

# name of storage engine
engine=$7

# number of warehouses
nw=$8

# if yes then prepare the sbtest table else ignore
prepare=${9}

# if yes then drop the sbtest table at test end else ignore
drop=${10}

# Number of seconds to warmup the server
rt=${11}

# Number of seconds to test the server
mt=${12}

# db host
dbh=${13}

# use innodb compression (yes, no)
compress=${14}

vmstat_bin=$( which vmstat )
iostat_bin=$( which iostat )

echo Run on
ssh $dbh hostname

shift 14

while (( "$#" )) ; do
  b=$1
  shift 1
  mybase=$ibase/$b
  mysql=$mybase/bin/mysql
  mysock=$mybase/var/mysql.sock
  #run_mysql="$mysql -u$myu -p$myp -S$mysock $myd"
  run_mysql="$mysql -u$myu -p$myp -h$dbh "
  echo Running $b from $mybase

  # mv /etc/my.cnf /etc/my.cnf.bak

  echo Shutdown at $( date )
  ssh $dbh $mybase/bin/mysqladmin -u$myu -p$myp -h127.0.0.1 shutdown
  sleep 20

  echo Start mysqld at $( date )
  if [[ $runasroot == "yes" ]] ; then
    echo ssh $dbh "$mybase/bin/mysqld_safe --user=root > /tmp/tpccsu 2>&1 &"
    ssh $dbh "$mybase/bin/mysqld_safe --user=root > /tmp/tpccsu 2>&1 &"
  else
    echo ssh start
    ssh $dbh "$mybase/bin/mysqld_safe > /tmp/tpccsu 2>&1 &"
  fi

  sleep 5
  while ! $run_mysql -e 'show variables like "version_comment"' ; do
    echo Wait for mysqld to be ready
    sleep 5
  done

  echo Sleep 10 after start
  sleep 10

  echo ssh $dbh "$mybase/bin/mysql -u$myu -p$myp -S$mysock -e \"grant all on *.* to root@'%' identified by '$myp' \" "
  ssh $dbh "$mybase/bin/mysql -u$myu -p$myp -S$mysock -e \"grant all on *.* to root@'%' identified by '$myp' \" "
  ssh $dbh "$mybase/bin/mysql -u$myu -p$myp -S$mysock mysql -e \"delete from user where length(Password) = 0; flush privileges;\""

  $run_mysql -e 'show variables like "version_comment"'

  echo scp mstat
  scp mstat.py $dbh:/data/$b
  ssh $dbh "ps aux | grep mstat\.py | grep -v grep | awk '{ print \$2 }' | xargs kill -9"

  sfx=$engine.$b.nw_$nw.c_${compress}
  ssh $dbh "python /data/mstat.py --loops 1000000 --interval 10 --db_user=$myu --db_password=$myp --db_host=$dbh" \
                 > tpc.mstat.$sfx &

  ssh $dbh killall vmstat
  ssh $dbh "vmstat 10 100000" > tpc.v.$sfx &

  ssh $dbh killall iostat
  ssh $dbh "iostat -x 10 100000" > tpc.i.$sfx &

  echo Running $b $engine
  bash run1.sh $nw $engine $mysql $maxdop $myu $myp $myd $mysock $rt $mt $prepare $drop $dbh $compress \
      > tpc.o.$sfx
  echo -n $b "$engine " > tpc.r.$sfx

  ssh $dbh killall vmstat
  ssh $dbh killall iostat
  ssh $dbh "ps aux | grep mstat\.py | grep -v grep | awk '{ print \$2 }' | xargs kill -9"

  $run_mysql -e 'show global status' > tpc.gs.$sfx
  $run_mysql -e 'show global variables' > tpc.gv.$sfx
  $run_mysql -e 'show engine innodb status\G' > tpc.is.$sfx
  $run_mysql -e 'select * from information_schema.user_statistics\G' > tpc.us.$sfx

  rm -f tpc.r.$sfx
  dop=1
  while [[ $dop -le $maxdop ]]; do
    mv tpc.o.$dop tpc.o.$dop.$sfx
    grep TpmC tpc.o.$dop.$sfx | grep -v '<TpmC>' | \
        awk '{ printf "%s ", $1 }' >> tpc.r.$sfx
    dop=$(( $dop * 2 ))
  done
  echo >> tpc.r.$sfx

  rm -f tpc.rno.$sfx
  dop=1
  while [[ $dop -le $maxdop ]]; do

    if [ ! -f tpc.rno.$sfx ]; then
      awk '/^MEASURING START/,/^STOPPING/' tpc.o.$dop.$sfx | \
        awk '{ if (NF == 6) { print $1 } }' | \
        tr ',' ' '  > tpc.rno.$sfx
    fi

    awk '/^MEASURING START/,/^STOPPING/' tpc.o.$dop.$sfx | \
      awk '{ if (NF == 6) { print $2 } }' | \
      tr ':' ' ' | \
      awk '{ print $2 }' | \
      tr ',' ' ' > tpc.rno.$dop

    paste tpc.rno.$sfx tpc.rno.$dop > tpc.tmp
    mv tpc.tmp tpc.rno.$sfx

    dop=$(( $dop * 2 ))
  done

  rm -f tpc.rpa.$sfx
  dop=1
  while [[ $dop -le $maxdop ]]; do

    if [ ! -f tpc.rpa.$sfx ]; then
      awk '/^MEASURING START/,/^STOPPING/' tpc.o.$dop.$sfx | \
        awk '{ if (NF == 6) { print $1 } }' | \
        tr ',' ' '  > tpc.rpa.$sfx
    fi

    awk '/^MEASURING START/,/^STOPPING/' tpc.o.$dop.$sfx | \
      awk '{ if (NF == 6) { print $3 } }' | \
      tr ':' ' ' | \
      awk '{ print $2 }' | \
      tr ',' ' ' > tpc.rpa.$dop

    paste tpc.rpa.$sfx tpc.rpa.$dop > tpc.tmp
    mv tpc.tmp tpc.rpa.$sfx

    dop=$(( $dop * 2 ))
  done

  # TODO cleanup
  echo Running $b shutdown
  ssh $dbh $mybase/bin/mysqladmin -u$myu -p$myp -h127.0.0.1 shutdown
  sleep 10
done

