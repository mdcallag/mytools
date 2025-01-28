dop=$1
 
bash run_all.batch1.sh fashion-mnist-784-euclidean c32r128 $dop &
jpid=$!
echo Running $pid

sleep 90; for M in 1 2 3; do sleep 30; x=v${M}.dop${dop}.ma; secs=10; bash pmpf.sh $( pidof mariadbd ) ${x}.pmp ; perf record -F 499 -p $( pidof mariadbd ) -- sleep $secs ; perf report --stdio > ${x}.perf.f ; perf record -F 499 -g -p $( pidof mariadbd ) -- sleep $secs ; perf report -g --stdio > ${x}.perf.g ; perf stat -a sleep $secs >& ${x}.perf.stat ; perf stat -p $( pidof mariadbd ) sleep $secs >& ${x}.perf.stat.dbms ; done

kill $jpid
sleep 5

( cd ~/d/ma110701_rel_withdbg ; bash down.sh )
sleep 10

killall top
killall vmstat
killall ps

ps aux | grep "bash run" | awk '{ print $2 }' | xargs kill
sleep 1

echo Done
ps aux | grep aria
echo
ps aux | grep python
echo
ps aux | grep vmstat
echo
ps aux | grep run
echo
ps aux | grep bash

sleep 5
