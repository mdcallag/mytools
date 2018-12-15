e=$1
nr=$2
nrt=$3

for d in orig803 orig802 orig801 orig5717 orig5635 orig5551 orig5172 orig5096 ; do
 cd ~/b/$d; bash ini.sh; sleep 5
 cd ~/git/mytools/bench/sysbench.lua
 bash all_small.sh 2 $nr 600 600 300 $e 1 0 ~/b/$d/bin/mysql none ~/b/sysbench10 /data/m/my/data nvme0n
 mkdir 2t.$nrt.$d.$e ; mv sb.* 2t.$nrt.$d.$e
 sleep 30; ~/b/$d/bin/mysqladmin -uroot -ppw -h127.0.0.1 shutdown; sleep 5
done
