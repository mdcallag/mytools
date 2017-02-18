bdir=$1
e=$2
nr=$3
checku=$4
bulk=$5
secatend=$6

for dop in 1 2 4 8 12 16 ; do
sfx=dop_${dop}
echo run for dop $dop

cd /data/mysql/$bdir
bash ini.sh >& o.$sfx

cd /data/mysql/ibench
echo bash iql.sh $e "" /data/mysql/$bdir/bin/mysql /data/mysql/$bdir/data md2 $checku $dop no no no $bulk $secatend $nr > o2.$sfx
bash iql.sh $e "" /data/mysql/$bdir/bin/mysql /data/mysql/$bdir/data md2 $checku $dop no no no $bulk $secatend $nr > o2.$sfx 2>&1

mv l l.$sfx
mv o2.$sfx l.$sfx

done
