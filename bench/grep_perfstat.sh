
# m=20; for d in ${m}m.*; do echo $d; for d2 in l.i0 l.x l.i1 q.L1.ips100 q.L2.ips500 q.L3.ips1000 ; do bash ../grep_perfstat.sh $d/$d2 > $d/$d2/o.summary.perfstat ; done ; done

# m=20; dsfx="_rel.cy10a_bee"; for d in my5621 my5631 my5641 my5651 my5710 my5720 my5730 my5743 my8013 my8014 my8018 my8019 my8020 my8027 my8028 my8030 my8034 ; do dfull="${m}m.${d}${dsfx}";  for d2 in l.i0 l.x l.i1 q.L1.ips100 q.L2.ips500 q.L3.ips1000 ; do sort $dfull/$d2/o.summary.perfstat > $dfull/$d2/o.summary.perfstat.sorted ; done ; done

#m=20; dsfx="_rel.cy10a_bee"; b=my5621; for d2 in l.i0 l.i1 q.L1.ips100 q.L2.ips500 q.L3.ips1000 ; do cp ${m}m.${b}${dsfx}/$d2/o.summary.perfstat.sorted o.perfstat; for d in my5631 my5641 my5651 my5710 my5720 my5730 my5743 my8013 my8014 my8018 my8019 my8020 my8027 my8028 my8030 my8034 ; do join o.perfstat ${m}m.${d}${dsfx}/$d2/o.summary.perfstat.sorted > o.perfstat.tmp; mv o.perfstat.tmp o.perfstat ; done ; cat o.perfstat | grep -v file | tr ' ' '\t' > o.perfstat.${d2}.tsv; cat o.perfstat | grep -v file | tr ' ' ',' > o.perfstat.${d2}.csv ; done

tdir=$1

nfiles=$( ls $tdir/o.perfstat.* | wc -l )
if [[ nfiles -gt 1 ]]; then
  ufile=$(( nfiles - 1 ))
elif [[ nfiles -eq 1 ]]; then
  ufile=1
else
  echo "Not enough files"
  ls $tdir/o.perfstat.*
  exit 1
fi

echo -e "file\t$tdir/o.perfstat.${ufile}"

function getcol {
  mcno=$1
  mname=$2
  pcno=$3
  pname=$4
  # echo mcno $mcno, mname $mname, pcno $pcno, pname $pname
  cat $tdir/o.perfstat.${ufile}.* | \
      sed 's/<not supported>/-1/' | \
      awk '{ if ($mcno == mname) { print $pcno }}' mcno=$mcno mname=$mname pcno=$pcno | \
      sed 's/,//g' | \
      sed 's/\%//g' | \
      awk '{ if ($1 == "<not supported>") { $1 = -1 }; printf "%s\t%s\n", pname, $1 }' pname=$pname
}

getcol 2 cycles 1 cycles
getcol 2 bus-cycles 1 bus-cycles
getcol 2 instructions 1 instructions
getcol 2 instructions 4 ipc

getcol 2 cache-references 1 cache-references
getcol 2 cache-misses 1 cache-misses
getcol 2 cache-misses 4 cache-miss-pct
getcol 2 branches 1 branches
getcol 2 branch-misses 1 branch-misses
getcol 2 branch-misses 4 branch-miss-pct

getcol 2 L1-dcache-loads 1 L1-dcache-loads
getcol 2 L1-dcache-load-misses 1 L1-dcache-load-misses
getcol 2 L1-dcache-load-misses 4 L1-dcache-load-miss-pct
getcol 2 L1-dcache-stores 1 L1-dcache-stores
getcol 2 L1-icache-loads-misses 1 L1-icache-loads-misses

getcol 2 dTLB-loads 1 dTLB-loads
getcol 2 dTLB-load-misses 1 dTLB-load-misses
getcol 2 dTLB-load-misses 4 dTLB-load-miss-pct
getcol 2 dTLB-stores 1 dTLB-stores
getcol 2 dTLB-store-misses 1 dTLB-store-misses
getcol 2 dTLB-prefetch-misses 1 dTLB-prefetch-misses

getcol 2 iTLB-loads 1 iTLB-loads
getcol 2 iTLB-load-misses 1 iTLB-load-misses
getcol 2 iTLB-load-misses 4 iTLB-load-miss-pct

getcol 2 LLC-loads 1 LLC-loads
getcol 2 LLC-load-misses 1 LLC-loads-misses
getcol 2 LLC-stores 1 LLC-stores
getcol 2 LLC-store-misses 1 LLC-store-misses
getcol 2 LLC-prefetches 1 LLC-prefetches

getcol 2 alignment-faults 1 alignment-faults
getcol 2 context-switches 1 context-switches
getcol 2 migrations 1 migratons
getcol 2 major-faults 1 major-faults
getcol 2 minor-faults 1 minor-faults
getcol 2 faults 1 faults

#                 0      alignment-faults
#            12,917      context-switches
#               731      migrations
#                 0      major-faults
#             9,699      minor-faults
#             9,699      faults
