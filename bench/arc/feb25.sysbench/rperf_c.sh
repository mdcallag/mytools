ntabs=$1
nrows=$2
rsecs=$3
wsecs=$4
dbdev=$5
usepk=$6
nthreads=$7

# Usually - rsecs=330 wsecs=630

for pm in \
 cache-references,cache-misses:c:50000 \
 branches,branch-misses:c:50000 \
 L1-dcache-loads,L1-dcache-load-misses:c:50000 \
 L1-icache-loads,L1-icache-loads-misses:c:50000 \
 dTLB-loads,dTLB-load-misses,iTLB-load-misses,iTLB-loads:c:50000 \
 instructions:c:50000 \
; do
  PERF_METRIC="${pm}" bash r.sh $ntabs $nrows $rsecs $wsecs $dbdev $usepk 1 $nthreads
  mkdir res.rperf."${pm}"
  mv x.* res.rperf."${pm}"
done
