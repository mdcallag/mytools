tag1=$1
tag2=$2
fn=$3

x=1
for c1 in $( grep "$tag1" $fn ); do
  c2=$( grep "$tag2" $fn | awk '{ print $x }' x=$x )
  ch=$( head -1 $fn | awk '{ print $x }' x=$x )
  if [[ $c2 == "0" || $c2 == "0.000" ]]; then
    printf "%s\t%s\tdiv0\t%s\n" $c1 $c2 $ch
  else
    echo $c1 $c2 $ch | awk '{ printf "%s\t%s\t%.3f\t%s\n", $1, $2, $1 / $2, $3 }'
  fi
  x=$(( $x + 1 ))
done

