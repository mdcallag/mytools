
# Path to "mysql" binary"
mysqlbin=$1
# User name for mysql login
my_user=$2
# password for mysql login
my_pw=$3
# name of database in mysql to use
my_db=$4
# number of rows to insert
nrows=$5

dbnodb="$mysqlbin -u${my_user} -p${my_pw}"
db="$mysqlbin -u${my_user} -p${my_pw} $my_db"

function drop_all {
  start=$1
  msg="$2"
  stop=$( date +%s )
  echo $(( stop - start )) seconds : $msg
  $db -e "alter table pi1 drop index pi1_marketsegment"
  $db -e "alter table pi1 drop index pi1_registersegment"
  $db -e "alter table pi1 drop index pi1_pdc"
}

$db -e "alter table pi1 drop index pi1_marketsegment"
$db -e "alter table pi1 drop index pi1_registersegment"
$db -e "alter table pi1 drop index pi1_pdc"

drop_all 1 foobar

#while :; do $db -e "show processlist"; sleep 3; done >& o.spl.2 &
#while :; do $db -e "show engine innodb status\G"; sleep 5; done >& o.spl.2 &
while :; do $dbnodb information_schema -e "select * from innodb_trx\G"; sleep 1; done >& o.spl.2 &
spid2=$!
msg="create concurrent with explicit inplace"
start=$( date +%s )
echo start 1
$db -e "alter table pi1 add index pi1_marketsegment (price, customerid), algorithm=inplace" &
j1=$!
echo start 2
$db -e "alter table pi1 add index pi1_registersegment (cashregisterid, price, customerid), algorithm=inplace" &
j2=$!
echo start 3
$db -e "alter table pi1 add index pi1_pdc (price, dateandtime, customerid), algorithm=inplace" &
j3=$!
wait $j1
wait $j2
wait $j3
kill $spid2
drop_all $start "$msg"
