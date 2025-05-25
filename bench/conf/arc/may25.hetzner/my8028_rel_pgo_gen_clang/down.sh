
vmstat 1 >& o.vms &
vpid=$!
iostat -y -kx 1 >& o.ios &
ipid=$!

echo Start shutdown at $( date )
#while :; do bash /home/mdcallag/git/mytools/bench/ibench/pmp.sh $( pidof mysqld ); sleep 3 ; done &
#ppid=$!
s1=$( date +%s )
bin/mysqladmin -uroot -ppw shutdown
e1=$( date +%s )
t1=$(( e1 - s1 ))
#kill $ppid
kill $vpid
kill $ipid
echo shutdown finished at $( date )
sleep 3

s2=$( date +%s )
while ps aux | egrep "mariadb|mysqld" | grep -v grep ; do sleep 1; echo running; done
e2=$( date +%s )
t2=$(( e2 - s2 ))
echo Total secs during, after shutdown is $t1 , $t2
echo Total secs during, after shutdown is $t1 , $t2 > o.stopsecs
cp /data/m/my/data/*.err .

sleep 3

killall -s KILL mysqld
sleep 2

rm -rf /data/m/my; mkdir -p /data/m/my
mkdir -p /data/m/my/data
mkdir -p /data/m/my/binlogs
mkdir -p /data/m/my/txlogs

rm -rf var
mkdir var

