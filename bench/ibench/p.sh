nr=$1
e=$2
eo=$3
ns=$4
client=$5
ddir=$6
dop=$7
dlmin=$8
dlmax=$9
dokill=${10}
dname=${11}
only1t=${12}
unique=${13}
rpc=${14}
ips=${15}
nqt=${16}

sfx=dop${dop}.ns${ns}

maxr=$(( $nr / $dop ))

printf "\ninsert and query rate at nth percentile\n" >> o.res.$sfx
for n in $( seq 1 $dop ) ; do
  lines=$( awk '{ if (NF == 9) { print $6 } }' o.ib.dop${dop}.ns${ns}.${n} | wc -l )
  for x in 50 75 90 95 99 ; do
    off=$( printf "%.0f" $( echo "scale=3; ($x / 100.0 ) * $lines " | bc ) )
    i_nth=$( awk '{ if (NF == 9) { print $6 } }' o.ib.dop${dop}.ns${ns}.${n} | sort -rnk 1,1 | head -${off} | tail -1 )
    q_nth=$( awk '{ if (NF == 9) { print $9 } }' o.ib.dop${dop}.ns${ns}.${n} | sort -rnk 1,1 | head -${off} | tail -1 )
    echo ${x}th, ${off} / ${lines} = $i_nth insert, $q_nth query >> o.res.$sfx
  done
done

cat o.res.$sfx
