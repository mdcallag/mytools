sfx=$1
ts=$( date +%H%M%S )
sfx="$sfx.$ts"

mpid=$( pidof mysqld )

perf record -F 99 -g -p $mpid -e bus-cycles -- sleep 10 ; perf report --stdio --no-children > ps.g.bus.$sfx
sleep 3

perf record -F 99    -p $mpid -e bus-cycles -- sleep 10 ; perf report --stdio --no-children > ps.f.bus.$sfx
sleep 3

perf record -F 99 -g -p $mpid -- sleep 10 ; perf report --stdio --no-children > ps.g.def.$sfx
sleep 3

perf record -F 99    -p $mpid -- sleep 10 ; perf report --stdio --no-children > ps.f.def.$sfx
sleep 3

