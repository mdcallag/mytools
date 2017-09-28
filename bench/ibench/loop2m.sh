bdir=$1
e=$2
nr=$3
checku=$4
only1t=$5
bulk=$6
secatend=$7
mongo=$8

for dop in 16 12 8 4 2 1 ; do
sfx=dop_${dop}
echo run for dop $dop

cd /data/mysql/$bdir
bash ini-nm.sh $e >& o.$sfx

cd /data/mysql/ibench
echo bash iql.sh $e "" /data/mysql/$bdir/bin/mysql /data/mysql/$bdir/data md2 $checku $dop $mongo no $only1t $bulk $secatend $nr > o2.$sfx
bash iql.sh $e "" /data/mysql/$bdir/bin/mysql /data/mysql/$bdir/data md2 $checku $dop $mongo no $only1t $bulk $secatend $nr > o2.$sfx 2>&1

mv l l.$sfx
mv scan scan.$sfx

done
