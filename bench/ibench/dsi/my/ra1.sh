nr1=$1
nr2=$2
nrt=$3
dop=$4
nsecs=$5
mbd=$6
dev=$7
only1t=$8
npart=$9

shift 9

for dc in pg12.8b40 ; do
for ver in pg123 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg12; ln -s $mbd/$ver $mbd/pg12
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.pg12.c${cnf} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}
done
done

for dc in in80.12b40 ; do
for ver in my8020 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my80; ln -s $mbd/$ver $mbd/my80
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.in80.c${cnf} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}
done
done

for dc in rx56.7b40 ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd $npart $@
done

