nr=$1
nrt1=$2
nrt2=$3
dname=$4
usepk=$5

for d in feb10.f3019b apr14.e28823.ak jun16.52e058 aug15.0d76ae oct16.1d0132 ; do

cd /data/mysql; rm -f myrocks; ln -s myrocks.$d myrocks
cd /data/mysql/myrocks.$d; bash ini.sh; sleep 10
cd /data/mysql/sysbench10
bash all.sh 8 $nr 180 300 180 rocksdb 1 0 /data/mysql/myrocks.$d/bin/mysql none /data/mysql/sysbench10 /data/mysql/myrocks.$d/data $dname $usepk
mkdir 8t.$nrt1.myrocks.$d.pk${usepk} ; mv sb.* 8t.$nrt1.myrocks.$d.pk${usepk}
cd /data/mysql/myrocks.$d; sleep 60; bin/mysqladmin -uroot -ppw shutdown; sleep 10; rm -rf data

done

for d in feb10.f3019b apr14.e28823.ak jun16.52e058 aug15.0d76ae oct16.1d0132 ; do

cd /data/mysql; rm -f myrocks; ln -s myrocks.$d myrocks
cd /data/mysql/myrocks.$d; bash ini.sh; sleep 10
cd /data/mysql/sysbench10
bash all.sh 1 $(( 8 * $nr )) 180 300 180 rocksdb 1 0 /data/mysql/myrocks.$d/bin/mysql none /data/mysql/sysbench10 /data/mysql/myrocks.$d/data $dname $usepk
mkdir 1t.$nrt2.myrocks.$d.pk${usepk} ; mv sb.* 1t.$nrt2.myrocks.$d.pk${usepk}
cd /data/mysql/myrocks.$d; sleep 60; bin/mysqladmin -uroot -ppw shutdown; sleep 10; rm -rf data

done

