

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
  PERF_METRIC="${pm}" bash r.sh 1 30000000 600 600 nvme0n1 1 1 1 
  mkdir aug24."${pm}"
  mv x.* aug24."${pm}"
done
