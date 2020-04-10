rdir=$1
tag=$2
display=$3

shift 3

bdir=$( dirname $0 )

farr=("$@")
f1=${farr[0]}

for d in "$@"; do
  echo $d
  bash $bdir/proc.sh $d $rdir $tag
done

for t in pre post ; do
for x in op sec ; do
head -1 p.l.$t.eff.$x.t.${f1} > z1.l.$t.eff.$x
for d in "$@"; do
  tail -1 p.l.$t.eff.$x.t.$d
done >> z1.l.$t.eff.$x
if [[ $display == "yes" ]]; then
  echo z1.l.$t.eff.$x
  cat z1.l.$t.eff.$x
fi
done
done

head -1 p.l.rt.t.${f1} > z2.l.rt
for d in "$@"; do
  tail -1 p.l.rt.t.$d
done >> z2.l.rt
if [[ $display == "yes" ]]; then
  echo z2.l.rt
  cat z2.l.rt
fi

for x in op sec ; do
head -1 p.r.eff.$x.$tag.t.${f1} > z3.r.eff.$x.$tag
for d in "$@"; do
  tail -1 p.r.eff.$x.$tag.t.$d
done >> z3.r.eff.$x.$tag
if [[ $display == "yes" ]]; then
  echo z3.r.eff.$x.$tag
  cat z3.r.eff.$x.$tag
fi
done

for x in node link; do
head -1 p.r.rt.$x.$tag.t.${f1} > z4.r.rt.$x.$tag
for d in "$@"; do
  tail -1 p.r.rt.$x.$tag.t.$d
done >> z4.r.rt.$x.$tag
if [[ $display == "yes" ]]; then
  echo z4.r.rt.$x.$tag
  cat z4.r.rt.$x.$tag
fi
done

