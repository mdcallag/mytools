bin/mysqladmin -uroot -ppw shutdown

rm -rf var; mkdir var
rm -rf /data/m/fbmy/*
mkdir -p /data/m/fbmy/data
mkdir -p /data/m/fbmy/binlogs
mkdir -p /data/m/fbmy/txlogs


