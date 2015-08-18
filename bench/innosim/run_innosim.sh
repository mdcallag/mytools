
binlog=$1
trxlog=$1

doublewrite=$2

writers=$3
users=$4

dirty_pct=$5
read_hit_pct=$6

test_duration=$7

prepare=$8

dfs=$9

comp=${10}

write_limit=${11}

dfn=${12}

ufd=${13}

dbs=${14}

dfs_by=$( echo "1024 * 1024 * 1024 * ${dfs}" | bc )

killall vmstat
killall iostat

G1=1073741824

bls=$G1
tls=$G1

suffix=bl_${binlog}.trx_${trxlog}.dblwr_${doublewrite}.wthr_${writers}.uthr_${users}.dirty_${dirty_pct}.rh_${read_hit_pct}.tls_${tls}.bls_${bls}.dfs_${dfs}.comp_${comp}.wlim_${write_limit}.dfn_${dfn}

vmstat 1 > v.${suffix} &
iostat -kx 1 > i.${suffix} &

echo ./innosim \
  --prepare $prepare \
  --max-dirty-pages 10000 \
  --binlog-file-size $bls \
  --trxlog-file-size $tls \
  --database-size ${dfs_by} \
  --data-file-number ${dfn} \
  --trxlog $trxlog \
  --binlog $binlog \
  --doublewrite $doublewrite \
  --num-writers $writers \
  --num-users $users \
  --dirty-pct $dirty_pct \
  --read-hit-pct $read_hit_pct \
  --compress-level $comp \
  --use-fdatasync $ufd \
  --data-block-size $dbs \
  --io-per-thread-per-second $write_limit \
  --test-duration $test_duration > c.${suffix}

./innosim \
  --prepare $prepare \
  --max-dirty-pages 10000 \
  --binlog-file-size $bls \
  --trxlog-file-size $tls \
  --database-size ${dfs_by} \
  --data-file-number ${dfn} \
  --trxlog $trxlog \
  --binlog $binlog \
  --doublewrite $doublewrite \
  --num-writers $writers \
  --num-users $users \
  --dirty-pct $dirty_pct \
  --read-hit-pct $read_hit_pct \
  --compress-level $comp \
  --use-fdatasync $ufd \
  --data-block-size $dbs \
  --io-per-thread-per-second $write_limit \
  --test-duration $test_duration > o.${suffix} 2> e.${suffix} 

killall vmstat
killall iostat
