ntabs=$1
nrows=$2
rsecs=$3
wsecs=$4
dbdev=$5
usepk=$6
nthreads=$7

# Usually - rsecs=330 wsecs=630

for pm in \
 cache-references \
 cache-misses \
 branches \
 branch-misses \
 L1-dcache-loads \
 L1-dcache-load-misses \
 L1-icache-loads-misses \
 dTLB-loads \
 dTLB-load-misses \
 iTLB-load-misses \
 iTLB-loads \
 instructions \
; do
  PERF_METRIC="${pm}" bash r.sh $ntabs $nrows $rsecs $wsecs $dbdev $usepk 1 $nthreads
  mkdir res.rperf."${pm}"
  mv x.* res.rperf."${pm}"
done
