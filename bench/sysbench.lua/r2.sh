r=$1
bd=$2
e=$3
usepk=$4

cd $bd; sleep 10; bash ini.sh >& o.ini; sleep 10; cd /data/users/mcallaghan/sysbench.lua
bash all.sh 8 $r 180 300 180 $e 1 0 $bd/bin/mysql none /data/mysql/sysbench10 $bd/data md2 $usepk
mkdir x.8.pk${usepk}; mv sb.* x.8.pk${usepk}

cd $bd; sleep 90; bash ini.sh >& o.ini; sleep 10; cd /data/users/mcallaghan/sysbench.lua
bash all.sh 1 $(( $r * 8 )) 180 300 180 $e 1 0 $bd/bin/mysql none  /data/mysql/sysbench10 $bd/data md2 $usepk
mkdir x.1.pk${usepk}; mv sb.* x.1.pk${usepk}
