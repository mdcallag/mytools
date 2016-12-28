ntabs=$1
nrows=$2
rsecs=$3
wsecs=$4
e=$5
mybin=$6
dbdir=$7

for twopc in 0 1 ; do
for cmt in 0 1 ; do
for boc in 0 1 ; do
for sync in 0 1 ; do

echo Run for 2pc $twopc, cmt $cmt, boc $boc, sync $sync at $( date )

echo configure mysqld
rm -f my.cnf.tmp
if [[ $twopc == 0 ]]; then
echo "rocksdb_disable_2pc=1" >> my.cnf.tmp
else
echo "rocksdb_disable_2pc=0" >> my.cnf.tmp
fi

if [[ $cmt == 0 ]]; then
echo "rocksdb_allow_concurrent_memtable_write=0" >> my.cnf.tmp
echo "rocksdb_enable_write_thread_adaptive_yield=0" >> my.cnf.tmp
else
echo "rocksdb_allow_concurrent_memtable_write=1" >> my.cnf.tmp
echo "rocksdb_enable_write_thread_adaptive_yield=1" >> my.cnf.tmp
fi

if [[ $boc == 0 ]]; then
echo "binlog_order_commits=0" >> my.cnf.tmp
else
echo "binlog_order_commits=1" >> my.cnf.tmp
fi

if [[ $sync == 0 ]]; then
echo "sync_binlog=0" >> my.cnf.tmp
echo "rocksdb_write_sync=0" >> my.cnf.tmp
else
echo "sync_binlog=1" >> my.cnf.tmp
echo "rocksdb_write_sync=1" >> my.cnf.tmp
fi

echo Using
cat my.cnf.tmp

cat $dbdir/etc/my.cnf.bak my.cnf.tmp > $dbdir/etc/my.cnf

echo restart mysqld
( cd $dbdir ; bash ini.sh >& o.ini; sleep 10 )

$mybin -uroot -ppw -e 'show global variables' > o.sgv

bash all_cmt.sh $ntabs $nrows $rsecs $wsecs $e 1 0 $mybin none >& o.all

mkdir $e.$ntabs.$nrows.2pc_${twopc}.cmt_${cmt}.boc_${boc}.sync_${sync}
mv sb.* $e.$ntabs.$nrows.2pc_${twopc}.cmt_${cmt}.boc_${boc}.sync_${sync}
cp $dbdir/etc/my.cnf $e.$ntabs.$nrows.2pc_${twopc}.cmt_${cmt}.boc_${boc}.sync_${sync}
mv o.sgv o.all $dbdir/o.ini $e.$ntabs.$nrows.2pc_${twopc}.cmt_${cmt}.boc_${boc}.sync_${sync}

done
done
done
done
