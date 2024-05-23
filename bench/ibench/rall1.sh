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
delete_per_insert=${13}

shift 13

if [[ $npart -gt 0 ]] ; then
  # Figure out total number of inserts used to determine per-partition ranges
  # This assumes the create index step first inserts 100
  nins=$( echo $nr1 $nr2 | awk '{ print $1 + $2 + 100 }' )
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
dpg9=${dbms_pfx}/pg9
dpg10=${dbms_pfx}/pg10
dpg11=${dbms_pfx}/pg11
dpg12=${dbms_pfx}/pg12
dpg13=${dbms_pfx}/pg13
dpg14=${dbms_pfx}/pg14
dpg15=${dbms_pfx}/pg15
dpg16=${dbms_pfx}/pg16
dpg17=${dbms_pfx}/pg17
dmy80=${dbms_pfx}/my80
dmy57=${dbms_pfx}/my57
dmy56=${dbms_pfx}/my56
dma11=${dbms_pfx}/ma11
dma10=${dbms_pfx}/ma10
dma10old=${dbms_pfx}/ma10old
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
  cd $dgit; bash iq.sh rocksdb "" $dmyfb56/bin/mysql /data/m/fbmy $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dmyfb56; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.rx56.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmyfb56/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
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
  cd $dgit; bash iq.sh rocksdb "" $dmyfb80/bin/mysql /data/m/fbmy $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.rx80.c${cnf}${ps}
  mkdir -p $rdir
  echo "cp /data/m/fbmy/data/.rocksdb/LOG* $rdir"
  ls /data/m/fbmy/data/.rocksdb/LOG*
  cp /data/m/fbmy/data/.rocksdb/LOG* $rdir
  cp /data/m/fbmy/slow.log $rdir
  cd $dmyfb80; bash down.sh; cd $dgit
  mv $dmyfb80/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
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
  cd $dgit; bash iq.sh innodb "" $dmy80/bin/mysql /data/m/my $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dmy80; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.in80.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmy80/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
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
  cd $dgit; bash iq.sh innodb "" $dmy57/bin/mysql /data/m/my $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dmy57; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.in57.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmy57/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
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
  cd $dgit; bash iq.sh innodb "" $dmy56/bin/mysql /data/m/my $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dmy56; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.in56.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmy56/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dmy56/etc/my.cnf $rdir
}

function do_ma11 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "innodb $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=in.$rmemt.dop$dop.c$cnf
  cd $dma11; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh innodb "" $dma11/bin/mariadb /data/m/my $dev 1 $dop mariadb no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dma11; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.ma11.c${cnf}${ps}
  mkdir -p $rdir
  mv $dma11/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dma11/etc/my.cnf $rdir
}

function do_ma10 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "innodb $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=in.$rmemt.dop$dop.c$cnf
  cd $dma10; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh innodb "" $dma10/bin/mariadb /data/m/my $dev 1 $dop mariadb no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dma10; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.ma10.c${cnf}${ps}
  mkdir -p $rdir
  mv $dma10/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dma10/etc/my.cnf $rdir
}

function do_ma10old {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "innodb $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=in.$rmemt.dop$dop.c$cnf
  cd $dma10old; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh innodb "" $dma10old/bin/mysql /data/m/my $dev 1 $dop mysql no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dma10old; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.ma10.c${cnf}${ps}
  mkdir -p $rdir
  mv $dma10old/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dma10old/etc/my.cnf $rdir
}

function do_pg9 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg9.c${cnf}${ps}
  mkdir -p $rdir
  cd $dpg9; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg9/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cp $dpg9/logfile $rdir
  cd $dpg9; bash down.sh; cd $dgit
  mv $dpg9/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dpg9/conf.diff $rdir
}

function do_pg10 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg10.c${cnf}${ps}
  mkdir -p $rdir
  cd $dpg10; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg10/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cp $dpg10/logfile $rdir
  cd $dpg10; bash down.sh; cd $dgit
  mv $dpg10/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dpg10/conf.diff $rdir
}

function do_pg11 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg11.c${cnf}${ps}
  mkdir -p $rdir
  cd $dpg11; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg11/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cp $dpg11/logfile $rdir
  cd $dpg11; bash down.sh; cd $dgit
  mv $dpg11/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dpg11/conf.diff $rdir
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
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg12.c${cnf}${ps}
  mkdir -p $rdir
  cd $dpg12; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg12/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cp $dpg12/logfile $rdir
  cd $dpg12; bash down.sh; cd $dgit
  mv $dpg12/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dpg12/conf.diff $rdir
}

function do_pg13 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg13.c${cnf}${ps}
  mkdir -p $rdir
  cd $dpg13; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg13/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cp $dpg13/logfile $rdir
  cd $dpg13; bash down.sh; cd $dgit
  mv $dpg13/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dpg13/conf.diff $rdir
}

function do_pg14 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg14.c${cnf}${ps}
  mkdir -p $rdir
  cd $dpg14; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg14/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cp $dpg14/logfile $rdir
  cd $dpg14; bash down.sh; cd $dgit
  mv $dpg14/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dpg14/conf.diff $rdir
}

function do_pg15 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg15.c${cnf}${ps}
  mkdir -p $rdir
  cd $dpg15; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg15/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cp $dpg15/logfile $rdir
  cd $dpg15; bash down.sh; cd $dgit
  mv $dpg15/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dpg15/conf.diff $rdir
}

function do_pg16 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg16.c${cnf}${ps}
  mkdir -p $rdir
  cd $dpg16; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg16/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cp $dpg16/logfile $rdir
  cd $dpg16; bash down.sh; cd $dgit
  mv $dpg16/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dpg16/conf.diff $rdir
}

function do_pg17 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem1=$4
  rmem2=$5
  shift 5

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.pg17.c${cnf}${ps}
  mkdir -p $rdir
  cd $dpg17; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" $dpg17/bin/psql /data/m/pg $dev 1 $dop postgres no $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cp $dpg17/logfile $rdir
  cd $dpg17; bash down.sh; cd $dgit
  mv $dpg17/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dpg17/conf.diff $rdir
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
  cd $dgit; bash iq.sh wiredtiger "" $dmo40/bin/mongo /data/m/mo $dev 1 $dop mongo yes $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dmo40; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.mo40.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmo40/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
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
  cd $dgit; bash iq.sh wiredtiger "" $dmo42/bin/mongo /data/m/mo $dev 1 $dop mongo yes $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dmo42; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.mo42.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmo42/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
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
  cd $dgit; bash iq.sh wiredtiger "" $dmo44/bin/mongo /data/m/mo $dev 1 $dop mongo yes $only1t 0 $rmem1 $rmem2 $qsecs $dbopt $npart $perpart $delete_per_insert $@ >& a.$sfx; sleep 10
  cd $dmo44; bash down.sh; cd $dgit
  rdir=${brdir}/${dop}u.1t${only1t}/$rmemt.mo44.c${cnf}${ps}
  mkdir -p $rdir
  mv $dmo44/o.ini.* l.i0 l.i1 l.i2 l.x end qr*.L* qp*.L* a.$sfx $rdir
  cp $dmo44/mongo.conf $rdir
}

mkdir -p $brdir

if [[ $dbms == "rx56" ]]; then
  do_rx56 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "rx80" ]]; then
  do_rx80 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg9" ]]; then
  do_pg9 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg10" ]]; then
  do_pg10 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg11" ]]; then
  do_pg11 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg12" ]]; then
  do_pg12 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg13" ]]; then
  do_pg13 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg14" ]]; then
  do_pg14 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg15" ]]; then
  do_pg15 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg16" ]]; then
  do_pg16 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "pg17" ]]; then
  do_pg17 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "in80" ]]; then
  do_in80 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "in57" ]]; then
  do_in57 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "in56" ]]; then
  do_in56 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "ma11" ]]; then
  do_ma11 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "ma10" ]]; then
  do_ma10 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "ma10old" ]]; then
  do_ma10old $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "mo40" ]]; then
  do_mo40 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "mo42" ]]; then
  do_mo42 $dop $cnf $nrt $nr1 $nr2 $@
elif [[ $dbms == "mo44" ]]; then
  do_mo44 $dop $cnf $nrt $nr1 $nr2 $@
fi 

echo Done

