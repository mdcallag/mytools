
file_prefix=$1
gib1=$2
gib2=$3
pause_secs=$4
run_secs=$5
tag=$6
iodepth=$7

GibToMib1=$(( gib1 * 1024 ))
GibToMib2=$(( gib2 * 1024 ))

if [ -f ${file_prefix}.1 ]; then
  echo Remove existing ${file_prefix}.1 then sleep for $pause_secs seconds at $( date )
  rm ${file_prefix}.1
  sync; sleep $pause_secs
fi

echo Create ${file_prefix}.1 at $( date ) 
dd if=/dev/urandom of=${file_prefix}.1 bs=1M count=$GibToMib1 iflag=fullblock 
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
  dd if=/dev/urandom of=${file_prefix}.2 bs=1M count=$GibToMib2 iflag=fullblock 
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

echo Remove ${file_prefix}.1 at $( date ) 
rm ${file_prefix}.1 & 
rmpid=$!

echo Start fio to read from ${file_prefix}.2 at $( date ) 
echo

fio --filename=${file_prefix}.2 --direct=1 --rw=randread --bs=4k --ioengine=libaio --iodepth=${iodepth} --runtime=${run_secs} --numjobs=1 --time_based --group_reporting --name=iops-test-job --eta-newline=1 --readonly
echo

kill $rmpid
kill $iopid
