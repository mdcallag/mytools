while kill $( pidof mongod ) ; do echo kill again; ps aux | grep mongod | grep -v grep; sleep 5; done
echo Sleep after kill
sleep 5
killall mysqld

echo Wipe data
rm -rf data; mkdir data
rm -rf /data/m/mo/*


