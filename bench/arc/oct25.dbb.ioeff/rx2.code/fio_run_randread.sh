njobs=$1
gb1=$2
runsecs=$3
rampsecs=$4
tag=$5
buffered=$6
ioengine=$7

fpath=/usr/bin/fio

echo Run for $runsecs seconds with $rampsecs warmup and ioengine $ioengine

if [[ $buffered -eq 1 ]]; then
  flag="--buffered=1 --direct=0"
  echo Use buffered=1 direct=0
else
  flag="--direct=1 --buffered=0"
  echo Use direct=1 buffered=0
fi

./fb-fio --name=randread --rw=randread --ioengine=sync --numjobs=$njobs --iodepth=1 \
  $flag \
  --create_only=1 \
  --bs=4k \
  --size=${gb1}G \
  --randrepeat=0 \
  --directory=${fpath} \
  --filename=${gb1}G_1:${gb1}G_2:${gb1}G_3:${gb1}G_4:${gb1}G_5:${gb1}G_6:${gb1}G_7:${gb1}G_8  \
  --group_reporting \
  >& ${fname}.create.out

sync; sync; sync
sleep 60

#fname="o.${tag}.rr.${njobs}j.8Fx${gb1}G.bs4k.${ioengine}.start"
#for fn in $( seq 1 8 ); do fincore ${fpath}/${gb1}G_${fn} ; done > ${fname}.fincore

for bs in 4k 8k ; do
for loop in 1 2 3 ; do

fname="o.${tag}.rr.${njobs}j.8Fx${gb1}G.bs${bs}.${ioengine}.loop${loop}"

iostat -kx 1 >& ${fname}.iostat &
ipid=$!

vmstat 1 >& ${fname}.vmstat &
vpid=$!

#strace -f -o ${fname}.strace \
/usr/bin/time -f '%e %U %S' -o ${fname}.time \
./fb-fio --name=randread --rw=randread --ioengine=$ioengine --numjobs=$njobs --iodepth=1 \
  $flag \
  --allow_file_create=0 \
  --bs=${bs} \
  --size=${gb1}G \
  --runtime=${runsecs}s --ramp_time=${rampsecs}s \
  --randrepeat=0 \
  --directory=${fpath} \
  --filename=${gb1}G_1:${gb1}G_2:${gb1}G_3:${gb1}G_4:${gb1}G_5:${gb1}G_6:${gb1}G_7:${gb1}G_8  \
  --group_reporting \
  >& ${fname}.out

kill $ipid
kill $vpid

#for fn in $( seq 1 8 ); do fincore ${fpath}/${gb1}G_${fn} ; done > ${fname}.fincore

usCpuSecs=$( cat ${fname}.time | awk '{ print $2 }' )
syCpuSecs=$( cat ${fname}.time | awk '{ print $3 }' )
iops=$( cat ${fname}.out | grep iops | awk '{ print $5 }' | tr ',=' ' '  | awk '{ print $2 }' )

usPerIo=$( echo "scale=3; ( 1000000.0 * $usCpuSecs ) / ( ( $runsecs + $rampsecs ) * $iops )" | bc )
syPerIo=$( echo "scale=3; ( 1000000.0 * $syCpuSecs ) / ( ( $runsecs + $rampsecs ) * $iops )" | bc )
cpuPerIo=$( echo "scale=3; ( 1000000.0 * ( $usCpuSecs + $syCpuSecs ) ) / ( ( $runsecs + $rampsecs ) * $iops )" | bc )

lat=$( grep " lat" ${fname}.out | grep stdev | awk '{ print $5 }' | sed 's/avg=//' | tr ',' ' ' )
latUnit=$( grep " lat" ${fname}.out | grep stdev | awk '{ print $2 }' )

echo "loop $loop, $tag, $njobs jobs, $gb1 GB, $runsecs seconds, ${bs} block"
echo -e "uCpu=$usCpuSecs\tsCpu=$syCpuSecs\tiops=$iops\tusPer=$usPerIo\tsyPer=$syPerIo\tcpuPer=$cpuPerIo\tlat=$lat\tunit=$latUnit"
echo
    
done
done

