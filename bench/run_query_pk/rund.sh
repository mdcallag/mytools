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

# number of queries per session
nq=${10}

# test table name
tn=${11}

# yes -- index-only on PK index
# no -- not index only
# TODO -- make 'yes' work for HANDLER
pk_only=${12}

# ps -- use prepared statements
# rs -- use plain SQL
# hs -- use HANDLER statements
#
sql=${13}
if [[ $sql == "ps" ]]; then
  # use prepared statements
  # for i in $( seq 1 $maxdop ); do
  for i in $( seq 1 1 ); do
    if [[ $pk_only == "yes" ]]; then
      echo "PREPARE stmt FROM \"SELECT i FROM $tn$i where i = ?\";" > q$i
    else
      echo "PREPARE stmt FROM \"SELECT i,j FROM $tn$i where i = ?\";" > q$i
    fi
    echo "set @a = $i;" >> q$i
    for q in $( seq 1 $nq ); do
      echo "EXECUTE stmt using @a;"
    done >> q$i
    echo "DEALLOCATE PREPARE stmt" >> q$i
  done
else
if [[ $sql = "hs" ]]; then
  # use handler statements
  if [[ $pk_only != "yes" ]]; then
    echo "pk_only must be yes for sql == hs"
    exit 1
  fi
  # for i in $( seq 1 $maxdop ); do
  for i in $( seq 1 1 ); do
    echo "HANDLER $tn$i OPEN;" > q$i
    for q in $( seq 1 $nq ); do
      echo "HANDLER $tn$i READ \`PRIMARY\` = ($i);"
    done >> q$i
    echo "HANDLER $tn$i CLOSE;" >> q$i
  done
else
  # use regular statements
  # for i in $( seq 1 $maxdop ); do
  for i in $( seq 1 1 ); do
    for q in $( seq 1 $nq ); do
      if [[ $pk_only == "yes" ]]; then
        echo "select i from $tn$i where i = $i;"
      else
        echo "select i,j from $tn$i where i = $i;"
      fi
    done > q$i
  done
fi
fi

shift 13

vmstat_bin=$( which vmstat )
iostat_bin=$( which iostat )

while (( "$#" )) ; do
  b=$1
  shift 1
  mybase=$ibase/$b
  mysql=$mybase/bin/mysql
  dz=$mybase/bin/drizzle
  mysock=$mybase/var/mysql.sock
  run_mysql="$mysql -u$myu -p$myp -S$mysock $myd"
  run_dz="$dz "
  echo Running $b from $mybase

  # mv /etc/my.cnf /etc/my.cnf.bak

  $mybase/bin/drizzle --shutdown
  if [[ $runasroot == "yes" ]] ; then
    echo $mybase/sbin/drizzled --user=root 
    $mybase/sbin/drizzled --user=root --pool_of_threads --pool_of_threads-size=4 --scheduler=pool_of_threads >& $mybase/o.d &
  else
    $mybase/sbin/drizzled >& $mybase/o.d &
  fi

  sleep 10
  $run_dz -e 'show variables like "version_comment"'

  if [[ $use_oprofile == "yes" ]]; then
    opcontrol --shutdown
    opcontrol --reset
    opcontrol --setup --no-vmlinux --event=CPU_CLK_UNHALTED:100000:0:0:1 --separate=library
    opcontrol --start
  fi

  if [ ! -z $vmstat_bin ]; then
    $vmstat_bin 10 100000 > ls.v.$engine.$b.nr_$nr.nq_$nq.$sql.io_${pk_only} &
    vmstat_pid=$!
  fi
  if [ ! -z $iostat_bin ]; then
    $iostat_bin -x 10 100000 > ls.i.$engine.$b.nr_$nr.nq_$nq.$sql.io_${pk_only} &
    iostat_pid=$!
  fi

  if [[ $b == "5138fbcuda" && $engine == "innodb" ]]; then
    ic="yes"
  else
    ic="no"
  fi

  echo Running $b $engine $sql
  bash rund1.sh $nr $nq $engine $dz $maxdop $myu $myp $myd $tn $mysock ls.x.$engine.$b.nr_$nr.nq_$nq.$sql.io_${pk_only} $ic \
      > ls.o.$engine.$b.nr_$nr.nq_$nq.$sql.io_${pk_only}
  echo -n $b "$engine $sql $pk_only " > ls.r.$engine.$b.nr_$nr.nq_$nq.$sql.io_${pk_only}

  if [ ! -z $vmstat_bin ]; then kill -9 $vmstat_pid; fi
  if [ ! -z $iostat_bin ]; then kill -9 $iostat_pid; fi

  grep maxscantime ls.o.$engine.$b.nr_$nr.nq_$nq.$sql.io_${pk_only} | awk '{ printf "%s ", $2 }' >> ls.r.$engine.$b.nr_$nr.nq_$nq.$sql.io_${pk_only}
  echo >> ls.r.$engine.$b.nr_$nr.nq_$nq.$sql.io_${pk_only}

  # TODO cleanup
  if [[ $use_oprofile == "yes" ]]; then
    opcontrol --dump; sleep 5
    opreport --demangle=smart --symbols >& ls.p.$engine.$b.nr_$nr.nq_$nq.$sql.io_${pk_only}
    opcontrol --shutdown 
  fi

  echo Running $b shutdown
  $mybase/bin/drizzle --shutdown
  sleep 10
done

