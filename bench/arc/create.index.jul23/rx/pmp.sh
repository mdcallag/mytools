mpid=$1
echo "set pagination 0" > /tmp/pmpgdb
echo "thread apply all bt" >> /tmp/pmpgdb

t=$( date +'%y%m%d_%H%M%S' )
echo tag is $t
gdb --command /tmp/pmpgdb  --batch -p $mpid | grep -v 'New Thread' > f.$t

cat f.$t | awk 'BEGIN { s = ""; }  /^Thread/ { print s; s = ""; } /^\#/ { x=index($2, "0x"); if (x == 1) { n=$4 } else { n=$2 }; if (s != "" ) { s = s "," n} else { s = n } } END { print s }' -  | sort | uniq -c | sort -r -n -k 1,1 > h.$t

