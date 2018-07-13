ns=$1
nr=$2

bd=/data/users/mcallaghan/myrocks.8may18
e=rocksdb
et=rx.8may18

for usepk in 0 1 ; do
for cnf in 5.16 5.8 5.4 5.1 4.1 3.1 ; do
sleep 30; cd $bd; cp my.cnf.$cnf etc/my.cnf
echo "in $PWD"
bash ini.sh >& o.i.$cnf; sleep 30
echo "init done"
cd /data/users/mcallaghan/sysbench.lua; sleep 10

bash all4.sh 1 $nr $ns $ns 180 $e 1 0 $bd/bin/mysql none /data/mysql/sysbench10 $bd/data md2 $usepk
mkdir x.${nr}.pk${usepk}.$cnf; mv pre post sb.* x.${nr}.pk${usepk}.$cnf

done
done
