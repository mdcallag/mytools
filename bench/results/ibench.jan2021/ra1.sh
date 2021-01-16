nr1=$1
nr2=$2
nrt=$3
dop=$4
nsecs=$5
mbd=$6
rdir=$7
dev=$8
only1t=$9
npart=${10}

if [[ $npart -gt 0 ]]; then
  ps=part${npart}
else
  ps=""
fi

shift 10

if [[ $npart -eq 0 ]]; then
  for dc in rx56.x6a ; do
    bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  done
fi

if [[ $npart -eq 0 ]]; then
  for dc in rx80.x6a ; do
    bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  done
fi

for dc in pg11.x5 ; do
for ver in pg1110 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg11; ln -s $mbd/$ver $mbd/pg11
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg11.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  sleep 600
done
done

for dc in pg12.x5 ; do
for ver in pg124 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg12; ln -s $mbd/$ver $mbd/pg12
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg12.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  sleep 600
done
done

for dc in pg13.x5 ; do
for ver in pg131 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg13; ln -s $mbd/$ver $mbd/pg13
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg13.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  sleep 600
done
done

for dc in in56.x6d ; do
for ver in my5649 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my56; ln -s $mbd/$ver $mbd/my56
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.in56.c${cnf}${ps} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  sleep 600
done
done

for dc in in57.x6d ; do
for ver in my5731 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my57; ln -s $mbd/$ver $mbd/my57
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.in57.c${cnf}${ps} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  sleep 600
done
done

for dc in in80.x6d ; do
for ver in my8021 my8022 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my80; ln -s $mbd/$ver $mbd/my80
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.in80.c${cnf}${ps} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  sleep 600
done
done


