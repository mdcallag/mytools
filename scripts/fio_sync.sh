
fname=$1
nsecs=$2
jobs=$3

# bash fio_sync.sh /data/m/f1 60 1 > o.fio_sync 
# egrep "O_DIRECT|IOPS" o.fio_sync > o.sum.fio_sync.ser7
# egrep "O_DIRECT|clat \(|sync \(" o.fio_sync

rm $fname

# create the test file and write to it to make sure it is fully allocated
fio --name=seqwrite --rw=write --ioengine=sync --bs=1M --size=1024M --filename=$fname --direct=1
sync; sleep 5

echo
echo
ls -lh $fname
ls -ls $fname
echo
echo

flags=( --name=sync_latency --filename=$fname --size=1024M --time_based --runtime=${nsecs}s --ioengine=psync --rw=randwrite --direct=1 --output-format=normal --max-jobs=$jobs )

for bs in 16K 2M ; do
echo Test for block size $bs

  for sync in 0 1 ; do
    echo O_DIRECT with fsync=$sync for block size $bs
    fio "${flags[@]}" --filename=$fname --bs=$bs --fsync=$sync 
    sleep 5

    echo O_DIRECT with fsync=$sync for block size $bs
    fio "${flags[@]}" --filename=$fname --bs=$bs --fsync=$sync 
    sleep 5
  done

  for sync in 0 1 ; do
    echo O_DIRECT with fdatasync=$sync for block size $bs
    fio "${flags[@]}" --filename=$fname --bs=$bs --fdatasync=$sync 
    sleep 5

    echo O_DIRECT with fdatasync=$sync for block size $bs
    fio "${flags[@]}" --filename=$fname --bs=$bs --fdatasync=$sync 
    sleep 5
  done

done

rm $fname
