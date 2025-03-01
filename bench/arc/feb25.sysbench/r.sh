ntabs=$1
nrows=$2
nsecs_r=$3
nsecs_w=$4
dev=$5
# 1 if using PK, 0 otherwise
usepk=$6
# 1 for prepared statements, 0 otherwise
prep=$7

shift 7

bash cmp_rx.sh $ntabs $nrows $nsecs_r $nsecs_w  /mnt/data/d /mnt/data/sysbench.lua/lua /mnt/data/m/fbmy/data/.rocksdb $dev $usepk $prep $@
#bash cmp_in.sh $ntabs $nrows $nsecs_r $nsecs_w /mnt/data/d /mnt/data/sysbench.lua/lua /mnt/data/m/my/data $dev $usepk $prep $@
#bash cmp_pg.sh $ntabs $nrows $nsecs_r $nsecs_w /mnt/data/d /mnt/data/sysbench.lua/lua /mnt/data/m/pg/base $dev $usepk $prep $@
