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
  iostat -y -kx $samp >& o.io.$sfx.q$q.e${explain} &
  ipid=$!

  if [[ $dbms == "mongo" ]]; then
    echo "no need to reset MongoDB replication as oplog is capped"
    while :; do ps aux | grep mongod | grep "\-\-config" | grep -v grep; sleep 5; done >& o.ps.$sfx &
    spid=$!
  elif [[ $dbms == "mysql" ]]; then
    $client -uroot -ppw -A -h127.0.0.1 -e 'reset master'
    while :; do ps aux | grep mysqld | grep basedir | grep datadir | grep -v mysqld_safe | grep -v grep; sleep 5; done >& o.ps.$sfx &
    spid=$!
  elif [[ $dbms == "postgres" ]]; then
    # TODO postgres
    echo "TODO: reset Postgres replication"
    while :; do ps aux | grep postgres | grep -v grep; sleep 5; done >& o.ps.$sfx &
    spid=$!
  fi

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

  pmrows=$( echo "scale=0; $nr / 1000000.0" | bc )
  if [[ $explain -eq 0 ]]; then
    bash an.sh o.io.$sfx.q$q.e0 o.vm.$sfx.q$q.e0 $samp $dname $nr > o.ib.scan.met.q$q
  fi

  stop_secs=$( date +%s )
  tot_secs=$(( $stop_secs - $start_secs ))
  tot_secs2=$tot_secs
  if [[ $tot_secs2 -eq 0 ]]; then tot_secs2=1; fi
  mper=$( echo "scale=3; $nr / 1000000.0  / $tot_secs2 / $ntabs" | bc | awk '{ printf "%0.3f", $1 }' )
  mtot=$( echo "scale=3; $nr / 1000000.0 / $tot_secs2"           | bc | awk '{ printf "%0.3f", $1 }' )
  echo "Query $q scan $tot_secs seconds, $ntabs tables, $explain explain, $mper Mrps_per, $mtot Mrps_tot, $pmrows Mrows" >> o.ib.scan

  kill $vpid
  kill $ipid
  kill $spid

done
done

mkdir scan
mv o.* scan

if [[ $scanonly == "yes" ]]; then
  if [[ $dbms == "mongo" ]] ; then 
    cp -r $data/diagnostic.data l
  fi
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

mkdir end

if [[ $dbms == "postgres" ]] ; then 
pga="-h 127.0.0.1 -U root ib"
echo "pi1_pkey" > o.pgsi
PGPASSWORD="pw" $client $pga -x -c "select * from pgstatindex('pi1_pkey')" >> o.pgsi
echo "pi1_pdc" >> o.pgsi
PGPASSWORD="pw" $client $pga -x -c "select * from pgstatindex('pi1_pdc')" >> o.pgsi
echo "pi1_marketsegment" >> o.pgsi
PGPASSWORD="pw" $client $pga -x -c "select * from pgstatindex('pi1_marketsegment')" >> o.pgsi
echo "pi1_registersegment" >> o.pgsi
PGPASSWORD="pw" $client $pga -x -c "select * from pgstatindex('pi1_registersegment')" >> o.pgsi
mv o.pgsi end

echo "pi1" > o.pgst
PGPASSWORD="pw" $client $pga -x -c "select * from pgstattuple('pi1')" >> o.pgst
mv o.pgst end
fi

rm -f o.linux o.mount o.sysblock.$dname o.sysvm
touch o.linux o.mount o.sysblock.$dname o.sysvm

for d in \
/proc/sys/vm/dirty_background_ratio \
/proc/sys/vm/dirty_ratio \
/proc/sys/vm/dirty_expire_centisecs \
/sys/block/${dname}/queue/read_ahead_kb ; do
  v=$( cat $d )
  printf "%s\t\t%s\n" "$v" $d >> o.linux
done

for d in /sys/block/${dname}/queue/* ; do
  v=$( cat $d )
  printf "%s\t\t%s\n" "$v" $d >> o.sysblock.$dname
done

for d in /proc/sys/vm/* ; do
  v=$( cat $d )
  printf "%s\t\t%s\n" "$v" $d >> o.sysvm
done

mount -v > o.mount
mv o.* l

if [[ $dbms == "mongo" ]] ; then 
  cp -r $data/diagnostic.data l
fi
