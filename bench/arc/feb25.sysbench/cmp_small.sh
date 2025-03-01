ntabs=$1
nrows=$2
nsecs=$3
basedir=$4
sysbdir=$5
datadir=$6
devname=$7
usepk=$8

# Remaining args are numbers of threads for which to run benchmarks, "1 2 4"
shift 8

function dbms_up() {
  bdir=$1
  cnf=$2
  # /media/ephemeral1 or /home/mdcallag/d or ???
  cdir=$PWD
  cd $bdir; bash ini.sh $cnf >& o.ini; sleep 10; cd $cdir
}

function dbms_down() {
  bdir=$1
  cnf=$2
  cdir=$PWD
  cd $bdir; bash down.sh $cnf >& o.down; cd $cdir
}

dbcreds=mysql,root,pw,127.0.0.1,test,innodb
for dcnf in my5649.x6d my5731.x6d my8022.x6d my8021.x6d my8020.x6d my8019.x6d my8018.x6d my8017.x6d ; do
  dbms=$( echo $dcnf | tr '.' ' ' | awk '{ print $1 }' )
  cnf=$( echo $dcnf | tr '.' ' ' | awk '{ print $2 }' )

  dbdir=$basedir/$dbms
  client=$dbdir/bin/mysql
  echo Run for $dbms with $cnf config from $dbdir

  dbms_up $dbdir $cnf
  bash all_small.sh $ntabs $nrows $nsecs $nsecs $nsecs $dbcreds 1 1 $client none $sysbdir $datadir $devname $usepk $@
  mkdir x.$dcnf.pk${usepk}; mv sb.* x.$dcnf.pk${usepk}; cp $dbdir/etc/my.cnf $dbdir/o.ini* x.$dcnf.pk${usepk}
  dbms_down $dbdir $cnf 
done

dbcreds=postgres,root,pw,127.0.0.1,ib
for dcnf in pg131.x5 pg130.x5 pg124.x5 pg123.x5 pg122.x5 pg121.x5 pg120.x5 ; do
  dbms=$( echo $dcnf | tr '.' ' ' | awk '{ print $1 }' )
  cnf=$( echo $dcnf | tr '.' ' ' | awk '{ print $2 }' )

  dbdir=$basedir/$dbms
  client=$dbdir/bin/psql
  echo Run for $dbms with $cnf config from $dbdir

  dbms_up $dbdir $cnf
  bash all_small.sh $ntabs $nrows $nsecs $nsecs $nsecs $dbcreds 1 1 $client none $sysbdir $datadir $devname $usepk $@
  mkdir x.$dcnf.pk${usepk}; mv sb.* x.$dcnf.pk${usepk}; cp $dbdir/conf.diff $dbdir/o.ini* x.$dcnf.pk${usepk}
  dbms_down $dbdir $cnf 
done

