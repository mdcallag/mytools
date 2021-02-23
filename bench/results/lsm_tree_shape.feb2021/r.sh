
num=$1
nw=$2
nr=$3

trig=8

wbs=8000000

args=( --num=$num --reads=$nr --key_size=8 --value_size=128 --write_buffer_size=$wbs --target_file_size_base=$wbs --compression_type=none --max_bytes_for_level_base=$(( $trig * $wbs )) --cache_size=$(( 1024 * 1024 * 1024 )) --seek_nexts=8 --stats_per_interval=1 --stats_interval_seconds=100 --cache_index_and_filter_blocks=1 --level_compaction_dynamic_level_bytes=1 --level0_file_num_compaction_trigger=$trig --level0_slowdown_writes_trigger=$(( $trig * 4 )) --level0_stop_writes_trigger=$(( $trig * 5 )) --max_write_buffer_number=2 --db=/data/m/rx --open_files=50000 --max_background_jobs=4 )
bb="--bloom_bits=10"

echo load range
./db_bench ${args[@]} $bb --benchmarks=fillrandom,stats,waitforcompaction,stats,flush,compact0,stats,waitforcompaction,stats 2>&1 | tee o.range1
echo run range
./db_bench ${args[@]} $bb --use_existing_db=1 --writes=$nw --benchmarks=overwrite,stats,waitforcompaction,stats,seekrandom,seekrandom,flush,waitforcompaction,stats,seekrandom,seekrandom,compact0,waitforcompaction,stats,seekrandom,seekrandom,compact1,stats,seekrandom,seekrandom,compactall,waitforcompaction,stats,seekrandom,seekrandom 2>&1 | tee o.range2

echo load point with bloom
./db_bench ${args[@]} $bb --benchmarks=fillrandom,stats,waitforcompaction,stats,flush,compact0,stats,waitforcompaction,stats 2>&1 | tee o.point1
echo run point without bloom
./db_bench ${args[@]} $bb --use_existing_db=1 --writes=$nw --benchmarks=overwrite,stats,waitforcompaction,stats,readrandom,readrandom,flush,waitforcompaction,stats,readrandom,readrandom,compact0,waitforcompaction,stats,readrandom,readrandom,compact1,stats,readrandom,readrandom,compactall,waitforcompaction,stats,readrandom,readrandom 2>&1 | tee o.point2

echo load point with bloom
./db_bench ${args[@]} --benchmarks=fillrandom,stats,waitforcompaction,stats,flush,compact0,stats,waitforcompaction,stats 2>&1 | tee o.pointnobloom1
echo run point without bloom
./db_bench ${args[@]} --use_existing_db=1 --writes=$nw --benchmarks=overwrite,stats,waitforcompaction,stats,readrandom,readrandom,flush,waitforcompaction,stats,readrandom,readrandom,compact0,waitforcompaction,stats,readrandom,readrandom,compact1,stats,readrandom,readrandom,compactall,waitforcompaction,stats,readrandom,readrandom 2>&1 | tee o.pointnobloom2

echo range > o.all
grep micros o.range2 | grep seekrandom | awk '{ if (NR % 2 == 0) { print $0 } }' >> o.all
echo >> o.all

echo point with bloom >> o.all
grep micros o.point2 | grep readrandom | awk '{ if (NR % 2 == 0) { print $0 } }' >> o.all

echo point without bloom >> o.all
grep micros o.pointnobloom2 | grep readrandom | awk '{ if (NR % 2 == 0) { print $0 } }' >> o.all
cat o.all
