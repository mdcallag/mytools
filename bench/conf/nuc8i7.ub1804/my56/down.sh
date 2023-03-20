echo Start shutdown at $( date )
bin/mysqladmin -uroot -ppw shutdown
echo shutdown finished at $( date )
sleep 3

killall -s KILL mysqld
sleep 2

rm -rf var; mkdir var
rm -rf /data/m/my/*
mkdir -p /data/m/my/data
mkdir -p /data/m/my/binlogs
mkdir -p /data/m/my/txlogs


