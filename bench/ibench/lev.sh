
dop=4
bd=/data/users/mcallaghan/myrocks.8may18
nr=30000000
e=rocksdb
et=ro.8may18

for cnf in 4096.1 512.1 64.1 64.4 64.8 64.16 ; do
sleep 30; cd $bd; cp my.cnf.$cnf etc/my.cnf
echo "in $PWD"
bash ini.sh >& o.i.$cnf; sleep 30
echo "init done"
cd /data/users/mcallaghan/ibench; sleep 10

bash iq2.sh rocksdb "" $bd/bin/mysql $bd/data md2 1 $dop no no no 0 no $nr no 

mkdir x.${nr}.$cnf; mv l scan q100* x.${nr}.$cnf

done
