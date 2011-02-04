# Args are:
# binlog&trxlog doublewrite #writers #users dirty_pct read_hit_pct test_duration prepare

prepare=$1

# read-only low-concur and optionally prepare files
bash run_innosim.sh  1 1 8  4   0   0 300 $prepare

# read-only high-concur
bash run_innosim.sh  1 1 8 32   0   0 300 0 

# write-only low-concur
bash run_innosim.sh  1 1 8  4 100 100 300 0

# write-only high-concur
bash run_innosim.sh  1 1 8 32 100 100 300 0

# read-write low-concur
bash run_innosim.sh  1 1 8  4  50   0 300 0

# read-write high-concur
bash run_innosim.sh  1 1 8 32  50   0 300 0
