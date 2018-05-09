
db_gb=$1
row_sz=$2
key_sz=$3
block_bytes=$4

args="--database_gb=$db_gb --row_size=$row_sz --key_size=$key_sz --block_bytes=$block_bytes"
sfx="${db_gb}gb.${row_sz}row.${key_sz}key.${block_bytes}block"

for fanout in 4 8 16 ; do
python lsm_leveled_rws.py $args --no_bloom_on_max --level_fanout=$fanout > o.leveled.$sfx.${fanout}fanout.nobloom
done
python lsm_leveled_rws.py $args --bloom_on_max --level_fanout=8 > o.leveled.$sfx.8fanout.bloom

for fanout in 4 8 16; do
python lsm_tiered_rws.py $args --no_bloom_on_max --tier_fanout=$fanout > o.tiered.$sfx.${fanout}fanout.nobloom
done
python lsm_tiered_rws.py $args --no_bloom_on_max --tier_fanout=4 --last_extra_fanout=2 > o.tiered.$sfx.4fanout.nobloom.2xfanout
python lsm_tiered_rws.py $args --bloom_on_max --tier_fanout=4 > o.tiered.$sfx.4fanout.bloom

python btree_clust_rws.py $args > o.btree_clust.$sfx
python btree_nclust_rws.py $args > o.btree_nclust.$sfx

