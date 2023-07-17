
for mb in 128 256 512 1024 2048 3000 4000 ; do
 cd /data/m/fbmy8028
 bin/mysqladmin -uroot -ppw shutdown
 sleep 10
 bin/mysqld_safe &
 sleep 30
 cd /data/m/ibench.repro

 bash b1.ddl.sh $mb
 mkdir r.mb${mb}
 mv o.* r.mb${mb}
done
