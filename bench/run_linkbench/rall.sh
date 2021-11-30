maxid=$1
dname=$2
wdop=$3
secs=$4
dbhost=$5
ldop=$6
dbms_cnf=$7
up=$8
# /media/ephemeral1 or /home/mdcallag/d or ???
dbms_pfx=$9
# Java max heap size, -Xmx=$heap
heap=${10}

# then DOP for queries as sequence of 1+ integers

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

# This can be overridden if a different Linkbench jar file is used, usually to get a different version of the MySQL Java Connector
jdbc="FacebookLinkBench.jar"

function do_rx56 {
  cnf=$1
  shift 1

  sfx=rx.c$cnf
  cd $dmyfb56; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  jdbc2="FacebookLinkBench.jar.cj508"
  cd $dgit; bash all.sh rx56 $dmyfb56/bin/mysql /data/m/fbmy $maxid $dname $wdop $secs mysql lb.myrocks $dbhost $ldop $heap $jdbc2 $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmyfb56; bash down.sh; cd $dgit
  fi
  rdir=a.rx56.c${cnf}
  mkdir -p $rdir
  mv $dmyfb56/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmyfb56/etc/my.cnf $rdir
}

function do_rx80 {
  cnf=$1
  shift 1

  sfx=rx.c$cnf
  cd $dmyfb80; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash all.sh rx80 $dmyfb80/bin/mysql /data/m/fbmy $maxid $dname $wdop $secs mysql lb.myrocks $dbhost $ldop $heap $jdbc $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmyfb80; bash down.sh; cd $dgit
  fi
  rdir=a.rx80.c${cnf}
  mkdir -p $rdir
  mv $dmyfb80/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmyfb80/etc/my.cnf $rdir
}

function do_in80 {
  cnf=$1
  shift 1

  sfx=in.c$cnf
  cd $dmy80; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash all.sh in80 $dmy80/bin/mysql /data/m/my $maxid $dname $wdop $secs mysql lb.innodb $dbhost $ldop $heap $jdbc $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmy80; bash down.sh; cd $dgit
  fi
  rdir=a.in80.c${cnf}
  mkdir -p $rdir
  mv $dmy80/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmy80/etc/my.cnf $rdir
}

function do_in57 {
  cnf=$1
  shift 1

  sfx=in.c$cnf
  cd $dmy57; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash all.sh in57 $dmy57/bin/mysql /data/m/my $maxid $dname $wdop $secs mysql lb.innodb $dbhost $ldop $heap $jdbc $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmy57; bash down.sh; cd $dgit
  fi
  rdir=a.in57.c${cnf}
  mkdir -p $rdir
  mv $dmy57/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmy57/etc/my.cnf $rdir
}

function do_in56 {
  cnf=$1
  shift 1

  sfx=in.c$cnf
  cd $dmy56; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  jdbc2="FacebookLinkBench.jar.cj508"
  cd $dgit; bash all.sh in56 $dmy56/bin/mysql /data/m/my $maxid $dname $wdop $secs mysql lb.innodb $dbhost $ldop $heap $jdbc2 $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmy56; bash down.sh; cd $dgit
  fi
  rdir=a.in56.c${cnf}
  mkdir -p $rdir
  mv $dmy56/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmy56/etc/my.cnf $rdir
}

function do_pg12 {
  cnf=$1
  shift 1

  sfx=pg.c$cnf
  cd $dpg12; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash all.sh pg12 $dpg12/bin/psql /data/m/pg $maxid $dname $wdop $secs postgres lb.postgres $dbhost $ldop $heap $jdbc $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dpg12; bash down.sh; cd $dgit
  fi
  rdir=a.pg12.c${cnf}
  mkdir -p $rdir
  mv $dpg12/o.ini.* l.* r.* a.$sfx $rdir
  cp $dpg12/conf.diff $rdir
}

function do_mo40 {
  cnf=$1
  shift 1

  sfx=mo.c$cnf
  cd $dmo40; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash all.sh mo40 $dmo40/bin/mongo /data/m/mo $maxid $dname $wdop $secs mongo lb.mongo $dbhost $ldop $heap $jdbc $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmo40; bash down.sh; cd $dgit
  fi
  rdir=a.mo40.c${cnf}
  mkdir -p $rdir
  mv $dmo40/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmo40/mongo.conf $rdir
}

function do_mo42 {
  cnf=$1
  shift 1

  sfx=mo.c$cnf
  cd $dmo42; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash all.sh mo42 $dmo42/bin/mongo /data/m/mo $maxid $dname $wdop $secs mongo lb.mongo $dbhost $ldop $heap $jdbc $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmo42; bash down.sh; cd $dgit
  fi
  rdir=a.mo42.c${cnf}
  mkdir -p $rdir
  mv $dmo42/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmo42/mongo.conf $rdir
}

function do_mo44 {
  cnf=$1
  shift 1

  sfx=mo.c$cnf
  cd $dmo44; bash ini.sh $cnf >& o.ini.$sfx; sleep 10
  cd $dgit; bash all.sh mo44 $dmo44/bin/mongo /data/m/mo $maxid $dname $wdop $secs mongo lb.mongo $dbhost $ldop $heap $jdbc $@ >& a.$sfx; sleep 10
  if [[ $up != 1 ]]; then
    cd $dmo44; bash down.sh; cd $dgit
  fi
  rdir=a.mo44.c${cnf}
  mkdir -p $rdir
  mv $dmo44/o.ini.* l.* r.* a.$sfx $rdir
  cp $dmo44/mongo.conf $rdir
}

dbms=$( echo $dbms_cnf | tr '.' ' ' | awk '{ print $1 }' )
cnf=$( echo $dbms_cnf | tr '.' ' ' | awk '{ print $2 }' )
echo Run for dbms=$dbms and cnf=$cnf

shift 10

echo start load and run at $( date ) for $dbms with $cnf

if [[ $dbms = "rx56" ]]; then
  do_rx56 $cnf $@
elif [[ $dbms = "rx80" ]]; then
  do_rx80 $cnf $@
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

echo done at $( date )
