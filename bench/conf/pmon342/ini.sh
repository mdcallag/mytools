kill $( pidof mongod )
sleep 10
rm -rf /data/m/mo/*

/usr/bin/mongod --config mongo.conf --master --storageEngine $1

