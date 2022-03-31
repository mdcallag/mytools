# x=rx.real; for i in 1 2 3 ; do zcat perf.rep.g.scr.*.$i.* | ~/local/git/FlameGraph.me/stackcollapse-perf.pl > $i.$x.fold; ~/local/git/FlameGraph.me/flamegraph.pl $i.$x.fold > $i.$x.svg; done

perf_secs=$1
loops=$2
pid=$3
tag=$4
pause_secs=$5
perf=$6

for x in $( seq 1 $loops ); do

  ts=$( date +'%b%d.%H%M%S' )
  echo Loop $x of $loops at $ts measuring for $perf_secs seconds
  sfx="$tag.$x.$ts"
  outf="perf.rec.g.$sfx"
  $perf record -g -p $pid -o $outf -- sleep $perf_secs

  $perf report --stdio --no-children -i $outf > perf.rep.g.f0.c0.$sfx
  $perf report --stdio --children    -i $outf > perf.rep.g.f0.c1.$sfx
  $perf report --stdio -n -g folded -i $outf > perf.rep.g.f1.cother.$sfx
  $perf report --stdio -n -g folded -i $outf --no-children > perf.rep.g.f1.c0.$sfx
  $perf report --stdio -n -g folded -i $outf --children > perf.rep.g.f1.c1.$sfx
  $perf script -i perf.rec.g.$sfx | gzip --fast > perf.rep.g.scr.$sfx.gz
  gzip --fast $outf

  ts=$( date +'%b%d.%H%M%S' )
  echo Loop $x of $loops at $ts measuring for $perf_secs seconds
  sfx="$tag.$x.$ts"
  outf="perf.rec.f.$sfx"

  $perf record -p $pid -o $outf -- sleep $perf_secs
  $perf report --stdio -i $outf > perf.rep.f.$sfx
  $perf script -i $outf | gzip --fast > perf.rep.f.scr.$sfx.gz
  gzip --fast $outf

  echo Sleep for $pause_secs seconds
  sleep $pause_secs
done
