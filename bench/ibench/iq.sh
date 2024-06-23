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
elif [[ $dbms == "mariadb" ]] ; then 
echo Use mariadb 
elif [[ $dbms == "postgres" ]] ; then 
echo Use postgres
else
echo "dbms must be one of: mongo, mysql, mariadb, postgres but was $dbms"
exit -1
fi

if [[ $delete_per_insert == "yes" || $delete_per_insert == "1" ]]; then
  if [[ $only1t == "yes" || $only1t == "1" ]]; then
    echo Cannot enable both delete_per_insert and only1t
    exit -1
  fi
fi

function vac_pg {
  my_nr=$1
  my_ntabs=$2

  # Sleep for 60s + 1s per 1M rows, with a max of 1200s
  sleep_secs=$( echo $my_nr | awk '{ nsecs = ($1 / 1000000) + 60; if (nsecs > 1200) nsecs = 1200; printf "%.0f", nsecs }' )
  echo "pg_vac starts at $( date ) with sleep_secs = $sleep_secs" > o.pgvac
  echo nr is :: $my_nr :: and ntabs is :: $my_ntabs :: >> o.pgvac
  start_secs=$( date +%s )
  done_secs=$(( start_secs + sleep_secs ))

  pga=( -h 127.0.0.1 -U root ib )

  major_version=$( PGPASSWORD="pw" $client "${pga[@]}" ib -x -c 'show server_version_num' | grep server_version_num | awk '{ print $3 }' )
  vac_args="(verbose, analyze)"
  if [[ $major_version -ge 120000 ]]; then
    vac_args="(verbose, analyze, index_cleanup ON)"
  fi
  echo "vac_args is $vac_args" >> o.pgvac

  x=0
  for n in $( seq 1 $my_ntabs ) ; do
    if [[ $npart -eq 0 ]]; then
      PGPASSWORD="pw" $client "${pga[@]}" -x -c "vacuum $vac_args pi${n}" >& o.pgvac.pi${n} &
      vpid[${x}]=$!
      x=$(( $x + 1 ))
    else
      for p in $( seq 0 $(( $npart - 1 )) ); do
        PGPASSWORD="pw" $client "${pga[@]}" -x -c "vacuum $vac_args pi${n}_p${p}" >& o.pgvac.pi${n}.p${p} &
        vpid[${x}]=$!
        x=$(( $x + 1 ))
      done
    fi
  done

  for n in $( seq 0 $(( $x - 1 )) ) ; do
    echo After load: wait for vacuum $n >> o.pgvac
    wait ${vpid[${n}]}
  done

  echo "Checkpoint started at $( date )" >> o.pgvac
  PGPASSWORD="pw" $client "${pga[@]}" -x -c "checkpoint" 2>&1 >> o.pgvac
  echo "Checkpoint done at $( date )" >> o.pgvac

  now_secs=$( date +%s )
  if [[ now_secs -lt done_secs ]]; then
    diff_secs=$(( done_secs - now_secs ))
    echo Sleep $diff_secs >> o.pgvac
    sleep $diff_secs
  fi

  now_secs=$( date +%s )
  diff_secs=$(( now_secs - start_secs ))
  echo "vac_pg done after $diff_secs at $( date )" >> o.pgvac
}

function vac_my {
  # This is optional and can be run after a test step
  # Goals:
  #  1) Flush dirty data (b-tree writeback, LSM compaction), but without shutting down the DBMS
  #  2) Get LSM tree into deterministic state
  #  3) Collect stats

  my_nr=$1
  my_ntabs=$2

  # Sleep for 60s + 1s per 1M rows, with a max of 1200s
  sleep_secs=$( echo $my_nr | awk '{ nsecs = ($1 / 1000000) + 60; if (nsecs > 1200) nsecs = 1200; printf "%.0f", nsecs }' )
  echo "vac_my starts at $( date ) with sleep_secs = $sleep_secs" > o.myvac
  echo nr is :: $my_nr :: and ntabs is :: $my_ntabs :: >> o.myvac
  start_secs=$( date +%s )
  done_secs=$(( start_secs + sleep_secs ))

  mya=( -h127.0.0.1 -uroot -ppw ib )

  # Reduce chance of a full disk
  $client "${mya[@]}" -e 'reset master' 2> /dev/null

  for x in $( seq 1 $my_ntabs ); do
    echo Analyze table pi${x} >> o.myvac
    /usr/bin/time -o o.myvac.time.$x $client "${mya[@]}" -e "analyze table pi${x}" > o.myvac.at.$x 2>&1 &
    apid[${x}]=$!
  done

  if [[ $e == "innodb" ]]; then
    $client "${mya[@]}" -e "show engine innodb status\G" >& o.myvac.es1
    maxDirty=$( $client "${mya[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct"' | awk '{ print $2 }' )
    maxDirtyLwm=$( $client "${mya[@]}" -N -B -e 'show global variables like "innodb_max_dirty_pages_pct_lwm"' | awk '{ print $2 }' )
    # This option is only in 8.0.18+
    idlePct=$( $client "${mya[@]}" -N -B -e 'show global variables like "innodb_idle_flush_pct"' 2> /dev/null | awk '{ print $2 }' )

    echo "Reduce max_dirty to 0 to flush InnoDB buffer pool" >> o.myvac
    $client "${mya[@]}" -e 'set global innodb_max_dirty_pages_pct_lwm=1' >> o.myvac 2>&1
    $client "${mya[@]}" -e 'set global innodb_max_dirty_pages_pct=1' >> o.myvac 2>&1
    echo "Increase idle_pct to 100 to flush InnoDB buffer pool" >> o.myvac
    $client "${mya[@]}" -e 'set global innodb_idle_flush_pct=100' >> o.myvac 2>&1
    $client "${mya[@]}" -e 'show global variables' >> o.myvac.show.1 2>&1

  elif [[ $e == "rocksdb" ]]; then
    echo Enable flush memtable and L0 in 2 parts >> o.myvac
    $client "${mya[@]}" -e "show engine rocksdb status\G" >& o.myvac.es1
    echo "Flush memtable at $( date )" >> o.myvac
    $client "${mya[@]}" -e 'set global rocksdb_force_flush_memtable_now=1' >> o.myvac 2>&1
    sleep 20
    echo "Flush lzero at $( date )" >> o.myvac
    $client "${mya[@]}" -e "show engine rocksdb status\G" >& o.myvac.es2
    # Not safe to use, see issues 1200 and 1295
    #$client "${mya[@]}" -e 'set global rocksdb_force_flush_memtable_and_lzero_now=1' >> o.myvac 2>&1
    # Alas, this only works on releases from mid 2023 or more recent
    $client "${mya[@]}" -e 'set global rocksdb_compact_lzero_now=1' >> o.myvac 2>&1
  fi

  now_secs=$( date +%s )
  if [[ now_secs -lt done_secs ]]; then
    diff_secs=$(( done_secs - now_secs ))
    echo Sleep $diff_secs >> o.myvac
    sleep $diff_secs
  fi

  for x in $( seq 1 $my_ntabs ); do
    echo After load: wait for analyze $n >> o.myvac
    wait ${apid[${x}]}
  done
  echo "Done waiting for analyze" >> o.myvac

  if [[ $e == "innodb" ]]; then
    echo "Reset max_dirty to $maxDirty and lwm to $maxDirtyLwm" >> o.myvac
    $client "${mya[@]}" -e "set global innodb_max_dirty_pages_pct=$maxDirty" >> o.myvac 2>&1
    $client "${mya[@]}" -e "set global innodb_max_dirty_pages_pct_lwm=$maxDirtyLwm" >> o.myvac 2>&1
    echo "Reset idle_pct to $idlePct" >> o.myvac
    $client "${mya[@]}" -e "set global innodb_idle_flush_pct=$idlePct" >> o.myvac 2>&1
    $client "${mya[@]}" -e 'show global variables' >> o.myvac.show.2 2>&1
    $client "${mya[@]}" -e "show engine innodb status\G" >& o.myvac.es3
  elif [[ $e == "rocksdb" ]]; then
    $client "${mya[@]}" -e "show engine rocksdb status\G" >& o.myvac.es3
  fi

  now_secs=$( date +%s )
  diff_secs=$(( now_secs - start_secs ))
  echo "vac_my done after $diff_secs at $( date )" >> o.myvac
}

# if vac >=1 then "clean up" immediately prior to the read-write steps
# no longer supported -- if > 1 then also clean up prior to each read-write step
# "clean up" means
#   if Postgres then do vacuum analyze and sleep for 1s per 1M rows
#   if MySQL with InnoDB then do analyze, reconfigure to trigger writeback, sleep for 1s per 1M rows
#   if MySQL with MyRocks then do analyze, reconfigure to trigger flush and compaction, sleep for 1s per 1M rows
vac=1
ns=3

# insert only without secondary indexes
bash np.sh $nr1 $e "$eo" 0 $client $data  $dop 10 20 0 $dname $only1t $checku 100 0 0 yes $dbms $short $bulk no $dbopt 0 $npart $perpart no >& o.a
mkdir l.i0
mv o.* l.i0

# insert only -- short running, then create indexes
# if 100 (ninserts) is changed then also update perpart computation in rall1.sh
bash np.sh 100 $e "$eo" $ns $client $data  $dop 10 20 0 $dname $only1t $checku 100 0 0 no $dbms $short 0 yes $dbopt $nr1 $npart $perpart no >& o.a
mkdir l.x
mv o.* l.x

# l.i1 does 4/5 of the requested random writes
nr2_50=$( echo $nr2 | awk '{ x = $1 * (4/5); if (x < 1) { x=1 }; printf "%.0f", x }' )

# l.i2 does 1/5 of the requested random writes
nr2_5=$( echo $nr2 | awk '{ x = $1 * (1/5); if (x < 1) { x=1 }; printf "%.0f", x }' )

# insert only with secondary indexes and 50 rows per commit
bash np.sh $nr2_50 $e "$eo" $ns $client $data  $dop 10 20 0 $dname $only1t $checku 50 0 0 no $dbms $short 0 no $dbopt 0 $npart $perpart $delete_per_insert >& o.a
mkdir l.i1
mv o.* l.i1

# insert only with secondary indexes and 5 rows per commit
bash np.sh $nr2_5 $e "$eo" $ns $client $data  $dop 10 20 0 $dname $only1t $checku 5 0 0 no $dbms $short 0 no $dbopt 0 $npart $perpart $delete_per_insert >& o.a
mkdir l.i2
mv o.* l.i2

ntabs=$dop
if [[ $only1t == "yes" ]]; then ntabs=1; fi
sfx=dop${ntabs}

if [[ vac -ge 1 ]] ; then
  if [[ $dbms == "postgres" ]] ; then
    # Vaccum after load & index. Wait for vacuum to finish before starting read-write tests
    vac_pg $nr1 $ntabs
    mv o.* l.i2
  elif [[ $dbms == "mysql" || $dbms == "mariadb" ]]; then
    vac_my $nr1 $ntabs
    mv o.* l.i2
  fi
fi

loop=1
farr=("$@")

for ipsAndpk in "$@"; do
  ips=$( echo $ipsAndpk | tr ":" " " | awk '{ print $1 }' )
  querypk=$( echo $ipsAndpk | tr ":" " " | awk '{ print $2}' )

  if [[ $querypk == "range" ]]; then
    # Run for querysecs seconds regardless of concurrency using range queries on the secondary indexes
    echo Run with ips $ips
    bash np.sh $(( $querysecs * $ips * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 50 $ips 1 no $dbms $short 0 no $dbopt 0 $npart $perpart $delete_per_insert range >& o.a.r
    rdir=qr${ips}.L${loop}
    mkdir $rdir; mv o.* $rdir
  else
    # Run for querysecs seconds regardless of concurrency using point queries on the PK index
    echo Run with ips $ips
    bash np.sh $(( $querysecs * $ips * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 50 $ips 1 no $dbms $short 0 no $dbopt 0 $npart $perpart $delete_per_insert point >& o.a.p
    rdir=qp${ips}.L${loop}
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
