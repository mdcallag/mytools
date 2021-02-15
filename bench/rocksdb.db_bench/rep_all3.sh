
x=1
for f in "$@" ; do
  if [[ $x -lt $# ]] ; then
    printf "%s\t" $f
  else
    printf "%s\ttest\n" $f
  fi
  x=$(( $x + 1 ))
done

nlines=$( wc -l res.$1/o.res.* | awk '{ print $1 }' )
for line in $( seq 1 $nlines ) ; do
x=1
for f in "$@" ; do
  if [[ $x -lt $# ]] ; then
    cat res.$f/o.res.* | head -${line} | tail -1 | awk '{ printf "%.1f\t", $3 }'
  else
    cat res.$f/o.res.* | head -${line} | tail -1 | awk '{ printf "%.1f\t%s\n", $3, $1 }'
  fi
  x=$(( $x + 1 ))
done
done

echo
x=1
for f in "$@" ; do
  if [[ $x -lt $# ]] ; then
    printf "%s\t" $f
  else
    printf "%s\ttest\n" $f
  fi
  x=$(( $x + 1 ))
done

for line in $( seq 1 $nlines ) ; do
x=1
for f in "$@" ; do
  if [[ $x -lt $# ]] ; then
    cat res.$f/o.res.* | head -${line} | tail -1 | awk '{ printf "%.0f\t", $5 }'
  else
    cat res.$f/o.res.* | head -${line} | tail -1 | awk '{ printf "%.0f\t%s\n", $5, $1 }'
  fi
  x=$(( $x + 1 ))
done
done
