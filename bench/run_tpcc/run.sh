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

# number of warehouses
nw=$9

# if yes then prepare the sbtest table else ignore
prepare=${10}

# if yes then drop the sbtest table at test end else ignore
drop=${11}

# Number of seconds to warmup the server
rt=${12}

# Number of seconds to test the server
mt=${13}

vmstat_bin=$( which vmstat )
iostat_bin=$( which iostat )

shift 13
while (( "$#" )) ; do
  b=$1
  shift 1
  mybase=$ibase/$b
  mysql=$mybase/bin/mysql
  mysock=$mybase/var/mysql.sock
  run_mysql="$mysql -u$myu -p$myp -S$mysock $myd"
  echo Running $b from $mybase

  # mv /etc/my.cnf /etc/my.cnf.bak

  $mybase/bin/mysqladmin -u$myu -p$myp -S$mysock shutdown
  if [[ $runasroot == "yes" ]] ; then
    $mybase/bin/mysqld_safe --user=root &
  else
    $mybase/bin/mysqld_safe &
  fi
  sleep 15

  $run_mysql -e 'show variables like "version_comment"'

  if [[ $use_oprofile == "yes" ]]; then
    opcontrol --shutdown
    opcontrol --reset
    opcontrol --setup --no-vmlinux --event=CPU_CLK_UNHALTED:100000:0:0:1 --separate=library
    opcontrol --start
  fi

  if [ ! -z $vmstat_bin ]; then
    $vmstat_bin 10 100000 > tpc.v.$engine.$b.nw_$nw &
    vmstat_pid=$!
  fi
  if [ ! -z $iostat_bin ]; then
    $iostat_bin -x 10 100000 > tpc.i.$engine.$b.nw_$nw &
    iostat_pid=$!
  fi

  echo Running $b $engine
  bash run1.sh $nw $engine $mysql $maxdop $myu $myp $myd $mysock $rt $mt $prepare $drop  \
      > tpc.o.$engine.$b.nw_$nw
  echo -n $b "$engine " > tpc.r.$engine.$b.nw_$nw

  if [ ! -z $vmstat_bin ]; then kill -9 $vmstat_pid; fi
  if [ ! -z $iostat_bin ]; then kill -9 $iostat_pid; fi

  grep TpmC tpc.o.$engine.$b.nw_$nw | grep -v '<TpmC>' | \
      awk '{ printf "%s ", $1 }' >> tpc.r.$engine.$b.nw_$nw
  echo >> tpc.r.$engine.$b.nw_$nw

  # TODO cleanup
  echo Running $b shutdown
  $mybase/bin/mysqladmin -u$myu -p$myp -S$mysock shutdown
  sleep 10
done

