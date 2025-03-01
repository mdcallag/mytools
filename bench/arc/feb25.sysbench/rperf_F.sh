ntabs=$1
nrows=$2
rsecs=$3
wsecs=$4
dbdev=$5
usepk=$6
nthreads=$7

# Usually - rsecs=330 wsecs=630

for pm in \
 cache-references,cache-misses:F:997 \
 branches,branch-misses:F:997 \
 L1-dcache-loads,L1-dcache-load-misses:F:997 \
 L1-icache-loads,L1-icache-loads-misses:F:997 \
 dTLB-loads,dTLB-load-misses,iTLB-load-misses,iTLB-loads:F:997 \
 instructions:F:997 \
; do
  PERF_METRIC="${pm}" bash r.sh $ntabs $nrows $rsecs $wsecs $dbdev $usepk 1 $nthreads
  mkdir res.rperf."${pm}"
  mv x.* res.rperf."${pm}"
done
