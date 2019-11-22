e=$1
eo=$2
client=$3
data=$4
dname=$5
checku=$6
dop=$7
dbms=$8
short=$9
only1t=${10}
bulk=${11}
secatend=${12}
nr=${13}
scanonly=${14}
# used to be hardwired to 5000 seconds
querysecs=${15}
# comma separate options specific to the engine, for Mongo can be "journal,transaction" or "transaction"
# should otherwise be "none"
dbopt=${16}

if [[ $dbms == "mongo" ]] ; then 
echo Use mongo
elif [[ $dbms == "mysql" ]] ; then 
echo Use mysql
elif [[ $dbms == "postgres" ]] ; then 
echo Use postgres
else
echo "dbms must be one of: mongo, mysql, postgres"
exit -1
fi

ns=3

# insert only
bash np.sh $nr $e "$eo" $ns $client $data  $dop 10 20 0 $dname $only1t $checku 100 0 0 yes $dbms $short $bulk $secatend $dbopt
mkdir l
mv o.* l

# full scan
ntabs=$dop
if [[ $only1t == "yes" ]]; then ntabs=1; fi
sfx=dop${ntabs}.ns${ns}

rm -f o.ib.scan
rm -f o.ib.scan.*

samp=2
for explain in 0 1 ; do
for q in 1 2 3 4 5 ; do

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
    if [[ $dbms == "mongo" ]] ; then 
      echo with explain $explain, ${txtmo[$q]} >> o.ib.scan.$q.$i
      moauth="--authenticationDatabase admin -u root -p pw"
      if [[ $explain -eq 1 ]]; then
        echo ${txtmo[$q]}".explain(\"executionStats\")" | $client $moauth ib >> o.ib.scan.$q.$i &
      else
        echo ${txtmo[$q]} | $client $moauth ib >> o.ib.scan.$q.$i 2>&1 &
      fi
    elif [[ $dbms == "mysql" ]] ; then 
      echo with explain $explain, \"${txtmy[$q]}\" >> o.ib.scan.$q.$i
      if [[ $explain -eq 1 ]]; then
        $client -h127.0.0.1 -uroot -ppw ib -e "explain ${txtmy[$q]}" >> o.ib.scan.$q.$i &
      else
        $client -h127.0.0.1 -uroot -ppw ib -e "${txtmy[$q]}" >> o.ib.scan.$q.$i 2>&1 &
      fi
    elif [[ $dbms == "postgres" ]] ; then 
      echo with explain $explain, \"${txtmy[$q]}\" >> o.ib.scan.$q.$i
      if [[ $explain -eq 1 ]]; then
        PGPASSWORD="pw" $client -h 127.0.0.1 -U root ib -c "explain ${txtmy[$q]}" >> o.ib.scan.$q.$i &
      else
        PGPASSWORD="pw" $client -h 127.0.0.1 -U root ib -c "${txtmy[$q]}" >> o.ib.scan.$q.$i 2>&1 &
      fi
    else
      echo "uknown dbms"
      exit -1
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
  mrps=$( echo "scale=3; $nr / $tot_secs / 1000000.0" | bc )
  echo "Query $q scan $tot_secs seconds, $ntabs tables, $explain explain, $mrps Mrps" >> o.ib.scan

  kill $vpid
  kill $ipid

done
done

mkdir scan
mv o.* scan

if [[ $scanonly == "yes" ]]; then
  exit 0
fi

# Run for querysecs seconds regardless of concurrency
bash np.sh $(( $querysecs * 1000 * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 100 1000 1 no $dbms $short 0 no $dbopt
mkdir q1000
mv o.* q1000

# Run for querysecs seconds regardless of concurrency
bash np.sh $(( $querysecs * 100 * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 100 100 1 no $dbms $short 0 no $dbopt
mkdir q100
mv o.* q100

