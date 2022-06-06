
test_out=$1
test_name=$2
bench_name=$3
do_header=$4

function month_to_num() {
    local date_str=$1
    date_str="${date_str/Jan/01}"
    date_str="${date_str/Feb/02}"
    date_str="${date_str/Mar/03}"
    date_str="${date_str/Apr/04}"
    date_str="${date_str/May/05}"
    date_str="${date_str/Jun/06}"
    date_str="${date_str/Jul/07}"
    date_str="${date_str/Aug/08}"
    date_str="${date_str/Sep/09}"
    date_str="${date_str/Oct/10}"
    date_str="${date_str/Nov/11}"
    date_str="${date_str/Dec/12}"
    echo $date_str
}

function summarize_result {
  test_out=$1
  test_name=$2
  bench_name=$3
  do_header=$4

  # Note that this function assumes that the benchmark executes long enough so
  # that "Compaction Stats" is written to stdout at least once. If it won't
  # happen then empty output from grep when searching for "Sum" will cause
  # syntax errors.
  version=$( grep ^RocksDB: $test_out | awk '{ print $3 }' )
  date=$( grep ^Date: $test_out | awk '{ print $6 "-" $3 "-" $4 "T" $5 }' )
  my_date=$( month_to_num $date )
  uptime=$( grep ^Uptime\(secs $test_out | tail -1 | awk '{ printf "%.0f", $2 }' )
  stall_pct=$( grep "^Cumulative stall" $test_out| tail -1  | awk '{  print $5 }' )
  nstall=$( grep ^Stalls\(count\):  $test_out | tail -1 | awk '{ print $2 + $6 + $10 + $14 + $18 + $20 }' )

  # Output formats
  # V1: overwrite    :       7.939 micros/op 125963 ops/sec;   50.5 MB/s
  # V2: overwrite    :       7.854 micros/op 127320 ops/sec 1800.001 seconds 229176999 operations;   51.0 MB/s

  format_version=$( grep ^${bench_name} $test_out | awk '{ if (NF >= 10 && $8 == "seconds") { print "V2" } else { print "V1" } }' )
  if [ $format_version == "V1" ]; then
    ops_sec=$( grep ^${bench_name} $test_out | awk '{ print $5 }' )
    usecs_op=$( grep ^${bench_name} $test_out | awk '{ printf "%.1f", $3 }' )
    mb_sec=$( grep ^${bench_name} $test_out | awk '{ print $7 }' )
  else
    ops_sec=$( grep ^${bench_name} $test_out | awk '{ print $5 }' )
    usecs_op=$( grep ^${bench_name} $test_out | awk '{ printf "%.1f", $3 }' )
    mb_sec=$( grep ^${bench_name} $test_out | awk '{ print $11 }' )
  fi

  flush_wgb=$( grep "^Flush(GB)" $test_out | tail -1 | awk '{ print $3 }' | tr ',' ' ' | awk '{ print $1 }' )
  sum_wgb=$( grep "^Cumulative compaction" $test_out | tail -1 | awk '{ printf "%.1f", $3 }' )
  cmb_ps=$( grep "^Cumulative compaction" $test_out | tail -1 | awk '{ printf "%.1f", $6 }' )
  if [[ "$sum_wgb" == "" || "$flush_wgb" == "" || "$flush_wgb" == "0.000" ]]; then
    wamp=""
  else
    wamp=$( echo "$sum_wgb / $flush_wgb" | bc -l | awk '{ printf "%.1f", $1 }' )
  fi
  c_wsecs=$( grep "^ Sum" $test_out | tail -1 | awk '{ printf "%.0f", $15 }' )
  c_csecs=$( grep "^ Sum" $test_out | tail -1 | awk '{ printf "%.0f", $16 }' )

  lsm_size=$( grep "^ Sum" $test_out | tail -1 | awk '{ printf "%.0f%s", $3, $4 }' )
  blob_size=$( grep "^Blob file count:" $test_out | tail -1 | awk '{ printf "%s%s", $7, $8 }' )

  b_rgb=$( grep "^ Sum" $test_out | tail -1 | awk '{ printf "%.0f", $21 }' )
  b_wgb=$( grep "^ Sum" $test_out | tail -1 | awk '{ printf "%.0f", $22 }' )

  p50=$( grep "^Percentiles:" $test_out | tail -1 | awk '{ printf "%.1f", $3 }' )
  p99=$( grep "^Percentiles:" $test_out | tail -1 | awk '{ printf "%.0f", $7 }' )
  p999=$( grep "^Percentiles:" $test_out | tail -1 | awk '{ printf "%.0f", $9 }' )
  p9999=$( grep "^Percentiles:" $test_out | tail -1 | awk '{ printf "%.0f", $11 }' )
  pmax=$( grep "^Min: " $test_out | grep Median: | grep Max: | awk '{ printf "%.0f", $6 }' )

  time_out=$test_out.time
  u_cpu=$( awk '{ printf "%.1f", $2 / 1000.0 }' $time_out )
  s_cpu=$( awk '{ printf "%.1f", $3 / 1000.0  }' $time_out )

  rss="na"
  if [ -f $test_out.stats.ps ]; then
    rss=$(  tail -1 $test_out.stats.ps | awk '{ printf "%.1f\n", $6 / (1024 * 1024) }' )
  fi

  if [ $do_header == "yes" ]; then
    echo -e "# ops_sec - operations per second"
    echo -e "# mb_sec - ops_sec * size-of-operation-in-MB" 
    echo -e "# lsm_sz - size of LSM tree" 
    echo -e "# blob_sz - size of BlobDB logs" 
    echo -e "# c_wgb - GB written by compaction" 
    echo -e "# w_amp - Write-amplification as (bytes written by compaction / bytes written by memtable flush)" 
    echo -e "# c_mbps - Average write rate for compaction" 
    echo -e "# c_wsecs - Wall clock seconds doing compaction" 
    echo -e "# c_csecs - CPU seconds doing compaction" 
    echo -e "# b_rgb - Blob compaction read GB" 
    echo -e "# b_wgb - Blob compaction write GB" 
    echo -e "# usec_op - Microseconds per operation" 
    echo -e "# p50, p99, p99.9, p99.99 - 50th, 99th, 99.9th, 99.99th percentile response time in usecs" 
    echo -e "# pmax - max response time in usecs" 
    echo -e "# uptime - RocksDB uptime in seconds" 
    echo -e "# stall% - Percentage of time writes are stalled" 
    echo -e "# Nstall - Number of stalls" 
    echo -e "# u_cpu - #seconds/1000 of user CPU" 
    echo -e "# s_cpu - #seconds/1000 of system CPU" 
    echo -e "# rss - max RSS in GB for db_bench process" 
    echo -e "# test - Name of test" 
    echo -e "# date - Date/time of test" 
    echo -e "# version - RocksDB version" 
    echo -e "# job_id - User-provided job ID" 
    echo -e "ops_sec\tmb_sec\tlsm_sz\tblob_sz\tc_wgb\tw_amp\tc_mbps\tc_wsecs\tc_csecs\tb_rgb\tb_wgb\tusec_op\tp50\tp99\tp99.9\tp99.99\tpmax\tuptime\tstall%\tNstall\tu_cpu\ts_cpu\trss\ttest\tdate\tversion\tjob_id" 
  fi

  echo -e "$ops_sec\t$mb_sec\t$lsm_size\t$blob_size\t$sum_wgb\t$wamp\t$cmb_ps\t$c_wsecs\t$c_csecs\t$b_rgb\t$b_wgb\t$usecs_op\t$p50\t$p99\t$p999\t$p9999\t$pmax\t$uptime\t$stall_pct\t$nstall\t$u_cpu\t$s_cpu\t$rss\t$test_name\t$my_date\t$version\t$job_id" 
}

summarize_result $test_out $test_name $bench_name $do_header
