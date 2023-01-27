ntabs=$1
nrows=$2
nsecs=$3
dev=$4
# 1 if using PK, 0 otherwise
usepk=$5
# 1 for prepared statements, 0 otherwise
prep=$6

shift 6

bash cmp_rx.sh $ntabs $nrows $nsecs ~/d ~/sysb /data/m/fbmy/data/.rocksdb $dev $usepk $prep $@
bash cmp_in.sh $ntabs $nrows $nsecs ~/d ~/sysb /data/m/my/data $dev $usepk $prep $@
bash cmp_pg.sh $ntabs $nrows $nsecs ~/d ~/sysb /data/m/pg/base $dev $usepk $prep $@
