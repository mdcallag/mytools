mbd=$1
dev=$2
rdir=$3

#bash ramo1.sh   5000000   5m 1 3600 $mbd $dev $rdir
bash ramo2.sh  50000000  50m 1 3600 $mbd $dev $rdir
bash ramo2.sh 250000000 250m 1 3600 $mbd $dev $rdir

