
admin=mysqladmin
client=mysql
install=mysql_install_db
safe=mysqld_safe

echo Shutdown existing instance
bin/${admin} -uroot -ppw shutdown
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
scripts/${install} --defaults-file=etc/my.cnf >& o.install

echo safe
sleep 2
./bin/${safe} --defaults-file=etc/my.cnf >& o.safe &
echo sleep 10s after safe
sleep 10

echo wait for connection
x=0
while ! bin/${client} -uroot -e 'select User, Host from mysql.user' ; do
  x=$(( x + 1 ))
  sleep 1
  echo "Waiting for connection: $x"
done
echo connected

bin/${admin} -u root password 'pw'
hn=$( hostname )
bin/${admin} -u root -ppw -h $hn password 'pw'

echo create
bin/${client} -uroot -ppw -h $hn -e "create user root@'%' identified by 'pw'"

echo grant
bin/${client} -uroot -ppw -h $hn -e "grant all on *.* to root@'%' with grant option"

echo drop1
bin/${client} -uroot -ppw -e "drop user ''@\"${hn}\""
echo drop2
bin/${client} -uroot -ppw -e "drop user ''@localhost"
echo drop3a
bin/${client} -uroot -ppw -e "drop user root@localhost"
echo drop3b
bin/${client} -uroot -ppw -e "drop user root@\"127.0.0.1\""
echo drop3c
bin/${client} -uroot -ppw -e "drop user root@\"::1\""
echo query user
bin/${client} -uroot -ppw -e 'select User, Host from mysql.user'

echo cleanup and query
bin/${client} -uroot -ppw -A -e 'drop database test'
bin/${client} -uroot -ppw -A -e 'create database test'
bin/${client} -uroot -ppw -A -e 'show databases'
bin/${client} -uroot -ppw -A -e 'show engines'

