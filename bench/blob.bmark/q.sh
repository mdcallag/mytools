dbdir=$1
nsecs=$2
nthr=$3
cachemb=$4
# no, memtable, L0, L1
cleanup_state=$5
cleanup_todo=$6
nmkeys=$7
dev_suffix=$8
# yes if database loaded by fillrandom in which case --use_existing_keys must be used.
# Note that --use_existing_keys can be very slow at startup thanks to
# much random IO when O_DIRECT is done for user reads.
fillrand=$9
block_align=${10}
val_size=${11}
odirect=${12}

if [ $fillrand == "yes" ]; then
  existingkeys=1
else
  existingkeys=0
fi

if [ $odirect == "yes" ]; then
  odirect_flags="--use_direct_io_for_flush_and_compaction --use_direct_reads"
fi

killall -q iostat
killall -q vmstat

sfx=nthr${nthr}.cachemb${cachemb}.cleanup${cleanup_state}.existkey${existingkeys}.nmkeys${nmkeys}.val${val_size}.odirect${odirect}

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

/usr/bin/time -o o.q.time.$sfx -f '%e %U %S' \
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
  $odirect_flags \
  --report_file=o.q.rep.$sfx \
  --report_interval_seconds=1 \
  --block_align=$block_align \
  --compression_type=none \
  --seed=1056573037454101 >> o.q.res.$sfx 2>&1

echo "dbdir=$dbdir, nsecs=$nsecs" >> o.q.res.$sfx

kill $ipid
kill $vpid

qps=$( grep ^readrandom o.q.res.$sfx | awk '{ printf "%.1f", $5 }' )
total_ops=$( grep ^readrandom o.q.res.$sfx | awk '{ printf "%.1f", $9 }' )

user_cpu=$( cat o.q.time.$sfx | awk '{ print $2 }' )
sys_cpu=$( cat o.q.time.$sfx | awk '{ print $3 }' )

cpu_usecs_per_query=$( echo $user_cpu $sys_cpu $total_ops | awk '{ printf "%.1f", (1000000.0 * ($1 + $2)) / $3 }' )
user_cpu_usecs_per_query=$( echo $user_cpu $total_ops | awk '{ printf "%.1f", (1000000.0 * $1) / $2 }' )
sys_cpu_usecs_per_query=$( echo $sys_cpu $total_ops | awk '{ printf "%.1f", (1000000.0 * $1) / $2 }' )

#Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
rps_col=$( iostat -kx 1 1 | grep r\/s | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "r/s") { found=n } } } END { printf "%s", found }' )
r_await_col=$( iostat -kx 1 1 | grep r_await | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "r_await") { found=n } } } END { printf "%s", found }' )
rareq_sz_col=$( iostat -kx 1 1 | grep rareq\-sz | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "rareq-sz") { found=n } } } END { printf "%s", found }' )
aqu_sz_col=$( iostat -kx 1 1 | grep aqu\-sz | head -1 | awk '{ found=0; for (n=1; n<=NF; n+=1) { if ($n == "aqu-sz") { found=n } } } END { printf "%s", found }' )

rps=NA
rps_qps_ratio=NA
if [ $rps_col -gt 0 ]; then
  rps=$( grep $dev_suffix o.q.io.$sfx | awk '{ c+=1; rps += $colno } END { printf "%.0f", rps/c }' colno=$rps_col )
  rps_qps_ratio=$( echo $rps $qps | awk '{ printf "%.3f", $1 / $2 }' )
fi
r_await=NA
if [ $r_await_col -gt 0 ]; then
  r_await=$( grep $dev_suffix o.q.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.3f", v/c }' colno=$r_await_col )
fi
rareq_sz=NA
if [ $rareq_sz_col -gt 0 ]; then
  rareq_sz=$( grep $dev_suffix o.q.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.3f", v/c }' colno=$rareq_sz_col )
fi
aqu_sz=NA
if [ $aqu_sz_col -gt 0 ]; then
  aqu_sz=$( grep $dev_suffix o.q.io.$sfx | awk '{ c+=1; v += $colno } END { printf "%.1f", v/c }' colno=$aqu_sz_col )
fi

res_line=$( grep ^readrandom o.q.res.$sfx )

avg_cs=$( cat o.q.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $1 }' )
avg_us=$( cat o.q.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $2 }' )
avg_sy=$( cat o.q.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $3 }' )
avg_us_sy=$( cat o.q.vm.$sfx | grep -v procs | grep -v swpd | awk '{ c += 1; cs += $12; us += $13; sy += $14 } END { printf "%.0f\t%.1f\t%.1f\t%.1f\n", cs/c, us/c, sy/c, (us+sy)/c }' | awk '{ print $4 }' )

echo "$res_line nthr=$nthr qps=$qps io_per_query=$rps_qps_ratio"
echo "cpu_usecs_per_query(user,sys,total)=($user_cpu_usecs_per_query, $sys_cpu_usecs_per_query, $cpu_usecs_per_query) vmstat(cs,us,sy,us+sy)=($avg_cs, $avg_us, $avg_sy, $avg_us_sy) iostat(rps,r_await,rareq-sz,aqu-sz=($rps, $r_await, $rareq_sz, $aqu_sz)"

