nr1=$1
nr2=$2
nrt=$3
dop=$4
nsecs=$5
mbd=$6
dev=$7
only1t=$8
trx=$9

shift 9

npart=0

if [[ $trx == "trx1" ]]; then
  dbopt="transaction,w_1,r_snapshot"
elif [[ $trx == "trxj" ]]; then
  dbopt="transaction,w_1,r_snapshot,journal"
else
  dbopt="w_1,r_local"
fi

for cnf in 5b40 ; do
for ver in mo4020 mo4019 mo4018 mo4017 mo4016 ; do
  rm $mbd/mo40; ln -s $mbd/$ver $mbd/mo40
  bash rall1.sh mo40.${cnf} $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd $dbopt $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.mo40.c${cnf} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${trx}
done
done

for cnf in 5b40 ; do
for ver in mo429 mo428 mo427 mo426 mo425 mo423 mo422 mo421 ; do
  rm $mbd/mo42; ln -s $mbd/$ver $mbd/mo42
  bash rall1.sh mo42.${cnf} $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd $dbopt $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.mo42.c${cnf} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${trx}
done
done

for cnf in 5b40 ; do
for ver in mo440 ; do
  rm $mbd/mo44; ln -s $mbd/$ver $mbd/mo44
  bash rall1.sh mo44.${cnf} $dop $nsecs $mbd/ibench $nr1 $nr2 $nrt $dev $only1t $mbd $dbopt $npart $@
  mv ${dop}u.1t${only1t}/${nrt}.mo44.c${cnf} ${dop}u.1t${only1t}/${nrt}.${ver}.c${cnf}${trx}
done
done

