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
nr1=${12}
nr2=${13}
querysecs=${14}
# comma separate options specific to the engine, for Mongo can be "journal,transaction" or "transaction"
# should otherwise be "none"
dbopt=${15}

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

# if =1 then only vacuum once, after index create
# if > 1 then vacuum after index create and before each read-write step (except the first)
# vacuum after index create is blocking, others are not
vac=2
ns=3

# insert only without secondary indexes
bash np.sh $nr1 $e "$eo" 0 $client $data  $dop 10 20 0 $dname $only1t $checku 100 0 0 yes $dbms $short $bulk no $dbopt 0 >& o.a
mkdir l.i0
mv o.* l.i0

# insert only -- short running, then create indexes
bash np.sh 100000 $e "$eo" $ns $client $data  $dop 10 20 0 $dname $only1t $checku 100 0 0 no $dbms $short 0 yes $dbopt $nr1 >& o.a
mkdir l.x
mv o.* l.x

# insert only with secondary indexes. Insert 1/10 of what was inserted in the previous step.
bash np.sh $nr2 $e "$eo" $ns $client $data  $dop 10 20 0 $dname $only1t $checku 50 0 0 no $dbms $short 0 no $dbopt 0 >& o.a
mkdir l.i1
mv o.* l.i1

ntabs=$dop
if [[ $only1t == "yes" ]]; then ntabs=1; fi
sfx=dop${ntabs}

if [[ vac -ge 1 && $dbms == "postgres" ]] ; then
  # Vaccum after load & index. Wait for vacuum to finish before starting read-write tests
  pga="-h 127.0.0.1 -U root ib"
  for n in $( seq 1 $ntabs ) ; do
    PGPASSWORD="pw" $client $pga -x -c "vacuum (verbose) pi${n}" >& o.pgvac.pi${n} &
    vpid[${n}]=$!
  done

  for n in $( seq 1 $ntabs ) ; do
    echo After load: wait for vacuum $n
    wait ${vpid[${n}]}
  done
  mv o.pgvac.* l.i1
fi

shift 15

loop=1
farr=("$@")

for ips in "$@"; do
  if [[ vac -gt 1 && $loop -gt 1 && $dbms == "postgres" ]] ; then
    # Vaccum during read-write tests. Do not wait because that would be downtime.
    pga="-h 127.0.0.1 -U root ib"
    for n in $( seq 1 $ntabs ) ; do
      PGPASSWORD="pw" $client $pga -x -c "vacuum (verbose) pi${n}" >& o.pgvac.pi${n} &
    done
    sleep 5
  fi

  # Run for querysecs seconds regardless of concurrency
  echo Run with ips $ips
  bash np.sh $(( $querysecs * $ips * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 50 $ips 1 no $dbms $short 0 no $dbopt 0 >& o.a

  rdir=q.L${loop}.ips${ips}
  mkdir $rdir; mv o.* $rdir
  loop=$(( $loop + 1 ))
done

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
mv o.* l.i0

if [[ $dbms == "mongo" ]] ; then 
  cp -r $data/diagnostic.data l.i0
fi
