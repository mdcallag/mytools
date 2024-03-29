# An example command line: cmb=0; fillrand=no; bash runit.sh /data/m/rx 8 16 2 120 $cmb 10 sdb $fillrand false 4096 32

dbdir=$1
bgflush=$2
bgcomp=$3
subcomp=$4
nsecs=$5
cachemb=$6
# value for --use_existing_keys
nmkeys=$7
dev_suffix=$8
# yes to use fillrandom, no to do filluniquerandom
# When no, then there is no need for --use_existing_keys as all keys exist.
# Note that --use_existing_keys can be very slow at startup thanks to
# much random IO when O_DIRECT is done for user reads.
fillrand=$9
block_align=${10}
val_size=${11}
# yes or no
odirect=${12}
# yes or no
useblob=${13}
partition=${14}

shift 14

#for cleanup in none memtable L0 L1 ; do
for cleanup in memtable ; do
  echo
  first=1
  for nthr in "$@" ; do
    if [ $first -eq 1 ]; then
      use_cleanup=$cleanup
      first=0
    else
      use_cleanup=none
    fi
    echo Run for nthr=$nthr and cleanup=$cleanup
    bash q.sh $dbdir $nsecs $nthr $cachemb $cleanup $use_cleanup $nmkeys $dev_suffix $fillrand $block_align $val_size $odirect $useblob $partition
  done
done

