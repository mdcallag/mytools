echo "First shutdown"
ls -lrt *profraw*
bin/mysqladmin -uroot -ppw shutdown
sleep 3
echo "After first shutdown"
ls -lrt *profraw*

rm -rf /data/m/fbmy; mkdir -p /data/m/fbmy
rm -rf /data/m/pg; mkdir -p /data/m/pg
rm -rf /data/m/rx; mkdir -p /data/m/rx

rm -rf /data/m/my; mkdir -p /data/m/my
mkdir /data/m/my/binlogs
mkdir /data/m/my/txlogs
mkdir /data/m/my/data

rm -rf var; mkdir var

csfx=def
if [ "$#" -ge 1 ]; then
  if [ -f etc/my.cnf.c${1} ]; then
    cp etc/my.cnf.c${1} etc/my.cnf
    csfx=c${1}
  else
    echo etc/my.cnf.c${1} does not exist
    exit 1
  fi
fi

killall -s KILL mongod
killall -s KILL mysqld
sleep 3

#sudo bash ~/mytools/scripts/compact_vm.sh
sleep 3

echo Init at $( date )
ls -lrt *profraw*
LLVM_PROFILE_FILE="code-%p.profraw" bin/mysqld --initialize-insecure  >& o.ini.$csfx
# bin/mysqld --initialize --initialize-insecure --defaults-file=etc/my.cnf >& o.init; cat o.init

# exit

sleep 2
echo After init
ls -lrt *profraw*
# TODO
# bin/mysqld_safe &
#numactl --interleave=all bin/mysqld_safe &
echo Start at $( date )
#LLVM_PROFILE_FILE="code-%p.profraw" numactl --interleave=all /home/mdcallag/d/my8028_rel_pgo_gen_clang/bin/mysqld --basedir=/home/mdcallag/d/my8028_rel_pgo_gen_clang --datadir=/data/m/my/data --plugin-dir=/home/mdcallag/d/my8028_rel_pgo_gen_clang/lib/plugin --log-error=Ubuntu-2204-jammy-amd64-base.err --pid-file=Ubuntu-2204-jammy-amd64-base.pid &
#LLVM_PROFILE_FILE="code-%p.profraw" /home/mdcallag/d/my8028_rel_pgo_gen_clang/bin/mysqld --basedir=/home/mdcallag/d/my8028_rel_pgo_gen_clang --datadir=/data/m/my/data --plugin-dir=/home/mdcallag/d/my8028_rel_pgo_gen_clang/lib/plugin --log-error=Ubuntu-2204-jammy-amd64-base.err --pid-file=Ubuntu-2204-jammy-amd64-base.pid &
/home/mdcallag/d/my8028_rel_pgo_gen_clang/bin/mysqld --basedir=/home/mdcallag/d/my8028_rel_pgo_gen_clang --datadir=/data/m/my/data --plugin-dir=/home/mdcallag/d/my8028_rel_pgo_gen_clang/lib/plugin --log-error=Ubuntu-2204-jammy-amd64-base.err --pid-file=Ubuntu-2204-jammy-amd64-base.pid &
mypid=$!
echo After start for mysqld $mypid
ls -lrt *profraw*
sleep 30
ps auxwww > o.ps
echo After sleep
ls -lrt *profraw*
bin/mysqladmin -uroot --password="" password pw

bin/mysql -uroot -ppw mysql -e "grant all on *.* to root@'%' identified by 'pw'"
# bin/mysql -uroot -ppw mysql -e "delete from user where length(Password) = 0; flush privileges;"

bin/mysql -uroot -ppw -A -e 'drop database test'
bin/mysql -uroot -ppw -A -e 'create database test'
bin/mysql -uroot -ppw -A -e 'show databases'

