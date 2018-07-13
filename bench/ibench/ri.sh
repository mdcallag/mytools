nr=$1
nrt=$2
only1t=$3
scanonly=$4
dop=$5

for d in orig5635 orig5717 orig801 orig802 orig803 myrocks ; do

cd /data/mysql/$d; bash ini.sh; sleep 10
cd /data/mysql/ibench

bash iq.sh innodb "" /data/mysql/$d/bin/mysql /data/mysql/$d/data md2 1 $dop no no $only1t 0 no $nr $scanonly

mkdir inno.$d.$nrt.only${only1t}.dop${dop} ; mv l scan q100* inno.$d.$nrt.only${only1t}.dop${dop}
cd /data/mysql/$d; sleep 60; bin/mysqladmin -uroot -ppw shutdown; sleep 10; rm -rf data

done
