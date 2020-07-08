nr1=$1
nr2=$2
nrt=$3
dop=$4
nsecs=$5
mbd=$6
dev=$7

shift 7

for cnf in 5b40 ; do
for ver in mo4019 mo4018 mo4017 mo4016 ; do
  rm $mbd/mo40; ln -s $mbd/$ver $mbd/mo40
  bash rall1.sh mo40.${cnf} $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev no $mbd $@
  mv ${dop}u/${nrt}.mo40.c${cnf} ${dop}u/${nrt}.${ver}.c${cnf}
done
done

for cnf in 5b40 ; do
for ver in mo428 mo427 mo426 mo425 mo423 mo422 mo421 ; do
  rm $mbd/mo42; ln -s $mbd/$ver $mbd/mo42
  bash rall1.sh mo42.${cnf} $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev no $mbd $@
  mv ${dop}u/${nrt}.mo42.c${cnf} ${dop}u/${nrt}.${ver}.c${cnf}
done
done

for cnf in 5b40 ; do
for ver in mo440rc11 mo440rc10 mo440rc9 ; do
  rm $mbd/mo44; ln -s $mbd/$ver $mbd/mo44
  bash rall1.sh mo44.${cnf} $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev no $mbd $@
  mv ${dop}u/${nrt}.mo44.c${cnf} ${dop}u/${nrt}.${ver}.c${cnf}
done
done
