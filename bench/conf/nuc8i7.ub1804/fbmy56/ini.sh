bin/mysqladmin -uroot -ppw shutdown

rm -rf var; mkdir var
rm -rf /data/m/fbmy/*
mkdir -p /data/m/fbmy/data
mkdir -p /data/m/fbmy/binlogs
mkdir -p /data/m/fbmy/txlogs

csfx=def
if [ "$#" -ge 1 ]; then
    cp etc/my.cnf.c${1} etc/my.cnf 
    csfx=c${1}
fi 

killall mongod mysqld

scripts/mysql_install_db --defaults-file=etc/my.cnf >& o.ini.$csfx

bin/mysqld_safe &
sleep 30
bin/mysqladmin -uroot --password="" password pw

bin/mysql -uroot -ppw mysql -e "grant all on *.* to root@'%' identified by 'pw'"
bin/mysql -uroot -ppw mysql -e "delete from user where length(Password) = 0; flush privileges;"

bin/mysql -uroot -ppw -A -e 'drop database test'
bin/mysql -uroot -ppw -A -e 'create database test'
bin/mysql -uroot -ppw -A -e 'show databases'

