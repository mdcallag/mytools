rdir=$1
tag=$2
display=$3
loadonly=$4
strippfx=$5
username=$6

shift 6

echo etl for $username

bdir=$( dirname $0 )

farr=("$@")
f1=${farr[0]}

for d in "$@"; do
  echo $d
  if [ $d != "BREAK" ]; then
    bash $bdir/proc.sh $d $rdir $username $tag
  fi
done

for t in pre post ; do
for x in op sec ; do
head -1 $rdir/p.l.$t.eff.$x.t.${f1} > $rdir/z1.l.$t.eff.$x
for d in "$@"; do
  if [ $d == "BREAK" ]; then
    echo "-"
  else
    tail -1 $rdir/p.l.$t.eff.$x.t.$d | sed "s/${strippfx}\.//g"
  fi
done >> $rdir/z1.l.$t.eff.$x
if [[ $display == "yes" ]]; then
  if [ $d == "BREAK" ]; then
    echo "-"
  else
    echo $rdir/z1.l.$t.eff.$x
    cat $rdir/z1.l.$t.eff.$x
  fi
fi
done
done

head -1 $rdir/p.l.rt.t.${f1} > $rdir/z2.l.rt
for d in "$@"; do
  if [ $d == "BREAK" ]; then
    echo "-"
  else
    tail -1 $rdir/p.l.rt.t.$d | sed "s/${strippfx}\.//g"
  fi
done >> $rdir/z2.l.rt
if [[ $display == "yes" ]]; then
  if [ $d == "BREAK" ]; then
    echo "-"
  else
    echo $rdir/z2.l.rt
    cat $rdir/z2.l.rt
  fi
fi

if [ $loadonly == "yes" ]; then exit 0; fi

for x in op sec ; do
head -1 $rdir/p.r.eff.$x.$tag.t.${f1} > $rdir/z3.r.eff.$x.$tag
for d in "$@"; do
  if [ $d == "BREAK" ]; then
    echo "-"
  else
    tail -1 $rdir/p.r.eff.$x.$tag.t.$d | sed "s/${strippfx}\.//g"
  fi
done >> $rdir/z3.r.eff.$x.$tag
if [[ $display == "yes" ]]; then
  if [ $d == "BREAK" ]; then
    echo "-"
  else
    echo $rdir/z3.r.eff.$x.$tag
    cat $rdir/z3.r.eff.$x.$tag
  fi
fi
done

for x in node link; do
head -1 $rdir/p.r.rt.$x.$tag.t.${f1} > $rdir/z4.r.rt.$x.$tag
for d in "$@"; do
  if [ $d == "BREAK" ]; then
    echo "-"
  else
    tail -1 $rdir/p.r.rt.$x.$tag.t.$d | sed "s/${strippfx}\.//g"
  fi
done >> $rdir/z4.r.rt.$x.$tag
if [[ $display == "yes" ]]; then
  if [ $d == "BREAK" ]; then
    echo "-"
  else
    echo $rdir/z4.r.rt.$x.$tag
    cat $rdir/z4.r.rt.$x.$tag
  fi
fi
done

