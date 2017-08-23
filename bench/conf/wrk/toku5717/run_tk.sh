for d in test ib linkdb linkdb0 tpc ; do mysql -uroot -ppw -e 'reset master'; mysql -uroot -ppw -e "drop database $d"; mysql -uroot -ppw -e "create database $d"; done; sleep 10; du -hs data; mysqladmin -uroot -ppw shutdown; du -hs data

LD_PRELOAD=/usr/lib64/libjemalloc.so.1 /usr/sbin/mysqld --basedir=/usr --datadir=/data/mysql/toku/data --plugin-dir=/usr/lib64/mysql/plugin --user=root --log-error=/var/log/mysqld.log --pid-file=/var/run/mysqld/mysqld.pid --user=root  >> db.err 2>&1 &
