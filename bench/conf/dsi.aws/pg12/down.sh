bdir=/data/m/pg

echo "stop and remove files"
bin/pg_ctl -D $bdir stop -m immediate
rm -rf $bdir; mkdir -p $bdir
rm -f logfile; touch logfile

