bin/mysqladmin -uroot -ppw shutdown
sleep 3

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

killall -s KILL mongod
killall -s KILL mysqld
sleep 3

#sudo bash ~/mytools/scripts/compact_vm.sh
sleep 3

echo Install db at $( date ) > o.ini.$csfx
scripts/mysql_install_db --defaults-file=etc/my.cnf >> o.ini.$csfx 2>&1

sleep 3
bin/mysqld_safe &
sleep 30
echo Change password at $( date ) >> o.ini.$csfx
x=0
while ! bin/mysqladmin -uroot --password="" password pw >> o.ini.$csfx 2>&1 ; do echo change pw failed; x=$(( x + 1 )); if [[ $x -ge 12 ]]; then echo Break after 60; exit 1; fi; sleep 10; done

bin/mysql -uroot -ppw mysql -e "grant all on *.* to root@'%' identified by 'pw'" >> o.ini.$csfx 2>&1
bin/mysql -uroot -ppw mysql -e "delete from user where length(Password) = 0; flush privileges;"

bin/mysql -uroot -ppw -A -e 'drop database test'
bin/mysql -uroot -ppw -A -e 'create database test'
bin/mysql -uroot -ppw -A -e 'show databases'

