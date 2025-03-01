
cat - | awk 'BEGIN { s = ""; }  /^Thread/ { print s; s = ""; } /^#/ { x=index($2, "0x"); if (x == 1) { n=$4 } else { n=$2 }; if (s != "" ) { s = s "," n} else { s = n } } END { print s }' -  | sort | uniq -c | sort -r -n -k 1,1 

