mbd=$1
rdir=$2
dev=$3
only1t=$4
npart=$5
dop=$6
secs=$7
delete_per_insert=$8
mr1=$9
mr2=${10}

nr1=$(( $mr1 * 1000000 * $dop ))
nrm=$(( $mr1 * $dop ))
nr2=$(( $mr2 * 1000000 * $dop ))

ips="100 500 1000"
bash ra1.sh  $nr1 $nr2 ${nrm}m $dop $secs $mbd $rdir $dev $only1t $npart $delete_per_insert $ips

#ips="100 500 1000"
#bash ra1.sh 500000000 10000000 500m $dop $secs $mbd $rdir $dev $only1t $npart $delete_per_insert $ips

