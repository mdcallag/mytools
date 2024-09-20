echo Start shutdown at $( date )
bin/mysqladmin -uroot -ppw shutdown
echo shutdown finished at $( date )
sleep 5

rm -rf /data/m/fbmy; mkdir -p /data/m/fbmy
mkdir -p /data/m/fbmy/data
mkdir -p /data/m/fbmy/binlogs
mkdir -p /data/m/fbmy/txlogs

rm -rf var
mkdir var


