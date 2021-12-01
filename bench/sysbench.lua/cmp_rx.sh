ntabs=$1
nrows=$2
nsecs=$3
basedir=$4
sysbdir=$5
datadir=$6
devname=$7
usepk=$8
prepstmt=$9

# Remaining args are numbers of threads for which to run benchmarks, "1 2 4"
shift 9

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

dbcreds=mysql,root,pw,127.0.0.1,test,rocksdb
#for dcnf in fbmy5635.y9a fbmy5635.y9b fbmy5635.y9c fbmy5635.y9c0 fbmy5635.y9c1 fbmy5635.y9c2 fbmy5635.y13a fbmy5635.y13b fbmy8020.y9c ; do
for dcnf in fbmy5635.y9c fbmy8020.y9c ; do
  dbms=$( echo $dcnf | tr '.' ' ' | awk '{ print $1 }' )
  cnf=$( echo $dcnf | tr '.' ' ' | awk '{ print $2 }' )

  dbdir=$basedir/$dbms
  client=$dbdir/bin/mysql
  echo Run for $dbms with $cnf config from $dbdir

  dbms_up $dbdir $cnf
  bash all_small.sh $ntabs $nrows $nsecs $nsecs $nsecs $dbcreds 1 0 $client none $sysbdir $datadir $devname $usepk $prepstmt $@
  mkdir x.$dcnf.pk${usepk}; mv sb.* x.$dcnf.pk${usepk}; cp $dbdir/etc/my.cnf $dbdir/o.ini* x.$dcnf.pk${usepk}
  dbms_down $dbdir $cnf
done
