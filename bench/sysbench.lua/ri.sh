nr=$1
nrt1=$2
nrt2=$3
dname=$4

for d in orig5635 orig5717 orig801 orig802 orig803 myrocks ; do

cd /data/mysql/$d; bash ini.sh; sleep 10
cd /data/mysql/sysbench10
bash all.sh 8 $nr 180 300 180 innodb 1 0 /data/mysql/$d/bin/mysql none /data/mysql/sysbench10 /data/mysql/$d/data $dname
mkdir 8t.$nrt1.$d; mv sb.* 8t.$nrt1.$d
cd /data/mysql/$d; sleep 60; bin/mysqladmin -uroot -ppw shutdown; sleep 10; rm -rf data

done

for d in orig5635 orig5717 orig801 orig802 orig803 myrocks ; do

cd /data/mysql/$d; bash ini.sh; sleep 10
cd /data/mysql/sysbench10
bash all.sh 1 $(( 8 * $nr )) 180 300 180 innodb 1 0 /data/mysql/$d/bin/mysql none /data/mysql/sysbench10 /data/mysql/$d/data $dname
mkdir 1t.$nrt2.$d ; mv sb.* 1t.$nrt2.$d
cd /data/mysql/$d; sleep 60; bin/mysqladmin -uroot -ppw shutdown; sleep 10; rm -rf data

done
