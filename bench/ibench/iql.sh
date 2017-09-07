e=$1
eo=$2
client=$3
data=$4
dname=$5
checku=$6
dop=$7
mongo=$8
short=$9
only1t=${10}
bulk=${11}
secatend=${12}
nr=${13}

# insert only
bash np.sh $nr $e "$eo" 3 $client $data  $dop 10 20 0 $dname $only1t $checku 100 0 0 yes $mongo $short $bulk $secatend
mkdir l
mv o.* l

# full scan
ntabs=$dop
if [[ $only1t == "yes" ]]; then ntabs=1; fi
sfx=dop${$ntabs}.ns${ns}

killall vmstat
killall iostat
vmstat 10 >& o.vm.$sfx &
vpid=$!
iostat -kx 10 >& o.io.$sfx &
ipid=$!

start_secs=$( date +%s )
for i in $( seq 1 $ntabs ) ; do
  if [[ $mongo == "yes" ]] ; then 
    echo "db.pi$i.find"'({ customerid : { $lt : 0 } }).count()' | $client ib > o.ib.scan.$i &
  else
    $client -h127.0.0.1 -uroot -ppw ib -e "select count(*) from pi1 where customerid < 0" > o.ib.scan.$i &
  fi
  pids[${i}]=$!
done

for i in $( seq 1 $ntabs ) ; do
  wait ${pids[${i}]}
done

stop_secs=$( date +%s )
tot_secs=$(( $stop_secs - $start_secs ))
echo "Scan $tot_secs seconds for $ntabs tables" > o.ib.scan

kill $vpid
kill $ipid
mkdir scan
mv o.* scan

