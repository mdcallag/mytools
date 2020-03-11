while kill $( pidof mongod ) ; do echo kill again; ps aux | grep mongod | grep -v grep; sleep 5; done
echo Sleep after kill
sleep 5

echo Wipe data
rm -rf data; mkdir data
rm -rf /data/m/mo/*

echo Sleep after wipe
sleep 5

#numactl --interleave=all /usr/bin/mongod --config mongo.conf --master --storageEngine $1
#/usr/bin/mongod --config mongo.conf --master --storageEngine $1
bin/mongod --config mongo.conf --storageEngine $1

sleep 5
bin/mongo admin --eval "rs.initiate()"

sleep 5
bin/mongo admin --eval 'db.createUser({user: "root", pwd: "pw", roles : ["root"]})'
bin/mongo admin -u root -p pw --eval 'db.createUser({user: "root2", pwd: "pw", roles : ["dbAdmin", "readWriteAnyDatabase"]})'


