dbms=$1
cnf=$2

dgit=/home/mdcallag/git/mytools/bench/ibench
dpg12=/home/mdcallag/d/pg120
dmy80=/home/mdcallag/d/my8018
dmy57=/home/mdcallag/d/my5729
dmyfb=/home/mdcallag/d/fbmy56
dmo42=/home/mdcallag/d/mo421

qsecs=3600

inmem=5000000
inmemt=5m

iob1=250000000
iobt1=250m

iob2=1000000000
iobt2=1000m

function do_rx {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem=$4

  echo "myrocks $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=rx.$rmemt.dop$dop.c$cnf
  cd $dmyfb; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh rocksdb "" ~/d/fbmy56/bin/mysql /data/m/fbmy/data nvme0n1 1 $dop mysql no no 0 no $rmem no $qsecs >& a.$sfx; sleep 10
  cd $dmyfb; bash down.sh
  cd $dgit
  rdir=${dop}u/$rmemt.rx56.c${cnf}
  mkdir -p $rdir
  mv $dmyfb/o.ini.* l end scan q100 q1000 a.$sfx $rdir
  cp $dmyfb/etc/my.cnf $rdir
}

function do_in80 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem=$4

  echo "innodb $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=in.$rmemt.dop$dop.c$cnf
  cd $dmy80; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh innodb "" ~/d/my8018/bin/mysql /data/m/my/data nvme0n1 1 $dop mysql no no 0 no $rmem no $qsecs >& a.$sfx; sleep 10
  cd $dmy80; bash down.sh
  cd $dgit
  rdir=${dop}u/$rmemt.in80.c${cnf}
  mkdir -p $rdir
  mv $dmy80/o.ini.* l end scan q100 q1000 a.$sfx $rdir
  cp $dmy80/etc/my.cnf $rdir
}

function do_in57 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem=$4

  echo "innodb $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=in.$rmemt.dop$dop.c$cnf
  cd $dmy57; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh innodb "" ~/d/my5729/bin/mysql /data/m/my/data nvme0n1 1 $dop mysql no no 0 no $rmem no $qsecs >& a.$sfx; sleep 10
  cd $dmy57; bash down.sh
  cd $dgit
  rdir=${dop}u/$rmemt.in57.c${cnf}
  mkdir -p $rdir
  mv $dmy57/o.ini.* l end scan q100 q1000 a.$sfx $rdir
  cp $dmy57/etc/my.cnf $rdir
}

function do_pg {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem=$4

  echo "postgres $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=pg.$rmemt.dop$dop.c$cnf
  cd $dpg12; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh pg "" ~/d/pg120/bin/psql /data/m/pg/base nvme0n1 1 $dop postgres no no 0 no $rmem no $qsecs none >& a.$sfx; sleep 10
  cd $dpg12; bash down.sh
  cd $dgit
  rdir=${dop}u/$rmemt.pg12.c${cnf}
  mkdir -p $rdir
  mv $dpg12/o.ini.* l end scan q100 q1000 a.$sfx $rdir
  cp $dpg12/conf.diff $rdir
}

function do_mo42 {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem=$4

  echo "mongo $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=mo.$rmemt.dop$dop.c$cnf
  cd $dmo42; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh wiredtiger "" ~/d/mo421/bin/mongo /data/m/mo/ nvme0n1 1 $dop mongo yes no 0 no $rmem no $qsecs none >& a.$sfx; sleep 10
  cd $dmo42; bash down.sh
  cd $dgit
  rdir=${dop}u/$rmemt.mo42.c${cnf}
  mkdir -p $rdir
  mv $dmo42/o.ini.* l end scan q100 q1000 a.$sfx $rdir
  cp $dmo42/mongo.conf $rdir
}

mkdir 1u
mkdir 2u

# test in-memory
for dop in 1 ; do
  if [[ $dbms == "rx" ]]; then
    do_rx $dop $cnf $inmemt $inmem
  elif [[ $dbms == "pg" ]]; then
    do_pg $dop $cnf $inmemt $inmem
  elif [[ $dbms == "in80" ]]; then
    do_in80 $dop $cnf $inmemt $inmem
  elif [[ $dbms == "in57" ]]; then
    do_in57 $dop $cnf $inmemt $inmem
  elif [[ $dbms == "mo42" ]]; then
    do_mo42 $dop $cnf $inmemt $inmem
  fi  
done

# now test io-bound with dop=1
dop=1
if [[ $dbms == "rx" ]]; then
  do_rx $dop $cnf $iobt1 $iob1
elif [[ $dbms == "pg" ]]; then
  do_pg $dop $cnf $iobt1 $iob1
elif [[ $dbms == "in80" ]]; then
  do_in80 $dop $cnf $iobt1 $iob1
elif [[ $dbms == "in57" ]]; then
  do_in57 $dop $cnf $iobt1 $iob1
elif [[ $dbms == "mo42" ]]; then
  do_mo42 $dop $cnf $iobt1 $iob1
fi  

