ddir=$1
# tag is something like L1.P1, L2.P2. See the suffixes used for r.r.* files
tag=$2
# sORq is one of "sec" "op"
secORop=$3
username=$4

function dt2s {
  ts=$1
  min=$( echo $ts | tr ':' ' ' | awk '{ print $1 }' )
  sec=$( echo $ts | tr ':' ' ' | awk '{ print $2 }' )
  nsecs=$( echo "$min * 60 + $sec" | bc )
  echo $nsecs
}

if [[ $secORop == "sec" ]]; then
  echo "qps,secs,rps,rmbps,wmbps,csps,cpups,cutil,dutil,vsz,rss,cnf"
else
  echo "qps,secs,rpq,rkbpq,wkbpq,cspq,cpupq,csecpq,dsecpq,csec,dsec,dbgb1,dbgb2,cnf"
fi

nsecs=$( cat $ddir/r.r.*.$tag | head -1 | awk '{ print $12 }' )
qps=$( cat $ddir/r.r.*.$tag | head -1 | awk '{ printf "%.0f", $16 }' )

# dbms CPU secs
dsec=$( grep dbms: $ddir/r.r.*.$tag | head -1 | awk '{ print $2 }' )
dsec0=$( echo $dsec | awk '{ printf "%.0f", $1 }' )

# client CPU secs
csec=$( grep client: $ddir/r.r.*.$tag | head -1 | awk '{ print $6 }' )
csec0=$( echo $csec | awk '{ printf "%.0f", $1 }' )

dbgb1=$( grep "^dbGB" $ddir/r.r.*.$tag | awk '{ printf "%.1f", $2 }' )
dbgb2=$( grep "^dbdirGB" $ddir/r.r.*.$tag | awk '{ printf "%.1f", $2 }' )

if [[ $secORop == "sec" ]]; then
  rps=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.0f", $2 }' )
  rmbps=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.0f", $3 / 1024.0 }' )
  wmbps=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.0f", $4 / 1024.0 }' )
  csps=$( cat $ddir/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.0f", $2 }' )
  cpups=$( cat $ddir/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.1f", $3 }' )
  cutil=$( echo $csec $nsecs | awk '{ printf "%.3f", $1 / $2 }' )
  dutil=$( echo $dsec $nsecs | awk '{ printf "%.3f", $1 / $2 }' )
  if grep $username $ddir/r.r.*.$tag > /dev/null ; then
    vsz=$( grep $username $ddir/r.r.*.$tag | tail -1 | awk '{ printf "%.1f", $5 / (1024*1024) }' )
    rss=$( grep $username $ddir/r.r.*.$tag | tail -1 | awk '{ printf "%.1f", $6 / (1024*1024) }' )
  else
    vsz=NA
    rss=NA
  fi
  #echo "$csec,$dsec"
  echo "$qps,$nsecs,$rps,$rmbps,$wmbps,$csps,$cpups,$cutil,$dutil,$vsz,$rss,$ddir"
else
  rpq=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.3f", $5 }' )
  rkbpq=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.3f", $6 }' )
  wkbpq=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.3f", $7 }' )
  cspq=$( cat $ddir/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.1f", $4 }' )
  cpupq=$( cat $ddir/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.0f", $5 * 1000000.0 }' )
  csecpq=$( echo $csec $nsecs $qps | awk '{ printf "%.1f", (($1 / ($2 * $3)) * 1000000) }' )
  dsecpq=$( echo $dsec $nsecs $qps | awk '{ printf "%.1f", (($1 / ($2 * $3)) * 1000000) }' )
  echo "$qps,$nsecs,$rpq,$rkbpq,$wkbpq,$cspq,$cpupq,$csecpq,$dsecpq,$csec0,$dsec0,$dbgb1,$dbgb2,$ddir"
fi

