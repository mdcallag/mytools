dbdir=$1
bgflush=$2
bgcomp=$3
subcomp=$4
nmkeys=$5
# yes to use fillrandom, no to do filluniquerandom
# When no, then there is no need for --use_existing_keys as all keys exist.
# Note that --use_existing_keys can be very slow at startup thanks to
# much random IO when O_DIRECT is done for user reads.
fillrand=$6
# true or false
block_align=$7
val_size=$8
odirect=$9
useblob=${10}

# TODO:   --use_shared_block_and_blob_cache=$use_shared_block_and_blob_cache \

killall -q vmstat
killall -q iostat

sfx=nthr${nthr}.cachegb${cachegb}.nmkeys${nmkeys}.val${val_size}.odirect${odirect}.blob${useblob}

iostat -y -mx 1 >& o.l.io.$sfx &
ipid=$!

vmstat 1 >& o.l.vm.$sfx &
vpid=$!

echo "Start load at $( date )"

if [ $fillrand == "yes" ]; then
  bmark=fillrandom
else
  bmark=filluniquerandom
fi

if [ $odirect == "yes" ]; then
  odirect_flags="--use_direct_io_for_flush_and_compaction"
fi

if [ $useblob == "yes" ]; then
extra_flags="\
  --enable_blob_files=true \
  --min_blob_size=1024 \
  --blob_file_size=536870912 \
  --enable_blob_garbage_collection=true \
  --blob_garbage_collection_age_cutoff=0.300000 \
  --pin_l0_filter_and_index_blocks_in_cache=false \
  --blob_garbage_collection_force_threshold=0.100000 "
else
extra_flags="\
  --bloom_bits=10 \
  --level_compaction_dynamic_level_bytes=true "
fi

dbb_cmd="\
./db_bench \
  --benchmarks=$bmark,stats \
  --num=$(( nmkeys * 1000000 )) \
  --compaction_style=0 \
  --threads=1 \
  --db=$dbdir \
  --key_size=16 \
  --block_align=$block_align \
  --value_size=$val_size \
  --compression_type=none \
  --enable_pipelined_write=true \
  --disable_wal=true \
  --write_buffer_size=536870912 \
  --target_file_size_base=67108864 \
  --max_bytes_for_level_base=671088640 \
  --cache_size=0 \
  $odirect_flags \
  $extra_flags \
  --max_background_flushes=$bgflush \
  --max_background_compactions=$bgcomp \
  --subcompactions=$subcomp \
  --max_write_buffer_number=3 \
  --level0_file_num_compaction_trigger=4 \
  --level0_slowdown_writes_trigger=16 \
  --level0_stop_writes_trigger=24 \
  --num_levels=8 \
  --max_bytes_for_level_multiplier=10 \
  --report_file=o.l.rep.$sfx \
  --report_interval_seconds=1 \
  --stats_per_interval=1 --stats_interval_seconds=60 \
  --seed=1665573037454110 "

echo $dbb_cmd > o.l.res.$sfx
$dbb_cmd >> o.l.res.$sfx 2>&1

grep ^${bmark} o.l.res.$sfx
echo "dbdir=$dbdir, bgflush=$bgflush, bgcomp=$bgcomp, subcomp=$subcomp" >> o.l.res.$sfx

kill $vpid
kill $ipid
