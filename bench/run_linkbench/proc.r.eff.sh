ddir=$1
# tag is something like L1.P1, L2.P2. See the suffixes used for r.r.* files
tag=$2
# sORq is one of "sec" "op"
secORop=$3

function dt2s {
  ts=$1
  min=$( echo $ts | tr ':' ' ' | awk '{ print $1 }' )
  sec=$( echo $ts | tr ':' ' ' | awk '{ print $2 }' )
  nsecs=$( echo "$min * 60 + $sec" | bc )
  echo $nsecs
}

if [[ $secORop == "sec" ]]; then
  echo "qps,secs,rps,rmbps,wmbps,csps,cpups,cutil,dutil,cnf"
else
  echo "qps,secs,rpq,rkbpq,wkbpq,cspq,cpupq,csecpq,dsecpq,csec,dsec,dbgb,cnf"
fi

nsecs=$( cat $ddir/r.r.*.$tag | head -1 | awk '{ print $12 }' )
qps=$( cat $ddir/r.r.*.$tag | head -1 | awk '{ printf "%.0f", $16 }' )

# dbms CPU secs
dh=$( cat $ddir/r.ps.*.$tag | grep -v mysqld_safe | head -1 | awk '{ print $10 }' )
dt=$( cat $ddir/r.ps.*.$tag | grep -v mysqld_safe | tail -1 | awk '{ print $10 }' )
hsec=$( dt2s $dh )
tsec=$( dt2s $dt )
dsec=$( echo "$hsec $tsec" | awk '{ printf "%.1f", $2 - $1 }' )
dsec0=$( echo "$hsec $tsec" | awk '{ printf "%.0f", $2 - $1 }' )

# client CPU secs
cus=$( cat $ddir/r.time.*.$tag | head -1 | awk '{ print $1 }' | sed 's/user//g' )
csy=$( cat $ddir/r.time.*.$tag | head -1 | awk '{ print $2 }' | sed 's/system//g' )
csec=$( echo "$cus $csy" | awk '{ printf "%.1f", $1 + $2 }' )
csec0=$( echo "$cus $csy" | awk '{ printf "%.0f", $1 + $2 }' )

dbgb=$( cat $ddir/r.r.*.$tag | head -12 | tail -1 | awk '{ printf "%.1f", $1 / 1024 }' )

if [[ $secORop == "sec" ]]; then
  rps=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.0f", $2 }' )
  rmbps=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.0f", $3 / 1024.0 }' )
  wmbps=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.0f", $4 / 1024.0 }' )
  csps=$( cat $ddir/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.0f", $2 }' )
  cpups=$( cat $ddir/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.1f", $3 }' )
  cutil=$( echo $csec $nsecs | awk '{ printf "%.3f", $1 / $2 }' )
  dutil=$( echo $dsec $nsecs | awk '{ printf "%.3f", $1 / $2 }' )
  #echo "$csec,$dsec"
  echo "$qps,$nsecs,$rps,$rmbps,$wmbps,$csps,$cpups,$cutil,$dutil,$ddir"
else
  rpq=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.3f", $5 }' )
  rkbpq=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.3f", $6 }' )
  wkbpq=$( cat $ddir/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.3f", $7 }' )
  cspq=$( cat $ddir/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.1f", $4 }' )
  cpupq=$( cat $ddir/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.0f", $5 * 1000000.0 }' )
  csecpq=$( echo $csec $nsecs $qps | awk '{ printf "%.1f", (($1 / ($2 * $3)) * 1000000) }' )
  dsecpq=$( echo $dsec $nsecs $qps | awk '{ printf "%.1f", (($1 / ($2 * $3)) * 1000000) }' )
  echo "$qps,$nsecs,$rpq,$rkbpq,$wkbpq,$cspq,$cpupq,$csecpq,$dsecpq,$csec0,$dsec0,$dbgb,$ddir"
fi

