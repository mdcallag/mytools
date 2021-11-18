dbdir=$1
odir=$2

nkeys=${NKEYS:-1000000}
cache_mb=${CACHE_MB:-128}
nsecs=${NSECS:-65}
nsecs_ro=${NSECS_RO:-65}
mb_wps=${MB_WPS:-2}
nthreads=${NTHREADS:-16}
comp_type=${COMP_TYPE:-lz4}
ml2_comp=${ML2_COMP:-3}
original=${ORIGINAL:-yes}
write_buf_mb=${WRITE_BUF_MB:-32}
sst_mb=${SST_MB:-32}
l1_mb=${L1_MB:-128}
max_bg_jobs=${MAX_BG_JOBS:-8}
cache_meta=${CACHE_META:-1}
pending_ratio=${PENDING_RATIO:-"0.5"}
write_amp_estimate=${WRITE_AMP_ESTIMATE:-20}

key_bytes=${KEY_BYTES:-20}
value_bytes=${VALUE_BYTES:-400}

stats_seconds=${STATS_SECONDS:-20}

direct_flags=""
if [ ! -z $DIRECT_IO ]; then
  direct_flags="USE_O_DIRECT=1"
fi

cacheb=$(( $cache_mb * 1024 * 1024 ))

# Values for published results: 
# NUM_KEYS=900,000,000 CACHE_SIZE=6,442,450,944 DURATION=5400 MB_WRITE_PER_SEC=2 

function usage() {
  echo "usage: perf_cmp.sh db_dir output_dir version+"
  echo -e "\tdb_dir - create RocksDB database in this directory"
  echo -e "\toutput_dir - write output from performance tests in this directory"
  echo -e "\tversion+ - space separated sequence of RocksDB versions to test."
  echo -e "\t\tThis expects that db_bench.\$version exists in \$PWD for each version in the sequence."
  echo -e "\t\tExample value for version+ is 6.23.0 6.24.0"
  echo ""
  echo -e "Environment variables for options"
  echo -e "\tNKEYS - number of keys to load"
  echo -e "\tKEY_BYTES - size of key"
  echo -e "\tVALUE_BYTES - size of value"
  echo -e "\tCACHE_MB - size of block cache in MB"
  echo -e "\tNSECS - number of seconds for which each test runs, except for read-only tests"
  echo -e "\tNSECS_RO - number of seconds for which each read-only test runs"
  echo -e "\tMB_WPS - rate limit for writer that runs concurrent with queries for some tests"
  echo -e "\tNTHREADS - number of user threads"
  echo -e "\tCOMP_TYPE - compression type (zstd, lz4, none, etc)"
  echo -e "\tML2_COMP - min_level_to_compress"
  echo -e "\tORIGINAL - if yes run original sequence of benchmarks"
  echo -e "\tWRITE_BUF_MB - size of write buffer in MB"
  echo -e "\tSST_MB - target_file_size_base in MB"
  echo -e "\tL1_MB - max_bytes_for_level_base in MB"
  echo -e "\tMAX_BG_JOBS - max_background_jobs"
  echo -e "\tCACHE_META - cache_index_and_filter_blocks"
  echo -e "\tDIRECT_IO\t\tUse O_DIRECT for user reads and compaction"
  echo -e "\tPENDING_RATIO - used to estimate write-stall limits"
  echo -e "\tWRITE_AMP_ESTIMATE\t\tEstimate for the write-amp that will occur. Used to compute write-stall limits"
  echo -e "\tSTATS_SECONDS\t\tValue for stats_interval_seconds"
}

function dump_env() {
  echo -e "dbdir\tdbdir" >> $odir/args
  echo -e "nkeys\t$nkeys" >> $odir/args
  echo -e "cache_mb\t$cache_mb" >> $odir/args
  echo -e "nsecs\t$nsecs" >> $odir/args
  echo -e "nsecs_ro\t$nsecs_ro" >> $odir/args
  echo -e "mb_wps\t$mb_wps" >> $odir/args
  echo -e "nthreads\t$nthreads" >> $odir/args
  echo -e "comp_type\t$comp_type" >> $odir/args
  echo -e "ml2_comp\t$ml2_comp" >> $odir/args
  echo -e "original\t$original" >> $odir/args
  echo -e "write_buf_mb\t$write_buf_mb" >> $odir/args
  echo -e "sst_mb\t$sst_mb" >> $odir/args
  echo -e "l1_mb\t$l1_mb" >> $odir/args
  echo -e "max_bg_jobs\t$max_bg_jobs" >> $odir/args
  echo -e "cache_meta\t$cache_meta" >> $odir/args
  echo -e "pending_ratio\t$pending_ratio" >> $odir/args
  echo -e "write_amp_estimate\t$write_amp_estimate" >> $odir/args
}

if [ $# -lt 3 ]; then
  usage
  echo
  echo "Need at least 3 arguments"
  exit 1
fi

shift 2

if [ -d $odir ]; then
  echo "Exiting because the output directory ($odir) exists"
  exit 1
fi
mkdir $odir
dump_env

# The goal is to make the limits large enough so that:
# 1) there aren't write stalls after every L0->L1 compaction
#
# But small enough so that
# 2) space-amp doesn't get out of control
# 3) the LSM tree shape doesn't get out of control
#
# For 1) the limit should be sufficiently larger than sizeof(L0) * write-amp
#     where write-amp is an estimate. Call this limit-1.
# For 2) and 3) the limit can be a function of the database size, f * sizeof(database)
#     where f is a value > 0, usually < 1, and the size is an estimate. Call
#     this limit-2,3. The value for f is passed by PENDING_BYTES_RATIO.
#
# Then use max(limit-1, limit-2,3) for soft_pending_compaction_bytes_limit
# and set the hard limit to be twice the soft limit.
#
# soft_pending_compaction_bytes_limit = estimated-db-size * pending_bytes_ratio
#     where estimated-db-size ignores compression
# hard_pending_compaction_bytes_limit = 2 * soft_pending_compaction_bytes_limit

# TODO: will this ever be configurable?
# Use this to estimate sizeof(L0)
compaction_trigger=4

pending_ratio=${PENDING_RATIO:-"0.5"}
write_amp_estimate=${WRITE_AMP_ESTIMATE:-20}

# This computes limit-2,3 in GB
soft_bytes23=$( echo $pending_ratio $nkeys $key_bytes $value_bytes | \
  awk '{ soft = (($3 + $4) * $2 * $1) / (1024*1024*1024); printf "%.1f", soft }' )

# This computes limit-1 in GB
# Multiplying by 2 below is a fudge factor
soft_bytes1=$( echo $compaction_trigger $write_buf_mb $write_amp_estimate | \
  awk '{ soft = ($1 * $2 * $3 * 2) / 1024; printf "%.1f", soft }' )
# Choose the max from soft_bytes1 and soft_bytes23
soft_bytes=$( echo $soft_bytes1 $soft_bytes23 | \
  awk '{ mx=$1; if ($2 > $1) { mx = $2 }; printf "%s", mx }' )
# To be safe make sure the soft limit is >= 10G
soft_bytes=$( echo $soft_bytes | \
  awk '{ mx=$1; if (10 > $1) { mx = 10 }; printf "%.0f", mx }' )
# Set the hard limit to be 2x the soft limit
hard_bytes=$( echo $soft_bytes | awk '{ printf "%.0f", $1 * 2 }' )

echo Test versions: $@
echo Test versions: $@ >> $odir/args

for v in $@ ; do
  my_odir=$odir/$v
  benchargs1=( OUTPUT_DIR=$my_odir DB_DIR=$dbdir WAL_DIR=$dbdir COMPRESSION_TYPE=$comp_type DB_BENCH_NO_SYNC=1 NUM_KEYS=$nkeys CACHE_SIZE=$cacheb )
  benchargs1+=( WRITE_BUFFER_SIZE_MB=$write_buf_mb TARGET_FILE_SIZE_BASE_MB=$sst_mb MAX_BYTES_FOR_LEVEL_BASE_MB=$l1_mb MAX_BACKGROUND_JOBS=$max_bg_jobs )
  benchargs1+=( CACHE_INDEX_AND_FILTER_BLOCKS=$cache_meta NUM_THREADS=$nthreads $direct_flags )
  benchargs1+=( SOFT_PENDING_COMPACTION_BYTES_LIMIT_IN_GB=$soft_bytes HARD_PENDING_COMPACTION_BYTES_LIMIT_IN_GB=$hard_bytes )
  benchargs1+=( KEY_SIZE=$key_bytes VALUE_SIZE=$value_bytes STATS_INTERVAL_SECONDS=$stats_seconds )
  benchargs2=("${benchargs1[@]}")
  benchargs2+=( MIN_LEVEL_TO_COMPRESS=$ml2_comp PENDING_BYTES_RATIO=$pending_ratio )
  benchargs3=("${benchargs2[@]}")
  benchargs3+=( MB_WRITE_PER_SEC=$mb_wps PENDING_BYTES_RATIO=$pending_ratio )

  echo Run benchmark for $v at $( date ) with results at $my_odir
  rm -f db_bench
  ln -s db_bench.$v db_bench

  rm -rf $my_odir
  rm -rf $dbdir/*

  # TODO: start & stop iostat & vmstat per test and save results to $my_odir

  if [[ $original == "yes" ]]; then
    # Use the original sequence of tests
    env "${benchargs1[@]}" bash tools/b.sh bulkload 
    env "${benchargs2[@]}" DURATION=$nsecs_ro bash tools/b.sh readrandom 
    env "${benchargs2[@]}" DURATION=$nsecs_ro bash tools/b.sh multireadrandom --multiread_batched 
    env "${benchargs2[@]}" DURATION=$nsecs_ro bash tools/b.sh fwdrange 
    env "${benchargs2[@]}" DURATION=$nsecs    bash tools/b.sh overwrite 
    env "${benchargs3[@]}" DURATION=$nsecs    bash tools/b.sh readwhilewriting 
    env "${benchargs3[@]}" DURATION=$nsecs    bash tools/b.sh fwdrangewhilewriting 
  else
    # Use an alternate test sequence
    env "${benchargs1[@]}" bash tools/b.sh fillseq_disable_wal
    # With overwriteandwait the test doesn't end until compaction has caught up
    env "${benchargs2[@]}" DURATION=$nsecs    bash tools/b.sh overwriteandwait
    env "${benchargs3[@]}" DURATION=$nsecs    bash tools/b.sh readwhilewriting 
    env "${benchargs3[@]}" DURATION=$nsecs    bash tools/b.sh fwdrangewhilewriting 
    # Flush memtable & L0 to get LSM tree into deterministic state before read-only tests
    env "${benchargs2[@]}"                    bash tools/b.sh flush_mt_l0
    env "${benchargs2[@]}" DURATION=$nsecs_ro bash tools/b.sh readrandom 
    env "${benchargs2[@]}" DURATION=$nsecs_ro bash tools/b.sh multireadrandom --multiread_batched 
    env "${benchargs2[@]}" DURATION=$nsecs_ro bash tools/b.sh fwdrange 
  fi

  cp $dbdir/LOG* $my_odir
done

# Generate a file that groups lines from the same test for all versions
basev=$1
nlines=$( awk '/^ops_sec/,/END/' $odir/${basev}/report.tsv | grep -v ops_sec | wc -l )
hline=$( awk '/^ops_sec/ { print NR }' $odir/${basev}/report.tsv )
sline=$(( $hline + 1 ))
eline=$(( $sline + $nlines - 1 ))

sum_file=$odir/summary.tsv

for v in $*; do
  echo $odir/${v}/report.tsv
done >> $sum_file
echo >> $sum_file

for x in $( seq $sline $eline ); do
  awk '{ if (NR == lno) { print $0 } }' lno=$hline $odir/${basev}/report.tsv >> $sum_file
  for v in $*; do
    r=$odir/${v}/report.tsv
    awk '{ if (NR == lno) { print $0 } }' lno=$x $r >> $sum_file
  done
echo >> $sum_file
done
