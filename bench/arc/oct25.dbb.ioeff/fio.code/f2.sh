njobs=$1
gb1=$2
runsecs=$3
rampsecs=$4
tag=$5
buffered=$6
ioengine=$7

for bs in 4k 8k ; do
for loop in 1 2 3 ; do

fname="o.${tag}.rr.${njobs}j.8Fx${gb1}G.bs${bs}.${ioengine}.loop${loop}"

#iostat -kx 1 >& ${fname}.iostat &
#ipid=$!

#vmstat 1 >& ${fname}.vmstat &
#vpid=$!

usCpuSecs=$( cat ${fname}.time | awk '{ print $2 }' )
syCpuSecs=$( cat ${fname}.time | awk '{ print $3 }' )
echo usCpuSecs is $usCpuSecs
echo syCpuSecs is $usCpuSecs

iops=$( cat ${fname}.out | grep iops | awk '{ print $5 }' | tr ',=' ' '  | awk '{ print $2 }' )
#iops=$( cat ${fname}.out | grep IOPS | awk '{ print $2 }' | tr '=,' ' '  | awk '{ print $2 }' )
echo iops is $iops

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

