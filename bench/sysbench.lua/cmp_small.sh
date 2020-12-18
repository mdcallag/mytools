ntabs=$1
nrows=$2
nsecs=$3
basedir=$4
sysbdir=$5
datadir=$6
devname=$7

# TODO, support=0
usepk=1

# Remaining args are numbers of threads for which to run benchmarks, "1 2 4"
shift 7

#client=/home/mdcallag/d/my8022/bin/mysql
#sysbdir=/home/mdcallag/d/sysbench
#ddir=/data/m/my/data
#dname=nvem0n1

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

dbcreds=postgres,root,pw,127.0.0.1,ib
for dcnf in pg131 pg130 pg124 pg123 pg122 pg121 pg120 ; do
  dbms=$( echo $dcnf | tr '.' ' ' | awk '{ print $1 }' )
  cnf=$( echo $dcnf | tr '.' ' ' | awk '{ print $2 }' )

  dbdir=$basedir/$dbms
  client=$dbdir/bin/psql
  echo Run for $dbms with $cnf config from $dbdir

  dbms_up $dbdir $cnf
  bash all_small.sh $ntabs $nrows $nsecs $nsecs $nsecs $dbcreds 1 1 $client none $sysbdir $datadir $devname $usepk $@
  mkdir x.$dcnf; mv sb.* x.$dcnf; cp $dbdir/etc/cnf.diff $dbdir/o.ini x.$dcnf
  dbms_down $dbdir $cnf 
done

dbcreds=mysql,root,pw,127.0.0.1,test,innodb
for dcnf in my8022.x1 my8021.x1 my8020.x1 my8019.x1 my8018.x1 my8017.x1 ; do
  dbms=$( echo $dcnf | tr '.' ' ' | awk '{ print $1 }' )
  cnf=$( echo $dcnf | tr '.' ' ' | awk '{ print $2 }' )

  dbdir=$basedir/$dbms
  client=$dbdir/bin/mysql
  echo Run for $dbms with $cnf config from $dbdir

  dbms_up $dbdir $cnf
  bash all_small.sh $ntabs $nrows $nsecs $nsecs $nsecs $dbcreds 1 1 $client none $sysbdir $datadir $devname $usepk $@
  mkdir x.$dcnf; mv sb.* x.$dcnf; cp $dbdir/etc/my.cnf $dbdir/o.ini x.$dcnf
  dbms_down $dbdir $cnf 
done
