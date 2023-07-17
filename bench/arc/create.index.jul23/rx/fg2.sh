tag=$1
secs=$2

sfx="${secs}.${tag}"

~/git/FlameGraph/stackcollapse-perf.pl perf.script.$sfx | ~/git/FlameGraph/flamegraph.pl > fg.${sfx}.svg

