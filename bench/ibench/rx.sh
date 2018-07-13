nr=$1
nrt=$2
only1t=$3
scanonly=$4
dop=$5

for d in feb10.f3019b apr14.e28823.ak jun16.52e058 aug15.0d76ae oct16.1d0132 ; do

cd /data/mysql; rm -f myrocks; ln -s myrocks.$d myrocks
cd /data/mysql/myrocks.$d; bash ini.sh; sleep 10
cd /data/mysql/ibench

bash iq.sh rocksdb "" /data/mysql/myrocks.$d/bin/mysql /data/mysql/myrocks.$d/data md2 1 $dop no no $only1t 0 no $nr $scanonly

mkdir rx.$d.$nrt.only${only1t}.dop${dop} ; mv l scan q100* rx.$d.$nrt.only${only1t}.dop${dop}
cd /data/mysql/myrocks.$d; sleep 60; bin/mysqladmin -uroot -ppw shutdown; sleep 10; rm -rf data

done
