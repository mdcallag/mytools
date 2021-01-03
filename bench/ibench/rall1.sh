dbms_cnf=$1
dop=$2
qsecs=$3
brdir=$4
nr1=$5
nr2=$6
nrt=$7
dev=$8
only1t=$9
# /media/ephemeral1 or /home/mdcallag/d or ???
dbms_pfx=${10}
dbopt=${11}
npart=${12}

shift 12

if [[ $npart -gt 0 ]] ; then
  # Figure out total number of inserts used to determine per-partition ranges
  # This assumes the create index step first inserts 100000
  nins=$( echo $nr1 $nr2 | awk '{ print $1 + $2 + 100000 }' )
  for ips in "$@"; do
    tins=$( echo $ips $qsecs $dop | awk '{ print ($1 * $2 * $3) }' )
    nins=$( echo $nins $tins | awk '{ print ($1 + $2) }' )
    # echo "nins=${nins} with ips=${ips} adding ${tins}"
  done
  # echo "Load inserts: $nins"
  if [[ $only1t == "yes" ]]; then
    ntabs=1
  else
    ntabs=$dop
  fi
  perpart=$( echo $nins $npart $ntabs | awk '{ printf "%.0f", ($1 / $2) / $3 }' )
  ps=part${npart}
else
  perpart=0
  ps=""
fi

dgit=$PWD
dpg12=${dbms_pfx}/pg12
dmy80=${dbms_pfx}/my80
dmy57=${dbms_pfx}/my57
dmy56=${dbms_pfx}/my56
dmyfb56=${dbms_pfx}/fbmy56
dmyfb80=${dbms_pfx}/fbmy80
dmo40=${dbms_pfx}/mo40
dmo42=${dbms_pfx}/mo42
dmo44=${dbms_pfx}/mo44

dbms=$( echo $dbms_cnf | tr '.' ' ' | awk '{ print $1 }' )
cnf=$( echo $dbms_cnf | tr '.' ' ' | awk '{ print $2 }' )
echo Run for dbms=$dbms and cnf=$cnf

function do_rx56 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "myrocks $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=rx.$rmemt.dop$dop.c$cnf
  cd $dmyfb56; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh rocksdb "" $dmyfb56/bin/mysql /data/m/fbmy $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $@ >& a.$sfx; sleep 10
  cd $dmyfb56; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.rx56.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmyfb56/o.ini.* l.i0 l.i1 l.x end q.L* a.$sfx $rdir
  cp $dmyfb56/etc/my.cnf $rdir
}

function do_rx80 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "myrocks $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=rx.$rmemt.dop$dop.c$cnf
  cd $dmyfb80; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh rocksdb "" $dmyfb80/bin/mysql /data/m/fbmy $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $@ >& a.$sfx; sleep 10
  cd $dmyfb80; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.rx80.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmyfb80/o.ini.* l.i0 l.i1 l.x end q.L* a.$sfx $rdir
  cp $dmyfb80/etc/my.cnf $rdir
}

function do_in80 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "innodb $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=in.$rmemt.dop$dop.c$cnf
  cd $dmy80; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh innodb "" $dmy80/bin/mysql /data/m/my $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $@ >& a.$sfx; sleep 10
  cd $dmy80; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.in80.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmy80/o.ini.* l.i0 l.i1 l.x end q.L* a.$sfx $rdir
  cp $dmy80/etc/my.cnf $rdir
}

function do_in57 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "innodb $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=in.$rmemt.dop$dop.c$cnf
  cd $dmy57; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh innodb "" $dmy57/bin/mysql /data/m/my $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $@ >& a.$sfx; sleep 10
  cd $dmy57; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.in57.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmy57/o.ini.* l.i0 l.i1 l.x end q.L* a.$sfx $rdir
  cp $dmy57/etc/my.cnf $rdir
}

function do_in56 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "innodb $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=in.$rmemt.dop$dop.c$cnf
  cd $dmy56; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh innodb "" $dmy56/bin/mysql /data/m/my $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $@ >& a.$sfx; sleep 10
  cd $dmy56; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.in56.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmy56/o.ini.* l.i0 l.i1 l.x end q.L* a.$sfx $rdir
  cp $dmy56/etc/my.cnf $rdir
}

function do_pg12 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  cd $dpg12; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg12/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $@ >& a.$sfx; sleep 10
  cd $dpg12; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg12.c${cnf}${ps}
  mkdir -p $rdir
  mv $dpg12/o.ini.* l.i0 l.i1 l.x end q.L* a.$sfx $rdir
  cp $dpg12/conf.diff $rdir
}

function do_mo40 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "mongo $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=mo.$rmemt.dop$dop.c$cnf
  cd $dmo40; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh wiredtiger "" $dmo40/bin/mongo /data/m/mo $dev 1 $dop mongo yes $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $@ >& a.$sfx; sleep 10
  cd $dmo40; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.mo40.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmo40/o.ini.* l.i0 l.i1 l.x end q.L* a.$sfx $rdir
  cp $dmo40/mongo.conf $rdir
}

function do_mo42 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "mongo $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=mo.$rmemt.dop$dop.c$cnf
  cd $dmo42; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh wiredtiger "" $dmo42/bin/mongo /data/m/mo $dev 1 $dop mongo yes $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $@ >& a.$sfx; sleep 10
  cd $dmo42; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.mo42.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmo42/o.ini.* l.i0 l.i1 l.x end q.L* a.$sfx $rdir
  cp $dmo42/mongo.conf $rdir
}

function do_mo44 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "mongo $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=mo.$rmemt.dop$dop.c$cnf
  cd $dmo44; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh wiredtiger "" $dmo44/bin/mongo /data/m/mo $dev 1 $dop mongo yes $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $@ >& a.$sfx; sleep 10
  cd $dmo44; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.mo44.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmo44/o.ini.* l.i0 l.i1 l.x end q.L* a.$sfx $rdir
  cp $dmo44/mongo.conf $rdir
}

mkdir -p $brdir

if [[ $dbms == "rx56" ]]; then
  do_rx56 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "rx80" ]]; then
  do_rx80 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg12" ]]; then
  do_pg12 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "in80" ]]; then
  do_in80 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "in57" ]]; then
  do_in57 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "in56" ]]; then
  do_in56 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "mo40" ]]; then
  do_mo40 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "mo42" ]]; then
  do_mo42 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "mo44" ]]; then
  do_mo44 $dop $cnf $nrt $nr1 $nr2 $@
fi 

echo Done

