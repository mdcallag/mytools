
binlog=$1
trxlog=$1

doublewrite=$2

writers=$3
users=$4

dirty_pct=$5
read_hit_pct=$6

test_duration=$7

prepare=$8

killall vmstat
killall iostat

G1=1073741824
G512=549755813888

bls=$G1
tls=$G1
dfs=$G512

suffix=bl_${binlog}.trx_${trxlog}.dblwr_${doublewrite}.wthr_${writers}.uthr_${users}.dirty_${dirty_pct}.rh_${read_hit_pct}.tls_${tls}.bls_${bls}.dfs_${dfs}

vmstat 1 > v.${suffix} &
iostat -x 1 > i.${suffix} &

./innosim \
  --prepare $prepare \
  --max-dirty-pages 10000 \
  --binlog-file-size $bls \
  --trxlog-file-size $tls \
  --data-file-size $dfs \
  --trxlog $trxlog \
  --binlog $binlog \
  --doublewrite $doublewrite \
  --num-writers $writers \
  --num-users $users \
  --dirty-pct $dirty_pct \
  --read-hit-pct $read_hit_pct \
  --test-duration $test_duration > o.${suffix} 2> e.${suffix} 

killall vmstat
killall iostat
