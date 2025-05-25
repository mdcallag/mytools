echo Start shutdown at $( date )
bin/mysqladmin -uroot -ppw shutdown
echo shutdown finished at $( date )

ssecs=$( date +%s )
while ps aux | egrep "mariadb|mysqld" | grep -v grep ; do sleep 1; echo running; done
esecs=$( date +%s )
tsecs=$(( esecs - ssecs ))
echo Total secs after shutdown is $tsecs
cp /data/m/my/data/*.err .

sleep 10

killall -s KILL mysqld
sleep 2

rm -rf var; mkdir var
rm -rf /data/m/my/*
mkdir -p /data/m/my/data
mkdir -p /data/m/my/binlogs
mkdir -p /data/m/my/txlogs


