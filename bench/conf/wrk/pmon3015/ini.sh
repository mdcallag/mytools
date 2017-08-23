while kill $( pidof mongod ) ; do echo kill again; ps aux | grep mongod | grep -v grep; sleep 5; done
echo Sleep after kill
sleep 5

echo Wipe data
rm -rf data; mkdir data

echo Sleep after wipe
sleep 5

numactl --interleave=all /usr/bin/mongod --config mongo.conf --master --storageEngine $1

