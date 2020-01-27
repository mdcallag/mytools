ddir=$1
pdir=$PWD

dtag=$( echo $ddir | tr '/' '.' )

echo :: $ddir :: $pdir

for x in pre post; do
  for t in sec op; do
    echo l.eff $t $x
    echo bash $pdir/proc.l.eff.sh $x $t 
    cd $ddir; bash $pdir/proc.l.eff.sh $x $t | tr ',' '\t' > $pdir/p.l.$x.eff.$t.$dtag; cd $pdir
  done
done
echo l.rt $x
cd $ddir; bash $pdir/proc.l.rt.sh | tr ',' '\t'      > $pdir/p.l.rt.$dtag; cd $pdir

shift 1
if [[ $# -gt 0 ]]; then
  doparr=( "$@" )
  for tag in "${doparr[@]}" ; do
    echo run for tag :: $tag
    for t in sec op; do
      cd $ddir; bash $pdir/proc.r.eff.sh $tag $t | tr ',' '\t' > $pdir/p.r.eff.$t.$tag.$dtag; cd $pdir
    done
    for x in node link ; do
      cd $ddir; bash $pdir/proc.r.rt.sh $tag $x | tr ',' '\t'      > $pdir/p.r.rt.$x.$tag.$dtag; cd $pdir
    done
  done
fi
