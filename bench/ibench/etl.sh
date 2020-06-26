d=$1
dop=$2
ddir=$3
mrows=$4
tag=$5
uname=$6
ncpu=$7

function from_hdr_i {
  fname=$1

  ips=$( head -1 $fname | awk '{ printf "%.0f", $7 }' )
  echo -n "$ips,"
}

function from_hdr_q {
  fname=$1

  qps=$( head -1 $fname | awk '{ printf "%.0f", $13 }' )
  echo -n "$qps,"
}

function from_by {
  fname=$1
  off1=$2
  off2=$3
  offq=$4

  rps=$( head -$off1 $fname   | tail -1 | awk '{ print $2 }' )
  rkbps=$( head -$off1 $fname | tail -1 | awk '{ print $3 }' )
  wkbps=$( head -$off1 $fname | tail -1 | awk '{ print $4 }' )
  rpq=$( head -$off1 $fname   | tail -1 | awk '{ print $5 }' )
  rkbpq=$( head -$off1 $fname | tail -1 | awk '{ print $6 }' )
  wkbpq=$( head -$off1 $fname | tail -1 | awk '{ print $7 }' )

  csps=$( head -$off2 $fname  | tail -1 | awk '{ print $2 }' )
  cpups=$( head -$off2 $fname | tail -1 | awk '{ print $3 }' )
  cspq=$( head -$off2 $fname  | tail -1 | awk '{ print $4 }' )

  # inserts/s for load and queries/s otherwise
  qps=$( head -1 $fname | awk '{ print $cn }' cn=$offq )
  nsecs=$( head -1 $fname | awk '{ print $5 }' )

  # Benchmark client CPU seconds
  ccpu=$( grep "^client:" $fname | awk '{ print $6 }' )

  # Client CPU microseconds / query
  ccpupq=$( echo "scale=6; ( $ccpu * 1000000.0) / ( $qps * $nsecs )" | bc | awk '{ printf "%.0f", $1 }' )

  # Total CPU seconds
  tcpu=$( echo "scale=6; ( $cpups / 100.0 ) * $nsecs * $ncpu" | bc | awk '{ printf "%.1f", $1 }' )

  # Total CPU microseconds / query
  cpupq=$( echo "scale=6; ( $tcpu * 1000000.0 ) / ( $qps * $nsecs )" | bc | awk '{ printf "%.0f", $1 }' )

  echo -n "$rps,$rkbps,$wkbps,$rpq,$rkbpq,$wkbpq,$csps,$cpups,$cspq,$cpupq,$ccpupq,"
}

function ddir_sz {
  fname=$1
  ddir=$2

  if grep $ddir $fname > /dev/null ; then
    sz=$( grep $ddir $fname | head -1 | awk '{ print $1 }' | sed s/G//g )
  else
    sz=NA
  fi
  echo -n "$sz,"
}

function dbms_vsz_rss {
  fname=$1
  username=$2

  if grep $username $fname > /dev/null ; then
    vsz=$( grep $username $fname | head -1 | awk '{ printf "%.1f", $5 / (1024*1024) }' )
    rss=$( grep $username $fname | head -1 | awk '{ printf "%.1f", $6 / (1024*1024) }' )
  else
    vsz=NA
    rss=NA
  fi
  echo -n "$vsz,$rss,"
}

function get_max {
  fname=$1
  pattern=$2

  maxv=$( awk "/^$pattern/ { at=NR+1 } { if (at==NR) { print \$0; exit }}" $fname )
  #echo awk "/^$pattern/ { at=NR+1 } { if (at==NR) { print \$0; exit }}" $fname
  echo -n "$maxv,"
}

function get_ptile {
  fname=$1
  target=$2
  field=$3
  v=$( grep "^$target" $fname | head -1 | awk "{ print \$$field }" )
  echo -n "$v,"
}

echo "ips,qps,rps,rkbps,wkbps,rpq,rkbpq,wkbpq,csps,cpups,cspq,cpupq,ccpupq,dbgb,vsz,rss,maxop,p50,p90,tag"

l0res=$d/l.i0/o.res.dop${dop}
lxres=$d/l.x/o.res.dop${dop}
l1res=$d/l.i1/o.res.dop${dop}

for f in $l0res $lxres $l1res ; do
#echo load hdr_i $f 
from_hdr_i $f
echo -n "0,"
from_by $f 5 8 7
ddir_sz $f $ddir
dbms_vsz_rss $f $uname
get_max $f "Max insert"
get_ptile $f 50th 6
get_ptile $f 90th 6
echo $tag
done

loop=1
for n in 100 100 200 200 400 400 600 600 800 800 1000 1000 ; do
f="${d}/q.L${loop}.ips${n}/o.res.dop${dop}"
# echo run $f 
from_hdr_i $f
from_hdr_q $f
from_by $f 12 15 13
ddir_sz $f $ddir
dbms_vsz_rss $f $uname
get_max $f "Max query"
get_ptile $f 50th 8
get_ptile $f 90th 8
echo $tag
loop=$(( $loop + 1 ))
done

