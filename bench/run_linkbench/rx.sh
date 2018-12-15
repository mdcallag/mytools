nr=$1
nrt=$2
dev=$3
comp=$4

for d in 16jun17 8may18 ; do
 cd ~/b; rm -f myrocks; ln -s myrocks.$d myrocks
 cd ~/b/myrocks.$d; bash ini.sh; sleep 30
 cd ~/git/mytools/bench/run_linkbench
 bash all.sh rx ~/b/myrocks.$d/bin/mysql /data/m/my $nr $dev 1 3600 mysql lb.sql.rocks 12 127.0.0.1 1
 mkdir my.$nrt.myrocks.$d.$comp ; mv l.* r.*   my.$nrt.myrocks.$d.$comp
 sleep 30; ~/b/myrocks.$d/bin/mysqladmin -uroot -ppw -h127.0.0.1 shutdown; sleep 30
done

