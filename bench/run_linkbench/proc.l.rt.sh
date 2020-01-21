
echo "secs,lps,n9,nx,nm,l9,lx,lm,c9,cx,cm,cnf"

for d in * ; do 
  n9=$( cat $d/l.pre.o.* | grep LOAD_NODE_BULK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
  nx=$( cat $d/l.pre.o.* | grep LOAD_NODE_BULK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.0f\n", $1 }' )
  nm=$( cat $d/l.pre.o.* | grep LOAD_NODE_BULK | tail -1 | awk '{ print $29 }' | sed 's/ms//g'  | awk '{ printf "%.0f\n", $1 }' )
  l9=$( cat $d/l.pre.o.* | grep LOAD_LINKS_BULK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
  lx=$( cat $d/l.pre.o.* | grep LOAD_LINKS_BULK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.0f\n", $1 }' )
  lm=$( cat $d/l.pre.o.* | grep LOAD_LINKS_BULK | tail -1 | awk '{ print $29 }' | sed 's/ms//g'  | awk '{ printf "%.0f\n", $1 }' )
  c9=$( cat $d/l.pre.o.* | grep LOAD_COUNTS_BULK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
  cx=$( cat $d/l.pre.o.* | grep LOAD_COUNTS_BULK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.0f\n", $1 }' )
  cm=$( cat $d/l.pre.o.* | grep LOAD_COUNTS_BULK | tail -1 | awk '{ print $29 }' | sed 's/ms//g'  | awk '{ printf "%.0f\n", $1 }' )

  secs=$( cat $d/l.pre.o.* | grep "LOAD PHASE COMPLETED" | awk '{ print $21 }' )
  lps=$( cat $d/l.pre.o.* | grep "LOAD PHASE COMPLETED" | awk '{ print $25 }' )

  echo "$secs,$lps,$n9,$nx,$nm,$l9,$lx,$lm,$c9,$cx,$cm,$d"
done


