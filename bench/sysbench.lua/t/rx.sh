nr=$1
nrt=$2
usepk=$3

for d in 8may18 16jun17 ; do
 cd ~/b; rm -f myrocks; ln -s myrocks.$d myrocks
 cd ~/b/myrocks.$d; bash ini.sh; sleep 30
 cd ~/git/mytools/bench/sysbench.lua
 bash all_small.sh 2 $nr 600 600 300 rocksdb 1 0 ~/b/myrocks.$d/bin/mysql none ~/b/sysbench10 /data/m/my/data nvme0n $usepk
 mkdir 2t.$nrt.myrocks.$d.pk${usepk} ; mv sb.* 2t.$nrt.myrocks.$d.pk${usepk}
 sleep 90; ~/b/myrocks.$d/bin/mysqladmin -uroot -ppw -h127.0.0.1 shutdown; sleep 30
done

