# Args are:
# binlog&trxlog doublewrite #writers #users dirty_pct read_hit_pct test_duration prepare

prepare=$1
secs=$2
sleep_secs=$3

if [ $prepare -gt 0 ] ; then
echo Prepare
bash run_innosim.sh  1 1 8  1   0   0 10 1
fi

for concur in 1 4 8 16 32 64 128 ; do
  echo read-only $concur concur
  bash run_innosim.sh  1 1 8  $concur   0   0 $secs 0; sleep $sleep_secs
done

for concur in 1 4 8 16 32 64 128 ; do

echo write-only $concur concur
bash run_innosim.sh  1 1 8  $concur 100 100 $secs 0; sleep $sleep_secs

echo read-write $concur concur dirty=25  (100 page reads to 50 page writes)
bash run_innosim.sh  1 1 8  $concur  25   0 $secs 0; sleep $sleep_secs

echo read-write $concur concur dirty=17 (100 page reads to 34 page writes)
bash run_innosim.sh  1 1 8  $concur  17   0 $secs 0; sleep $sleep_secs

echo read-write $concur concur dirty=13 (100 page reads to 26 page writes)
bash run_innosim.sh  1 1 8  $concur  13   0 $secs 0; sleep $sleep_secs

echo read-write $concur concur dirty=6  (100 page reads to 12 page writes)
bash run_innosim.sh  1 1 8  $concur  6   0 $secs 0; sleep $sleep_secs

done
