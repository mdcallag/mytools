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
delete_per_insert=${11}

if [[ $npart -gt 0 ]]; then
  ps=part${npart}
else
  ps=""
fi

shift 11

if [[ $npart -eq 0 ]]; then
for dc in rx56.y9c ; do
for ver in fbmy5635 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/fbmy56; ln -s $mbd/$ver $mbd/fbmy56
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.rx56.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done
fi

if [[ $npart -eq 0 ]]; then
for dc in rx80.y9c ; do
for ver in fbmy8028 fbmy8020 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/fbmy80; ln -s $mbd/$ver $mbd/fbmy80
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.rx80.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done
fi

for dc in in80.y8 ; do
for ver in my8031 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my80; ln -s $mbd/$ver $mbd/my80
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.in80.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in in57.y8 ; do
for ver in my5735 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my57; ln -s $mbd/$ver $mbd/my57
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.in57.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in in56.y8 ; do
for ver in my5649 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/my56; ln -s $mbd/$ver $mbd/my56
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.in56.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

exit

for dc in pg12.x7 ; do
for ver in pg1211 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg12; ln -s $mbd/$ver $mbd/pg12
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg12.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in pg13.x7 ; do
for ver in pg137 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg13; ln -s $mbd/$ver $mbd/pg13
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg13.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in pg14.x7 ; do
for ver in pg143 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg14; ln -s $mbd/$ver $mbd/pg14
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg14.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in pg15.x7 ; do
for ver in pg15b1 ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg15; ln -s $mbd/$ver $mbd/pg15
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg15.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in pg16.x7 ; do
for ver in pg163_def ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg16; ln -s $mbd/$ver $mbd/pg16
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg16.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in pg17.x7 ; do
for ver in pg170_def ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg17; ln -s $mbd/$ver $mbd/pg17
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg17.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in pg18.x7 ; do
for ver in pg180_def ; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/pg18; ln -s $mbd/$ver $mbd/pg18
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.pg18.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in ma10old.z11a_c8r32 ; do
for ver in \
ma100244_rel_withdbg \
ma100339_rel_withdbg \
; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/ma10old; ln -s $mbd/$ver $mbd/ma10old
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.ma10.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in ma10.z11a_c8r32 ; do
for ver in \
ma100434_rel_withdbg \
ma100526_rel_withdbg \
ma100619_rel_withdbg \
ma101109_rel_withdbg \
; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/ma10; ln -s $mbd/$ver $mbd/ma10
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.ma10.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done

for dc in \
ma11.z11b_c8r32 \
; do
for ver in \
ma110403_rel_withdbg \
ma110502_rel_withdbg \
ma110601_rel_withdbg \
; do
  cnf=$( echo $dc | tr '.' ' ' | awk '{ print $2 }' )
  rm $mbd/ma11; ln -s $mbd/$ver $mbd/ma11
  bash rall1.sh $dc $dop $nsecs $rdir $nr1 $nr2 $nrt $dev $only1t $mbd none $npart $delete_per_insert $@
  mv $rdir/${dop}u.1t${only1t}/${nrt}.ma11.c${cnf}${ps} $rdir/${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${ps}
  echo Done $ver $dc
  sleep 1200
done
done
