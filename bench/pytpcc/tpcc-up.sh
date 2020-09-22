killall iostat
killall vmstat
bash down.sh
bash ini.sh 5
iostat -kx 5 >& o.io &
vmstat 5 >& o.vm &

