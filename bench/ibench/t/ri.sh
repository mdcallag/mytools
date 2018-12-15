e=$1
nr=$2
nrt=$3

for d in orig803 orig802 orig801 orig5717 orig5635 orig5551 orig5172 orig5096 ; do
 cd ~/b/$d; bash ini.sh; sleep 5
 cd ~/git/mytools/bench/ibench
 bash iq.sh $e "" ~/b/$d/bin/mysql /data/m/my/data nvme0n1 1 1 no no no 0 no $nr no
 mkdir my.$nrt.$d.$e ; mv l scan q100* my.$nrt.$d.$e
 sleep 30; ~/b/$d/bin/mysqladmin -uroot -ppw -h127.0.0.1 shutdown; sleep 5
done
