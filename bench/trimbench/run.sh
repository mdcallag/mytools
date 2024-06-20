
# Path to files including directory and prefix of filename. Files to be created are ${file_prefix}.0 .1 and .2
file_prefix=$1
# Size in GiB of file to be created and dropped
gib1=$2
# Size in GiB of file to be read by fio
gib2=$3
# Number of seconds to pause after creating files
pause_secs=$4
# Number of seconds for fio to run
run_secs=$5
# iostat and vmstat output are o.${tag}.iostat and o.${tag}.vmstat
tag=$6
# Value for iodepth argument to fio
iodepth=$7
# Value for ioengine argument to fio
fioengine=$8

if [ $# -ne 8 ]; then
  echo Need 8 arguments
  exit 1
fi

if [ $5 -lt 31 ]; then
  echo Number of seconds was $5 and must be greater than 30
  exit 1
fi

if [ -f ${file_prefix}.1 ]; then
  echo Remove existing ${file_prefix}.1 then sleep for $pause_secs seconds at $( date )
  rm ${file_prefix}.1
  sync; sleep $pause_secs
fi

echo Create input files ${file_prefix}.0 and ${file_prefix}.1 at $( date ) 
dd if=/dev/urandom of=${file_prefix}.0 bs=1G count=1 iflag=fullblock 

for x in $( seq 1 $gib1 ); do
  dd if=${file_prefix}.0 of=${file_prefix}.1 bs=1G count=1  conv=notrunc oflag=append iflag=fullblock >> o.$tag.dd.1 2>&1
done

ls -lh ${file_prefix}.0
ls -lh ${file_prefix}.1 
echo Sleep for $pause_secs seconds after creating ${file_prefix}.1 at $( date ) 
sync; sleep $pause_secs

f2_bytes=$( stat -c %s ${file_prefix}.2 )
expect_bytes=$( echo "$gib2 * 1024 * 1024 * 1024" | bc )
if [ $f2_bytes -lt $expect_bytes ]; then
  echo Existing ${file_prefix}.2 is too small, must delete and create again
  rm ${file_prefix}.2
else
  echo Existing ${file_prefix}.2 is large enough
fi

if [ ! -f ${file_prefix}.2 ]; then
  echo Create ${file_prefix}.2 then sleep for $pause_secs seconds at $( date )
  for x in $( seq 1 $gib2 ); do
    dd if=${file_prefix}.0 of=${file_prefix}.2 bs=1G count=1 conv=notrunc oflag=append iflag=fullblock >> o.$tag.dd.2 2>&1
  done
  ls -lh ${file_prefix}.2
  sync; sleep $pause_secs
fi

echo List kernel
uname -a

echo List mount options for filesystems 
mount -v 
echo

iostat -y -mx 1 >& o.$tag.iostat &
iopid=$!
vmstat 1 >& o.$tag.vmstat &
vmpid=$!
while :; do ps aux | grep fio | grep -v grep; sleep 1; done >& o.$tag.ps &
pspid=$!

echo Start fio to read from ${file_prefix}.2 at $( date ) 
echo
fio --filename=${file_prefix}.2 --direct=1 --rw=randread --bs=4k --ioengine=$fioengine --iodepth=${iodepth} --runtime=${run_secs} --numjobs=1 --time_based --group_reporting --name=iops-test-job --eta-newline=1 --readonly &
fpid=$!
echo Let fio run for 30 seconds before removing files
sleep 30

echo Remove ${file_prefix}.0 and .1 at $( date ) 
rm ${file_prefix}.0 & 
rm0pid=$!
rm ${file_prefix}.1 & 
rm1pid=$!

wait $rm0pid
wait $rm1pid
wait $fpid

kill $iopid
kill $vmpid
kill $pspid
