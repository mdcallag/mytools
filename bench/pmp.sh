mpid=$1
loop=$2
sec=$3
echo "set pagination 0" > /tmp/pmpgdb
echo "thread apply all bt" >> /tmp/pmpgdb
echo "print srv_thread_concurrency" >> /tmp/pmpgdb

t=$( date +'%y%m%d_%H%M%S' )
echo tag is $t
rm -f f.$t
for x in $( seq 1 $loop ); do
  gdb --command /tmp/pmpgdb  --batch -p $mpid | grep -v 'New Thread' >> f.$t
  sleep $sec
done
cat f.$t | awk 'BEGIN { s = ""; }  /Thread/ { print s; s = ""; } /^\#/ { if (s != "" ) { s = s "," $4} else { s = $4 } } END { print s }' -  | sort | uniq -c | sort -r -n -k 1,1 > h.$t

