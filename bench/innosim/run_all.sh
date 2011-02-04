# Args are:
# binlog&trxlog doublewrite #writers #users dirty_pct read_hit_pct test_duration prepare

prepare=$1
secs=$2

# read-only 0-concur and prepare files
bash run_innosim.sh  1 1 8  1   0   0 $secs $prepare

# read-only low-concur and prepare files
bash run_innosim.sh  1 1 8  4   0   0 $secs 0

# read-only high-concur
bash run_innosim.sh  1 1 8 32   0   0 $secs 0 

# write-only 0-concur
bash run_innosim.sh  1 1 8  1 100 100 $secs 0

# write-only low-concur
bash run_innosim.sh  1 1 8  4 100 100 $secs 0

# write-only high-concur
bash run_innosim.sh  1 1 8 32 100 100 $secs 0

# read-write 0-concur
bash run_innosim.sh  1 1 8  1  50   0 $secs 0

# read-write low-concur
bash run_innosim.sh  1 1 8  4  50   0 $secs 0

# read-write high-concur
bash run_innosim.sh  1 1 8 32  50   0 $secs 0
