
db_gb=$1
row_sz=$2
key_sz=$3
index_point_compares=$4
index_write_amp=$5
index_space_amp=$6

sfx="${db_gb}gb.${row_sz}row.${key_sz}key"

python log_only_rws.py \
--database_gb=$db_gb \
--row_size=$row_sz \
--key_size=$key_sz \
--index_point_compares=$index_point_compares \
--index_write_amp=$index_write_amp \
--index_space_amp=$index_space_amp

