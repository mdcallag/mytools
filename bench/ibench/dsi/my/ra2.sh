nr1=$1
nr2=$2
nrt=$3
dop=$4
nsecs=$5
mbd=$6
dev=$7
 
shift 7

for dc in pg12.8b40 ; do
for ver in pg120 pg123 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg12; ln -s $mbd/$ver $mbd/pg12
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev no $mbd $@
  mv ${dop}u/${nrt}.pg12.c${cnf} ${dop}u/${nrt}.${ver}.c${cnf}
done
done

for dc in in80.10b40 ; do
for ver in my8018 my8020 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my80; ln -s $mbd/$ver $mbd/my80
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev no $mbd $@
  mv ${dop}u/${nrt}.in80.c${cnf} ${dop}u/${nrt}.${ver}.c${cnf}
done
done

for dc in rx56.7b40 rx56.8b40 ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev no $mbd $@
done

