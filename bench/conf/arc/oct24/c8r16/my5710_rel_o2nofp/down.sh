echo Start shutdown at $( date )
bin/mysqladmin -uroot -ppw shutdown
echo shutdown finished at $( date )
sleep 5

rm -rf /data/m/my; mkdir -p /data/m/my
mkdir -p /data/m/my/data
mkdir -p /data/m/my/binlogs
mkdir -p /data/m/my/txlogs

rm -rf /home/mdcallag/mytx
mkdir /home/mdcallag/my

rm -rf var
mkdir var


