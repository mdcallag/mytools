
dgit=/home/mdcallag/git/mytools/bench/ibench
dpg12=/home/mdcallag/d/pg120
dmy8=/home/mdcallag/d/my8018
dmyfb=/home/mdcallag/d/fbmysql56

qsecs=3600

inmem=5000000
inmemt=5m

iob1=500000000
iobt1=500m

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
  cd $dgit; bash iq.sh rocksdb "" ~/d/fbmysql56/bin/mysql /data/m/fbmy/data nvme0n1 1 $dop mysql no no 0 no $rmem no $qsecs >& a.$sfx; sleep 10
  cd $dmyfb; bash down.sh
  cd $dgit
  rdir=${dop}u/$rmemt.rx56.c${cnf}
  mkdir $rdir
  mv $dmyfb/o.ini.* l end scan q100 q1000 a.$sfx $rdir
  cp $dmyfb/etc/my.cnf $rdir
}

function do_in {
  dop=$1
  cnf=$2
  rmemt=$3
  rmem=$4

  echo "innodb $rmemt, dop $dop, conf $cnf at $( date )"
  sfx=in.$rmemt.dop$dop.c$cnf
  cd $dmy8; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash iq.sh innodb "" ~/d/my8018/bin/mysql /data/m/my/data nvme0n1 1 $dop mysql no no 0 no $rmem no $qsecs >& a.$sfx; sleep 10
  cd $dmy8; bash down.sh
  cd $dgit
  rdir=${dop}u/$rmemt.in80.c${cnf}
  mkdir $rdir
  mv $dmy8/o.ini.* l end scan q100 q1000 a.$sfx $rdir
  cp $dmy8/etc/my.cnf $rdir
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
  mkdir $rdir
  mv $dpg12/o.ini.* l end scan q100 q1000 a.$sfx $rdir
  cp $dpg12/conf.diff $rdir
}

# test in-memory
for dop in 1 2; do
for cnf in 1 3 5 ; do
  do_rx $dop $cnf $inmemt $inmem
done
done

for dop in 1 2; do
for cnf in 8 ; do
  do_in $dop $cnf $inmemt $inmem
done
done

for dop in 1 2; do
for cnf in 5 ; do
  do_pg $dop $cnf $inmemt $inmem
done
done

# now test io-bound with dop=1
dop=1
for cnf in 1 2 3 4 5 ; do
  do_rx $dop $cnf $iobt1 $iob1
done

for cnf in 8 ; do
  do_in $dop $cnf $iobt1 $iob1
done

for cnf in 5 ; do
  do_pg $dop $cnf $iobt1 $iob1
done

# now test io-bound with dop=2
dop=2
for cnf in 1 2 3 4 5 6 ; do
  do_rx $dop $cnf $iobt2 $iob2
done

for cnf in 8 ; do
  do_in $dop $cnf $iobt2 $iob2
done

for cnf in 5 ; do
  do_pg $dop $cnf $iobt2 $iob2
done

