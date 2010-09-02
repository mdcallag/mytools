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

# if yes then enable oprofile else ignore
use_oprofile=$7

# name of storage engine
engine=$8

# number of rows
nr=$9

# Test duration
t=${10}

# rw : (default, no extra params)
# ro   : --oltp-read-only --oltp-skip-trx
# si   : --oltp-read-only --oltp-skip-trx --oltp-test-mode=simple
# roha : --oltp-read-only --oltp-skip-trx --oltp-point-select-mysql-handler
# siha : --oltp-read-only --oltp-skip-trx ---oltp-point-select-mysql-handler --oltp-test-mode=simple
# sihaorc : --oltp-read-only --oltp-skip-trx ---oltp-point-select-mysql-handler-open-read-close --oltp-test-mode=simple
# siac : --oltp-read-only --oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-all-cols
# sij : --oltp-read-only --oltp-skip-trx --oltp-test-mode=simplejoin 
# incupd : --oltp-skip-trx --oltp-test-mode=incupdate
# incins : --oltp-skip-trx --oltp-test-mode=incinsert
# sirw : --oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-all-cols --oltp-simple-update

strx=${11}

# if yes then prepare the sbtest table else ignore
prepare=${12}

# if yes then drop the sbtest table at test end else ignore
drop=${13}

# --mysql-engine-trx=[yes,no]
etrx=${14}

dbh=${15}

# when 'no' --oltp-secondary
usepk=${16}

# distribution u==uniform, s==special
dist=${17}

# yes -> warmup the buffer cache
warmup=${18}

# value for --oltp-range-size
range=${19}

shift 19

while (( "$#" )) ; do
  b=$1
  shift 1
  mybase=$ibase/$b
  mysock=$mybase/var/mysql.sock
  echo Running $b from $mybase

  ssh $dbh "ps aux | grep mstat\.py | grep -v grep | awk '{ print \$2 }' | xargs kill -9"

  mysql=$mybase/bin/mysql
  run_mysql="$mysql -u$myu -p$myp -h$dbh -A "

  echo Run ssh $dbh "$mybase/bin/mysqladmin -u$myu -p$myp -S$mysock shutdown"
  ssh $dbh "$mybase/bin/mysqladmin -u$myu -p$myp -S$mysock shutdown"

  if [[ $runasroot == "yes" ]] ; then
    echo ssh $dbh "$mybase/bin/mysqld_safe --user=root > /dev/null 2>&1 &"
    ssh $dbh "$mybase/bin/mysqld_safe --user=root > /dev/null 2>&1 &"
  else
    ssh $dbh "$mybase/bin/mysqld_safe > /dev/null 2>&1 &"
  fi
  echo Sleep after startup  
  sleep 40

  echo ssh $dbh "$mybase/bin/mysql -u$myu -p$myp -S$mysock -e \"grant all on *.* to root@'%' identified by '$myp' \" "
  ssh $dbh "$mybase/bin/mysql -u$myu -p$myp -S$mysock -e \"grant all on *.* to root@'%' identified by '$myp' \" "
  ssh $dbh "$mybase/bin/mysql -u$myu -p$myp -S$mysock mysql -e \"delete from user where length(Password) = 0; flush privileges;\""

  echo Running $b $engine
  rm -f startme
  bash run1.sh $engine $t $nr $strx $etrx $mysql $maxdop $prepare $myu $myp $myd $dbh $usepk $dist $warmup $range > \
      sb.o.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist &
  fid=$!

  while [[ ! -f startme ]]; do echo "wait for startme"; sleep 5; done

  if [[ $use_oprofile == "yes" ]]; then
    ssh $dbh which opcontrol
    ssh $dbh opcontrol --shutdown
    if ! ssh $dbh opcontrol --setup --no-vmlinux --event=CPU_CLK_UNHALTED:100000:0:0:1 --image=all --separate=library ; then
      echo "try oprofile in timer mode"
      if ! ssh $dbh opcontrol --setup --no-vmlinux --image=all --separate=library ; then
        echo "cannot start oprofile"
        exit 1
      fi
    fi
    ssh $dbh opcontrol --no-vmlinux --start
    ssh $dbh opcontrol --reset
    ssh $dbh opcontrol --status
  fi

  ssh $dbh killall vmstat
  ssh $dbh "vmstat 10 100000" > sb.v.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist &

  ssh $dbh killall iostat
  ssh $dbh "iostat -x 10 100000" > sb.i.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist &

  ssh $dbh "ps aux | grep mstat\.py | grep -v grep | awk '{ print \$2 }' | xargs kill -9"
  ssh $dbh "sysctl dev.flashcache.zero_stats=1"
  ssh $dbh "cat /proc/flashcache_stats" > sb.fc0.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist 
  ssh $dbh "python /data/mstat.py --loops 1000000 --interval 10 --db_user=$myu --db_password=$myp --db_host=$dbh" \
                 > sb.mstat.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist &
 
  wait $fid

  echo -n $b "$engine " > sb.r.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  grep transactions: sb.o.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist | awk '{ print $3 }' | tr '(' ' ' > res
  awk '{ printf "%s ", $1 }' res >> sb.r.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  echo >> sb.r.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist

  ssh $dbh killall vmstat
  ssh $dbh killall iostat
  ssh $dbh "cat /proc/flashcache_stats" > sb.fc1.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist 
  ssh $dbh "ps aux | grep mstat\.py | grep -v grep | awk '{ print \$2 }' | xargs kill -9"

  if [[ $use_oprofile == "yes" ]]; then
    ssh $dbh opcontrol --dump
    sleep 5
    ssh $dbh opreport --demangle=smart --symbols > sb.p.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
    ssh $dbh opcontrol --shutdown
  fi

  #
  # Innodb mutex stats
  #
  $run_mysql -e 'show mutex status' > sb.ms.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist

  if grep Line sb.ms.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist > /dev/null; then
    grep -v Line sb.ms.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist | \
        awk '{ printf "%s:%s %s\n", $1, $2, $3 }' > sb.mst.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
    mv sb.mst.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist sb.ms.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  fi

  # By mutex
  sort -k 1,1 sb.ms.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist | \
    grep -v OS_waits | \
    awk '{ if ($1 != pk) { if (s > 0) { printf "%10d\t%s\n", s, pk }; s = $2; pk = $1 } else { s += $2 } } END { if (s > 0) { printf "%10d\t%s\n", s, pk } } ' | \
    sort -r -n -k 1,1 | \
    head -20 > sb.ms20.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist

  # By callers
  sort -k 1,1 sb.ms.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist | \
    grep -v OS_waits | \
    awk '{ if ($1 != pk) { if (s < 0) { printf "%10d\t%s\n", -s, pk }; s = $2; pk = $1 } else { s += $2 } } END { if (s < 0) { printf "%10d\t%s\n", -s, pk } } '  | \
    sort -r -n -k 1,1 | \
    head -20 > sb.cms20.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist

  #
  # General mutex stats
  #
  $run_mysql -e 'show global mutex status' > sb.gs.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  # By mutex
  $run_mysql -B -e 'show global mutex status' | head -1 > sb.gs20.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  sort -r -n -k 3,3 sb.gs.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist | grep -v Sleeps | head -20 > sb.gs20.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  # By caller
  $run_mysql -B -e 'show global mutex status' | head -1 > sb.cgs20.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  grep -v Sleeps sb.gs.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist | \
    awk '{ if ($3 < 0) { $3 = -$3; print $0 } }' | \
    sort -r -n -k 3,3 | \
    head -20 > sb.cgs20.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist

  if [[ $drop != "no" ]]; then
    $run_mysql $myd -e "drop table sbtest"
  fi
 
  echo Running $b shutdown
  ssh $dbh "$mybase/bin/mysqladmin -u$myu -p$myp -S$mysock shutdown"
  sleep 5
done
