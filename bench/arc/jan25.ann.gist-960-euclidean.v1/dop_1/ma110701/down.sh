#bin/mariadb -uroot -ppw test -e 'show engine innodb status\G' > o.seis.down
#exit

echo Start shutdown at $( date )
bin/mariadb-admin -uroot -ppw shutdown
echo shutdown finished at $( date )
sleep 5

rm -rf /data/m/my; mkdir -p /data/m/my
mkdir -p /data/m/my/data
mkdir -p /data/m/my/binlogs
mkdir -p /data/m/my/txlogs

rm -rf var
mkdir var
