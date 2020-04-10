ddir=$1
rdir=$2
sdir=$( dirname $0 )
pdir=$PWD

echo :: $ddir :: $pdir

for x in pre post; do
  for t in sec op; do
    echo l.eff $t $x
    #echo "cd $ddir; bash $sdir/proc.l.eff.sh $x $t "
    #echo "bash $sdir/proc.l.eff.sh $ddir $x $t > $rdir/p.l.$x.eff.$t.c.$ddir"
    bash $sdir/proc.l.eff.sh $ddir $x $t > $rdir/p.l.$x.eff.$t.c.$ddir
    cat $rdir/p.l.$x.eff.$t.c.$ddir | tr ',' '\t' > $rdir/p.l.$x.eff.$t.t.$ddir
  done
done

echo l.rt $x
bash $sdir/proc.l.rt.sh $ddir > $rdir/p.l.rt.c.$ddir
cat $rdir/p.l.rt.c.$ddir | tr ',' '\t' > $rdir/p.l.rt.t.$ddir

shift 2
if [[ $# -gt 0 ]]; then
  doparr=( "$@" )
  for tag in "${doparr[@]}" ; do
    echo run for tag :: $tag
    for t in sec op; do
      f1=$rdir/p.r.eff.$t.$tag.c.$ddir
      f2=$rdir/p.r.eff.$t.$tag.t.$ddir
      bash $sdir/proc.r.eff.sh $ddir $tag $t > $f1
      cat $f1 | tr ',' '\t' > $f2
    done
    for x in node link ; do
      f1=$rdir/p.r.rt.$x.$tag.c.$ddir
      f2=$rdir/p.r.rt.$x.$tag.t.$ddir
      bash $sdir/proc.r.rt.sh $ddir $tag $x > $f1
      cat $f1 | tr ',' '\t' > $f2
    done
  done
fi
