
dgit=/home/mdcallag/git/mytools/bench/ibench
dmo42=/home/mdcallag/d/mo421

#TODO
#qsecs=3600
qsecs=30

inmem=5000000
inmemt=5m

#TODO
#iob1=500000000
iob1=6000000
iobt1=500m

#TODO
#iob2=1000000000
iob2=7000000
iobt2=1000m

function do_mo {
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
  mkdir $rdir
  mv $dmo42/o.ini.* l end scan q100 q1000 a.$sfx $rdir
  cp $dmo42/etc/my.cnf $rdir
}

ts=$( date +'%m%d_%H%M%S' )
mv 1u 1u.bak.$ts
mv 2u 2u.bak.$ts
mkdir 1u
mkdir 2u

# echo in-memory
for dop in 1 2; do
for cnf in 1 ; do
  do_mo $dop $cnf $inmemt $inmem
done
done

# now test io-bound with dop=1
dop=1
for cnf in 1 4 ; do
  do_mo $dop $cnf $iobt1 $iob1
done

# now test io-bound with dop=2
dop=2
for cnf in 1 4 5 2 ; do
  do_mo $dop $cnf $iobt2 $iob2
done

