
# Path to "mysql" binary"
mysqlbin=$1
# User name for mysql login
my_user=$2
# password for mysql login
my_pw=$3
# name of database in mysql to use
my_db=$4
# number of rows to insert, in millions
mrows=$5

nrows=$(( mrows * 1000000 ))
sfx=${mrows}m

dbnodb="$mysqlbin -u${my_user} -p${my_pw}"
db="$mysqlbin -u${my_user} -p${my_pw} $my_db"

$dbnodb -e "create database ${my_db}" >& /dev/null

python3 iibench.py --dbms=mysql --db_name=${my_db} --secs_per_report=1 --db_host=127.0.0.1 --db_user=${my_user} --db_password=${my_pw} --engine=innodb --engine_options= --unique_checks=1 --bulk_load=0 --max_rows=$nrows --table_name=pi1 --setup --num_secondary_indexes=0 --data_length_min=10 --data_length_max=20 --rows_per_commit=100 --inserts_per_second=0 --query_threads=0 --seed=1682702413 --dbopt=none >& o.ci.$sfx

function drop_all {
  start=$1
  msg="$2"
  stop=$( date +%s )
  echo $(( stop - start )) seconds : $msg >> o.ci.$sfx
  $db -e "alter table pi1 drop index pi1_marketsegment"
  $db -e "alter table pi1 drop index pi1_registersegment"
  $db -e "alter table pi1 drop index pi1_pdc"
}

$db -e "alter table pi1 drop index pi1_marketsegment" >& /dev/null
$db -e "alter table pi1 drop index pi1_registersegment" >& /dev/null
$db -e "alter table pi1 drop index pi1_pdc" >& /dev/null

msg="create all with explicit inplace"
echo $msg >> o.ci.$sfx
start=$( date +%s )
/usr/bin/time -a -o o.ci.$sfx $db -e "alter table pi1 add index pi1_marketsegment (price, customerid), add index pi1_registersegment (cashregisterid, price, customerid), add index pi1_pdc (price, dateandtime, customerid), algorithm=inplace"
drop_all $start "$msg"

msg="create one at a time with explicit inplace"
start=$( date +%s )
echo "create 1" >> o.ci.$sfx
/usr/bin/time -a -o o.ci.$sfx $db -e "alter table pi1 add index pi1_marketsegment (price, customerid), algorithm=inplace"
echo "create 2" >> o.ci.$sfx
/usr/bin/time -a -o o.ci.$sfx $db -e "alter table pi1 add index pi1_registersegment (cashregisterid, price, customerid), algorithm=inplace"
echo "create 3" >> o.ci.$sfx
/usr/bin/time -a -o o.ci.$sfx $db -e "alter table pi1 add index pi1_pdc (price, dateandtime, customerid), algorithm=inplace"
drop_all $start "$msg"

