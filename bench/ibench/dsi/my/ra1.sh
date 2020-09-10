nr1=$1
nr2=$2
nrt=$3
dop=$4
nsecs=$5
mbd=$6
dev=$7
only1t=$8
npart=$9

if [[ $npart -gt 0 ]]; then
  ps=part${npart}
else
  ps=""
fi

shift 9

for dc in pg12.8b40 ; do
for ver in pg120 pg123 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg12; ln -s $mbd/$ver $mbd/pg12
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.pg12.c${cnf}${ps} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
done
done

for dc in in80.14b40 in80.15b40 ; do
for ver in my8018 my8020 my8021 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my80; ln -s $mbd/$ver $mbd/my80
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.in80.c${cnf}${ps} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
done
done

for dc in in57.14b40 in57.15b40 ; do
for ver in my5731 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my57; ln -s $mbd/$ver $mbd/my57
  bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.in57.c${cnf}${ps} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
done
done

if [[ $npart -eq 0 ]]; then
  for dc in rx56.7b40 ; do
    bash rall1.sh $dc $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  done
fi

