# OPT="-DNDEBUG -O2" make db_bench # DEBUG_LEVEL=0 make db_bench
dbdir=$1
keys=$2
secs=$3
nthreads=$4
rowlen=$5
wkb_per_sec=$6
write_buf_mb=$7
max_bg_thr=$8
l0=$9
l1_mb=${10}
fanout=${11}
min_level_compress=${12}
comp_type=${13}
cache_mb=${14}
bg_io_mb=${15}
secs_debt=${16}
dbversion=${17}
dbbench=${18}
bloombits=${19}
nfiles=${20}

# Comments on the command line options
# arg 1 - database directory. This must exist. The test won't create it.
# arg 2 - number of keys (keys == rows) to Put into RocksDB
# arg 3 - number of seconds for which each test is run. See below for the tests that are run.
# arg 4 - number of user threads that will be created
# arg 5 - number of bytes for the values that are Put into RocksDB
# arg 6 - rate limit in KB/sec for tests that rate limit the writers
# arg 7 - sets the size of the write buffer (memtable). I usually use 32mb or 64mb for the write buffer
# arg 8 - sets the number of background compaction threads. Start with number-real-cores / 4. Compaction
#         needs CPU but if there are too many then some will get starved and you all need CPU for the
#         application and request handling.
# arg 9 - determines values for l0 compaction, slowdown and stop triggers: x1, x4 and x5
# arg 10 - target size for level 1 of the LSM tree. I usually use 256mb, 512mb or 1024mb. Note that I
#         configured compaction to start when there are 4 files in level 0
#         (--level0_file_num_compaction_trigger=4) and I want sizeof(L0) ~= sizeof(L1) when compaction occurs.
#         The size of L0 files is determined by the size of the write buffer (see arg7). So if you adjust
#         arg 7 then adjust this arg.
# arg 11 - per-level fanout, default is 10
# arg 12 - first level in the LSM tree to compress. I usually start compression on level 3 and leave levels 0,
#         1 and 2 uncompressed. I don't compress small levels because the CPU cost is high, but the space
#         savings are small. Compressing L0, L1 and L2 would reduce the total write-rate & write-amplification
#         from compaction, but I don't think it is worth it. Compaction stalls usually happen from L0->L1
#         compaction or from L1->L2 compaction and compression makes that slower, so it increases stalls.
# arg 13 - compression type. This is your choice but when choosing between zstd and zlib I prefer zstd.
#         See http://smalldatum.blogspot.com/2016/09/zlib-vs-zstd-for-myrocks-running.html
# arg 14 - size of the RocksDB block cache. My advice is at
#         http://smalldatum.blogspot.com/2016/09/tuning-rocksdb-block-cache.html
# arg 15 - an estimate of the IO rate that storage & RocksDB supports
# arg 16 - used for compaction throttling. The number of seconds of "IO debt" I allow RocksDB to have before
#          throttling writes. Used with arg 13.
# arg 17 - release number that determines which RocksDB options are used to support this script across many
#          versions. I don't update this for every release so only a few versions are valid. And "leveldb"
#          is a valid version.
# arg 18 - path to db_bench
# arg 19 - bloom bits, when -1 then no bloom
# arg 20 - number of open files

xkeys=$(( $keys * 1000 ))

if [[ $dbversion = "4.1" ]] ; then
  wps=$(( ( 1024 * $wkb_per_sec) / ( $rowlen + 12 ) ))
  ddds="--disable_data_sync=0"
  cpri=""
elif [[ $dbversion = "4.5" ]] ; then
  wps=$(( 1024 * $wkb_per_sec ))
  ddds="--disable_data_sync=0"
  cpri=""
  echo "using 4.5"
elif [[ $dbversion = "5.4" || $dbversion = "5.8" ]] ; then
  wps=$(( 1024 * $wkb_per_sec ))
  ddds=""
  # enable kMinOverlappingRatio
  cpri="--compaction_pri=3"
  echo "using $dbversion"
elif [[ $dbversion = "leveldb" ]]; then
  wps="" 
  ddds=""
  cpri=""
  echo "using $dbversion"
else
  echo Version $dbversion not supported
  exit -1
fi

killall vmstat
killall iostat

sfx=N${keys}.S${secs}.T${nthreads}

if [[ $dbversion != "leveldb" ]]; then

f1="\
--stats_per_interval=1 \
--stats_interval_seconds=10 \
--num=$keys \
--value_size=$rowlen \
--key_size=8 \
--max_write_buffer_number=4 \
--write_buffer_size=$(( 1024 * 1024 * $write_buf_mb )) \
--target_file_size_base=$(( 1024 * 1024 * $write_buf_mb )) \
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
--bloom_bits=$bloombits \
--open_files=$nfiles \
--sync=0 \
--disable_wal=0 \
$dds \
$cpri \
--max_total_wal_size=$(( 1024 * 1024 * 1024 )) \
--verify_checksum=1 \
--allow_concurrent_memtable_write \
--max_bytes_for_level_multiplier=$fanout \
--level0_file_num_compaction_trigger=$l0 \
--level0_slowdown_writes_trigger=$(( $l0 * 4 )) \
--level0_stop_writes_trigger=$(( $l0 * 5 )) \
--hard_pending_compaction_bytes_limit=$(( 1024 * 1024 * $bg_io_mb * $secs_debt )) "

f2="\
--use_existing_db=0 \
--threads=1"

else

f1="\
--num=$keys \
--value_size=$rowlen \
--write_buffer_size=$(( 1024 * 1024 * $write_buf_mb )) \
--block_size=8192 \
--cache_size=$(( 1024 * 1024 * $cache_mb )) \
--max_file_size=$(( 1024 * 1024 * $write_buf_mb )) \
--histogram=0 \
--bloom_bits=$bloombits \
--open_files=$nfiles"

f2="\
--use_existing_db=0 \
--threads=1"

fi

if [[ $dbversion = "leveldb" ]]; then
seed=""
seedval=""
else
seed="--seed="
seedval=$( date +%s )
fi

ps aux | grep db_bench | grep -v grep

echo Run fillrandom $keys keys $( date )
vmstat 10 >& o.vm.fillrandom.$sfx &
vpid=$!
iostat -kx 10 >& o.io.fillrandom.$sfx &
ipid=$!
while :; do ps aux | grep db_bench; sleep 10; done >& o.ps.fillrandom.$sfx &
ppid=$!
${dbbench} --db=$dbdir --benchmarks=fillrandom $f1 $f2 ${seed}${seedval} >& o.fillrandom.$sfx
estat=$?
echo ${dbbench} --db=$dbdir --benchmarks=fillrandom,levelstats,memstats,stats $f1 $f2 ${seed}${seedval} >> o.fillrandom.$sfx
if [ $estat -ne 0 ]; then echo "overwrite failed"; echo "failed" >> o.fillrandom.$sfx; exit 1 ; fi
du -hs $dbdir >> o.fillrandom.$sfx
kill $vpid
kill $ipid
kill $ppid

grep "^fillrandom" o.fillrandom.$sfx > o.res.$sfx
grep "Cumulative stall" o.fillrandom.$sfx >> o.res.$sfx

ps aux | grep db_bench | grep -v grep

