LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so \
/usr/sbin/mysqld --defaults-file=/home/mdcallag/b/toku.my/my.cnf --plugin-dir=/usr/lib/mysql/plugin --user=mdcallag --log-error=/home/mdcallag/b/toku.my/error.log --pid-file=/home/mdcallag/b/toku.my/mysqld.pid --socket=/home/mdcallag/b/toku.my/mysqld.sock --port=3306
