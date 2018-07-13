nr=$1
nrt=$2
only1t=$3
scanonly=$4
mongov=$5
e=$6

bd=/data/users/mcallaghan/$mongov

for dop in 16 32 ; do

cd $bd; bash ini.sh $e ; sleep 10
cd /data/users/mcallaghan/ibench

bash iq.sh wt "" $bd/bin/mongo $bd/data md2 1 $dop yes no $only1t no no $nr $scanonly 

dn=$mongov.$nrt.dop${dop}.1t${only1t}.$e
mkdir $dn
mv l scan q100* $dn
cp $bd/elog $bd/mongo.conf $dn
sleep 30

done
