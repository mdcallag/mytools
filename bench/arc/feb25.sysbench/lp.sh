secs=$1
ts=$( date +'%m%d_%H%M%S' )

perf stat -a sleep $secs > p.${ts} 2>&1
perf stat -e cycles,instructions,cache-references,cache-misses,bus-cycles -a sleep $secs >> p.${ts} 2>&1
perf stat -e 'syscalls:sys_enter_*' -a sleep $secs >> p.${ts} 2>&1
perf stat -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores -a sleep $secs >> p.${ts} 2>&1
perf stat -e dTLB-loads,dTLB-load-misses,dTLB-prefetch-misses -a sleep $secs >> p.${ts} 2>&1
perf stat -e LLC-loads,LLC-load-misses,LLC-stores,LLC-prefetches -a sleep $secs >> p.${ts} 2>&1
