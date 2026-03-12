tag=$1

sudo dmidecode --type memory > o.dmidecode.$tag
sudo lshw > o.lshw.$tag

for f in write read ; do lua/sysbench memory --memory-block-size=1G --memory-total-size=100G --memory-oper=${f} run > o.sysbench.mem.${f}.$tag ; done
cat /proc/cpuinfo > o.cpuinfo.$tag
lscpu > o.lscpu.$tag
for nt in 1 4 8 16 24 32 40 48 ; do lua/sysbench cpu run --cpu-max-prime=20000 --threads=$nt > o.cpu.nt${nt}.$tag ; done
