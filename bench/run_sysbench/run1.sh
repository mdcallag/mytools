# engine type
e=$1

# test duration
t=$2

# num rows
nr=$3

strx=$4
case $strx in
  "ro")
    xa="--oltp-read-only " ;;
  "roha")
    xa="--oltp-read-only --oltp-point-select-mysql-handler " ;;
  "si")
    xa="--oltp-read-only --oltp-skip-trx --oltp-test-mode=simple " ;;
  "siha")
    xa="--oltp-read-only --oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-mysql-handler " ;;
  "sihaorc")
    xa="--oltp-read-only --oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-mysql-handler-open-read-close " ;;
  "siac")
    xa="--oltp-read-only --oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-all-cols " ;;
  "sij")
    xa="--oltp-read-only --oltp-skip-trx --oltp-test-mode=simplejoin " ;;
  "incupd")
    xa="--oltp-skip-trx --oltp-test-mode=incupdate " ;;
  "incins")
    xa="--oltp-skip-trx --oltp-test-mode=incinsert " ;;
  "sirw")
    xa="--oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-all-cols --oltp-simple-update " ;;
  "rw"|*)
    xa="" ;;
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

dist=${14}
if [[ $dist == "u" ]]; then
  xa="$xa --oltp-dist-type=uniform "
else
  xa="$xa --oltp-dist-type=special "
fi

warmup=${15}

range=${16}
xa="$xa --oltp-range-size=${range} "

run_mysql="$mysql -u$myu -p$myp -h$dbh $myd -A"

sb="../sysbench4 "

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
  $run_mysql -e 'analyze table sbtest'
  $run_mysql -e 'select count(*) from sbtest'
  sleep 20
fi

# Warmup buffer cache -- TODO make this optional
if [[ $warmup == "yes" ]]; then
  echo Warmup buffer cache at $( date )
  $run_mysql -e 'show create table sbtest'
  mkdir -p w

  x=1
  turn=0
  rm -f wuq; touch wuq;
  while [[ $x -le $nr ]]; do
    m=$(( $x + 9999 ))
    if [[ $m -gt $nr ]]; then m=$nr ; fi

    echo Warmup from $x to $m for max rows $nr

    if [ ! -f w/wuq.$x.$m.gz ]; then
      echo "select count(*) from sbtest where id in (" > w/wuq.$x.$m
      for i in $( seq -f '%7.0f' $x $(( $m - 1 )) ) ; do
        echo -n "$i," >> w/wuq.$x.$m
      done
      echo -n "$m);" >> w/wuq.$x.$m
    else
      gunzip w/wuq.$x.$m     
    fi

    cat w/wuq.$x.$m >> wuq 
    gzip w/wuq.$x.$m

    x=$(( $m + 1 ))

    turn=$(( $turn + 1 ))
    if [[ $turn -eq 10 ]]; then
      cp wuq wuq.bak
      while ! $run_mysql < wuq ; do echo Failed with $? ; done
      turn=0
      rm -f wuq; touch wuq;
    fi

  done
  echo Done warmup buffer cache at $( date ) with loop $x and max $nr
fi

touch startme

dop=1
while [[ $dop -le $maxdop ]]; do
  echo Run $dop
  echo $sb $sb_args $xa --num-threads=$dop --seed-rng=$dop run
  $sb $sb_args $xa --num-threads=$dop --seed-rng=$dop run

  echo
  $run_mysql -e 'show table status like "sbtest"'
  $run_mysql -e 'select * from sbtest order by id asc limit 2'

  dop=$(( $dop * 2 ))
#  dop=$(( $dop + 1 ))

done

$run_mysql -e 'show variables like "version_comment"'
$run_mysql -e 'show status like "%_seconds"'
$run_mysql -e 'show status like "qc%"'
$run_mysql -e 'show variables'
$run_mysql -e 'show global status'
$run_mysql -e 'show innodb status\G'
