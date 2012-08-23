ssh root@udb9584.snc1 cp /data/5152dev/my.cnf.base.6 /data/5152dev/my.cnf
for c in yes yespad no ; do bash run.sh 1024 /data yes root pw test innodb 20 yes no 300 3600 10.19.55.89 $c 5152dev > o.$c 2> e.$c ; done
mkdir cached.6
mv tpc.* cached.6

ssh root@udb9584.snc1 cp /data/5152dev/my.cnf.base.1 /data/5152dev/my.cnf
for c in yes yespad no ; do bash run.sh 1024 /data yes root pw test innodb 20 yes no 300 3600 10.19.55.89 $c 5152dev > o.$c 2> e.$c ; done
mkdir cached.1
mv tpc.* cached.1
