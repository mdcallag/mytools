tag=$1
shift 1

bn=$1
cat $bn/sb.r.qps.* | awk '{ for (f=3; f <= NF ; f++) { printf "%s ", $f }; printf "\n" }' > xrsh.lines

y=1
for x in "$@" ; do
  echo "col-${y} : $x"
  y=$(( y + 1 ))
done > xrsh.inputs
echo >> xrsh.inputs

y=1
for x in "$@" ; do
  if [ $y -eq 1 ]; then
    echo -n "col-${y}";
  else
    echo -e -n "\tcol-${y}";
  fi
  y=$(( y + 1 ))
done > xrsh.header
echo >> xrsh.header

y=1
for x in "$@" ; do
  cat $x/sb.r.qps.* | awk '{ print $1 }' > $x.qps
  if [ $y -eq 1 ]; then
    cp $x.qps xrsh.all
  else
    paste xrsh.all $x.qps > xrsh.all.tmp; mv xrsh.all.tmp xrsh.all
  fi
  y=$(( y + 1 ))
done

paste xrsh.all xrsh.lines > xrsh.all.tmp; mv xrsh.all.tmp xrsh.all
cat xrsh.inputs xrsh.header xrsh.all > sum.$tag
