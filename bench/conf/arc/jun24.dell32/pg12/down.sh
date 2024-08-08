
bdir=/data/m/pg

echo "stop and remove files"
bin/pg_ctl -m immediate -D $bdir stop
sleep 5
rm -rf $bdir/*
rm -f logfile; touch logfile
