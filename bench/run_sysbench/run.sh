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
# siac : --oltp-read-only --oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-all-cols
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

shift 17

while (( "$#" )) ; do
  b=$1
  shift 1
  mybase=$ibase/$b
  mysock=$mybase/var/mysql.sock
  echo Running $b from $mybase

  mysql=$mybase/bin/mysql
  run_mysql="$mysql -u$myu -p$myp -h$dbh -A "

  echo Run ssh $dbh "$mybase/bin/mysqladmin -uroot -p$myp -S$mysock shutdown"
  ssh $dbh "$mybase/bin/mysqladmin -uroot -p$myp -S$mysock shutdown"

  if [[ $runasroot == "yes" ]] ; then
    ssh $dbh "$mybase/bin/mysqld_safe --user=root > /dev/null 2>&1 &"
  else
    ssh $dbh "$mybase/bin/mysqld_safe > /dev/null 2>&1 &"
  fi
  echo Sleep after startup  
  sleep 15

  # Warmup buffer cache -- TODO make this optional
  # echo Warmup buffer cache
  # $run_mysql test -e 'select count(*) from sbtest where length(c) > -1'
  # $run_mysql test -e 'select count(*) from sbtest where (k + 1 ) > -99'
  # echo Done warmup buffer cache

  echo ssh $dbh "$mybase/bin/mysql -uroot -p$myp -S$mysock -e \"grant all on *.* to root@'%' identified by '$myp' \" "
  ssh $dbh "$mybase/bin/mysql -uroot -p$myp -S$mysock -e \"grant all on *.* to root@'%' identified by '$myp' \" "

  if [[ $use_oprofile == "yes" ]]; then
    echo Start oprofile
    ssh $dbh opcontrol --shutdown
    ssh $dbh  opcontrol --reset
    ssh $dbh  opcontrol --setup --no-vmlinux --event=CPU_CLK_UNHALTED:100000:0:0:1 --separate=library
    ssh $dbh  opcontrol --start
  fi

  # TODO -- support ssh
  ssh $dbh "vmstat 10 100000" > sb.v.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist &
  ssh $dbh "iostat -x 10 100000" > sb.i.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist &

  echo Running $b $engine
  bash run1.sh $engine $t $nr $strx $etrx $mysql $maxdop $prepare $myu $myp $myd $dbh $usepk $dist > \
      sb.o.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  echo -n $b "$engine " > sb.r.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  grep transactions: sb.o.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist | awk '{ print $3 }' | tr '(' ' ' > res
  awk '{ printf "%s ", $1 }' res >> sb.r.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  echo >> sb.r.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist

  ssh $dbh killall vmstat
  ssh $dbh killall iostat

  if [[ $use_oprofile == "yes" ]]; then
    echo Stop oprofile
    ssh $dbh opcontrol --dump
    sleep 5
    ssh $dbh opreport --demangle=smart --symbols > sb.p.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
    ssh $dbh opcontrol --shutdown
  fi

  $run_mysql -e "show innodb status\G" >> sb.is.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist
  $run_mysql -e "show status" >> sb.s.$engine.$b.t_$t.r_$nr.tx_$strx.pk_$usepk.dist_$dist

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
  sleep 10
done
