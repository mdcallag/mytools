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
sfx=dop${ntabs}.ns${ns}

killall vmstat
killall iostat
vmstat 10 >& o.vm.$sfx &
vpid=$!
iostat -kx 10 >& o.io.$sfx &
ipid=$!

rm -f o.ib.scan
for q in 1 2 3 4 ; do
  start_secs=$( date +%s )
  for i in $( seq 1 $ntabs ) ; do

    txtmo[1]="db.pi$i.find"'({ customerid : { $lt : 0 } }, { _id:1, data:1, customerid:1})'
    txtmo[2]="db.pi$i.find"'({ customerid : { $lt : 0 } }, { _id:-1, price:1, customerid:1}).sort({price:1, customerid:1})'
    txtmo[3]="db.pi$i.find"'({ customerid : { $lt : 0 } }, { _id:-1, cashregisterid:1, price:1, customerid:1}).sort({cashregisterid:1, price:1, customerid:1})'
    txtmo[4]="db.pi$i.find"'({ customerid : { $lt : 0 } }, { _id:-1, price:1, dateandtime:1, customerid:1}).sort({price:1, dateandtime:1, customerid:1})'

    txtmy[1]="select transactionid,data,customerid from pi$i where customerid < 0"
    txtmy[2]="select price,customerid from pi$i where customerid < 0 order by price,customerid"
    txtmy[3]="select cashregisterid,price,customerid from pi$i where customerid < 0 order by cashregisterid,price,customerid"
    txtmy[4]="select price,dateandtime,customerid from pi$i where customerid < 0 order by price,dateandtime,customerid"

    if [[ $mongo == "yes" ]] ; then 
      echo ${txtmo[$q]}".explain()" | $client ib > o.ib.scan.$q.$i
      echo ${txtmo[$q]}
      echo ${txtmo[$q]} | $client ib >> o.ib.scan.$q.$i 2>&1 &
    else
      $client -h127.0.0.1 -uroot -ppw ib -e "explain ${txtmy[$q]}" > o.ib.scan.$q.$i 
      echo \"${txtmy[$q]}\"
      $client -h127.0.0.1 -uroot -ppw ib -e "${txtmy[$q]}" >> o.ib.scan.$q.$i 2>&1 &
    fi
    pids[${i}]=$!
  done

  for i in $( seq 1 $ntabs ) ; do
    wait ${pids[${i}]}
  done

  stop_secs=$( date +%s )
  tot_secs=$(( $stop_secs - $start_secs ))
  echo "Query $q scan $tot_secs seconds for $ntabs tables" >> o.ib.scan

done

kill $vpid
kill $ipid

mkdir scan
mv o.* scan

# Run for 5000 seconds regardless of concurrency
bash np.sh $(( 5000000 * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 100 1000 1 no $mongo $short 0 no
mkdir q1000
mv o.* q1000

# Run for 5000 seconds regardless of concurrency
bash np.sh $(( 500000 * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 100 100 1 no $mongo $short 0 no
mkdir q100
mv o.* q100

