sfx=$1

mpid=$( pidof mysqld )

perf stat -a sleep 10 >& ps.stat.$sfx
sleep 3

perf stat -e cycles,instructions,cache-references,cache-misses,bus-cycles -a sleep 10 >& ps.cycle.$sfx
sleep 3

perf stat -e 'syscalls:sys_enter_*' -a sleep 10 >& ps.syscall.$sfx
sleep 3

perf stat -e L1-dcache-loads,L1-dcache-load-misses,L1-dcache-stores -a sleep 10 >& ps.cache.$sfx
sleep 3

perf stat -e dTLB-loads,dTLB-load-misses,dTLB-prefetch-misses -a sleep 10 >& ps.tlb.$sfx
sleep 3

perf stat -e LLC-loads,LLC-load-misses,LLC-stores,LLC-prefetches -a sleep 10 >& ps.llc.$sfx
sleep 3

perf top -e raw_syscalls:sys_enter -ns comm >& ps.top.$sfx
sleep 3

#perf list --help >& ps.list.$sfx

perf record -F 99 -g -p $mpid -e bus-cycles -- sleep 30 ; perf report --stdio --no-children > ps.g.my.$sfx
sleep 3
perf record -F 99    -p $mpid -e bus-cycles -- sleep 30 ; perf report --stdio --no-children > ps.f.my.$sfx
sleep 3

perf record -F 99 -g -a -e bus-cycles -- sleep 30 ; perf report --stdio --no-children > ps.g.a.$sfx
sleep 3
perf record -F 99    -a -e bus-cycles -- sleep 30 ; perf report --stdio --no-children > ps.f.a.$sfx
sleep 3

#perf record -F 99 -g -p $mpid -- sleep 30
#perf record -F 99 -g -p $mpid -- sleep 30
perf record -F 99 -g -a -- sleep 30

echo before stack collapse

perf script | ./stackcollapse-perf.pl > ps.fold.$sfx
./flamegraph.pl ps.fold.$sfx > ps.$sfx.svg
for mw in $( seq 1 20 ); do
./flamegraph.pl ps.fold.$sfx > ps.$sfx.$mw.svg
done

mkdir pa.$sfx
mv ps.* pa.$sfx

