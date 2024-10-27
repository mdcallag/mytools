bin/mysqladmin -uroot -ppw shutdown

rm -rf var; mkdir var
rm -rf /data/m/my/*
mkdir -p /data/m/my/data
mkdir -p /data/m/my/binlogs
mkdir -p /data/m/my/txlogs

rm -rf /home/mdcallag/mytx
mkdir /home/mdcallag/mytx


