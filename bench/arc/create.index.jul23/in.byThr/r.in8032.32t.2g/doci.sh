
#for m in 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 ; do echo Run $m ; time bash ciperf.sh /data/m/my8032/bin/mysql root pw ib $m; grep seconds o.ci.${m}m ; done
#for m in 1024 2048 4096 ; do echo Run $m ; time bash ciperf.sh /data/m/my8032/bin/mysql root pw ib $m; grep seconds o.ci.${m}m ; done
for m in 8192 ; do echo Run $m ; time bash ciperf.sh /data/m/my8032/bin/mysql root pw ib $m; grep seconds o.ci.${m}m ; done
