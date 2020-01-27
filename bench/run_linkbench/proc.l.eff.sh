# tag is one of "pre" "post"
tag=$1
# sORq is one of "sec" "op"
secORop=$2

function dt2s {
  ts=$1
  min=$( echo $ts | tr ':' ' ' | awk '{ print $1 }' )
  sec=$( echo $ts | tr ':' ' ' | awk '{ print $2 }' )
  d2nsecs=$( echo "$min * 60 + $sec" | bc )
  echo $d2nsecs
}

if [[ $secORop == "sec" ]]; then
  echo "secs,ips,rps,rmbps,wmbps,csps,cpups,cutil,dutil,cnf"
else
  echo "secs,ips,rpi,rkbpi,wkbpi,cspi,cpupi,csecpq,dsecpq,csec,dsec,dbgb,cnf"
fi

for d in * ; do 
  nsecs=$( cat $d/l.$tag.r.* | grep "^Inserted in" | awk '{ print $3 }' )
  # Avoids div by 0 during l.post when there is no work to do because 
  # index was created during l.pre
  if [[ $nsecs -eq 0 ]]; then nsecs=1 ; fi
  ips=$( cat $d/l.$tag.r.* | head -3 | tail -1 | awk '{ printf "%.0f", $8 }' )

  # dbms CPU secs
  dh=$( cat $d/l.$tag.ps.* | grep -v mysqld_safe | head -1 | awk '{ print $10 }' )
  dt=$( cat $d/l.$tag.ps.* | grep -v mysqld_safe | tail -1 | awk '{ print $10 }' )
  hsec=$( dt2s $dh )
  tsec=$( dt2s $dt )
  dsec=$( echo "$hsec $tsec" | awk '{ printf "%.1f", $2 - $1 }' )
  dsec0=$( echo "$hsec $tsec" | awk '{ printf "%.0f", $2 - $1 }' )

  # client CPU secs
  if [ -f $d/l.$tag.time.* ]; then
    cus=$( cat $d/l.$tag.time.* | head -1 | awk '{ print $1 }' | sed 's/user//g' )
    csy=$( cat $d/l.$tag.time.* | head -1 | awk '{ print $2 }' | sed 's/system//g' )
    csec=$( echo "$cus $csy" | awk '{ printf "%.1f", $1 + $2 }' )
    csec0=$( echo "$cus $csy" | awk '{ printf "%.0f", $1 + $2 }' )
  else
    cus=X; csy=X; csec=0; csec0=0
  fi
dbgb=$( cat $d/l.$tag.r.* | head -11 | tail -1 | awk '{ print $1 }' )

  if [[ $secORop == "sec" ]]; then
    rps=$( cat $d/l.$tag.r.* | head -3 | tail -1 | awk '{ printf "%.0f", $2 }' )
    rmbps=$( cat $d/l.$tag.r.* | head -3 | tail -1 | awk '{ printf "%.0f", $3 / 1024.0 }' )
    wmbps=$( cat $d/l.$tag.r.* | head -3 | tail -1 | awk '{ printf "%.0f", $4 / 1024.0 }' )
    csps=$( cat $d/l.$tag.r.* | head -6 | tail -1 | awk '{ printf "%.0f", $2 }' )
    cpups=$( cat $d/l.$tag.r.* | head -6 | tail -1 | awk '{ printf "%.1f", $3 }' )
    cutil=$( echo $csec $nsecs | awk '{ printf "%.3f", $1 / $2 }' )
    dutil=$( echo $dsec $nsecs | awk '{ printf "%.3f", $1 / $2 }' )
    #echo "$csec,$dsec"
    echo "$nsecs,$ips,$rps,$rmbps,$wmbps,$csps,$cpups,$cutil,$dutil,$d"
  else
    rpi=$( cat $d/l.$tag.r.* | head -3 | tail -1 | awk '{ printf "%.3f", $5 }' )
    rkbpi=$( cat $d/l.$tag.r.* | head -3 | tail -1 | awk '{ printf "%.3f", $6 }' )
    wkbpi=$( cat $d/l.$tag.r.* | head -3 | tail -1 | awk '{ printf "%.3f", $7 }' )
    cspi=$( cat $d/l.$tag.r.* | head -6 | tail -1 | awk '{ printf "%.1f", $4 }' )
    cpupi=$( cat $d/l.$tag.r.* | head -6 | tail -1 | awk '{ printf "%.0f", $5 * 1000000.0 }' )
    csecpq=$( echo $csec $nsecs $ips | awk '{ printf "%.1f", (($1 / ($2 * $3)) * 1000000) }' )
    dsecpq=$( echo $dsec $nsecs $ips | awk '{ printf "%.1f", (($1 / ($2 * $3)) * 1000000) }' )
    echo "$nsecs,$ips,$rpi,$rkbpi,$wkbpi,$cspi,$cpupi,$csecpq,$dsecpq,$csec0,$dsec0,$dbgb,$d"
  fi

done
