#for d in orig802 orig801 orig5717 orig5635 orig5551 orig5172 orig5096 ; do
for d in orig802 orig801 orig5717 orig5635 orig5551 orig5172 ; do
 cd ~/b/$d
 bash ini.sh
 sleep 5
 #cd ~/git/mytools/bench/ibench
 cd ~/git/mytools/bench/sysbench.lua
 #bash iq.sh innodb "" ~/b/$d/bin/mysql /data/m/my nvme0n1 1 1 no no no 0 no 500000000
 #bash iq3.sh innodb "" ~/b/$d/bin/mysql /data/m/my nvme0n1 1 1 no no no 0 no 5000000
 mkdir my.500m.$d
 mv l q100*  my.500m.$d
 ~/b/$d/bin/mysql -uroot -ppw -h127.0.0.1 -e "show global variables" > my.500m.$d/o.sgv
 ~/b/$d/bin/mysql -uroot -ppw -h127.0.0.1 -e "show global status" > my.500m.$d/o.sgs
 ~/b/$d/bin/mysqladmin -uroot -ppw -h127.0.0.1 shutdown
 sleep 5
done

