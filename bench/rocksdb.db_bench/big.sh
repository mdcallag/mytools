# OPT="-DNDEBUG -O2" make db_bench 
# DEBUG_LEVEL=0 make db_bench

dbdir=$1
keys=$2
secs=$3
rowlen=$4
write_buf_mb=$5
max_bg_thr=$6
l1_mb=$7
min_level_compress=${8}
comp_type=${9}
cache_mb=${10}
bg_io_mb=${11}
secs_debt=${12}

# Comments on the command line options
# arg 5 - this sets the size of the write buffer (memtable). I usually use 32mb or 64mb for the write buffer
# arg 6 - this sets the number of background compaction threads. Start with number-real-cores / 4. Compaction
#         needs CPU but if there are too many then some will get starved and you all need CPU for the
#         application and request handling.
# arg 7 - the target size for level 1 of the LSM tree. I usually use 256mb, 512mb or 1024mb. Note that I
#         configured compaction to start when there are 4 files in level 0
#         (--level0_file_num_compaction_trigger=4) and I want sizeof(L0) ~= sizeof(L1) when compaction occurs.
#         The size of L0 files is determined by the size of the write buffer (see arg7). So if you adjust
#         arg 7 then adjust this arg.
# arg 8  - first level in the LSM tree to compress. I usually start compression on level 3 and leave levels 0,
#         1 and 2 uncompressed. I don't compress small levels because the CPU cost is high, but the space
#         savings are small. Compressing L0, L1 and L2 would reduce the total write-rate & write-amplification
#         from compaction, but I don't think it is worth it. Compaction stalls usually happen from L0->L1
#         compaction or from L1->L2 compaction and compression makes that slower, so it increases stalls.
# arg 9  - compression type. This is your choice but when choosing between zstd and zlib I prefer zstd.
#         See http://smalldatum.blogspot.com/2016/09/zlib-vs-zstd-for-myrocks-running.html
# arg 10 - size of the RocksDB block cache. My advice is at
#         http://smalldatum.blogspot.com/2016/09/tuning-rocksdb-block-cache.html
# arg 11 - an estimate of the IO rate that storage & RocksDB supports
# arg 12 - used for compaction throttling. The number of seconds of "IO debt" I allow RocksDB to have before
#         throttling writes. Used with arg 13.

rm -rf $dbdir; mkdir $dbdir

killall vmstat
killall iostat

sfx=N${keys}.S${secs}

f1="\
--stats_per_interval=1 \
--stats_interval_seconds=10 \
--num=$keys \
--value_size=$rowlen \
--key_size=8 \
--max_write_buffer_number=4 \
--write_buffer_size=$(( 1024 * 1024 * $write_buf_mb )) \
--target_file_size_base=$(( 1024 * 1024 * 32 )) \
--max_background_compactions=$max_bg_thr \
--max_background_flushes=2 \
--cache_index_and_filter_blocks=1 \
--pin_l0_filter_and_index_blocks_in_cache=1 \
--block_size=8192 \
--cache_size=$(( 1024 * 1024 * $cache_mb )) \
--level_compaction_dynamic_level_bytes=1 \
--max_bytes_for_level_base=$(( 1024 * 1024 * $l1_mb )) \
--compression_type=${comp_type} \
--min_level_to_compress=$min_level_compress \
--bytes_per_sync=$(( 1024 * 1024 * 8 )) \
--wal_bytes_per_sync=$(( 1024 * 1024 * 8 )) \
--statistics=0 \
--histogram=0 \
--bloom_bits=10 \
--open_files=-1 \
--sync=0 \
--disable_wal=0 \
--disable_data_sync=0 \
--max_total_wal_size=$(( 1024 * 1024 * 1024 )) \
--verify_checksum=1"

f2="\
--use_existing_db=0 \
--memtablerep=vector \
--threads=1 \
--disable_wal=1"

echo Run fillseq $keys keys $( date )
vmstat 10 >& o.vm.fillseq.$sfx &
vpid=$!
iostat -kx 10 >& o.io.fillseq.$sfx &
ipid=$!
./db_bench --db=$dbdir --benchmarks=fillseq $f1 $f2 --seed=$( date +%s ) >& o.fillseq.$sfx
echo db_bench --db=$dbdir --benchmarks=fillseq $f1 $f2 --seed=$( date +%s ) >> o.fillseq.$sfx
du -hs $dbdir >> o.fillseq.$sfx
kill $vpid
kill $ipid

f2="\
--duration=$secs \
--use_existing_db=1 \
--level0_file_num_compaction_trigger=4 \
--level0_slowdown_writes_trigger=20 \
--level0_stop_writes_trigger=30 \
--hard_pending_compaction_bytes_limit=$(( 1024 * 1024 * $bg_io_mb * $secs_debt ))  \
--rate_limiter_bytes_per_sec=$(( 1024 * 1024 * $bg_io_mb )) \
--soft_pending_compaction_bytes_limit=$(( 1024 * 512 * $bg_io_mb * $secs_debt )) "

rm -f o.res.$sfx
echo "before" >> o.res.$sfx

t=readrandom
for c in 1 2 4 8 16 ; do
echo Run $t dop=$c $secs seconds at $( date )
vmstat 10 >& o.vm.$t.1.$c.secs.$sfx &
vpid=$!
iostat -kx 10 >& o.io.$t.1.$c.secs.$sfx &
ipid=$!
./db_bench --db=$dbdir --benchmarks=$t $f1 $f2 --seed=$( date +%s ) --threads=$c >& o.$t.1.$c.secs.$sfx
echo db_bench --db=$dbdir --benchmarks=$t $f1 $f2 --seed=$( date +%s ) --threads=$c >> o.$t.1.$c.secs.$sfx
du -hs $dbdir >> o.$t.1.$c.secs.$sfx
kill $vpid
kill $ipid
grep "^$t" o.$t.1.$c.secs.$sfx >> o.res.$sfx
done

f2="\
--writes=$keys \
--use_existing_db=1 \
--threads=1 \
--level0_file_num_compaction_trigger=4 \
--level0_slowdown_writes_trigger=20 \
--level0_stop_writes_trigger=30 \
--hard_pending_compaction_bytes_limit=$(( 1024 * 1024 * $bg_io_mb * $secs_debt )) \
--soft_pending_compaction_bytes_limit=$(( 1024 * 512 * $bg_io_mb * $secs_debt ))"

echo Run overwrite $keys keys at $( date )
vmstat 10 >& o.vm.overwrite.all.$sfx &
vpid=$!
iostat -kx 10 >& o.io.overwrite.all.$sfx &
ipid=$!
./db_bench --db=$dbdir --benchmarks=overwrite $f1 $f2 --seed=$( date +%s ) >& o.overwrite.all.$sfx
echo db_bench --db=$dbdir --benchmarks=overwrite $f1 $f2 --seed=$( date +%s ) >> o.overwrite.all.$sfx
du -hs $dbdir >> o.overwrite.all.$sfx
kill $vpid
kill $ipid

f2="\
--duration=$secs \
--use_existing_db=1 \
--level0_file_num_compaction_trigger=4 \
--level0_slowdown_writes_trigger=20 \
--level0_stop_writes_trigger=30 \
--hard_pending_compaction_bytes_limit=$(( 1024 * 1024 * $bg_io_mb * $secs_debt ))  \
--rate_limiter_bytes_per_sec=$(( 1024 * 1024 * $bg_io_mb )) \
--soft_pending_compaction_bytes_limit=$(( 1024 * 512 * $bg_io_mb * $secs_debt )) "

echo "after" >> o.res.$sfx
t=readrandom
for c in 1 2 4 8 16 ; do
echo Run $t dop=$c $secs seconds at $( date )
vmstat 10 >& o.vm.$t.2.$c.secs.$sfx &
vpid=$!
iostat -kx 10 >& o.io.$t.2.$c.secs.$sfx &
ipid=$!
./db_bench --db=$dbdir --benchmarks=$t $f1 $f2 --seed=$( date +%s ) --threads=$c >& o.$t.2.$c.secs.$sfx
echo db_bench --db=$dbdir --benchmarks=$t $f1 $f2 --seed=$( date +%s ) --threads=$c >> o.$t.2.$c.secs.$sfx
du -hs $dbdir >> o.$t.2.$c.secs.$sfx
kill $vpid
kill $ipid
grep "^$t" o.$t.2.$c.secs.$sfx >> o.res.$sfx
done

