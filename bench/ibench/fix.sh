nr=$1
ns=$2
ddir=$3
dop=$4
dname=$5
rpc=$6
ips=$7

sfx=dop${dop}.ns${ns}
maxr=$(( $nr / $dop ))

# TODO
#tot_secs=$(( $stop_secs - $start_secs ))
tot_secs=$( head -1 o.res.$sfx | awk '{ print $5 }' )

insert_rate=$( echo "scale=1; $nr / $tot_secs" | bc )
insert_per=$( echo "scale=1; $insert_rate / $dop" | bc )

total_query=$( for n in $( seq 1 $dop ); do awk '{ if (NF==9) print $0 }' o.ib.dop${dop}.ns${ns}.$n | tail -1 ; done | awk '{ tq += $7; } END { print tq }' )
query_rate=$( echo "scale=1; $total_query / $tot_secs" | bc )

# echo $dop processes, $maxr rows-per-process, $tot_secs seconds, $insert_rate rows-per-second, $insert_per rows-per-second-per-user
echo $dop processes, $maxr rows-per-process, $tot_secs seconds, $insert_rate rows-per-second, $insert_per rows-per-second-per-user, $total_query queries, $query_rate queries-per-second > o.res.$sfx

# Compute average rates per interval using 10 intervals
for x in 6 9 ; do
for n in $( seq 1 $dop ); do
  f=o.ib.dop${dop}.ns3.$n
  xa=$( wc -l $f | awk '{ print $1 }' ); xm=$(( $xa - 2 )); xp=$(( $xm / 10 ))
  for s in $( seq 0 9 ); do
    ha=$(( ($s * $xp) + $xp + 2 ))
    head -${ha} $f | tail -${xp} | awk '{ c += 1; s += $x } END { printf "%.0f,", s/c }' x=$x
  done
  printf "%s:DBMS\n" $n
done > o.rate.c.$x
cat o.rate.c.$x | tr ',' '\t' > o.rate.t.$x
done 

#du -hs $ddir > o.sz.$sfx
#echo "with apparent size " >> o.sz.$sfx
#du -hs --apparent-size $ddir >> o.sz.$sfx
#echo "all" >> o.sz.$sfx
#du -hs ${ddir}/* >> o.sz.$sfx

# Old and new format for iostat output
#Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
#Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util

printf "\niostat, vmstat normalized by insert rate\n" >> o.res.$sfx
printf "samp\tr/s\trkb/s\twkb/s\tr/q\trkb/q\twkb/q\tips\t\tspi\n" >> o.res.$sfx

iover=$( head -10 o.io.$sfx | grep Device | grep avgrq\-sz | wc -l )
if [[ $iover -eq 1 ]]; then
  grep $dname o.io.$sfx | awk '{ if (NR>1) { rs += $4; rkb += $6; wkb += $7; c += 1 } } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.3f\t%.3f\t%s\t\t%.6f\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q, (p*r)/q }' q=${insert_rate} p=$dop r=$rpc >> o.res.$sfx
else
  grep $dname o.io.$sfx | awk '{ if (NR>1) { rs += $2; rkb += $4; wkb += $5; c += 1 } } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.3f\t%.3f\t%s\t\t%.6f\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q, (p*r)/q }' q=${insert_rate} p=$dop r=$rpc >> o.res.$sfx
fi

printf "\nsamp\tcs/s\tcpu/c\tcs/q\tcpu/q\n" >> o.res.$sfx
grep -v swpd o.vm.$sfx | awk '{ if (NR>1) { cs += $12; cpu += $13 + $14; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=${insert_rate} >> o.res.$sfx

printf "\niostat, vmstat normalized by query rate\n" >> o.res.$sfx
printf "samp\tr/s\trkb/s\twkb/s\tr/q\trkb/q\twkb/q\tqps\t\tspq\n" >> o.res.$sfx
if [[ $iover -eq 1 ]]; then
  grep $dname o.io.$sfx | awk '{ if (NR>1) { rs += $4; rkb += $6; wkb += $7; c += 1 } } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.3f\t%.3f\t%s\t\t%.6f\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q, (p*r)/q }' q=${query_rate} p=$dop r=$rpc >> o.res.$sfx
else
  grep $dname o.io.$sfx | awk '{ if (NR>1) { rs += $2; rkb += $4; wkb += $5; c += 1 } } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.3f\t%.3f\t%s\t\t%.6f\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q, (p*r)/q }' q=${query_rate} p=$dop r=$rpc >> o.res.$sfx
fi

printf "\nsamp\tcs/s\tcpu/c\tcs/q\tcpu/q\n" >> o.res.$sfx
grep -v swpd o.vm.$sfx | awk '{ if (NR>1) { cs += $12; cpu += $13 + $14; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=${query_rate} >> o.res.$sfx

echo >> o.res.$sfx
#du -hs $ddir >> o.res.$sfx
echo TODO size $ddir >> o.res.$sfx

echo >> o.res.$sfx
#ps auxww | grep mysqld | grep -v mysqld_safe | grep -v grep >> o.res.$sfx
#ps aux | grep mongod | grep -v grep >> o.res.$sfx
echo TODO ps dbmsd >> o.res.$sfx

echo >> o.res.$sfx
echo "Max insert" >> o.res.$sfx
grep -h "Insert rt" o.ib.dop${dop}.ns${ns}.* | grep -v max | awk '{ printf "%.3f\n", $13 }' | sort -rnk 1 | head -3 >> o.res.$sfx
echo "Max query" >> o.res.$sfx
grep -h "Query rt" o.ib.dop${dop}.ns${ns}.* | grep -v max | awk '{ printf "%.3f\n", $13 }' | sort -rnk 1 | head -3 >> o.res.$sfx

echo >> o.res.$sfx
for n in $( seq 1 $dop ) ; do
  grep "Insert rt" o.ib.dop${dop}.ns${ns}.${n} >> o.res.$sfx
done

echo >> o.res.$sfx
for n in $( seq 1 $dop ) ; do
  grep "Query rt" o.ib.dop${dop}.ns${ns}.${n} >> o.res.$sfx
done

printf "\ninsert and query rate at nth percentile\n" >> o.res.$sfx
for n in $( seq 1 $dop ) ; do
  lines=$( awk '{ if (NF == 9) { print $6 } }' o.ib.dop${dop}.ns${ns}.${n} | wc -l )
  for x in 50 75 90 95 99 ; do
    off=$( printf "%.0f" $( echo "scale=3; ($x / 100.0 ) * $lines " | bc ) )
    i_nth=$( grep -v "Insert rt" o.ib.dop${dop}.ns${ns}.$n | grep -v "Query rt" | grep -v total_seconds | awk '{ if (NF == 9) { print $6 } }' | sort -rnk 1,1 | head -${off} | tail -1 )
    q_nth=$( grep -v "Insert rt" o.ib.dop${dop}.ns${ns}.$n | grep -v "Query rt" | grep -v total_seconds | awk '{ if (NF == 9) { print $9 } }' | sort -rnk 1,1 | head -${off} | tail -1 )
    echo ${x}th, ${off} / ${lines} = $i_nth insert, $q_nth query >> o.res.$sfx
  done
done

echo >> o.res.$sfx
echo "CPU seconds" >> o.res.$sfx

# Client CPU seconds
cat o.ctime.${sfx}.* | head -1 | awk '{ print $1 }' | sed 's/user//g' > o.utime.$sfx
cat o.ctime.${sfx}.* | head -1 | awk '{ print $2 }' | sed 's/system//g' > o.stime.$sfx
paste o.utime.$sfx o.stime.$sfx > o.atime.$sfx
us=$( cat o.atime.$sfx | awk '{ s += $1 } END { printf "%.2f\n", s }' )
sy=$( cat o.atime.$sfx | awk '{ s += $2 } END { printf "%.2f\n", s }' )
echo "client: $us user, $sy system, $( echo "$us $sy" | awk '{ printf "%.1f", $1 + $2 }' ) total" >> o.res.$sfx

function dt2s {
  ts=$1
  min=$( echo $ts | tr ':' ' ' | awk '{ print $1 }' )
  sec=$( echo $ts | tr ':' ' ' | awk '{ print $2 }' )
  d2nsecs=$( echo "$min * 60 + $sec" | bc )
  echo $d2nsecs
}

# dbms CPU seconds
# TODO -- make this work for postgres which uses many processes
dh=$( cat o.ps.$sfx | head -1 | awk '{ print $10 }' )
dt=$( cat o.ps.$sfx | tail -1 | awk '{ print $10 }' )
hsec=$( dt2s $dh )
tsec=$( dt2s $dt )
dsec=$( echo "$hsec $tsec" | awk '{ printf "%.1f", $2 - $1 }' )
dsec0=$( echo "$hsec $tsec" | awk '{ printf "%.0f", $2 - $1 }' )
echo "dbms: $dsec" >> o.res.$sfx

