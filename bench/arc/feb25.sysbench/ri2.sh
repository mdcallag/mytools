e=$1
nr=$2
nrt=$3

for d in orig5717 ; do
 cd ~/b/$d; bash ini.sh; sleep 5
 cd ~/git/mytools/bench/sysbench.lua
 bash all_small2.sh 1 $nr 60 600 300 $e 1 0 ~/b/$d/bin/mysql none ~/b/sysbench10 /data/m/my/data nvme0n
 #mkdir 1t.$nrt.$d.$e ; mv sb.* 1t.$nrt.$d.$e
 sleep 30; ~/b/$d/bin/mysqladmin -uroot -ppw -h127.0.0.1 shutdown; sleep 5
done
