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
    # xa="--oltp-skip-trx --oltp-test-mode=simple --oltp-point-select-all-cols --oltp-simple-update " ;;
    xa="--oltp-test-mode=simple --oltp-point-select-all-cols --oltp-simple-update " ;;
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

id=${17}
max_id=${18}

mybase=${19}

use_compress=${20}
if [[ $use_compress == "yes" ]]; then
  xa="$xa --mysql-create-options=key_block_size=8"
fi

run_mysql="$mysql -u$myu -p$myp -h$dbh $myd -A"

sb="/data/bench/sysbench4 "

if [[ $e == "heap" ]]; then
  xa="$xa --oltp-auto-inc=off"
fi

def_args=" --mysql-host=$dbh --mysql-user=$myu --mysql-password=$myp --mysql-db=$myd "
sb_args=" --test=oltp ${def_args} --oltp-table-size=$nr --max-time=$t --max-requests=0 --mysql-table-engine=$e --db-ps-mode=disable --mysql-engine-trx=$etrx --oltp-table-name=sbtest${id} "
sb_args=" --batch --batch-delay=60 $sb_args"

if [[ $prepare == "yes" ]]; then
  echo Setup for $id using database $myd
  echo Sizes before prepare
  ls -halrt $mybase/var; ls -halrt $mybase/var/$myd
  $mysql -u$myu -p$myp -h$dbh -A -e "create database $myd"
  $run_mysql -e "drop table if exists sbtest${id}"
  $run_mysql -e 'show tables'
  echo Run:: $sb $sb_args $xa prepare
  $sb $sb_args $xa prepare || exit 1
  $run_mysql -e "analyze table sbtest${id}"
  $run_mysql -e "select count(*) from sbtest${id}"
  sleep 20
fi

# Warmup buffer cache -- TODO make this optional
if [[ $warmup == "yes" ]]; then
  echo Warmup buffer cache at $( date )
  $run_mysql -e "show create table sbtest${id}"
  $run_mysql --quick -e "select * from sbtest${id}" > /dev/null
  echo Done warmup buffer cache at $( date ) 
fi

if [[ $warmup == "yes2" ]]; then
  echo Warmup buffer cache at $( date )
  $run_mysql -e "show create table sbtest${id}"
  $run_mysql --quick -e "update sbtest${id} set c = 0" > /dev/null
  echo Done warmup buffer cache at $( date ) 
fi


touch startme.${id}

echo Purge lag at test start
$run_mysql -e "show engine innodb status\G" | grep History | awk '{ print $4 }' 

dop=1
while [[ $dop -le $maxdop ]]; do
  echo Sizes before run $dop
  ls -halrt $mybase/var; ls -halrt $mybase/var/$myd

  echo Touch ready.${dop}.${id} at $( date )
  touch ready.${dop}.${id}
  if [[ $id -eq 1 ]] ; then
    num_ready=1
    while [[ $num_ready -lt $max_id ]]; do
      echo Wait for $max_id with $num_ready ready
      sleep 1    
      num_ready=$( ls ready.${dop}.* | wc -l )
    done

    lag=1000000
    lag_sleep=1
    while [[ $lag -gt 1000 ]]; do
      sleep $lag_sleep
      lag=$( $run_mysql -e "show engine innodb status\G" | grep History | awk '{ print $4 }' )
      echo Wait for purge lag to drop from $lag to 1000 with dop $dop
      lag_sleep=10
    done

    echo Touch go.${dop} at $( date )
    touch go.${dop}
  else
    while [[ ! -f go.${dop} ]] ; do
      echo Wait for go.${dop} from $id
      sleep 1
    done
    echo Done wait for go.${dop}
  fi

  echo Run $dop at $( date )
  echo $sb $sb_args $xa --num-threads=$dop --seed-rng=$(( $dop * $id )) run
  $sb $sb_args $xa --num-threads=$dop --seed-rng=$(( $dop * $id )) run

  echo
  $run_mysql -e "show table status like \"sbtest${id}\""
  $run_mysql -e "select * from sbtest${id} order by id asc limit 2"

  dop=$(( $dop * 2 ))
#  dop=$(( $dop + 1 ))

done

rm -f go.* ready.*

echo Sizes at end
ls -halrt $mybase/var; ls -halrt $mybase/var/$myd

$run_mysql -e 'show variables like "version_comment"'
$run_mysql -e 'show status like "%_seconds"'
$run_mysql -e 'show status like "qc%"'
$run_mysql -e 'show variables'
$run_mysql -e 'show global status'
$run_mysql -e 'show engine innodb status\G'
