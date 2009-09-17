mpid=$1
db -ex "set pagination 0" -ex "thread apply all bt" --batch -p $mpid | \
awk 'BEGIN { s = ""; }  /Thread/ { print s; s = ""; } /^\#/ { if (s != "" ) { s = s "," $4} else { s = $4 } } END { print s }' -  | \
sort | uniq -c | sort -r -n -k 1,1
