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

# old
#       0   1   2     3     4   5     6     7    8     9   10    11    12    13  14    15  16  17  18
#echo "ips,qps,rps,rkbps,wkbps,rpq,rkbpq,wkbpi,csps,cpups,cspq,cpupq,dbgb1,dbgb2,rss,maxop,p50,p99,tag"

# new
#       0   1   2     3   4     5   6     7   8     9   10    11   12    13    14    15  16    17  18  19  20
#echo "ips,qps,rps,rmbps,wps,wmbps,rpq,rkbpq,wpi,wkbpi,csps,cpups,cspq,cpupq,dbgb1,dbgb2,rss,maxop,p50,p99,tag"

#iostat, vmstat normalized by insert rate
#1 	2	3	4	5	6	7	8	9	10
#nsamp   r/s     rMB/s   w/s     wMB/s   r/i     rKB/i   w/i     wKB/i   ips
#38      0.0     0.0     38.3    15.4    0.000   0.000   0.000   0.153   103092.7

function from_by {
  fname=$1
  off1=$2
  off2=$3
  offq=$4
  offw=$5

  rps=$( head -$off1 $fname   | tail -1 | awk '{ print $2 }' )
  rmbps=$( head -$off1 $fname | tail -1 | awk '{ print $3 }' )
  wps=$( head -$off1 $fname   | tail -1 | awk '{ print $4 }' )
  wmbps=$( head -$off1 $fname | tail -1 | awk '{ print $5 }' )
  rpq=$( head -$off1 $fname   | tail -1 | awk '{ print $6 }' )
  rkbpq=$( head -$off1 $fname | tail -1 | awk '{ print $7 }' )
  wpi=$( head -$offw $fname   | tail -1 | awk '{ print $8 }' )
  wkbpi=$( head -$offw $fname | tail -1 | awk '{ print $9 }' )

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

  echo -n "$rps,$rmbps,$wps,$wmbps,$rpq,$rkbpq,$wpi,$wkbpi,$csps,$cpups,$cspq,$cpupq,"
}

function ddir_sz {
  fname=$1
  ddir=$2

  # dbGB    0.103
  sz1=$( grep dbGB $fname | awk '{ printf "%.1f", $2 }' )

  # dbdirGB 0.314   /data/m/pg
  sz2=$( grep dbdirGB $fname | awk '{ printf "%.1f", $2 }' )

  echo -n "$sz1,$sz2,"
}

function dbms_vsz_rss {
  fname=$1
  username=$2

  # ps truncates long usernames
  uname7=$( echo $username | awk '{ print substr($1, 1, 7) }' )

  if grep $uname7 $fname > /dev/null ; then
    vsz=$( grep $uname7 $fname | head -1 | awk '{ printf "%.1f", $5 / (1024*1024) }' )
    rss=$( grep $uname7 $fname | head -1 | awk '{ printf "%.1f", $6 / (1024*1024) }' )
  else
    vsz=NA
    rss=NA
  fi
  echo -n "$rss,"
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

#       0   1   2     3     4   5     6     7    8     9   10    11    12    13  14    15  16  17  18
#echo "ips,qps,rps,rkbps,wkbps,rpq,rkbpq,wkbpi,csps,cpups,cspq,cpupq,dbgb1,dbgb2,rss,maxop,p50,p99,tag"
#       0   1   2     3   4     5   6     7   8     9   10    11   12    13    14    15  16    17  18  19  20
echo "ips,qps,rps,rmbps,wps,wmbps,rpq,rkbpq,wpi,wkbpi,csps,cpups,cspq,cpupq,dbgb1,dbgb2,rss,maxop,p50,p99,tag"

l0res=$d/l.i0/o.res.dop${dop}
lxres=$d/l.x/o.res.dop${dop}
l1res=$d/l.i1/o.res.dop${dop}
l2res=$d/l.i2/o.res.dop${dop}

for f in $l0res $lxres $l1res $l2res ; do
#echo load hdr_i $f 
from_hdr_i $f
echo -n "0,"
from_by $f 5 8 7 5
ddir_sz $f $ddir
dbms_vsz_rss $f $uname
get_max $f "Max insert"
get_ptile $f 50th 6
get_ptile $f 99th 6
echo $tag
done

loop=1
for n in 100 500 1000 ; do
for y in r p ; do
f="${d}/q${y}${n}.L${loop}/o.res.dop${dop}"
# echo run $f 
from_hdr_i $f
from_hdr_q $f
from_by $f 12 15 13 5
ddir_sz $f $ddir
dbms_vsz_rss $f $uname
get_max $f "Max query"
get_ptile $f 50th 10
get_ptile $f 99th 10
echo $tag
loop=$(( $loop + 1 ))
done
done

