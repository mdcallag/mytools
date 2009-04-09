# engine type
e=$1

# test duration
t=$2

# num rows
nr=$3

# 0 --> --oltp-read-only
strx=$4
if [[ $strx -eq 0 ]]; then
  xa="--oltp-read-only"
  if [[ $e == "myisam" ]]; then
    xa="$xa --oltp-skip-trx"
  elif [[ $e == "heap" ]]; then
    xa="$xa --oltp-skip-trx"
  elif [[ $e == "blackhole" ]]; then
    xa="$xa --oltp-skip-trx"
  fi
else
  xa=""
fi

# --mysql-engine-trx=[yes,no]
etrx=$5

# path to 'mysql' binary
mysql=$6

# max value for --num-threads
maxdop=$7

# if yes then prepare sbtest table else ignore
prepare=$8

myu=$9
myp=${10}
myd=${11}
mysock=${12}

run_mysql="$mysql -u$myu -p$myp -S$mysock $myd -A"

sb=./sysbench2

if [[ $e == "heap" ]]; then
  xa="$xa --oltp-auto-inc=off"
fi

def_args=" --mysql-socket=$mysock --mysql-user=$myu --mysql-password=$myp --mysql-db=$myd "

sb_args=" --test=oltp ${def_args} --oltp-table-size=$nr --max-time=$t --max-requests=0 --mysql-table-engine=$e --db-ps-mode=disable --mysql-engine-trx=$etrx --oltp-secondary-index"

# Values used by Percona
# sb_args=" --test=oltp ${def_args}  --oltp-table-size=$nr --mysql-engine-trx=yes --oltp-test-mode=nontrx --oltp-nontrx-mode=update_key --max-requests=0 --oltp-dist-type=uniform --init-rng=on --max-time=$t --max-requests=0 "

if [[ $prepare == "yes" ]]; then
  echo Setup
  $mysql -u$myu -p$myp -S$mysock -A -e "create database $myd"
  $run_mysql -e 'drop table if exists sbtest'
  $run_mysql -e 'show tables'
  echo Run:: $sb $sb_args prepare
  $sb $sb_args prepare || exit 1
fi

$run_mysql -e 'analyze table sbtest'
$run_mysql -e 'select count(*) from sbtest'
sleep 30

dop=1
while [[ $dop -le $maxdop ]]; do
  echo Run $dop
  echo $sb $sb_args $xa --num-threads=$dop run
  $sb $sb_args $xa --num-threads=$dop run

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
  $run_mysql -e 'show table status like "sbtest"'
  $run_mysql -e 'select count(*) from sbtest'

  dop=$(( $dop * 2 ))

done
