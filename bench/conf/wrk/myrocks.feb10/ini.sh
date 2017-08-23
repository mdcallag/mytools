bin/mysqladmin -uroot -ppw shutdown

rm -rf data /binlogs/myrocks/* /txlogs/myrocks/*
mkdir data
mkdir -p /binlogs/myrocks
mkdir -p /txlogs/myrocks

scripts/mysql_install_db --defaults-file=/data/mysql/myrocks/etc/my.cnf >& o.init; cat o.init

bin/mysqld_safe --user=root &
sleep 30
bin/mysqladmin -uroot --password="" password pw

bin/mysql -uroot -ppw mysql -e "grant all on *.* to root@'%' identified by 'pw'"
bin/mysql -uroot -ppw mysql -e "delete from user where length(Password) = 0; flush privileges;"

bin/mysql -uroot -ppw -A -e 'drop database test'
bin/mysql -uroot -ppw -A -e 'create database test'
bin/mysql -uroot -ppw -A -e 'show databases'
