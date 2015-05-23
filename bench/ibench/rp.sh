nr=$1
e=$2
eo=$3
dbdir=$4

python mstat.py --db_user=root --db_password=pw --db_host=127.0.0.1 --loops=10000000 --interval=10 >& o.mstat &
mpid=$!

time python iibench.py --db_host=127.0.0.1 --db_user=root --db_password=pw --max_rows=${nr} --engine=$e --engine_options=$eo --setup --insert_only >& o.ib

kill -9 $mpid

mysql -uroot -ppw -A -h127.0.0.1 -e 'show engine innodb status\G' > o.es
mysql -uroot -ppw -A -h127.0.0.1 -e 'show global status' > o.gs
mysql -uroot -ppw -A -h127.0.0.1 -e 'show global variables' > o.gv

du -hs $dbdir > o.sz.${maxn}
du --apparent-size -hs $dbdir >> o.sz.${maxn}

