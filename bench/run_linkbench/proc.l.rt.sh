ddir=$1

echo "ips,secs,n9,nx,nm,l9,lx,lm,c9,cx,cm,cnf"

n9=$( cat $ddir/l.pre.o.* | grep LOAD_NODE_BULK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
nx=$( cat $ddir/l.pre.o.* | grep LOAD_NODE_BULK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.0f\n", $1 }' )
nm=$( cat $ddir/l.pre.o.* | grep LOAD_NODE_BULK | tail -1 | awk '{ print $29 }' | sed 's/ms//g'  | awk '{ printf "%.0f\n", $1 }' )
l9=$( cat $ddir/l.pre.o.* | grep LOAD_LINKS_BULK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
lx=$( cat $ddir/l.pre.o.* | grep LOAD_LINKS_BULK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.0f\n", $1 }' )
lm=$( cat $ddir/l.pre.o.* | grep LOAD_LINKS_BULK | tail -1 | awk '{ print $29 }' | sed 's/ms//g'  | awk '{ printf "%.0f\n", $1 }' )
c9=$( cat $ddir/l.pre.o.* | grep LOAD_COUNTS_BULK | tail -1 | awk '{ print $23 }' | tr -d '[]ms' | tr ',' ' ' | awk '{ print $2 }' )
cx=$( cat $ddir/l.pre.o.* | grep LOAD_COUNTS_BULK | tail -1 | awk '{ print $26 }' | sed 's/ms//g' | awk '{ printf "%.0f\n", $1 }' )
cm=$( cat $ddir/l.pre.o.* | grep LOAD_COUNTS_BULK | tail -1 | awk '{ print $29 }' | sed 's/ms//g'  | awk '{ printf "%.0f\n", $1 }' )

secs=$( cat $ddir/l.pre.o.* | grep "LOAD PHASE COMPLETED" | awk '{ printf "%.0f", $21 }' )
ips=$( cat $ddir/l.pre.o.* | grep "LOAD PHASE COMPLETED" | awk '{ printf "%.0f", $25 }' )

echo "$ips,$secs,$n9,$nx,$nm,$l9,$lx,$lm,$c9,$cx,$cm,$ddir"


