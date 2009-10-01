# engine type
e=$1

# test duration
t=$2

# num rows
nr=$3

strx=$4
case $strx in
  "ro")
    xa="--oltp-read-only --oltp-skip-trx" ;;
  "roha")
    xa="--oltp-read-only --oltp-skip-trx --oltp-point-select-mysql-handler" ;;
  "si")
    xa="--oltp-read-only --oltp-skip-trx --oltp-test-mode=simple" ;;
  "siha")
    xa="--oltp-read-only --oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-mysql-handler" ;;
  "siac")
    xa="--oltp-read-only --oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-all-cols" ;;
  "rw"|*)
    xa=" " ;;
esac

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
dbh=${12}
usepk=${13}

if [[ $usepk != "yes" ]]; then
 xa="$xa --oltp-secondary --oltp-auto-inc=off" 
fi

run_mysql="$mysql -u$myu -p$myp -h$dbh $myd -A"

sb="../sysbench --seed-rng=1 "

if [[ $e == "heap" ]]; then
  xa="$xa --oltp-auto-inc=off"
fi

def_args=" --mysql-host=$dbh --mysql-user=$myu --mysql-password=$myp --mysql-db=$myd "

sb_args=" --test=oltp ${def_args} --oltp-table-size=$nr --max-time=$t --max-requests=0 --mysql-table-engine=$e --db-ps-mode=disable --mysql-engine-trx=$etrx "

# Values used by Percona
# sb_args=" --test=oltp ${def_args}  --oltp-table-size=$nr --mysql-engine-trx=yes --oltp-test-mode=nontrx --oltp-nontrx-mode=update_key --max-requests=0 --oltp-dist-type=uniform --init-rng=on --max-time=$t --max-requests=0 "

if [[ $prepare == "yes" ]]; then
  echo Setup
  $mysql -u$myu -p$myp -h$dbh -A -e "create database $myd"
  $run_mysql -e 'drop table if exists sbtest'
  $run_mysql -e 'show tables'
  echo Run:: $sb $sb_args $xa prepare
  $sb $sb_args $xa prepare || exit 1
fi

$run_mysql -e 'analyze table sbtest'
$run_mysql -e 'select count(*) from sbtest'
sleep 30

dop=1
while [[ $dop -le $maxdop ]]; do
  echo Run $dop
  echo $sb $sb_args $xa --num-threads=$dop run
  $sb $sb_args $xa --num-threads=$dop run

  echo
  $run_mysql -e 'show table status like "sbtest"'
  $run_mysql -e 'select count(*) from sbtest'

  dop=$(( $dop * 2 ))

done

$run_mysql -e 'show variables like "version_comment"'
$run_mysql -e 'show status like "%_seconds"'
$run_mysql -e 'show status like "qc%"'

