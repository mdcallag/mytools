nr=12000000

bd=/data/users/mcallaghan/orig5635
e=innodb
et=inno.o5635

for usepk in 0 1 ; do
sleep 30; cd $bd
echo "in $PWD"
bash ini.sh >& o.i; sleep 30
echo "init done"
cd /data/users/mcallaghan/sysbench.lua; sleep 10

bash all3.sh 1 $nr 300 300 180 $e 1 0 $bd/bin/mysql none /data/mysql/sysbench10 $bd/data md2 $usepk
mkdir x.${nr}.pk${usepk}; mv sb.* x.${nr}.pk${usepk}

done
