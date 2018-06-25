nsec=$1
bloombits=$2
nfiles=$3

rowlen=200
dbdir=/data/m/rx
fanout=8

wb=8
l0=1
l1mb=32

rm -rf $dbdir/*
bash all3.sh /data/m/rx 10000000 $nsec 1 $rowlen 1 $wb 2 $l0 $l1mb $fanout 7 none 2000 1024 60 5.8 ~/git/rocksdb/db_bench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb} ; mv o.* z.wb${wb}.trig${l0}.base${l1mb}

l0=4
rm -rf $dbdir/*
bash all3.sh /data/m/rx 10000000 $nsec 1 $rowlen 1 $wb 2 $l0 $l1mb $fanout 7 none 2000 1024 60 5.8 ~/git/rocksdb/db_bench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb} ; mv o.* z.wb${wb}.trig${l0}.base${l1mb}

l0=8
rm -rf $dbdir/*
bash all3.sh /data/m/rx 10000000 $nsec 1 $rowlen 1 $wb 2 $l0 $l1mb $fanout 7 none 2000 1024 60 5.8 ~/git/rocksdb/db_bench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb} ; mv o.* z.wb${wb}.trig${l0}.base${l1mb}

wb=64
l0=1
l1mb=256

rm -rf $dbdir/*
bash all3.sh /data/m/rx 10000000 $nsec 1 $rowlen 1 $wb 2 $l0 $l1mb $fanout 7 none 2000 1024 60 5.8 ~/git/rocksdb/db_bench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb} ; mv o.* z.wb${wb}.trig${l0}.base${l1mb}

wb=256
l0=1
l1mb=2048

rm -rf $dbdir/*
bash all3.sh /data/m/rx 10000000 $nsec 1 $rowlen 1 $wb 2 $l0 $l1mb $fanout 7 none 2000 1024 60 5.8 ~/git/rocksdb/db_bench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb} ; mv o.* z.wb${wb}.trig${l0}.base${l1mb}

