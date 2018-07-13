bin/mysqladmin -uroot -ppw shutdown
sleep 2

rm -rf data var /binlogs/myrocks/* /txlogs/myrocks/*
mkdir -p /binlogs/myrocks
mkdir -p /txlogs/myrocks
mkdir data var
libexec/mysqld --initialize-insecure --user=root >& o.init; tail -5 o.init

bin/mysqld_safe --user=root &
sleep 30
bin/mysqladmin -uroot --password="" password pw

bin/mysql -uroot -ppw mysql -e "grant all on *.* to root@'%' identified by 'pw'"
# bin/mysql -uroot -ppw mysql -e "delete from user where length(Password) = 0; flush privileges;"

# bin/mysql -uroot -ppw -A -e 'drop database test'
bin/mysql -uroot -ppw -A -e 'create database test'
bin/mysql -uroot -ppw -A -e 'show databases'

