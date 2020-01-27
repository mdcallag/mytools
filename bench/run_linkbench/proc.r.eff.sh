# tag is something like L1.P1, L2.P2. See the suffixes used for r.r.* files
tag=$1
# sORq is one of "sec" "op"
secORop=$2

function dt2s {
  ts=$1
  min=$( echo $ts | tr ':' ' ' | awk '{ print $1 }' )
  sec=$( echo $ts | tr ':' ' ' | awk '{ print $2 }' )
  nsecs=$( echo "$min * 60 + $sec" | bc )
  echo $nsecs
}

if [[ $secORop == "sec" ]]; then
  echo "secs,qps,rps,rmbps,wmbps,csps,cpups,cutil,dutil,cnf"
else
  echo "secs,qps,rpq,rkbpq,wkbpq,cspq,cpupq,csecpq,dsecpq,csec,dsec,dbgb,cnf"
fi

for d in * ; do 
  nsecs=$( cat $d/r.r.*.$tag | head -1 | awk '{ print $12 }' )
  qps=$( cat $d/r.r.*.$tag | head -1 | awk '{ print $16 }' )

  # dbms CPU secs
  dh=$( cat $d/r.ps.*.$tag | grep -v mysqld_safe | head -1 | awk '{ print $10 }' )
  dt=$( cat $d/r.ps.*.$tag | grep -v mysqld_safe | tail -1 | awk '{ print $10 }' )
  hsec=$( dt2s $dh )
  tsec=$( dt2s $dt )
  dsec=$( echo "$hsec $tsec" | awk '{ printf "%.1f", $2 - $1 }' )
  dsec0=$( echo "$hsec $tsec" | awk '{ printf "%.0f", $2 - $1 }' )

  # client CPU secs
  cus=$( cat $d/r.time.*.$tag | head -1 | awk '{ print $1 }' | sed 's/user//g' )
  csy=$( cat $d/r.time.*.$tag | head -1 | awk '{ print $2 }' | sed 's/system//g' )
  csec=$( echo "$cus $csy" | awk '{ printf "%.1f", $1 + $2 }' )
  csec0=$( echo "$cus $csy" | awk '{ printf "%.0f", $1 + $2 }' )

  dbgb=$( cat $d/r.r.*.$tag | head -12 | tail -1 | awk '{ print $1 }' )

  if [[ $secORop == "sec" ]]; then
    rps=$( cat $d/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.0f", $2 }' )
    rmbps=$( cat $d/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.0f", $3 / 1024.0 }' )
    wmbps=$( cat $d/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.0f", $4 / 1024.0 }' )
    csps=$( cat $d/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.0f", $2 }' )
    cpups=$( cat $d/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.1f", $3 }' )
    cutil=$( echo $csec $nsecs | awk '{ printf "%.3f", $1 / $2 }' )
    dutil=$( echo $dsec $nsecs | awk '{ printf "%.3f", $1 / $2 }' )
    #echo "$csec,$dsec"
    echo "$nsecs,$qps,$rps,$rmbps,$wmbps,$csps,$cpups,$cutil,$dutil,$d"
  else
    rpq=$( cat $d/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.3f", $5 }' )
    rkbpq=$( cat $d/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.3f", $6 }' )
    wkbpq=$( cat $d/r.r.*.$tag | head -4 | tail -1 | awk '{ printf "%.3f", $7 }' )
    cspq=$( cat $d/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.1f", $4 }' )
    cpupq=$( cat $d/r.r.*.$tag | head -7 | tail -1 | awk '{ printf "%.0f", $5 * 1000000.0 }' )
    csecpq=$( echo $csec $nsecs $qps | awk '{ printf "%.1f", (($1 / ($2 * $3)) * 1000000) }' )
    dsecpq=$( echo $dsec $nsecs $qps | awk '{ printf "%.1f", (($1 / ($2 * $3)) * 1000000) }' )
    echo "$nsecs,$qps,$rpq,$rkbpq,$wkbpq,$cspq,$cpupq,$csecpq,$dsecpq,$csec0,$dsec0,$dbgb,$d"
  fi

done
