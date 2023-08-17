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
npart=${16}
perpart=${17}
delete_per_insert=${18}

shift 18

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

if [[ $delete_per_insert == "yes" || $delete_per_insert == "1" ]]; then
  if [[ $only1t == "yes" || $only1t == "1" ]]; then
    echo Cannot enable both delete_per_insert and only1t
    exit -1
  fi
fi

function vac_all {
  blocking=$1

  pga="-h 127.0.0.1 -U root ib"
  x=0
  for n in $( seq 1 $ntabs ) ; do
    if [[ $npart -eq 0 ]]; then
      PGPASSWORD="pw" $client $pga -x -c "vacuum (verbose) pi${n}" >& o.pgvac.pi${n} &
      vpid[${x}]=$!
      x=$(( $x + 1 ))
    else
      for p in $( seq 0 $(( $npart - 1 )) ); do
        PGPASSWORD="pw" $client $pga -x -c "vacuum (verbose) pi${n}_p${p}" >& o.pgvac.pi${n}.p${p} &
        vpid[${x}]=$!
        x=$(( $x + 1 ))
      done
    fi
  done

  if [[ $blocking -eq 1 ]]; then
    for n in $( seq 0 $(( $x - 1 )) ) ; do
      echo After load: wait for vacuum $n
      wait ${vpid[${n}]}
    done
  fi
}

# if =1 then only vacuum once, after index create
# if > 1 then vacuum after index create and before each read-write step (except the first)
# vacuum after index create is blocking, others are not
vac=2
ns=3

# insert only without secondary indexes
bash np.sh $nr1 $e "$eo" 0 $client $data  $dop 10 20 0 $dname $only1t $checku 100 0 0 yes $dbms $short $bulk no $dbopt 0 $npart $perpart no >& o.a
mkdir l.i0
mv o.* l.i0

# insert only -- short running, then create indexes
# if 100000 (ninserts) is changed then also update perpart computation in rall1.sh
bash np.sh 100000 $e "$eo" $ns $client $data  $dop 10 20 0 $dname $only1t $checku 100 0 0 no $dbms $short 0 yes $dbopt $nr1 $npart $perpart no >& o.a
mkdir l.x
mv o.* l.x

# insert only with secondary indexes
bash np.sh $nr2 $e "$eo" $ns $client $data  $dop 10 20 0 $dname $only1t $checku 50 0 0 no $dbms $short 0 no $dbopt 0 $npart $perpart $delete_per_insert >& o.a
mkdir l.i1
mv o.* l.i1

ntabs=$dop
if [[ $only1t == "yes" ]]; then ntabs=1; fi
sfx=dop${ntabs}

if [[ vac -ge 1 && $dbms == "postgres" ]] ; then
  # Vaccum after load & index. Wait for vacuum to finish before starting read-write tests
  vac_all 1
  mv o.pgvac.* l.i1
fi

loop=1
farr=("$@")

for ipsAndpk in "$@"; do
  ips=$( echo $ipsAndpk | tr ":" " " | awk '{ print $1 }' )
  querypk=$( echo $ipsAndpk | tr ":" " " | awk '{ print $2}' )

  # TODO - assume autovac is sufficient
  # if [[ vac -gt 1 && $loop -gt 1 && $dbms == "postgres" ]] ; then
  # Don't wait for vacuum to finish
  #  vac_all 0
  #  sleep 5
  # fi

  # TODO - assume autovac is sufficient
  # if [[ vac -gt 1 && $loop -gt 1 && $dbms == "postgres" ]] ; then
  # Vaccum during read-write tests. Do not wait because that would be downtime.
  #  pga="-h 127.0.0.1 -U root ib"
  #  for n in $( seq 1 $ntabs ) ; do
  #    PGPASSWORD="pw" $client $pga -x -c "vacuum (verbose) pi${n}" >& o.pgvac.pi${n} &
  #  done
  #  sleep 5
  # fi

  if [[ $querypk == "range" ]]; then
    # Run for querysecs seconds regardless of concurrency using range queries on the secondary indexes
    echo Run with ips $ips
    bash np.sh $(( $querysecs * $ips * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 50 $ips 1 no $dbms $short 0 no $dbopt 0 $npart $perpart $delete_per_insert range >& o.a.r
    rdir=r.L${loop}.ips${ips}
    mkdir $rdir; mv o.* $rdir
  else
    # Run for querysecs seconds regardless of concurrency using point queries on the PK index
    echo Run with ips $ips
    bash np.sh $(( $querysecs * $ips * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 50 $ips 1 no $dbms $short 0 no $dbopt 0 $npart $perpart $delete_per_insert point >& o.a.p
    rdir=p.L${loop}.ips${ips}
    mkdir $rdir; mv o.* $rdir
  fi

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
