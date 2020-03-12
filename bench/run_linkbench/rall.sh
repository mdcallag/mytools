maxid=$1
dname=$2
wdop=$3
secs=$4
dbhost=$5
ldop=$6
dbms_cnf=$7
up=$8
# then DOP for queries as sequence of 1+ integers

dgit=/home/mdcallag/git/mytools/bench/run_linkbench
dpg12=/home/mdcallag/d/pg12
dmy80=/home/mdcallag/d/my80
dmy57=/home/mdcallag/d/my57
dmy56=/home/mdcallag/d/my56
dmyfb=/home/mdcallag/d/fbmy56
dmo40=/home/mdcallag/d/mo40
dmo42=/home/mdcallag/d/mo42
dmo44=/home/mdcallag/d/mo44

function do_rx56 {
  cnf=$1
  shift 1

  echo "myrocks conf $cnf at $( date )"
  sfx=rx.c$cnf
  cd $dmyfb; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh rx56 ~/d/fbmy56/bin/mysql /data/m/fbmy $maxid $dname $wdop $secs mysql lb.myrocks $dbhost $ldop $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmyfb; bash down.sh; cd $dgit
  fi
  rdir=a.rx56.c${cnf}
  mkdir $rdir
  mv $dmyfb/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmyfb/etc/my.cnf $rdir
}

function do_in80 {
  cnf=$1
  shift 1

  echo "innodb conf $cnf at $( date )"
  sfx=in.c$cnf
  cd $dmy80; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh in80 ~/d/my80/bin/mysql /data/m/my/data $maxid $dname $wdop $secs mysql lb.innodb $dbhost $ldop $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmy80; bash down.sh; cd $dgit
  fi
  rdir=a.in80.c${cnf}
  mkdir $rdir
  mv $dmy80/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmy80/etc/my.cnf $rdir
}

function do_in57 {
  cnf=$1
  shift 1

  echo "innodb conf $cnf at $( date )"
  sfx=in.c$cnf
  cd $dmy57; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh in57 ~/d/my57/bin/mysql /data/m/my/data $maxid $dname $wdop $secs mysql lb.innodb $dbhost $ldop $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmy57; bash down.sh; cd $dgit
  fi
  rdir=a.in57.c${cnf}
  mkdir $rdir
  mv $dmy57/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmy57/etc/my.cnf $rdir
}

function do_in56 {
  cnf=$1
  shift 1

  echo "innodb conf $cnf at $( date )"
  sfx=in.c$cnf
  cd $dmy56; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh in56 ~/d/my56/bin/mysql /data/m/my/data $maxid $dname $wdop $secs mysql lb.innodb $dbhost $ldop $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmy56; bash down.sh; cd $dgit
  fi
  rdir=a.in56.c${cnf}
  mkdir $rdir
  mv $dmy56/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmy56/etc/my.cnf $rdir
}

function do_pg12 {
  cnf=$1
  shift 1

  echo "postgres conf $cnf at $( date )"
  sfx=pg.c$cnf
  cd $dpg12; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh pg12 ~/d/pg12/bin/psql /data/m/pg/base $maxid $dname $wdop $secs postgres lb.postgres $dbhost $ldop $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dpg12; bash down.sh; cd $dgit
  fi
  rdir=a.pg12.c${cnf}
  mkdir $rdir
  mv $dpg12/o.ini.* l.* r.* a.$sfx $rdir
  cp $dpg12/conf.diff $rdir
}

function do_mo40 {
  cnf=$1
  shift 1

  echo "mongo conf $cnf at $( date )"
  sfx=mo.c$cnf
  cd $dmo40; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh mo40 ~/d/mo40/bin/mongo /data/m/mo $maxid $dname $wdop $secs mongo lb.mongo $dbhost $ldop $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmo40; bash down.sh; cd $dgit
  fi
  rdir=a.mo40.c${cnf}
  mkdir $rdir
  mv $dmo40/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmo40/mongo.conf $rdir
}

function do_mo42 {
  cnf=$1
  shift 1

  echo "mongo conf $cnf at $( date )"
  sfx=mo.c$cnf
  cd $dmo42; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh mo42 ~/d/mo42/bin/mongo /data/m/mo $maxid $dname $wdop $secs mongo lb.mongo $dbhost $ldop $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmo42; bash down.sh; cd $dgit
  fi
  rdir=a.mo42.c${cnf}
  mkdir $rdir
  mv $dmo42/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmo42/mongo.conf $rdir
}

function do_mo44 {
  cnf=$1
  shift 1

  echo "mongo conf $cnf at $( date )"
  sfx=mo.c$cnf
  cd $dmo44; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  echo start load and run at $( date )
  cd $dgit; bash all.sh mo44 ~/d/mo44/bin/mongo /data/m/mo $maxid $dname $wdop $secs mongo lb.mongo $dbhost $ldop $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmo44; bash down.sh; cd $dgit
  fi
  rdir=a.mo44.c${cnf}
  mkdir $rdir
  mv $dmo44/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmo44/mongo.conf $rdir
}

dbms=$( echo $dbms_cnf | tr '.' ' ' | awk '{ print $1 }' )
cnf=$( echo $dbms_cnf | tr '.' ' ' | awk '{ print $2 }' )
echo Run for dbms=$dbms and cnf=$cnf

shift 8

if [[ $dbms = "rx56" ]]; then
  do_rx56 $cnf $@
elif  [[ $dbms = "in80" ]]; then
  do_in80 $cnf $@
elif  [[ $dbms = "in57" ]]; then
  do_in57 $cnf $@
elif  [[ $dbms = "in56" ]]; then
  do_in56 $cnf $@
elif [[ $dbms = "pg12" ]]; then
  do_pg12 $cnf $@
elif [[ $dbms = "mo40" ]]; then
  do_mo40 $cnf $@
elif [[ $dbms = "mo42" ]]; then
  do_mo42 $cnf $@
elif [[ $dbms = "mo44" ]]; then
  do_mo44 $cnf $@
fi

