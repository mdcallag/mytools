dir1=$1
dir2=$2
tag=$3

resdir="$dir1.$dir2"
mkdir -p $resdir

for ndir in l.i0 l.i1 q.L1.ips100 q.L2.ips500 q.L3.ips1000 ; do
  mkdir -p $resdir/$ndir
  n1=$( ls $dir1/$ndir/*.fold.* | wc -l )
  n2=$( ls $dir2/$ndir/*.fold.* | wc -l )
  n=$( echo $n1 $n2 | awk '{ if ($1 < $2) { print $1 } else { print $2 } }' )
  echo For $ndir counts are $n1 and $n2 with min $n
  for x in $( seq 1 $n ); do
    f1=$( ls -rt $dir1/$ndir/*.fold.* | head -${x} | tail -1 )
    f2=$( ls -rt $dir2/$ndir/*.fold.* | head -${x} | tail -1 )
    echo Diff $x : $f1 and $f2
    ~/git/FlameGraph/difffolded.pl $f1 $f2 | ~/git/FlameGraph/flamegraph.pl > $resdir/$ndir/$tag.$ndir.$x.svg
  done
done

