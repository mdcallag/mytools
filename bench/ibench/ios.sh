iof=$1
vmf=$2
dname=$3
insert_rate=$4
query_rate=$5
realdop=$6
rpc=$7

# iostat output formats for Ubuntu 24/22, 20, 18 and 16. Someone likes change.
#Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz f/s f_await  aqu-sz  %util
#Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz  aqu-sz  %util
#Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
#Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

rs=$( grep Device $iof | head -1 | awk '{ print $4 }' )
rkb=$( grep Device $iof | head -1 | awk '{ print $6 }' )
wkb=$( grep Device $iof | head -1 | awk '{ print $7 }' )

# when the value is =0 then that field doesn't exist
if [[ "$rs" == "r/s" && "$rkb" == "rkB/s" && "$wkb" == "wkB/s" ]] ; then
  iover=ub16; crs=4; crkb=6; cwkb=7; cws=5; rsz=8; wsz=8; rwait=11; wwait=12; fwait=0
else
  rs=$( grep Device $iof | head -1 | awk '{ print $2 }' )
  rkb=$( grep Device $iof | head -1 | awk '{ print $4 }' )
  wkb=$( grep Device $iof | head -1 | awk '{ print $5 }' )

  if [[ "$rs" == "r/s" && "$rkb" == "rkB/s" && "$wkb" == "wkB/s" ]] ; then
    iover=ub18; crs=2; crkb=4; cwkb=5; cws=3; rsz=13; wsz=14; rwait=10; wwait=11; fwait=0
  else
    rs=$( grep Device $iof | head -1 | awk '{ print $2 }' )
    rkb=$( grep Device $iof | head -1 | awk '{ print $3 }' )
    wkb=$( grep Device $iof | head -1 | awk '{ print $9 }' )
    aqusz=$( grep Device $iof | head -1 | awk '{ print $20 }' )
    fwait=$( grep Device $iof | head -1 | awk '{ print $21 }' )

    if [[ "$rs" == "r/s" && "$rkb" == "rkB/s" && "$wkb" == "wkB/s" && "$aqusz" == "aqu-sz" ]] ; then
      iover=ub20; crs=2; crkb=3; cwkb=9; cws=8; rsz=7; wsz=13; rwait=6; wwait=12; fwait=0
    elif [[ "$rs" == "r/s" && "$rkb" == "rkB/s" && "$wkb" == "wkB/s" && "$fwait" == "f_await" ]] ; then
      iover=ub22; crs=2; crkb=3; cwkb=9; cws=8; rsz=7; wsz=13; rwait=6; wwait=12; fwait=21
    else
      echo "Cannot parse: $( grep Device $iof | head -1 )"
      exit -1
    fi
  fi
fi

#echo version: $iover
#grep Device $iof | head -1 | awk '{ print $rs, $rkb, $wkb }' rs=$crs rkb=$crkb wkb=$cwkb

printf "\niostat, vmstat normalized by insert rate\n" 
printf "nsamp\tr/s\trMB/s\tw/s\twMB/s\tr/i\trKB/i\tw/i\twKB/i\tips\n"

grep $dname $iof | awk '{ rs += $crs; rkb += $crkb; ws += $cws; wkb += $cwkb; c += 1 } END { printf "%s\t%.1f\t%.1f\t%.1f\t%.1f\t%.3f\t%.3f\t%.3f\t%.3f\t%s\n", c, rs/c, rkb/c/1024.0, ws/c, wkb/c/1024.0, rs/c/q, rkb/c/q, ws/c/q, wkb/c/q, q }' q=${insert_rate} p=$realdop r=$rpc crs=$crs crkb=$crkb cwkb=$cwkb cws=$cws

#grep $dname $iof | awk '{ rs += $crs; rkb += $crkb; ws += $cws; wkb += $cwkb; c += 1 } END { printf "%s\t%.1f\t%.1f\t%.1f\t%.1f\t%.3f\t%.3f\t%.3f\t%s\n", c, rs/c, rkb/c/1024.0, ws/c, wkb/c/1024.0, rs/c/q, rkb/c/q, wkb/c/q, q }' q=${ops} p=$realdop crs=$crs crkb=$crkb cwkb=$cwkb cws=$cws

printf "\nnsamp\tcs/s\tcpu/s\tcs/q\tcpu/q\n"
grep -v swpd $vmf | awk '{ if (NR>1) { cs += $12; cpu += $13 + $14; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=${insert_rate}

printf "\niostat, vmstat normalized by query rate\n"
printf "nsamp\tr/s\trMB/s\tw/s\twMB/s\tr/q\trKB/q\tw/q\twKB/q\tqps\n"

grep $dname $iof | awk '{ rs += $crs; rkb += $crkb; ws += $cws; wkb += $cwkb; c += 1 } END { printf "%s\t%.1f\t%.1f\t%.1f\t%.1f\t%.3f\t%.3f\t%.3f\t%.3f\t%s\n", c, rs/c, rkb/c/1024.0, ws/c, wkb/c/1024.0, rs/c/q, rkb/c/q, ws/c/q, wkb/c/q, q }' q=${query_rate} p=$realdop r=$rpc crs=$crs crkb=$crkb cwkb=$cwkb cws=$cws

printf "\nnsamp\tcs/s\tcpu/s\tcs/q\tcpu/q\n"
grep -v swpd $vmf | awk '{ if (NR>1) { cs += $12; cpu += $13 + $14; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=${query_rate}

