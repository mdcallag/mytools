echo Shutdown existing instance
bin/mariadb-admin -uroot -ppw shutdown
sleep 3

echo Cleanup and recreate directories
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

killall mongod mysqld mariadbd

echo install-db
scripts/mariadb-install-db --defaults-file=etc/my.cnf >& o.install

echo safe
sleep 2
./bin/mariadbd-safe --defaults-file=etc/my.cnf >& o.safe &
echo sleep 10s after safe
sleep 10

echo wait for connection
x=0
while ! bin/mariadb -umdcallag -e 'select User, Host from mysql.user' ; do
  x=$(( x + 1 ))
  sleep 1
  echo "Waiting for connection: $x"
done
echo connected

hn="$( hostname )"

bin/mariadb -umdcallag -e "drop user ''@\"${hn}\""
bin/mariadb -umdcallag -e "drop user ''@localhost"
bin/mariadb -umdcallag -e "drop user root@localhost"
bin/mariadb -umdcallag -e "create user root@'%' identified by 'pw'"
bin/mariadb -umdcallag -e "grant all on *.* to root@'%' with grant option"
bin/mariadb -umdcallag -e 'select User, Host from mysql.user'
bin/mariadb -uroot -ppw -e 'select User, Host from mysql.user'

bin/mariadb -uroot -ppw -A -e 'drop database test'
bin/mariadb -uroot -ppw -A -e 'create database test'
bin/mariadb -uroot -ppw -A -e 'show databases'
bin/mariadb -uroot -ppw -A -e 'show engines'

