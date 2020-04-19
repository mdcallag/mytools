mbd=$1
dev=$2

bash ra1-dsi.sh 80000000 80m 8 1200 $mbd $dev
bash ra2-dsi.sh 320000000 320m 8 1800 $mbd $dev
bash ra2-dsi.sh 1000000000 1000m 8 1800 $mbd $dev
