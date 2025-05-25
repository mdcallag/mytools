echo Shutdown start at $( date )
bin/mysqladmin -uroot -ppw shutdown
echo Shutdown done at $( date )
sleep 5

rm -rf var; mkdir var
rm -rf /data/m/fbmy; mkdir -p /data/m/fbmy
mkdir -p /data/m/fbmy/data
mkdir -p /data/m/fbmy/binlogs
mkdir -p /data/m/fbmy/txlogs

rm -rf /data/m/my; mkdir -p /data/m/my
mkdir -p /data/m/my/data
mkdir -p /data/m/my/binlogs
mkdir -p /data/m/my/txlogs
