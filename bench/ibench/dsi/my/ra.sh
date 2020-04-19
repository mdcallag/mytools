mbd=$1
dev=$2

bash ra1.sh   80000000   80m 8 3600 $mbd $dev
bash ra2.sh  320000000  320m 8 3600 $mbd $dev
bash ra2.sh 1000000000 1000m 8 3600 $mbd $dev
