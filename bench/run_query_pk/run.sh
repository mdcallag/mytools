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
idx_only=${12}

# ps -- use prepared statements
# rs -- use plain SQL
# hs -- use HANDLER statements
# ha -- use open, read, close with HANDLER
#
sql=${13}
if [[ $sql == "ps" ]]; then
  # use prepared statements
  echo Use ps
  for i in $( seq 1 1 ); do
    if [[ $idx_only == "yes" ]]; then
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
if [[ $sql == "hs" ]]; then
  # use handler statements
  echo Use hs
  if [[ $idx_only == "yes" ]]; then
    echo "idx_only must be no for sql == hs"
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
if [[ $sql == "ha" ]]; then
  # use handler statements
  echo Use ha
  if [[ $idx_only == "yes" ]]; then
    echo "idx_only must be no for sql == ha"
    exit 1
  fi
  # for i in $( seq 1 $maxdop ); do
  for i in $( seq 1 1 ); do
    for q in $( seq 1 $nq ); do
      echo "HANDLER $tn$i OPEN; HANDLER $tn$i READ \`PRIMARY\` = ($i); HANDLER $tn$i CLOSE;"
    done >> q$i
  done
else
  # use regular statements
  echo Use rs
  for i in $( seq 1 1 ); do
    for q in $( seq 1 $nq ); do
      if [[ $idx_only == "yes" ]]; then
        echo "select i from $tn$i where i = $i;"
      else
        echo "select i,j from $tn$i where i = $i;"
      fi
    done > q$i
  done
fi
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

  sleep 10
  $run_mysql -e 'show variables like "version_comment"'

  if [[ $use_oprofile == "yes" ]]; then
    opcontrol --shutdown
    opcontrol --reset
    opcontrol --setup --no-vmlinux --event=CPU_CLK_UNHALTED:100000:0:0:1 --separate=library
    opcontrol --start
    opcontrol -c 4
  fi

  if [ ! -z $vmstat_bin ]; then
    $vmstat_bin 10 100000 > ls.v.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only} &
    vmstat_pid=$!
  fi
  if [ ! -z $iostat_bin ]; then
    $iostat_bin -x 10 100000 > ls.i.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only} &
    iostat_pid=$!
  fi

  if [[ $b == "5138fbcuda" && $engine == "innodb" ]]; then
    ic="yes"
  else
    ic="no"
  fi

  echo Running $b $engine $sql
  bash run1.sh $nr $nq $engine $mysql $maxdop $myu $myp $myd $tn $mysock ls.x.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only} $ic \
      > ls.o.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  echo -n $b "$engine $sql $idx_only " > ls.r.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}

  if [ ! -z $vmstat_bin ]; then kill -9 $vmstat_pid; fi
  if [ ! -z $iostat_bin ]; then kill -9 $iostat_pid; fi

  grep maxscantime ls.o.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only} | awk '{ printf "%s ", $2 }' >> ls.r.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  echo >> ls.r.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}

  # TODO cleanup
  if [[ $use_oprofile == "yes" ]]; then
    opcontrol --dump; sleep 5
    opreport --demangle=smart --symbols >& ls.pf.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
    opreport -c --demangle=smart --symbols >& ls.ph.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
    opcontrol --shutdown 
  fi

  $run_mysql -e "show innodb status\G" > ls.is.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  $run_mysql -e "show status" > ls.s.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}

  #
  # Innodb mutex stats
  #
  $run_mysql -e 'show mutex status' > ls.ms.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  # By mutex
  $run_mysql -B -e 'show mutex status' | head -1 > ls.ms20.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  sort -k 1,1 ls.ms.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only} | \
    grep -v OS_waits | \
    awk '{ if ($1 != pk) { if (s > 0) { printf "%10d\t%s\n", s, pk }; s = $2; pk = $1 } else { s += $2 } } END { if (s > 0) { printf "%10d\t%s\n", s, pk } } ' | \
    sort -r -n -k 1,1 | \
    head -20 >> ls.ms20.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  # By callers
  $run_mysql -B -e 'show mutex status' | head -1 > ls.cms20.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  sort -k 1,1 ls.ms.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only} | \
    grep -v OS_waits | \
    awk '{ if ($1 != pk) { if (s < 0) { printf "%10d\t%s\n", -s, pk }; s = $2; pk = $1 } else { s += $2 } } END { if (s < 0) { printf "%10d\t%s\n", -s, pk } } '  | \
    sort -r -n -k 1,1 | \
    head -20 >> ls.cms20.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}

  #
  # General mutex stats
  #
  $run_mysql -e 'show global mutex status' > ls.gs.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  # By mutex
  $run_mysql -B -e 'show global mutex status' | head -1 > ls.gs20.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  sort -r -n -k 3,3 ls.gs.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only} | grep -v Sleeps | head -20 > ls.gs20.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  # By caller
  $run_mysql -B -e 'show global mutex status' | head -1 > ls.cgs20.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}
  grep -v Sleeps ls.gs.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only} | \
    awk '{ if ($3 < 0) { $3 = -$3; print $0 } }' | \
    sort -r -n -k 3,3 | \
    head -20 > ls.cgs20.$engine.$b.nr_$nr.nq_$nq.$sql.io_${idx_only}

  echo Running $b shutdown
  $mybase/bin/mysqladmin -u$myu -p$myp -S$mysock shutdown
  sleep 10
done

