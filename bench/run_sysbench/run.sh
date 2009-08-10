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

# if 0 then use --oltp-read-only else ignore
strx=${11}

# if yes then prepare the sbtest table else ignore
prepare=${12}

# if yes then drop the sbtest table at test end else ignore
drop=${13}

# --mysql-engine-trx=[yes,no]
etrx=${14}

shift 14

vmstat_bin=$( which vmstat )
iostat_bin=$( which iostat )

while (( "$#" )) ; do
  b=$1
  shift 1
  mybase=$ibase/$b
  mysql=$mybase/bin/mysql
  mysock=$mybase/var/mysql.sock
  echo Running $b from $mybase

  # mv /etc/my.cnf /etc/my.cnf.bak

  $mybase/bin/mysqladmin -uroot -S$mysock shutdown

  if [[ $runasroot == "yes" ]] ; then
    $mybase/bin/mysqld_safe --user=root &
  else
    $mybase/bin/mysqld_safe &
  fi
  echo Sleep after startup  
  sleep 15

  if [[ $use_oprofile == "yes" ]]; then
    opcontrol --shutdown
    opcontrol --reset
    opcontrol --setup --no-vmlinux --event=CPU_CLK_UNHALTED:100000:0:0:1 --separate=library
    opcontrol --start
  fi

  if [ ! -z $vmstat_bin ]; then
    $vmstat_bin 10 100000 > sb.v.$engine.$b.t_$t.r_$nr.tx_$strx &
    vmstat_pid=$!
  fi
  if [ ! -z $iostat_bin ]; then
    $iostat_bin -x 10 100000 > sb.i.$engine.$b.t_$t.r_$nr.tx_$strx &
    iostat_pid=$!
  fi

  echo Running $b $engine
  bash run1.sh $engine $t $nr $strx $etrx $mysql $maxdop $prepare $myu $myp $myd $mysock > \
      sb.o.$engine.$b.t_$t.r_$nr.tx_$strx
  echo -n $b "$engine " > sb.r.$engine.$b.t_$t.r_$nr.tx_$strx
  grep transactions: sb.o.$engine.$b.t_$t.r_$nr.tx_$strx | awk '{ print $3 }' | tr '(' ' ' > res
  awk '{ printf "%s ", $1 }' res >> sb.r.$engine.$b.t_$t.r_$nr.tx_$strx
  echo >> sb.r.$engine.$b.t_$t.r_$nr.tx_$strx

  if [ ! -z $vmstat_bin ]; then kill -9 $vmstat_pid; fi
  if [ ! -z $iostat_bin ]; then kill -9 $iostat_pid; fi

  if [[ $drop != "no" ]]; then
    $mysql -u$myu -p$myp -S$mysock -e "drop table sbtest"
  fi

  if [[ $use_oprofile == "yes" ]]; then
    opreport --demangle=smart --symbols=$mybase/libexec/mysqld > sb.p.$engine.$b.t_$t.r_$nr.tx_$strx
    opcontrol --shutdown
  fi
  
  echo Running $b shutdown
  $mybase/bin/mysqladmin -u$myu -p$myp -S$mysock shutdown
  sleep 10
done
