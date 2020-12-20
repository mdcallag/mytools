for f in *.scr.gz; do 
  bf=$( basename $f .gz )
  gunzip $f
  ~/git/FlameGraph/stackcollapse-perf.pl $bf  | ~/git/FlameGraph/flamegraph.pl > ${bf}.svg
  gzip -9 $bf
  gzip -9 ${bf}.svg
done

