ntabs=$1
nrows=$2
nsecs_r=$3
nsecs_w=$4
basedir=$5
sysbdir=$6
datadir=$7
devname=$8
usepk=$9
prepstmt=${10}

# Remaining args are numbers of threads for which to run benchmarks, "1 2 4"
shift 10

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
for dcnf in fbmy5635.ay9c fbmy8028.ay9c ; do
  dbms=$( echo $dcnf | tr '.' ' ' | awk '{ print $1 }' )
  cnf=$( echo $dcnf | tr '.' ' ' | awk '{ print $2 }' )

  dbdir=$basedir/$dbms
  client=$dbdir/bin/mysql
  echo Run for $dbms with $cnf config from $dbdir

  dbms_up $dbdir $cnf
  grep -i huge /proc/meminfo > sb.hp.pre
  bash all_small.sh $ntabs $nrows $nsecs_r $nsecs_w $nsecs_w $dbcreds 1 0 $client none $sysbdir $datadir $devname $usepk $prepstmt $@
  grep -i huge /proc/meminfo > sb.hp.post
  mkdir x.$dcnf.pk${usepk}; mv sb.* x.$dcnf.pk${usepk}; cp $dbdir/etc/my.cnf $dbdir/o.ini* x.$dcnf.pk${usepk}
  cp /data/m/fbmy/data/*.err x.$dcnf.pk${usepk}
  dbms_down $dbdir $cnf
  cp $dbdir/o.down x.$dcnf.pk${usepk}
  sleep 600
done
