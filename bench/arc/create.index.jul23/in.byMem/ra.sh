# Path at which test DBMS are installed
mbd=$1
# Path to result directory, "." is fine
rdir=$2
# Name of storage device. Use shortest string that can match name shown by df -h
dev=$3
# yes or no, yes means only 1 table, shared if dop > 1
only1t=$4
# 0 means no partitions, 1+ means number of partitions
npart=$5
# number of concurrent clients
dop=$6
# Try with 1800 or more
secs=$7

ips="100 500 1000"

# in-memory for a small server
#nr=$(( 20000000 * dop ))
#nrt=$(( 20 * dop ))
#bash ra1.sh  $nr $nr ${nrt}m $dop $secs $mbd $rdir $dev $only1t $npart $ips

nr=$(( 5000000 * dop ))
nrt=$(( 5 * dop ))
bash ra1.sh  $nr $nr ${nrt}m $dop $secs $mbd $rdir $dev $only1t $npart $ips
exit

nr1=$(( 400000000 * dop ))
nr2=$(( 40000000 * dop ))
nrt=$(( 400 * dop ))
bash ra1.sh  $nr1 $nr2 ${nrt}m $dop $secs $mbd $rdir $dev $only1t $npart $ips

# IO-bound for a small server
#bash ra1.sh 500000000 10000000 500m $dop $secs $mbd $rdir $dev $only1t $npart $ips

