
# --num in millions, 1000M ~= 144gb uncompressed database
mkeys=$1
# --block_size
bs=$2
# --cache_size in GB
cgb=$3
# --writable_file_max_buffer_size in MB
wfmb=$4
# if > 1 then --num_multi_db is used
numdb=$5

nkeys=$(( $mkeys * 1000 * 1000 ))
cby=$(( 1024 * 1024 * 1024 * $cgb ))
wfby=$(( 1024 * 1024 * $wfmb ))

if [ $numdb -gt 1 ]; then
  dbpfx="multidb_$numdb"
  dbopt="--num_multi_db=$numdb"
else
  dbpfx="db_apdx"
  dbopt=""
fi

sfx="k_${mkeys}.${dbpfx}.bs_${bs}"
sfx2="$sfx.cgb_${cgb}.wfmb_${wfmb}"
dbdir=/data/m/rx.$sfx

rm -rf $dbdir
mkdir -p $dbdir
killall iostat
killall vmstat

iostat -y -mx 1 >& o.ld.io.$sfx2 &
iopid=$!

vmstat 1 >& o.ld.vm.$sfx2 &
vmpid=$!

while :; do du -hs $dbdir; date ; sleep 10; done >& o.ld.du1.$sfx2 &
duid1=$!

while :; do ps aux | grep db_bench | grep -v grep | tail -1; sleep 10; done >& o.ld.ps.$sfx2 &
psid=$!

M1=$(( 1024 * 1024 ))

cmd="./db_bench \
--statistics=1 \
--stats_interval_seconds=60 \
--stats_per_interval=1 \
--report_interval_seconds=1 \
--report_file=o.ld.rep.$sfx2 \
--max_background_compactions=6 \
--max_background_flushes=4 \
--max_write_buffer_number=4 \
--cache_high_pri_pool_ratio=0.5 \
--pin_l0_filter_and_index_blocks_in_cache=true \
--level0_file_num_compaction_trigger=4 \
--level0_slowdown_writes_trigger=20 \
--level0_stop_writes_trigger=40 \
--num=$nkeys \
--disable_wal=true \
--block_size=$bs \
--num_levels=8 \
--use_direct_reads=true \
--use_direct_io_for_flush_and_compaction=true \
--writable_file_max_buffer_size=$wfby \
--stats_level=3 \
--cache_numshardbits=7 \
--compaction_readahead_size=$(( $M1 * 1 )) \
--compaction_style=0 \
--write_buffer_size=$(( $M1 * 64 )) \
--max_bytes_for_level_base=$(( $M1 * 256 )) \
--target_file_size_base=$(( $M1 * 64 )) \
--compression_type=none \
--key_size=48 \
--db=$dbdir \
$dbopt \
--use_existing_db=false \
--cache_size=$cby \
--benchmarks=fillseq,stats,levelstats"

echo $cmd > o.ld.out.$sfx2

/usr/bin/time -f '%e %U %S' -o o.ld.time.$sfx2 $cmd >> o.ld.out.$sfx2 2>&1

kill $iopid
kill $vmpid
kill $duid1
kill $psid
