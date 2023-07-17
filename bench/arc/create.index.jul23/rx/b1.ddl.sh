
mcrsmb=$1

mcrs=$(( $mcrsmb * 1024 * 1024 ))

echo MCRS: $mcrsmb $mcrs

sfx=ddl

while :; do ps aux | grep mysqld | grep basedir | grep datadir | grep -v mysqld_safe | grep -v grep; sleep 10; done >& o.ps.$sfx &
pspid=$!

vmstat 5 >& o.vm.$sfx &
vpid=$!

iostat -y -kx 5 >& o.io.$sfx &
ipid=$!

/usr/bin/time -o o.dx.$sfx mysql -uroot -ppw -h127.0.0.1 ib -e 'alter table pi1 drop index x1, drop index x2, drop index x3' >& o.dx2.$sfx

/usr/bin/time -o o.cx.$sfx mysql -uroot -ppw -h127.0.0.1 ib -e \
  "SET SESSION rocksdb_merge_combine_read_size=$mcrs; \
   SET SESSION rocksdb_bulk_load_allow_sk=1; \
   SET SESSION rocksdb_bulk_load=1; \
   alter table pi1 add index x1(price, customerid), add index x2 (cashregisterid, price, customerid), add index x3 (price, dateandtime, customerid)" >& o.ib.$sfx &
mypid=$!

sleep 5
mysql -uroot -ppw -h127.0.0.1 -e 'show processlist'
wait $mypid

kill $pspid
kill $vpid
kill $ipid
