nr=$1
nrt=$2
dop=$3
nsecs=$4
mbd=$5
dev=$6
 
shift 6

for dc in pg12.8b40 ; do
for ver in pg120 pg123 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg12; ln -s $mbd/$ver $mbd/pg12
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt $dev no $mbd $@
  mv ${dop}u/${nrt}.pg12.c${cnf} ${dop}u/${nrt}.${ver}.c${cnf}
done
done

for dc in in80.10b40 ; do
for ver in my8018 my8020 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my80; ln -s $mbd/$ver $mbd/my80
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt $dev no $mbd $@
  mv ${dop}u/${nrt}.in80.c${cnf} ${dop}u/${nrt}.${ver}.c${cnf}
done
done

for dc in rx56.7b40 rx56.8b40 ; do
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr $nrt $dev no $mbd $@
done

