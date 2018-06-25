nsec=$1
bloombits=$2
nfiles=$3
dbdir=$4
dbbench=$5
bg_io_mb=$6
bg_thr=$7
wkbs=$8
version=$9

rowlen=200
fanout=8
nr=10000000
cache_mb=4096

#cache_mb=8096
#bg_io_mb=2048
#bg_thr=8
#wkbs=1000

l1mb=32
wb=2
l0=16
rm -rf $dbdir/*
bash all3.sh $dbdir $nr $nsec 1 $rowlen $wkbs $wb $bg_thr $l0 $l1mb $fanout 7 none $cache_mb $bg_io_mb 60 $version $dbbench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb}
cp $dbdir/LOG* z.wb${wb}.trig${l0}.base${l1mb}
mv o.* z.wb${wb}.trig${l0}.base${l1mb}

wb=4
l0=8
rm -rf $dbdir/*
bash all3.sh $dbdir $nr $nsec 1 $rowlen $wkbs $wb $bg_thr $l0 $l1mb $fanout 7 none $cache_mb $bg_io_mb 60 $version $dbbench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb}
cp $dbdir/LOG* z.wb${wb}.trig${l0}.base${l1mb}
mv o.* z.wb${wb}.trig${l0}.base${l1mb}

wb=8
l0=4
rm -rf $dbdir/*
bash all3.sh $dbdir $nr $nsec 1 $rowlen $wkbs $wb $bg_thr $l0 $l1mb $fanout 7 none $cache_mb $bg_io_mb 60 $version $dbbench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb}
cp $dbdir/LOG* z.wb${wb}.trig${l0}.base${l1mb}
mv o.* z.wb${wb}.trig${l0}.base${l1mb}

wb=32
l0=1
rm -rf $dbdir/*
bash all3.sh $dbdir $nr $nsec 1 $rowlen $wkbs $wb $bg_thr $l0 $l1mb $fanout 7 none $cache_mb $bg_io_mb 60 $version $dbbench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb}
cp $dbdir/LOG* z.wb${wb}.trig${l0}.base${l1mb}
mv o.* z.wb${wb}.trig${l0}.base${l1mb}

l1mb=256
wb=64
l0=1
rm -rf $dbdir/*
bash all3.sh $dbdir $nr $nsec 1 $rowlen $wkbs $wb $bg_thr $l0 $l1mb $fanout 7 none $cache_mb $bg_io_mb 60 $version $dbbench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb}
cp $dbdir/LOG* z.wb${wb}.trig${l0}.base${l1mb}
mv o.* z.wb${wb}.trig${l0}.base${l1mb}

l1mb=2048
wb=256
l0=1
rm -rf $dbdir/*
bash all3.sh $dbdir $nr $nsec 1 $rowlen $wkbs $wb $bg_thr $l0 $l1mb $fanout 7 none $cache_mb $bg_io_mb 60 $version $dbbench $bloombits $nfiles
mkdir z.wb${wb}.trig${l0}.base${l1mb}
cp $dbdir/LOG* z.wb${wb}.trig${l0}.base${l1mb}
mv o.* z.wb${wb}.trig${l0}.base${l1mb}

