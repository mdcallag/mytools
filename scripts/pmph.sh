mpid=$1
nsamples=$2
sleeptime=$3
for x in $( seq 0 $nsamples) ; do
 gdb -ex "set pagination 0" -ex "thread apply all bt" --batch -p $mpid
 sleep $sleeptime; done | \
awk '
  BEGIN { s = ""; } 
  /^Thread/ { print s; s = ""; } 
  /^\#/ { if ( $3 != "in" ) { new = $2 } else { new = $4 }; if (s != "" ) { s = s "," new} else { s = new } } 
  END { print s }' | \
sort | uniq -c | sort -r -n -k 1,1
