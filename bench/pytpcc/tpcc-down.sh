rdir=$1
ddir=$2

killall iostat
killall vmstat

mkdir $rdir
mv o.vm $rdir
mv o.io $rdir

cp -r /data/m/mo/diagnostic.data $rdir

echo "end $ddir" > o.sz1
du -sm $ddir >> o.sz1
echo "after $ddir" > o.sz2
du -sm $ddir/* >> o.sz2
echo "after $ddir" > o.asz1
du -sm --apparent-size $ddir >> o.asz1
echo "after $ddir" > o.asz2
du -sm --apparent-size $ddir/* >> o.asz2

ls -asShR $ddir > o.lshr
ls -asS --block-size=1M $ddir > o.ls
ls -asSh $ddir > o.lsh

mv o.sz* o.asz* o.ls* $rdir

echo "show dbs" | bin/mongo -u root -p pw > o.dbs
mv o.dbs $rdir

ps aux | grep mongod | grep -v grep > o.ps
mv o.ps $rdir

cp /data/m/mo/mongod.log $rdir

bash down.sh

