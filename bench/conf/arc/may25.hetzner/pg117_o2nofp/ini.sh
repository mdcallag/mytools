bdir=/data/m/pg

echo "stop and remove files"
bin/pg_ctl -D $bdir stop
rm -rf $bdir/*
rm -f logfile; touch logfile
killall mysqld mongod

rm -rf /data/m/fbmy; mkdir -p /data/m/fbmy
rm -rf /data/m/my; mkdir -p /data/m/my
rm -rf /data/m/pg; mkdir -p /data/m/pg
rm -rf /data/m/rx; mkdir -p /data/m/rx

if [ "$#" -ge 1 ]; then
  if [ -f conf.diff.c${1} ]; then
    cp conf.diff.c${1} conf.diff
  else
    echo conf.diff.c${1} does not exist
    exit 1
  fi
fi

echo "init"
bin/initdb --data-checksums -D $bdir >& o.ini.1
mv $bdir/postgresql.conf $bdir/postgresql.conf.orig
cat $bdir/postgresql.conf.orig conf.diff > $bdir/postgresql.conf
numactl --interleave=all bin/pg_ctl -D $bdir -l logfile start >& o.ini.2
sleep 5

echo "create db and users"
bin/createdb me
bin/createdb ib
bin/createdb linkbench
bin/psql me -c "create user root with superuser login password 'pw'"
bin/psql me -c "create user linkbench with superuser login password 'pw'"

bin/psql template1 -c 'create extension pgstattuple'

