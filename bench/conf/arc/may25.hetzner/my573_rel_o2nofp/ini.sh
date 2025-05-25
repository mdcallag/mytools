bin/mysqladmin -uroot -ppw shutdown

rm -rf /data/m/fbmy; mkdir -p /data/m/fbmy
rm -rf /data/m/pg; mkdir -p /data/m/pg
rm -rf /data/m/rx; mkdir -p /data/m/rx

rm -rf /data/m/my; mkdir -p /data/m/my
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

bin/mysqld_safe &
sleep 5
echo Change password at $( date ) >> o.ini.$csfx
x=0
while ! bin/mysqladmin -uroot --password="" password pw >> o.ini.$csfx 2>&1 ; do echo change pw failed; x=$(( x + 1 )); if [[ $x -ge 30 ]]; then echo Break after $(( x * 10 )); exit 1; fi; sleep 10; done

echo Connect at $( date ) >> o.ini.$csfx
bin/mysql -uroot -ppw mysql -e "grant all on *.* to root@'%' identified by 'pw'"
bin/mysql -uroot -ppw mysql -e "delete from user where length(Password) = 0; flush privileges;"

bin/mysql -uroot -ppw -A -e 'drop database test'
bin/mysql -uroot -ppw -A -e 'create database test'
bin/mysql -uroot -ppw -A -e 'show databases'

