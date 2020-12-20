f1=$1
f2=$2
tag=$3

~/git/FlameGraph/stackcollapse-perf.pl $f1 > /tmp/fold.f1
~/git/FlameGraph/stackcollapse-perf.pl $f2 > /tmp/fold.f2
~/git/FlameGraph/difffolded.pl /tmp/fold.f1 /tmp/fold.f2 | ~/git/FlameGraph/flamegraph.pl > diff.$tag.svg

