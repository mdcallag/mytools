fn=$1
client=$2
ddir=$3
maxid=$4
dname=$5
wdop=$6
secs=$7
dbms=$8
ddl=$9
dbhost=${10}
ldop=${11}
heap=${12}

vac=1

echo Load at $( date )
bash load.sh $fn $client $ddir $maxid $dname $ldop true $dbms $ddl $dbhost $heap

if [[ $vac -eq 1 && $dbms == "postgres" ]]; then
  loop=1
  for t in linktable counttable nodetable ; do
    $client linkbench -x -c "vacuum (verbose) linkdb0.$t" >& r.pgvac.$fn.INI.$t &
    vpid[${loop}]=$!
    loop=$(( $loop + 1 ))
    sleep 1
  done

  for n in 1 2 3 ; do
    echo After load: wait for vacuum $n
    wait ${vpid[${n}]}
  done
fi

# Warmup
echo Warmup at $( date )
bash run.sh $fn.W.P${wdop} $client $ddir $maxid $dname $wdop $secs $dbms $dbhost $heap

shift 12

loop=1
if [[ $# -gt 0 ]]; then
  doparr=( "$@" )

  for mydop in "${doparr[@]}" ; do

    if [[ $vac -eq 1 && $dbms == "postgres" ]]; then
      for t in linktable counttable nodetable ; do
        $client linkbench -x -c "vacuum (verbose, skip_locked) linkdb0.$t" >& r.pgvac.$fn.L${loop}.P${mydop}.$t &
        sleep 1
      done
    fi

    echo Run dop=$mydop at $( date )
    bash run.sh $fn.L${loop}.P${mydop} $client $ddir $maxid $dname $mydop $secs $dbms $dbhost $heap
    loop=$(( $loop + 1 ))
  done
fi

if [[ $dbms == "mongo" ]]; then
  echo TODO add MongoDB count validation
  cp -r $ddir/diagnostic.data l.diag.data.$fn

elif [[ $dbms == "mysql" ]]; then
  $client -uroot -ppw -A -h${dbhost} -e 'select id, ltagg.lid, link_type, count, ltagg.lct as cct from counttable ct left join (select id1 as lid, link_type as llt, count(*) as lct from linktable where visibility=1 group by id1, link_type) ltagg on ct.id = ltagg.lid and ct.link_type = ltagg.llt where ltagg.lct != count' >& r.validate1.$fn
  $client -uroot -ppw -A -h${dbhost} -e 'select id, ltagg.lid, link_type, count, ltagg.lct as cct from counttable ct right join (select id1 as lid, link_type as llt, count(*) as lct from linktable where visibility=1 group by id1, link_type) ltagg on ct.id = ltagg.lid and ct.link_type = ltagg.llt where ltagg.lct != count' >& r.validate2.$fn
elif [[ $dbms == "postgres" ]]; then
  pgauth="--host 127.0.0.1"
  $client linkbench $pgauth -x -c 'select id, ltagg.lid, link_type, count, ltagg.lct as cct from counttable ct left join (select id1 as lid, link_type as llt, count(*) as lct from linktable where visibility=1 group by id1, link_type) ltagg on ct.id = ltagg.lid and ct.link_type = ltagg.llt where ltagg.lct != count' >& r.validate1.$fn
  $client linkbench $pgauth -x -c 'select id, ltagg.lid, link_type, count, ltagg.lct as cct from counttable ct right join (select id1 as lid, link_type as llt, count(*) as lct from linktable where visibility=1 group by id1, link_type) ltagg on ct.id = ltagg.lid and ct.link_type = ltagg.llt where ltagg.lct != count' >& r.validate2.$fn
else
  echo DBMS $dbms not supported
fi

