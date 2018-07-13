nr=$1
nrt=$2
only1t=$3
scanonly=$4
dop=$5
mongov=$6
gb=$7
e=$8

for v in 16 17 18 19 20 21 ; do
#for v in $( seq 1 12 ); do

bd=/data/users/mcallaghan/$mongov
cd $bd
cp cnf.${gb}g/mongo.conf.v${v} mongo.conf
bash ini.sh $e ; sleep 10
cd /data/users/mcallaghan/ibench

bash iq.sh wt "" $bd/bin/mongo $bd/data md2 1 $dop yes no $only1t no no $nr $scanonly 

dn=$mongov.$nrt.dop${dop}.1t${only1t}.gb${gb}.v${v}.$e
mkdir $dn
mv l scan q100* $dn
cp $bd/elog $bd/mongo.conf $dn
sleep 30

done
