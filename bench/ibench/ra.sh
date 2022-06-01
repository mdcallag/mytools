mbd=$1
rdir=$2
dev=$3
only1t=$4
npart=$5

#ips="100 100 200 200 400 400 600 600 800 800 1000 1000"
#ns=1800

ips="100 500 1000"
ns=$(( 3600 * 2 ))
bash ra1.sh  20000000 20000000  20m 1 $ns $mbd $rdir $dev $only1t $npart $ips

ips="100 500 1000"
ns=$(( 3600 * 2 ))
bash ra1.sh 500000000 10000000 500m 1 $ns $mbd $rdir $dev $only1t $npart $ips

