# mkdir data ?

rm -rf /data/m/data /data/m/binlogs /data/m/txlogs
rm -f data
ln -s /data/m/data data

mkdir /data/m/txlogs
mkdir /data/m/binlogs

rm -rf etc
mkdir etc
cp ../my.cnf.578 etc/my.cnf

rm -rf var
mkdir var

bin/mysqld --initialize  >& o.init; cat o.init
# bin/mysqld --initialize --defaults-file=etc/my.cnf >& o.init; cat o.init

# bin/mysqld_safe --user=root &

bin/mysqld_safe &
sleep 30
bin/mysqladmin -uroot -p password pw

bin/mysql -uroot -ppw mysql -e "grant all on *.* to root@'%' identified by 'pw'"
# bin/mysql -uroot -ppw mysql -e "delete from user where length(Password) = 0; flush privileges;"

bin/mysql -uroot -ppw -A -e 'drop database test'
bin/mysql -uroot -ppw -A -e 'create database test'
bin/mysql -uroot -ppw -A -e 'show databases'

