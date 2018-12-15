nr=$1
e=$2
ns=$3
dop=$4
dname=$5
rpc=$6

insert_rate=$7
query_rate=$8

sfx=dop${dop}.ns${ns}
rm -f o.res.$sfx

maxr=$(( $nr / $dop ))

#insert_rate=$( echo "scale=1; $nr / $tot_secs" | bc )
insert_per=$( echo "scale=1; $insert_rate / $dop" | bc )

total_query=$( for n in $( seq 1 $dop ); do grep -v "Insert rt" o.ib.dop${dop}.ns${ns}.$n | grep -v "Query rt" | tail -3 | head -1 ; done | awk '{ tq += $7; } END { print tq }' )
#query_rate=$( echo "scale=1; $total_query / $tot_secs" | bc )

echo $dop processes, $maxr rows-per-process, $tot_secs seconds, $insert_rate rows-per-second, $insert_per rows-per-second-per-user, $total_query queries, $query_rate queries-per-second > o.res.$sfx

printf "\niostat, vmstat normalized by insert rate\n" >> o.res.$sfx
printf "samp\tr/s\trkb/s\twkb/s\tr/q\trkb/q\twkb/q\tips\t\tspi\n" >> o.res.$sfx
grep $dname o.io.$sfx | awk '{ if (NR>1) { rs += $4; rkb += $6; wkb += $7; c += 1 } } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.3f\t%.3f\t%s\t\t%.6f\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q, (p*r)/q }' q=${insert_rate} p=$dop r=$rpc >> o.res.$sfx

printf "\nsamp\tcs/s\tcpu/c\tcs/q\tcpu/q\n" >> o.res.$sfx
grep -v swpd o.vm.$sfx | awk '{ if (NR>1) { cs += $12; cpu += $13 + $14; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=${insert_rate} >> o.res.$sfx

printf "\niostat, vmstat normalized by query rate\n" >> o.res.$sfx
printf "samp\tr/s\trkb/s\twkb/s\tr/q\trkb/q\twkb/q\tqps\t\tspq\n" >> o.res.$sfx
grep $dname o.io.$sfx | awk '{ if (NR>1) { rs += $4; rkb += $6; wkb += $7; c += 1 } } END { printf "%s\t%.1f\t%.0f\t%.0f\t%.3f\t%.3f\t%.3f\t%s\t\t%.6f\n", c, rs/c, rkb/c, wkb/c, rs/c/q, rkb/c/q, wkb/c/q, q, (p*r)/q }' q=${query_rate} p=$dop r=$rpc >> o.res.$sfx

printf "\nsamp\tcs/s\tcpu/c\tcs/q\tcpu/q\n" >> o.res.$sfx
grep -v swpd o.vm.$sfx | awk '{ if (NR>1) { cs += $12; cpu += $13 + $14; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.3f\t%.6f\n", c, cs/c, cpu/c, cs/c/q, cpu/c/q }' q=${query_rate} >> o.res.$sfx

echo >> o.res.$sfx

echo >> o.res.$sfx
ps auxww | grep mysqld | grep -v mysqld_safe | grep -v grep >> o.res.$sfx
ps aux | grep mongod | grep -v grep >> o.res.$sfx

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

cat o.res.$sfx
