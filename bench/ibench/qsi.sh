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
q=${14}
ns=3

# full scan
ntabs=$dop
if [[ $only1t == "yes" ]]; then ntabs=1; fi
sfx=dop${ntabs}.ns${ns}

samp=2
explain=0

  killall vmstat
  killall iostat
  vmstat $samp >& o.vm.$sfx.q$q.e${explain} &
  vpid=$!
  iostat -kx $samp >& o.io.$sfx.q$q.e${explain} &
  ipid=$!

  start_secs=$( date +%s )
  for i in $( seq 1 $ntabs ) ; do

    txtmo[1]="db.pi$i.find"'({ data : { $eq : "" } }, { _id:1, data:1, customerid:1})'
    txtmo[2]="db.pi$i.find"'({ price : { $gte : 0 }, customerid : { $lt : 0 } }, { _id:0, price:1, customerid:1}).sort({price:1, customerid:1})'
    txtmo[3]="db.pi$i.find"'({ cashregisterid : { $gte : 0 }, customerid : { $lt : 0 } }, { _id:0, cashregisterid:1, price:1, customerid:1}).sort({cashregisterid:1, price:1, customerid:1})'
    txtmo[4]="db.pi$i.find"'({ price : { $gte : 0 }, customerid : { $lt : 0 } }, { _id:0, price:1, dateandtime:1, customerid:1}).sort({price:1, dateandtime:1, customerid:1})'
    txtmo[5]="db.pi$i.find"'({ data : { $eq : "" } }, { _id:1, data:1, customerid:1})'

    txtmy[1]="select transactionid,data,customerid from pi$i where customerid < 0"
    txtmy[2]="select price,customerid from pi$i where price >= 0 and customerid < 0 order by price,customerid"
    txtmy[3]="select cashregisterid,price,customerid from pi$i where cashregisterid >= 0 and customerid < 0 order by cashregisterid,price,customerid"
    txtmy[4]="select price,dateandtime,customerid from pi$i where price >= 0 and customerid < 0 order by price,dateandtime,customerid"
    txtmy[5]="select transactionid,data,customerid from pi$i where customerid < 0"

    # Explain after running the query. Don't want explain time counted in query time.
    if [[ $mongo == "yes" ]] ; then 
      echo with explain $explain, ${txtmo[$q]}
      if [[ $explain -eq 1 ]]; then
        echo ${txtmo[$q]}".explain()" | $client ib >> o.ib.scan.$q.$i &
      else
        echo ${txtmo[$q]} | $client ib >> o.ib.scan.$q.$i 2>&1 &
      fi
    else
      echo with explain $explain, \"${txtmy[$q]}\" 
      if [[ $explain -eq 1 ]]; then
        $client -h127.0.0.1 -uroot -ppw ib -e "explain ${txtmy[$q]}" >> o.ib.scan.$q.$i &
      else
        $client -h127.0.0.1 -uroot -ppw ib -e "${txtmy[$q]}" >> o.ib.scan.$q.$i 2>&1 &
      fi
    fi
    pids[${i}]=$!
  done

  for i in $( seq 1 $ntabs ) ; do
    wait ${pids[${i}]}
  done

  if [[ $explain -eq 0 ]]; then
    bash an.sh o.io.$sfx.q$q.e0 o.vm.$sfx.q$q.e0 $samp $dname $nr > o.ib.scan.met.q$q
  fi

  stop_secs=$( date +%s )
  tot_secs=$(( $stop_secs - $start_secs ))
  echo "Query $q scan $tot_secs seconds for $ntabs tables and explain $explain" >> o.ib.scan

  kill $vpid
  kill $ipid

