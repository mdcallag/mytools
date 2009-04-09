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

# scale factor
sf=$9

# if yes then prepare the test tables
prepare=${10}

# if yes then drop the test tables at test end
drop=${11}

# if yes then create indexes after loading the tables, else ignore
index_after=${12}

shift 12
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

  echo Running $b $engine
  bash run1.sh $engine $sf $mysql $maxdop $prepare $myu $myp $myd $mysock $index_after > \
      wb.o.$engine.$b.sf_$sf
  echo -n $b "$engine " > wb.r.$engine.$b.sf_$sf
  grep "Test time is" wb.o.$engine.$b.sf_$sf | awk '{ print $4 }' | tr '(' ' ' > res
  awk '{ printf "%s ", $1 }' res >> wb.r.$engine.$b.sf_$sf
  echo >> wb.r.$engine.$b.sf_$sf

  if [[ $drop != "no" ]]; then
    $mysql -u$myu -p$myp -S$mysock $myd -e "drop table onektup"
    $mysql -u$myu -p$myp -S$mysock $myd -e "drop table tenktup1"
    $mysql -u$myu -p$myp -S$mysock $myd -e "drop table tenktup2"
  fi

  if [[ $use_oprofile == "yes" ]]; then
    opreport --demangle=smart --symbols=$mybase/libexec/mysqld > wb.p.$engine.$b.sf_$sf
    opcontrol --shutdown
  fi
  
  echo Running $b shutdown
  $mybase/bin/mysqladmin -u$myu -p$myp -S$mysock shutdown
  sleep 10
done
