e=$1

echo Maybe kill mongod
while ps aux | grep mongod | grep -v grep ; do echo kill it; killall mongod; sleep 1; done

echo sleep
sleep 5

echo wipe data dir
rm -rf data; mkdir data
rm -f elog

echo start
numactl --interleave=all bin/mongod --config mongo.conf --storageEngine $e
tail -10 elog
