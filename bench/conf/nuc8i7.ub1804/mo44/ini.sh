echo Kill mongod at $( date )
while kill $( pidof mongod ) ; do echo kill again; ps aux | grep mongod | grep -v grep; sleep 5; done
echo Sleep after kill at $( date )
sleep 5
killall mysqld

echo Wipe data
rm -rf /data/m/mo; mkdir -p /data/m/mo

echo Sleep after wipe
sleep 5

if [ "$#" -ge 1 ]; then
  if [ -f mongo.conf.c${1} ]; then
    cp mongo.conf.c${1} mongo.conf
  else
    echo mongo.conf.c${1} does not exist
    exit 1
  fi
fi

numactl --interleave=all bin/mongod --config mongo.conf 

sleep 5
bin/mongo admin --eval "rs.initiate()"

sleep 5
bin/mongo admin --eval 'db.createUser({user: "root", pwd: "pw", roles : ["root"]})'
bin/mongo admin -u root -p pw --eval 'db.createUser({user: "root2", pwd: "pw", roles : ["dbAdmin", "readWriteAnyDatabase"]})'
