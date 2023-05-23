mbd=$1
rdir=$2
dev=$3
only1t=$4
npart=$5
dop=$6
secs=$7
delete_per_insert=$8

ips="100 500 1000"
if [[ $delete_per_insert == "no" ]]; then
  nr2=20000000
else
  nr2=50000000
fi
bash ra1.sh  20000000 $nr2 20m $dop $secs $mbd $rdir $dev $only1t $npart $delete_per_insert $ips

#ips="100 500 1000"
#bash ra1.sh 500000000 10000000 500m $dop $secs $mbd $rdir $dev $only1t $npart $delete_per_insert $ips

