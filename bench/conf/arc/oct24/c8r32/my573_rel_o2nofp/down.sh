bin/mysqladmin -uroot -ppw shutdown
sleep 3

rm -rf var; mkdir var
rm -rf /data/m/my/*
mkdir -p /data/m/my/data
mkdir -p /data/m/my/binlogs
mkdir -p /data/m/my/txlogs


