e=$1
nr=$2
nrt=$3
scanonly=$4

for d in jun16 ; do
 cd ~/b/myrocks.$d; bash ini.sh; sleep 5
 cd ~/git/mytools/bench/ibench
 bash iq.sh $e "" ~/b/myrocks.$d/bin/mysql /data/m/my/data nvme0n 1 1 no no no 0 no $nr $scanonly
 mkdir my.$nrt.rx.$d.$e ; mv l scan q100* my.$nrt.rx.$d.$e
 sleep 30; ~/b/myrocks.$d/bin/mysqladmin -uroot -ppw -h127.0.0.1 shutdown; sleep 5
done
