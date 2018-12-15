for d in orig5096 orig5172 orig5551 orig5635 orig5717 orig801 orig802 ; do
 cd ~/b/$d
 bash ini.sh
 sleep 5
 cd ~/git/mytools/bench/sysbench.lua
 bash all_small.sh 4 1000000 600 600 300 myisam 1 0 ~/b/$d/bin/mysql none ~/b/sysbench10
 mkdir x.myisam$d
 mv sb.* x.myisam$d
 ~/b/$d/bin/mysqladmin -uroot -ppw -h127.0.0.1 shutdown
 sleep 5
 #cp -r /data/m/my /data/m/my.$d
done

