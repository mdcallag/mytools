tag=$1
secs=$2
pid=$3

sfx="$secs.$tag"

perf record -a -F 99 -g -p $pid -o perf.data.$sfx -- sleep $secs
perf script -i perf.data.$sfx > perf.script.$sfx

chown mdcallag perf.data.$sfx
chown mdcallag perf.script.$sfx
