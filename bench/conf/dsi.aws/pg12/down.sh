bdir=/data/m/pg

echo "stop and remove files"
bin/pg_ctl -D $bdir stop -m immediate
rm -rf $bdir/*
rm -f logfile; touch logfile

