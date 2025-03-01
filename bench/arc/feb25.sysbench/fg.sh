for f in sb.perf.rep.g.scr.*.gz ; do
  echo Process $f
  bf=$( basename $f .gz )
  gunzip $f
  ~/git/FlameGraph/stackcollapse-perf.pl $bf  | ~/git/FlameGraph/flamegraph.pl > ${bf}.svg
  gzip -9 $bf
  gzip -9 ${bf}.svg
done

