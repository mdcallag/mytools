
#x=0; for d in $( ls -rt | grep ^x\. | grep -v qps ); do echo $d; cd $d ; for f in sb.perf.last.*; do ln=$( cat $f ); ln2=$ln; if [[ ln2 -gt x ]]; then ln2=$(( ln2 - x )); fi ; f2=$( echo $f | sed 's/last/hw/' ); f3="${f2}.${ln2}"; echo $f $x $ln $ln2 $f3; bash ~/grep_perfstat1.sh $f3 > raw${x}.$f ; sort -k 1,1 raw${x}.$f > sorted${x}.$f; done; cd .. ; done

ifile=$1

function getcol {
  mcno=$1
  mname=$2
  pcno=$3
  pname=$4
  # echo mcno $mcno, mname $mname, pcno $pcno, pname $pname
  cat $ifile | \
      sed 's/<not supported>/-1/' | \
      awk '{ if ($mcno == mname) { print $pcno }}' mcno=$mcno mname=$mname pcno=$pcno | \
      sed 's/,//g' | \
      sed 's/\%//g' | \
      awk '{ if ($1 == "<not supported>") { $1 = -1 }; printf "%s\t%s\n", pname, $1 }' pname=$pname | \
      head -1
}

getcol 2 cycles 1 cycles
getcol 2 cycles 4 GHz
getcol 2 bus-cycles 1 bus-cycles
getcol 2 instructions 1 instructions
getcol 2 instructions 4 ipc
getcol 2 branches 1 branches
getcol 2 branch-misses 1 branch-misses
getcol 2 branch-misses 4 branch-miss-pct

getcol 2 cache-references 1 cache-references
getcol 2 cache-misses 1 cache-misses
getcol 2 cache-misses 4 cache-miss-pct
getcol 2 stalled-cycles-backend 1 stalled-cycles-backend
getcol 2 stalled-cycles-frontend 1 stalled-cycles-frontend

getcol 2 L1-dcache-loads 1 L1-dcache-loads
getcol 2 L1-dcache-load-misses 1 L1-dcache-load-misses
getcol 2 L1-dcache-load-misses 4 L1-dcache-load-miss-pct
getcol 2 L1-dcache-stores 1 L1-dcache-stores

getcol 2 dTLB-loads 1 dTLB-loads
getcol 2 dTLB-load-misses 1 dTLB-load-misses
getcol 2 dTLB-load-misses 4 dTLB-load-miss-pct
getcol 2 dTLB-stores 1 dTLB-stores
getcol 2 dTLB-store-misses 1 dTLB-store-misses

getcol 2 iTLB-loads 1 iTLB-loads
getcol 2 iTLB-load-misses 1 iTLB-load-misses
getcol 2 iTLB-load-misses 4 iTLB-load-miss-pct
getcol 2 L1-icache-loads-misses 1 L1-icache-loads-misses
getcol 2 L1-icache-loads-misses 4 L1-icache-load-miss-pct
getcol 2 L1-icache-loads 1 L1-icache-loads

getcol 2 LLC-loads 1 LLC-loads
getcol 2 LLC-load-misses 1 LLC-load-misses
getcol 2 LLC-stores 1 LLC-stores
getcol 2 LLC-store-misses 1 LLC-store-misses
getcol 2 LLC-prefetches 1 LLC-prefetches

getcol 2 alignment-faults 1 alignment-faults
getcol 2 context-switches 1 context-switches
getcol 2 migrations 1 migratons
getcol 2 major-faults 1 major-faults
getcol 2 minor-faults 1 minor-faults
getcol 2 faults 1 faults

