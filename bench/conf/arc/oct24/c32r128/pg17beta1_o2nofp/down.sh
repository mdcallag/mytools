bdir=/data/m/pg

echo "stop and remove files"
bin/pg_ctl -D $bdir stop
rm -rf $bdir/*
rm -f logfile; touch logfile

