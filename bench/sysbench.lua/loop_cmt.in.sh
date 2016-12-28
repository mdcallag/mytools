ntabs=$1
nrows=$2
rsecs=$3
wsecs=$4
e=$5
mybin=$6
dbdir=$7

for boc in 0 1 ; do
for sync in 0 1 ; do

echo Run for boc $boc, sync $sync at $( date )

echo configure mysqld
rm -f my.cnf.tmp
if [[ $boc == 0 ]]; then
echo "binlog_order_commits=0" >> my.cnf.tmp
else
echo "binlog_order_commits=1" >> my.cnf.tmp
fi

if [[ $sync == 0 ]]; then
echo "sync_binlog=0" >> my.cnf.tmp
echo "innodb_flush_log_at_trx_commit=2" >> my.cnf.tmp
else
echo "sync_binlog=1" >> my.cnf.tmp
echo "innodb_flush_log_at_trx_commit=1" >> my.cnf.tmp
fi

echo Using
cat my.cnf.tmp

cat $dbdir/etc/my.cnf.bak my.cnf.tmp > $dbdir/etc/my.cnf

echo restart mysqld
( cd $dbdir ; bash ini.sh >& o.ini; sleep 10 )

$mybin -uroot -ppw -e 'show global variables' > o.sgv

bash all_cmt.sh $ntabs $nrows $rsecs $wsecs $e 1 0 $mybin none >& o.all

mkdir $e.$ntabs.$nrows.boc_${boc}.sync_${sync}
mv sb.* $e.$ntabs.$nrows.boc_${boc}.sync_${sync}
cp $dbdir/etc/my.cnf $e.$ntabs.$nrows.boc_${boc}.sync_${sync}
mv o.sgv o.all $dbdir/o.ini $e.$ntabs.$nrows.boc_${boc}.sync_${sync}

done
done
