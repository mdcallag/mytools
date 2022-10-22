dbdir=$1
nsecs=$2
nthr=$3
cachemb=$4
# no, memtable, L0, L1
cleanup_state=$5
cleanup_todo=$6
nmkeys=$7
devname=$8
# yes if database loaded by fillrandom in which case --use_existing_keys must be used.
# Note that --use_existing_keys can be very slow at startup thanks to
# much random IO when O_DIRECT is done for user reads.
fillrand=$9
block_align=${10}

if [ $fillrand == "yes" ]; then
  existingkeys=1
else
  existingkeys=0
fi

killall -q iostat
killall -q vmstat

sfx=nthr${nthr}.cachemb${cachemb}.cleanup${cleanup_state}.existkey${existingkeys}.nmkeys${nmkeys}

if [ $cleanup_todo == "L1" ]; then
  echo "Flush memtable. Compact L0,L1"
  ./db_bench \
    --benchmarks=stats,flush,waitforcompaction,compact0,waitforcompaction,compact1,waitforcompaction,stats \
    --db=$dbdir \
    --use_existing_db=1 \
    --block_align=$block_align \
    --compression_type=none \
    --use_direct_io_for_flush_and_compaction \
    --use_direct_reads >& o.q.res.$sfx
elif [ $cleanup_todo == "L0" ]; then
  echo "Flush memtable. Compact L0"
  ./db_bench \
    --benchmarks=stats,flush,waitforcompaction,compact0,waitforcompaction,stats \
    --db=$dbdir \
    --use_existing_db=1 \
    --block_align=$block_align \
    --compression_type=none \
    --use_direct_io_for_flush_and_compaction \
    --use_direct_reads >& o.q.res.$sfx
elif [ $cleanup_todo == "memtable" ]; then
  echo "Flush memtable."
  ./db_bench \
    --benchmarks=stats,flush,waitforcompaction,stats \
    --db=$dbdir \
    --use_existing_db=1 \
    --block_align=$block_align \
    --compression_type=none \
    --use_direct_io_for_flush_and_compaction \
    --use_direct_reads >& o.q.res.$sfx
else
  echo "Just waitforcompaction."
  ./db_bench \
    --benchmarks=stats,waitforcompaction,stats \
    --db=$dbdir \
    --use_existing_db=1 \
    --block_align=$block_align \
    --compression_type=none \
    --use_direct_io_for_flush_and_compaction \
    --use_direct_reads >& o.q.res.$sfx
fi

if [ $existingkeys -eq 1 ]; then
  ekopt="--use_existing_keys=1"
else
  ekopt="--num=$(( nmkeys * 1000000 ))"
fi

iostat -y -mx 1 >& o.q.io.$sfx &
ipid=$!

vmstat 1 >& o.q.vm.$sfx &
vpid=$!

cachebytes=$(( $cachemb * 1024 * 1024 ))

if [ $cachemb -gt 0 ]; then
cache_opts="\
  --cache_index_and_filter_blocks=true \
  --cache_high_pri_pool_ratio=0.5 \
  --cache_low_pri_pool_ratio=0 \
  --pin_l0_filter_and_index_blocks_in_cache=true"
else
cache_opts="\
  --pin_l0_filter_and_index_blocks_in_cache=false"
fi

./db_bench \
  --benchmarks=readrandom,stats \
  --db=$dbdir \
  --threads=$nthr \
  --duration=$nsecs \
  --enable_blob_files=true \
  --min_blob_size=1024 \
  --enable_blob_garbage_collection=true \
  --blob_garbage_collection_age_cutoff=0.30000 \
  --blob_garbage_collection_force_threshold=0.100000 \
  $cache_opts \
  --write_buffer_size=536870912 \
  --blob_file_size=536870912 \
  --target_file_size_base=67108864 \
  --max_bytes_for_level_base=671088640 \
  --num_levels=8 \
  --max_bytes_for_level_multiplier=10 \
  --disable_wal=true \
  --use_existing_db=1 \
  $ekopt \
  --cache_size=$cachebytes \
  --use_direct_io_for_flush_and_compaction \
  --use_direct_reads \
  --report_file=o.q.rep.$sfx \
  --report_interval_seconds=1 \
  --block_align=$block_align \
  --compression_type=none \
  --seed=1056573037454101 >> o.q.res.$sfx 2>&1

echo "dbdir=$dbdir, nsecs=$nsecs" >> o.q.res.$sfx

qps=$( grep ^readrandom o.q.res.$sfx | awk '{ printf "%.1f", $5 }' )
rps_col=$( iostat -kx 1 1 | grep r\/s | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "r/s") { found=n } } } END { printf "%s", found }' )
if [ $rps_col -gt 0 ]; then
  iops=$( grep $devname o.q.io.$sfx | awk '{ c+=1; rps += $2 } END { printf "%.0f", rps/c }' )
  iops_qps_ratio=$( echo $iops $qps | awk '{ printf "%.3f", $1 / $2 }' )
else
  iops=NA
  iops_qps_ratio=NA
fi

res_line=$( grep ^readrandom o.q.res.$sfx )
echo $res_line iops=$iops io_per_query=$iops_qps_ratio

kill $ipid
kill $vpid
