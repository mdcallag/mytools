mpid=$1
nsamples=$2
sleeptime=$3
for x in $( seq 0 $nsamples) ; do
 gdb -ex "set pagination 0" -ex "thread apply all bt" --batch -p $mpid
 sleep $sleeptime; done | \
awk '/^\#/ { print $4 }' | \
sort | uniq -c | sort -r -n -k 1,1
