tag=$1
file_path=$2
fioengine=$3
iodepth=$4
run_secs=$5
sizeGB=$6

iostat -y -mx 1 >& o.$tag.iostat &
iopid=$!
vmstat 1 >& o.$tag.vmstat &
vmpid=$!
#while :; do ps aux | grep fio | grep -v grep; sleep 1; done >& o.$tag.ps &
#pspid=$!

echo Start fio to read from ${file_path} at $( date )
echo
fio --filename=${file_path} --direct=1 --rw=randread --bs=4k --ioengine=$fioengine --iodepth=${iodepth} --runtime=${run_secs} --numjobs=1 --time_based --group_reporting --name=iops-test-job --eta-newline=1 --size=${sizeGB} >& o.$tag.fio

kill $iopid
kill $vmpid
#kill $pspid:
