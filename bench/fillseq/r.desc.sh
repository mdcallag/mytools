nk=$1

dbb="db_bench.v6.26.1.fillseq.desc"

ddir=/data/m/rx
rm -rf $ddir
mkdir -p $ddir

usex=0
/usr/bin/time -f '%e %U %S' -o o.time1 numactl --interleave=all ./${dbb} --benchmarks=fillseq --allow_concurrent_memtable_write=false --level0_file_num_compaction_trigger=4 --level0_slowdown_writes_trigger=20 --level0_stop_writes_trigger=30 --max_background_jobs=8 --max_write_buffer_number=8 --db=$ddir --wal_dir=$ddir --num=$nk --num_levels=8 --key_size=20 --value_size=400 --block_size=8192 --cache_size=51539607552 --cache_numshardbits=6 --compression_max_dict_bytes=0 --compression_ratio=0.5 --compression_type=none --bytes_per_sync=8388608 --cache_index_and_filter_blocks=1 --cache_high_pri_pool_ratio=0.5 --benchmark_write_rate_limit=0 --write_buffer_size=16777216 --target_file_size_base=16777216 --max_bytes_for_level_base=67108864 --verify_checksum=1 --delete_obsolete_files_period_micros=62914560 --max_bytes_for_level_multiplier=8 --statistics=0 --stats_per_interval=1 --stats_interval_seconds=10 --histogram=1 --memtablerep=skip_list --bloom_bits=10 --open_files=-1 --subcompactions=1 --compaction_style=0 --min_level_to_compress=3 --level_compaction_dynamic_level_bytes=true --pin_l0_filter_and_index_blocks_in_cache=1 --soft_pending_compaction_bytes_limit=167503724544 --hard_pending_compaction_bytes_limit=335007449088 --min_level_to_compress=0 --use_existing_db=$usex --sync=0 --threads=1 --memtablerep=vector --allow_concurrent_memtable_write=false --disable_wal=1 --seed=1641328309 2>&1 | tee -a o.log1

rdir=r.desc
rm -rf $rdir; mkdir $rdir
mv o.log1 $rdir
mv o.time1 $rdir

