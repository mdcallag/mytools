
# --num in millions 
mkeys=$1
# --block_size
bs=$2
# --cache_size in GB
cgb=$3
# --writable_file_max_buffer_size in MB
wfmb=$4
# number of seconds for --duration
nsecs=$5
# yes to restore seed database rather than use what is currently there
restore_db=$6
# one of: hwperf, all_random, all_dist, prefix_random, prefix_dist
workload=$7
# all, put, get or seek
operations=$8
# if > 1 then --num_multi_db is used
numdb=$9

if [ $numdb -gt 1 ]; then
  dbpfx="multidb_$numdb"
  dbopt="--num_multi_db=$numdb"
else
  dbpfx="db_apdx"
  dbopt=""
fi

nkeys=$(( $mkeys * 1000 * 1000 ))
cby=$(( 1024 * 1024 * 1024 * $cgb ))
wfby=$(( 1024 * 1024 * $wfmb ))

sfx="k_${mkeys}.${dbpfx}.bs_${bs}"
dbdir=/data/m/rx.$sfx

if [ $restore_db == "yes" ]; then
  echo restore $dbdir at $( date )
  rm -rf $dbdir
  cp -r $dbdir.bak $dbdir
  sync; sleep 1; sync; sleep 1
fi

if [ $operations == "all" ]; then
  ratios="--mix_get_ratio=0.83 --mix_put_ratio=0.14 --mix_seek_ratio=0.03"
elif [ $operations == "put" ]; then
  ratios="--mix_get_ratio=0 --mix_put_ratio=1 --mix_seek_ratio=0"
elif [ $operations == "get" ]; then
  ratios="--mix_get_ratio=1 --mix_put_ratio=0 --mix_seek_ratio=0"
elif [ $operations == "seek" ]; then
  ratios="--mix_get_ratio=0 --mix_put_ratio=0 --mix_seek_ratio=1"
else
  echo "operations :: $operations :: not supported"
  exit 1
fi

if [ $workload == "hwperf" ]; then
  # from tests used by HW perf team 
  wl_opts="--key_dist_a=0.002312 --key_dist_b=0.3467 --value_k=0.2615 --value_sigma=25.45 $ratios"

elif [ $workload == "all_random" ]; then
  # from paper, all_random
  wl_opts=="--keyrange_num=1 --value_k=0.2615 --value_sigma=25.45 --iter_k=2.517 --iter_sigma=14.236 $ratios --sine_mix_rate_interval_milliseconds=5000 --sine_a=1000 --sine_b=0.000073 --sine_d=4500"

elif [ $workload == "all_dist" ]; then
  # from paper, all_dist
  wl_opts="--key_dist_a=0.002312 --key_dist_b=0.3467 --keyrange_num=1 --value_k=0.2615 --value_sigma=25.45 --iter_k=2.517 --iter_sigma=14.236 $ratios --sine_mix_rate_interval_milliseconds=5000 --sine_a=1000 --sine_b=0.000073 --sine_d=4500"

elif [ $workload == "prefix_random" ]; then
  # from paper, prefix_random
  wl_opts="--keyrange_dist_a=14.18 keyrange_dist_c=0.0164 --keyrange_dist_b=-2.917 --keyrange_dist_d=-0.08082 --keyrange_num=30 --value_k=0.2615 --value_sigma=25.45 --iter_k=2.517 --iter_sigma=14.236 $ratios --sine_mix_rate_interval_milliseconds=5000 --sine_a=1000 --sine_b=0.000073 --sine_d=4500"

elif [ $workload == "prefix_dist" ]; then
  # from paper, prefix_dist
  wl_opts="--key_dist_a=0.002312 --key_dist_b=0.3467 --keyrange_dist_a=14.18 --keyrange_dist_b=-2.917 --keyrange_dist_c=0.0164 --keyrange_dist_d=-0.08082 --keyrange_num=30 --value_k=0.2615 --value_sigma=25.45 --iter_k=2.517 --iter_sigma=14.236 $ratios --sine_mix_rate_interval_milliseconds=5000 --sine_a=1000 --sine_b=0.000073 --sine_d=4500"

else
  echo workload :: $workload :: not supported
  exit 1
fi

sfx2="$sfx.cgb_${cgb}.wfmb_${wfmb}.$workload.op_${operations}"
M1=$(( 1024 * 1024 ))

# While the load uses --value_size, the mixgraph benchmark has other options for that

cmd_base="./db_bench \
--statistics=1 \
--stats_interval_seconds=60 \
--stats_per_interval=1 \
--report_interval_seconds=1 \
--report_file=o.run.rep.$sfx2 \
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
--use_existing_db=1 \
--cache_size=$cby \
--duration=$nsecs \
--benchmarks=mixgraph,stats,levelstats"

killall iostat 2> /dev/null
killall vmstat 2> /dev/null

iostat -y -mx 1 >& o.run.io.$sfx2 &
iopid=$!

vmstat 1 >& o.run.vm.$sfx2 &
vmpid=$!

while :; do du -hs $dbdir; date ; sleep 10; done >& o.run.du1.$sfx2 &
duid1=$!

while :; do ps aux | grep db_bench | grep -v grep | tail -1; sleep 10; done >& o.run.ps.$sfx2 &
psid=$!

cmd="$cmd_base $wl_opts"
echo $cmd > o.run.out.$sfx2

/usr/bin/time -f '%e %U %S' -o o.run.time.$sfx2 $cmd >> o.run.out.$sfx2 2>&1

kill $iopid
kill $vmpid
kill $duid1
kill $psid

bc_miss=$( grep "rocksdb.block.cache.miss" o.run.out.$sfx2 | grep COUNT | awk '{ print $4 }' )
bc_hit=$( grep "rocksdb.block.cache.hit" o.run.out.$sfx2 | grep COUNT | awk '{ print $4 }' )
bc_hit_percent=$( echo $bc_hit $bc_miss | awk '{ p = 100 * ($1 / ( $1 + $2 )); printf "%.1f", p }' )

echo -e "block cache hit percent\t$bc_hit_percent" > o.run.sum.$sfx2
grep "^Cumulative writes" o.run.out.$sfx2 | tail -1 >> o.run.sum.$sfx2
grep "^mixgraph" o.run.out.$sfx2 >> o.run.sum.$sfx2
grep "avg_val_size" o.run.out.$sfx2 >> o.run.sum.$sfx2
grep md2 o.run.io.$sfx2 | awk '{ s +=1; r += $2; rMB += $4; wMB += $5 } END { printf "IO samples, rps, rMB/s, wMB/s:\t%d\t%.0f\t%.1f\t%.1f\n", s, r/s, rMB/s, wMB/s }' >> o.run.sum.$sfx2

o_ps=$( grep "^mixgraph" o.run.out.$sfx2 | awk '{ print $5 }' )
if grep ^mixgraph o.run.out.$sfx2 | grep MB ; then
  z1=10; z2=11; z3=12
else
  z1=8; z2=9; z3=10
fi
get_ps=$( grep "^mixgraph" o.run.out.$sfx2 | awk '{ print $cn }' cn=$z1 | tr ':' ' ' | awk '{ printf "%.0f", $2 / nsecs }' nsecs=$nsecs )
put_ps=$( grep "^mixgraph" o.run.out.$sfx2 | awk '{ print $cn }' cn=$z2 | tr ':' ' ' | awk '{ printf "%.0f", $2 / nsecs }' nsecs=$nsecs )
seek_ps=$( grep "^mixgraph" o.run.out.$sfx2 | awk '{ print $cn }' cn=$z3 | tr ':' ' ' | awk '{ printf "%.0f", $2 / nsecs }' nsecs=$nsecs )

# IO per second (_ps)
r_ps=$( grep "^IO " o.run.sum.$sfx2 | awk '{ print $7 }' )
rMB_ps=$( grep "^IO " o.run.sum.$sfx2 | awk '{ print $8 }' )
wMB_ps=$( grep "^IO " o.run.sum.$sfx2 | awk '{ print $9 }' )

# IO per operation (_po)
r_po=$( echo $o_ps $r_ps | awk '{ printf "%.2f", $2 / $1 }' )
rKB_po=$( echo $o_ps $rMB_ps | awk '{ printf "%.2f", ( $2 * 1024 ) / $1 }' )
wKB_po=$( echo $o_ps $wMB_ps | awk '{ printf "%.2f", ( $2 * 1024 ) / $1 }' )

# IO per seek+get and per put (_pr, _pp)
r_pr="0"
rKB_pr="0"
if [[ $get_ps -gt 0 || $seek_ps -gt 0 ]]; then
  r_pr=$( echo $get_ps $seek_ps $r_ps | awk '{ printf "%.2f", $3 / ( $1 + $2 ) }' )
  rKB_pr=$( echo $get_ps $seek_ps $rMB_ps | awk '{ printf "%.2f", ( $3 * 1024 ) / ( $1 + $2 ) }' )
fi

wKB_pp="0"
if [ $put_ps -gt 0 ]; then
  wKB_pp=$( echo $put_ps $wMB_ps | awk '{ printf "%.2f", ( $2 * 1024 ) / $1 }' )
fi

echo -e "o/s\tget/s\tput/s\tseek/s\tr/s\trMB/s\twMB/s\tr/o\trKB/o\twKB\o\tr/s+g\trKB/s+g\twKB/p" >> o.run.sum.$sfx2
echo -e "$o_ps\t$get_ps\t$put_ps\t$seek_ps\t$r_ps\t$rMB_ps\t$wMB_ps\t$r_po\t$rKB_po\t$wKB_po\t$r_pr\t$rKB_pr\t$wKB_pp" >> o.run.sum.$sfx2

echo
echo Done for $sfx2 at $( date )
cat o.run.sum.$sfx2
echo

