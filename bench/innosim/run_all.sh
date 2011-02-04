# Args are:
# binlog&trxlog doublewrite #writers #users dirty_pct read_hit_pct test_duration prepare

prepare=$1
secs=$2

if [ $prepare -gt 0 ] ; then
echo Prepare
bash run_innosim.sh  1 1 8  1   0   0 10 1
fi

for concur in 1 4 32 128 ; do

echo read-only $concur concur
bash run_innosim.sh  1 1 8  $concur   0   0 $secs 0

echo write-only $concur concur
bash run_innosim.sh  1 1 8  $concur 100 100 $secs 0

echo read-write $concur concur
bash run_innosim.sh  1 1 8  $concur  50   0 $secs 0

done
