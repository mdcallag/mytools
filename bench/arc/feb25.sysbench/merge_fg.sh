tag=$1

for f in sb.perf.rep.g.scr.${tag}.*.gz ; do
  echo Process $f
  bf=$( basename $f .gz )
  gunzip $f
  ~/git/FlameGraph/stackcollapse-perf.pl $bf > collapse.${bf}
  gzip $bf
done

cat collapse.* |  ~/git/FlameGraph/flamegraph.pl > ${tag}.svg
rm collapse.*

