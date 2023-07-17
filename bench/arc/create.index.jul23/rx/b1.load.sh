
sfx=load

while :; do ps aux | grep mysqld | grep basedir | grep datadir | grep -v mysqld_safe | grep -v grep; sleep 10; done >& o.ps.$sfx &
pspid=$!

vmstat 5 >& o.vm.$sfx &
vpid=$!

iostat -y -kx 5 >& o.io.$sfx &
ipid=$!

mysql -uroot -ppw -h127.0.0.1 -e 'drop database ib'
mysql -uroot -ppw -h127.0.0.1 -e 'create database ib'

python3 iibench.py --dbms=mysql --db_name=ib --secs_per_report=1 --db_host=127.0.0.1 --db_user=root --db_password=pw --engine=rocksdb --engine_options= --unique_checks=1 --max_rows=800000000 --table_name=pi1 --setup --num_secondary_indexes=0 --data_length_min=10 --data_length_max=20 --rows_per_commit=100 --inserts_per_second=0 --query_threads=0 --seed=1685681060 --dbopt=0 --my_id=1 >& o.ib.$sfx

kill $pspid
kill $vpid
kill $ipid
