mcrsmb=$1

for m in 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 ; do echo Run $m ; time bash ciperf_rx.sh /data/m/fbmy8028/bin/mysql root pw ib $m $mcrsmb ; grep seconds o.ci.${m}m ; done
