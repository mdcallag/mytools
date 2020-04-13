d=$1
dop=$2
ns=$3
ddir=$4
mrows=$5
tag=$6
uname=$7

lres=$d/l/o.res.dop${dop}.ns${ns}
q1000res=$d/q1000/o.res.dop${dop}.ns${ns}
q100res=$d/q100/o.res.dop${dop}.ns${ns}

scanf=$d/scan/o.ib.scan

function from_hdr_i {
  fname=$1

  ips=$( head -1 $fname | awk '{ print $7 }' )
  echo -n "$ips,"
}

function from_hdr_q {
  fname=$1

  qps=$( head -1 $fname | awk '{ print $13 }' )
  echo -n "$qps,"
}

function from_by {
  fname=$1
  off1=$2
  off2=$3

  rps=$( head -$off1 $fname   | tail -1 | awk '{ print $2 }' )
  rkbps=$( head -$off1 $fname | tail -1 | awk '{ print $3 }' )
  wkbps=$( head -$off1 $fname | tail -1 | awk '{ print $4 }' )
  rpq=$( head -$off1 $fname   | tail -1 | awk '{ print $5 }' )
  rkbpq=$( head -$off1 $fname | tail -1 | awk '{ print $6 }' )
  wkbpq=$( head -$off1 $fname | tail -1 | awk '{ print $7 }' )

  csps=$( head -$off2 $fname  | tail -1 | awk '{ print $2 }' )
  cpups=$( head -$off2 $fname | tail -1 | awk '{ print $3 }' )
  cspq=$( head -$off2 $fname  | tail -1 | awk '{ print $4 }' )
  cpupq=$( head -$off2 $fname | tail -1 | awk '{ print $5 }' )

  echo -n "$rps,$rkbps,$wkbps,$rpq,$rkbpq,$wkbpq,$csps,$cpups,$cspq,$cpupq,"
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

function get_scans {
  fname=$1
  field=$2
  tag=$3

  secs=$( head -${field} $fname | tail -1 | awk '{ print $4 }'  )
  s2=$secs
  if [[ $s2 -eq 0 ]]; then s2=1; fi
  mrps=$( echo "scale=3; $mrows / $s2 " | bc | awk '{ printf "%.3f", $1 }' )

  metf=$fname.met.q${field}

  rps=$(   awk '/wGB/ { at=NR+1 } { if (at==NR && NF==10) { print $2; exit } }' $metf )
  rmbps=$( awk '/wGB/ { at=NR+1 } { if (at==NR && NF==10) { print $3; exit } }' $metf )
  wmbps=$( awk '/wGB/ { at=NR+1 } { if (at==NR && NF==10) { print $4; exit } }' $metf )
  rpo=$(   awk '/wGB/ { at=NR+1 } { if (at==NR && NF==10) { print $5; exit } }' $metf )
  rkbpo=$( awk '/wGB/ { at=NR+1 } { if (at==NR && NF==10) { print $6; exit } }' $metf )
  if [ -z $rps ]; then rps="0"; fi
  if [ -z $rmbps ]; then rmbps="0"; fi
  if [ -z $wmbps ]; then wmbps="0"; fi
  if [ -z $rpo ]; then rpo="0"; fi
  if [ -z $rkbpo ]; then rkbpo="0"; fi

  csps=$(     awk '/Mcpu/ { at=NR+1 } { if (at==NR && NF==6) { print $2; exit } }' $metf )
  cpups=$(    awk '/Mcpu/ { at=NR+1 } { if (at==NR && NF==6) { print $3; exit } }' $metf )
  cspo=$(     awk '/Mcpu/ { at=NR+1 } { if (at==NR && NF==6) { print $4; exit } }' $metf )
  mcpupo=$(   awk '/Mcpu/ { at=NR+1 } { if (at==NR && NF==6) { print $5; exit } }' $metf )
  if [ -z $csps ]; then csps="0"; fi
  if [ -z $cpups ]; then cpups="0"; fi
  if [ -z $cspo ]; then cspo="0"; fi
  if [ -z $mcpupo ]; then mcpupo="0"; fi

  echo "$s2,$mrps,$rps,$rmbps,$wmbps,$rpo,$rkbpo,$csps,$cpups,$cspo,$mcpupo,$tag"
}

echo "ips,qps,rps,rkbps,wkbps,rpq,rkbpq,wkbpq,csps,cpups,cspq,cpupq,dbgb,vsz,rss,maxop,p50,p99,tag"

# echo load
from_hdr_i $lres
echo -n "0,"
from_by $lres 5 8
ddir_sz $lres $ddir
dbms_vsz_rss $lres $uname
get_max $lres "Max insert"
get_ptile $lres 50th 6
get_ptile $lres 99th 6
echo $tag

# echo q1000
from_hdr_i $q1000res
from_hdr_q $q1000res
from_by $q1000res 12 15
ddir_sz $q1000res $ddir
dbms_vsz_rss $q1000res $uname
get_max $q1000res "Max query"
get_ptile $q1000res 50th 8
get_ptile $q1000res 99th 8
echo $tag

# echo q100
from_hdr_i $q100res
from_hdr_q $q100res
from_by $q100res 12 15
ddir_sz $q100res $ddir
dbms_vsz_rss $q100res $uname
get_max $q100res "Max query"
get_ptile $q100res 50th 8
get_ptile $q100res 99th 8
echo $tag

echo "secs,mrps,rps,rmbps,wmbps,rpo,rkbpo,csps,cpups,cspo,Mcpupo,tag"
get_scans $scanf 1 $tag
get_scans $scanf 2 $tag
get_scans $scanf 3 $tag
get_scans $scanf 4 $tag
get_scans $scanf 5 $tag

