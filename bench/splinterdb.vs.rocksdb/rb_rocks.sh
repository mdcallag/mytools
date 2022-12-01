nr=$1
dbdir=$2
usenuma=$3
rowlen=$4
cachegb=$5
getperf=$6
# uf means use_fsync
uf=$7
# comp is lc or uc for leveled or universal
comp=$8
nsecs=$9
devname=${10}

tfb=$(( 64 * 1024 * 1024 ))
comptrig=4
rangelen=10
keylen=20

both_opt="\
--db=$dbdir \
--disable_wal=true \
--write_buffer_size=$tfb --target_file_size_base=$tfb --max_bytes_for_level_base=$(( $comptrig * $tfb )) \
--pin_l0_filter_and_index_blocks_in_cache=1 \
--bloom_bits=10 \
--open_files=-1 \
--key_size=$keylen --value_size=$rowlen \
--max_background_jobs=4 --threads=1 \
--compression_type=none \
--block_size=4096 \
--cache_size=$(( $cachegb * 1024 * 1024 * 1024 )) \
--bytes_per_sync=$(( 1024 * 1024 )) \
--seek_nexts=$rangelen \
--stats_per_interval=1 --stats_interval_seconds=60 \
"

uc_opt="\
--compaction_style=1 \
--level0_file_num_compaction_trigger=$(( 2 * $comptrig )) --level0_slowdown_writes_trigger=$(( 5 * $comptrig )) --level0_stop_writes_trigger=$(( 10 * $comptrig ))  \
--universal_min_merge_width=4 \
--universal_max_merge_width=12 \
--universal_max_size_amplification_percent=200 \
--universal_allow_trivial_move=1 \
--num_levels=40 \
"

lc_opt="\
--compaction_style=0 \
--level0_file_num_compaction_trigger=$comptrig --level0_slowdown_writes_trigger=$(( 4 * $comptrig )) --level0_stop_writes_trigger=$(( 8 * $comptrig ))  \
--level_compaction_dynamic_level_bytes=true \
--num_levels=8 \
"

if [ $usenuma == "yes" ]; then numactl="numactl --interleave=all" ; else numactl="" ; fi

killall iostat
killall vmstat

PERF_METRIC=${PERF_METRIC:-cycles}

get_perf=0

function start_perf {
  perf_secs=$1
  pause_secs=$2  
  bmark=$3

  x=1
  perfpid=0

  #fgp="$HOME/git/FlameGraph.me"
  #if [ ! -d $fgp ]; then echo FlameGraph not found; exit 1; fi
  echo PERF_METRIC is $PERF_METRIC

  sleep $pause_secs

  while :; do

    dbbpid=$( ps aux | grep db_bench | grep -v \/usr\/bin\/time | grep -v timeout | grep -v grep | awk '{ print $2 }' )
    if [ -z $dbbpid ]; then echo Cannot get db_bench PID; continue; fi

    ts=$( date +'%b%d.%H%M%S' )
    sfx="$bmark.$x.$ts"
    outf="bm.perf.rec.g.$sfx"
    echo "perf record -e $PERF_METRIC -c 500000 -g -p $dbbpid -o $outf -- sleep $perf_secs"
    perf record -e $PERF_METRIC -c 500000 -g -p $dbbpid -o $outf -- sleep $perf_secs

    #perf report --stdio --no-children -i $outf > bm.perf.rep.g.f0.c0.$sfx
    #perf report --stdio --children    -i $outf > bm.perf.rep.g.f0.c1.$sfx
    #perf report --stdio -n -g folded -i $outf > bm.perf.rep.g.f1.cother.$sfx
    perf report --stdio -n -g folded -i $outf --no-children > bm.perf.rep.g.f1.c0.$sfx
    perf report --stdio -n -g folded -i $outf --children > bm.perf.rep.g.f1.c1.$sfx
    perf script -i $outf > bm.perf.rep.g.scr.$sfx
    gzip --fast $outf
    #cat bm.perf.rep.g.scr.$sfx | $fgp/stackcollapse-perf.pl > bm.perf.g.fold.$sfx
    #$fgp/flamegraph.pl bm.perf.g.fold.$sfx > bm.perf.g.$sfx.svg
    gzip --fast bm.perf.rep.g.scr.$sfx

    sleep $pause_secs
    ts=$( date +'%b%d.%H%M%S' )
    sfx="$bmark.$x.$ts"
    outf="bm.perf.rec.f.$sfx"

    # perf record -c 500000 -p $dbbpid -o $outf -- sleep $perf_secs
    # perf report --stdio -i $outf > bm.perf.rep.f.$sfx
    # perf script -i $outf | gzip --fast > bm.perf.rep.f.scr.$sfx.gz
    gzip --fast $outf

    sleep $pause_secs
    x=$(( $x + 1 ))
  done &
  # This sets a global value
  perfpid=$!
}

if [ $getperf -eq 1 ]; then
  uf=0
  echo Cached, leveled, use_fsync=$uf at $( date ) with perf

  for bmark in fillseq waitforcompaction overwrite waitforcompaction readrandom seekrandom ; do

    if [ $bmark != "waitforcompaction" ]; then
      vmstat 1 >& bm.cached.vm.lc.uf${uf} &
      vpid=$!
      iostat -y -mx 1 >& bm.cached.io.lc.uf${uf} &
      ipid=$!
      start_perf 10 10 $bmark
      echo forked $ipid and $vpid and $perfpid
    fi

    if [ $bmark != "fillseq" ]; then
      ue=1
    else
      ue=0
    fi

    echo "$numactl ./db_bench $both_opt $lc_opt --benchmarks=$bmark --use_existing_db=$ue --num=$nr --use_fsync=$uf" > bm.cached.res.lc.uf${uf}.$bmark
    /usr/bin/time -f '%e %U %S' -o bm.cached.res.time.lc.uf${uf}.$bmark $numactl ./db_bench $both_opt $lc_opt --benchmarks=$bmark --use_existing_db=$ue --num=$nr --use_fsync=$uf >> bm.cached.res.lc.uf${uf}.$bmark 2>&1

    grep -E "^fillseq|^overwrite|^readrandom|^seekrandom" bm.cached.res.lc.uf${uf}.$bmark
    du -hs $dbdir >> bm.cached.res.lc.uf${uf}.$bmark
    du -hs $dbdir

    if [ $bmark != "waitforcompaction" ]; then
      kill $vpid
      kill $ipid
      kill $perfpid
      echo killed $ipid and $vpid and $perfpid
    fi

  done
fi

function start_stats {
  pfx=$1
  sfx=$2

  vmstat 1 >& $pfx.vm.$sfx &
  vpid=$!
  iostat -y -mx 1 >& $pfx.io.$sfx &
  ipid=$!
  echo forked $ipid and $vpid
}

function stop_stats {
  pfx=$1
  sfx=$2

  fname=$pfx.res.$sfx

  if [ $uf -eq 0 ]; then
    # To get accurate write-amp estimate, force database to disk if use_fsync=0
    sync; sync; sync; sleep 60
  fi

  grep -E "^fillseq|^fillrandom|^overwrite|^readrandom|^seekrandom" $fname
  du -hs $dbdir >> $fname
  du -hs $dbdir
  kill $vpid
  kill $ipid
  echo killed $ipid and $vpid

  echo -e "count\tIOwGB\tIOwMB/s\tUwGB\tWamp"
  gbwritten=$( echo $rowlen $keylen $nr | awk '{ printf "%.1f", (($1 + $2) * $3) / (1024*1024*1024.0) }' )
  grep $devname $pfx.io.$sfx | awk '{ c += 1; wmb += $9 } END { printf "%s\t%.1f\t%.1f\t%.1f\t%.1f\n", c, wmb/1024.0, wmb / c, gbw, (wmb/1024.0)/gbw }' gbw=$gbwritten  
}


sz=$( echo $nr | awk '{ printf "%.0fm", $1 / 1000000.0 }' )
ex_opt="--cache_index_and_filter_blocks=1 --cache_high_pri_pool_ratio=0.5"

if [ $comp == "lc" ]; then
  comp_opt="$lc_opt"
else
  comp_opt="$uc_opt"
fi

nreads=$( echo $nr $rangelen | awk '{ printf "%0", $1 / $2 }' )

echo $sz with $comp : use_fsync=$uf at $( date )

start_stats bm.$sz $comp.uf${uf}.1
cmd="$numactl ./db_bench $both_opt $comp_opt $ex_opt --benchmarks=fillrandom,stats --num=$nr --use_fsync=$uf --use_existing_db=0"
echo "$cmd" > bm.$sz.res.$comp.uf${uf}.1
/usr/bin/time -f '%e %U %S' -o bm.$sz.res.time.$comp.uf${uf} $cmd >> bm.$sz.res.$comp.uf${uf}.1 2>&1
stop_stats bm.$sz $comp.uf${uf}.1

# use fillseq to guarantee that all keys from 0 to num-1 exist
start_stats bm.$sz $comp.uf${uf}.2
cmd="$numactl ./db_bench $both_opt $comp_opt $ex_opt --benchmarks=fillseq,stats --num=$nr --use_fsync=$uf --use_existing_db=0"
echo "$cmd" > bm.$sz.res.$comp.uf${uf}.2
/usr/bin/time -f '%e %U %S' -o bm.$sz.res.time.$comp.uf${uf} $cmd >> bm.$sz.res.$comp.uf${uf}.2 2>&1
stop_stats bm.$sz $comp.uf${uf}.2

# fragment the database by overwriting 10% of the keys
p10=$( echo $nr | awk '{ printf "%.0f", $1 / 10 }' )
start_stats bm.$sz $comp.uf${uf}.3
cmd="$numactl ./db_bench $both_opt $comp_opt $ex_opt --benchmarks=overwrite,stats --num=$nr --writes=$p10 --use_fsync=$uf --use_existing_db=1"
echo "$cmd" > bm.$sz.res.$comp.uf${uf}.3
/usr/bin/time -f '%e %U %S' -o bm.$sz.res.time.$comp.uf${uf} $cmd >> bm.$sz.res.$comp.uf${uf}.3 2>&1
stop_stats bm.$sz $comp.uf${uf}.3

# the first readrandom lets compaction debt get reduced and warms the cache, the readrandom and seekrandom that follow are to measure perf
start_stats bm.$sz $comp.uf${uf}.4
cmd="$numactl ./db_bench $both_opt $comp_opt $ex_opt --benchmarks=readrandom,readrandom,seekrandom,stats --num=$nr --use_fsync=$uf --use_existing_db=1 --duration=$nsecs"
echo "$cmd" > bm.$sz.res.$comp.uf${uf}.4
/usr/bin/time -f '%e %U %S' -o bm.$sz.res.time.$comp.uf${uf} $cmd >> bm.$sz.res.$comp.uf${uf}.4 2>&1
stop_stats bm.$sz $comp.uf${uf}.4

# repeat the tests after making the memtable and L0 empty
if [ $comp == "lc" ] ; then
  cmd="$numactl ./db_bench $both_opt $comp_opt $ex_opt --benchmarks=flush,waitforcompaction,stats,compact0,waitforcompaction,stats --num=$nr --use_fsync=$uf --use_existing_db=1"
else
  # waitforcompaction can hang with universal
  cmd="$numactl ./db_bench $both_opt $comp_opt $ex_opt --benchmarks=flush,stats,compact0,stats --num=$nr --use_fsync=$uf --use_existing_db=1"
fi
echo "$cmd" > bm.$sz.res.$comp.uf${uf}.5
/usr/bin/time -f '%e %U %S' -o bm.$sz.res.time.$comp.uf${uf} $cmd >> bm.$sz.res.$comp.uf${uf}.5 2>&1

# the first readrandom warms the cache, the readrandom and seekrandom that follow are to measure perf
start_stats bm.$sz $comp.uf${uf}.6
cmd="$numactl ./db_bench $both_opt $comp_opt $ex_opt --benchmarks=readrandom,readrandom,seekrandom,stats --num=$nr --use_fsync=$uf --use_existing_db=1 --duration=$nsecs"
echo "$cmd" > bm.$sz.res.$comp.uf${uf}.6
/usr/bin/time -f '%e %U %S' -o bm.$sz.res.time.$comp.uf${uf} $cmd >> bm.$sz.res.$comp.uf${uf}.6 2>&1
stop_stats bm.$sz $comp.uf${uf}.6

# repeat the tests after making the L1 empty
if [ $comp == "lc" ] ; then
  # Only for leveled, the L1 isn't really a thing with unviersal
  cmd="$numactl ./db_bench $both_opt $comp_opt $ex_opt --benchmarks=compact1,waitforcompaction,stats --num=$nr --use_fsync=$uf --use_existing_db=1"
  echo "$cmd" > bm.$sz.res.$comp.uf${uf}.7
  /usr/bin/time -f '%e %U %S' -o bm.$sz.res.time.$comp.uf${uf} $cmd >> bm.$sz.res.$comp.uf${uf}.7 2>&1

  # the first readrandom warms the cache, the readrandom and seekrandom that follow are to measure perf
  start_stats bm.$sz $comp.uf${uf}.8
  cmd="$numactl ./db_bench $both_opt $comp_opt $ex_opt --benchmarks=readrandom,readrandom,seekrandom,stats --num=$nr --use_fsync=$uf --use_existing_db=1 --duration=$nsecs"
  echo "$cmd" > bm.$sz.res.$comp.uf${uf}.8
  /usr/bin/time -f '%e %U %S' -o bm.$sz.res.time.$comp.uf${uf} $cmd >> bm.$sz.res.$comp.uf${uf}.8 2>&1
  stop_stats bm.$sz $comp.uf${uf}.8
fi

