maxid=$1
dname=$2
wdop=$3
secs=$4
dbhost=$5
ldop=$6
dbms_cnf=$7
# then DOP for queries as sequence of 1+ integers

dgit=/home/mdcallag/git/mytools/bench/run_linkbench
dpg12=/home/mdcallag/d/pg120
dmy8=/home/mdcallag/d/my8018
dmyfb=/home/mdcallag/d/fbmysql56
dmo42=/home/mdcallag/d/mo421

function do_rx {
  cnf=$1
  shift 1

  echo "myrocks conf $cnf at $( date )"
  sfx=rx.c$cnf
  cd $dmyfb; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh rx56 ~/d/fbmysql56/bin/mysql /data/m/fbmy $maxid $dname $wdop $secs mysql lb.myrocks $dbhost $ldop $@ >& a.$sfx; sleep 10
  cd $dmyfb; bash down.sh
  cd $dgit
  rdir=a.rx56.c${cnf}
  mkdir $rdir
  mv $dmyfb/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmyfb/etc/my.cnf $rdir
}

function do_in {
  cnf=$1
  shift 1

  echo "innodb conf $cnf at $( date )"
  sfx=in.c$cnf
  cd $dmy8; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh in80 ~/d/my8018/bin/mysql /data/m/my/data $maxid $dname $wdop $secs mysql lb.innodb $dbhost $ldop $@ >& a.$sfx; sleep 10
  cd $dmy8; bash down.sh
  cd $dgit
  rdir=a.in80.c${cnf}
  mkdir $rdir
  mv $dmy8/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmy8/etc/my.cnf $rdir
}

function do_pg {
  cnf=$1
  shift 1

  echo "postgres conf $cnf at $( date )"
  sfx=pg.c$cnf
  cd $dpg12; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh pg12 ~/d/pg120/bin/psql /data/m/pg/base $maxid $dname $wdop $secs postgres lb.postgres $dbhost $ldop $@ >& a.$sfx; sleep 10
  cd $dpg12; bash down.sh
  cd $dgit
  rdir=a.pg12.c${cnf}
  mkdir $rdir
  mv $dpg12/o.ini.* l.* r.* a.$sfx $rdir
  cp $dpg12/conf.diff $rdir
}

function do_mo {
  cnf=$1
  shift 1

  echo "mongo conf $cnf at $( date )"
  sfx=mo.c$cnf
  cd $dmo42; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh mo42 ~/d/mo421/bin/mongo /data/m/mo $maxid $dname $wdop $secs mongo lb.mongo $dbhost $ldop $@ >& a.$sfx; sleep 10
  cd $dmo42; bash down.sh
  cd $dgit
  rdir=a.mo42.c${cnf}
  mkdir $rdir
  mv $dmo42/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmo42/mongo.conf $rdir
}

dbms=$( echo $dbms_cnf | tr '.' ' ' | awk '{ print $1 }' )
cnf=$( echo $dbms_cnf | tr '.' ' ' | awk '{ print $2 }' )
echo Run for dbms=$dbms and cnf=$cnf

shift 7

if [[ $dbms = "rx" ]]; then
  do_rx $cnf $@
elif  [[ $dbms = "in" ]]; then
  do_in $cnf $@
elif [[ $dbms = "pg" ]]; then
  do_pg $cnf $@
elif [[ $dbms = "mo" ]]; then
  do_mo $cnf $@
fi

