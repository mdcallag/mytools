bin/mysqladmin -uroot -ppw shutdown
sleep 3

rm -rf /data/m/my; mkdir -p /data/m/my
rm -rf /data/m/pg; mkdir -p /data/m/pg
rm -rf /data/m/rx; mkdir -p /data/m/rx

rm -rf /data/m/fbmy; mkdir -p /data/m/fbmy
mkdir /data/m/fbmy/binlogs
mkdir /data/m/fbmy/txlogs
mkdir /data/m/fbmy/data

mkdir /data/m/my/binlogs
mkdir /data/m/my/txlogs
mkdir /data/m/my/data

rm -rf var; mkdir var

csfx=def
if [ "$#" -ge 1 ]; then
  if [ -f etc/my.cnf.c${1} ]; then
    cp etc/my.cnf.c${1} etc/my.cnf
    csfx=c${1}
  else
    echo etc/my.cnf.c${1} does not exist
    exit 1
  fi
fi 

killall mongod mysqld

scripts/mysql_install_db --defaults-file=etc/my.cnf >& o.ini.$csfx

bin/mysqld_safe --numa-interleave &
sleep 30
bin/mysqladmin -uroot --password="" password pw

bin/mysql -uroot -ppw mysql -e "grant all on *.* to root@'%' identified by 'pw'"
bin/mysql -uroot -ppw mysql -e "delete from user where length(Password) = 0; flush privileges;"

bin/mysql -uroot -ppw -A -e 'drop database test'
bin/mysql -uroot -ppw -A -e 'create database test'
bin/mysql -uroot -ppw -A -e 'show databases'

