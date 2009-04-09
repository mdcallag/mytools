# engine type
e=$1

# scale factor
sf=$2

# path to 'mysql' binary
mysql=$3

# max value for --threads
maxdop=$4

# if yes then prepare test tables else ignore
prepare=$5

myu=$6
myp=$7
myd=$8
mysock=$9

run_mysql="$mysql -u$myu -p$myp -S$mysock $myd -A"

if [[ ${10} == "yes" ]]; then
  index_after="--index_after_load"
else
  index_after=""
fi

py_args=\
"--db_name=$myd --db_user=$myu --db_password=$myp --db_sock=$mysock\
 --scale_factor=$sf $index_after"

if [[ $prepare == "yes" ]]; then
  echo Setup
  $mysql -u$myu -p$myp -S$mysock -A -e "create database $myd"
  $run_mysql -e 'drop table if exists onektup'
  $run_mysql -e 'drop table if exists tenktup1'
  $run_mysql -e 'drop table if exists tenktup2'
  $run_mysql -e 'show tables'
  echo Setup:: ../wisc/wisc.py $py_args --prepare
  ../wisc/wisc.py $py_args --prepare || exit 1

  $run_mysql -e 'analyze table onektup'
  $run_mysql -e 'analyze table tenktup1'
  $run_mysql -e 'analyze table tenktup2'
fi

$run_mysql -e 'select count(*) from onektup'
$run_mysql -e 'select count(*) from tenktup1'
$run_mysql -e 'select count(*) from tenktup2'
$run_mysql -e 'show table status like "onektup"'
$run_mysql -e 'show table status like "tenktup%"'
sleep 30

echo "Run maxdop $maxdop"
dop=1
while [[ $dop -le $maxdop ]]; do
  echo Run $dop

  echo Run:: ../wisc/wisc.py $py_args --threads=$dop
  ../wisc/wisc.py $py_args --threads=$dop || exit 1

  echo; echo; echo SHOW MUTEX STATUS
  $run_mysql -B -e 'show mutex status' | head -1
  $run_mysql -B -e 'show mutex status' | \
      awk '{ if ($3 > 0) { print $0 } }' | sort -r -n -k 3,3 | head -10

  echo
  echo BY CALLERS
  $run_mysql -B -e 'show mutex status' | head -1
  $run_mysql -B -e 'show mutex status' | \
      awk '{ if ($3 < 0) { $3 = -$3; print $0 } }' | sort -r -n -k 3,3 | head -20

  echo; echo; echo SHOW GLOBAL MUTEX STATUS
  $run_mysql -B -e 'show global mutex status' | head -1
  $run_mysql -B -e 'show global mutex status' | \
      awk '{ if ($3 > 0) { print $0 } }' | sort -r -n -k 3,3 | head -20

  echo
  echo BY CALLERS
  $run_mysql -B -e 'show global mutex status' | head -1
  $run_mysql -B -e 'show global mutex status' | \
      awk '{ if ($3 < 0) { $3 = -$3; print $0 } }' | sort -r -n -k 3,3 | head -20

  echo
  $run_mysql -e 'show innodb status\G'
  $run_mysql -e 'show variables like "version_comment"'

  dop=$(( $dop * 2 ))

done
