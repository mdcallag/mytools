mbd=$1
dev=$2

ips="100 100 200 200 400 400 600 600 800 800 1000 1000"

ns=300
bash ramo1.sh  15000000 15000000  15m 1 $ns $mbd $dev $ips

ns=1800
bash ramo1.sh  40000000 40000000  40m 8 $ns $mbd $dev $ips
bash ramo2.sh 800000000 80000000 800m 8 $ns $mbd $dev $ips

