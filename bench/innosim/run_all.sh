# 1) Use this to run many tests
# 2) Run 'bash stats.sh $max_concur' to generate reports 

# -----------------

# 1 means to create database files, 0 means reuse them
prepare=$1

# Seconds for which innosim runs each time it is started
secs=$2

# Seconds to sleep between each run of innosim 
sleep_secs=$3

# Size of database file in GB
dfs=$4

# 1 means use compression (simulate CPU cost of it)
comp=$5

# IO rate (per second per thread), 0 means no limit. Might be useful
# for write heavy workloads.
write_limit=$6

# Max concurrency for which test is run. Should be a power of 2.
max_concur=$7

# Args for run_innosim are:
#   binlog&trxlog
#   doublewrite
#   nwriters
#   nusers
#   dirty_pct
#   read_hit_pct
#   test_duration
#   prepare
#   database_size_in_GB
#   use_compression
#   write_limit

if [ $prepare -gt 0 ] ; then
echo Prepare
bash run_innosim.sh  1 1 8  1   0   0 10 1 $dfs $comp 0
fi

concur=1
while [ $concur -le $max_concur ]; do
  echo read-only $concur concur
  bash run_innosim.sh  1 1 8  $concur   0   0 $secs 0 $dfs $comp 0; sleep $sleep_secs
  concur=$(( $concur * 2 ))
done

concur=1
while [ $concur -le $max_concur ]; do
  wl=$(( $write_limit / $concur ))
  echo write-only $concur concur with $wl write limit
  bash run_innosim.sh  1 1 8  $concur 100 100 $secs 0 $dfs $comp $wl ; sleep $sleep_secs
  concur=$(( $concur * 2 ))
done

concur=1
while [ $concur -le $max_concur ]; do

echo read-write $concur concur dirty=25  100 page reads to 50 page writes
bash run_innosim.sh  1 1 8  $concur  25   0 $secs 0 $dfs $comp 0 ; sleep $sleep_secs

echo read-write $concur concur dirty=17 100 page reads to 34 page writes
bash run_innosim.sh  1 1 8  $concur  17   0 $secs 0 $dfs $comp 0 ; sleep $sleep_secs

echo read-write $concur concur dirty=6  100 page reads to 12 page writes
bash run_innosim.sh  1 1 8  $concur  6   0 $secs 0 $dfs $comp 0 ; sleep $sleep_secs

concur=$(( $concur * 2 ))
done
