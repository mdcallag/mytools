tag=$1
dev=$2

pm=L1-dcache-loads,L1-dcache-load-misses,L1-icache-loads-misses,cache-misses:F:111
#pm=dTLB-loads,dTLB-load-misses,iTLB-load-misses,iTLB-loads:F:111
#pm=branches,branch-misses,instructions:F:111

PERF_METRIC="${pm}" \
bash r.sh 1 50000000 600 900 $dev 1 1 1
mkdir res.dop1.$tag
mv x.* res.dop1.$tag

exit

PERF_METRIC="${pm}" \
bash r.sh 8 10000000 600 900 $dev 1 1 18
mkdir res.dop18.$tag
mv x.* res.dop18.$tag
