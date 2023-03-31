
pk=$1

#sb.r.qps.read-only.pre.range10.pk1

tPre=( \
point-query.pre.range100 \
points-covered-pk.pre.range100 \
points-covered-si.pre.range100 \
points-notcovered-pk.pre.range100 \
points-notcovered-si.pre.range100 \
random-points.pre.range1000 \
random-points.pre.range100 \
random-points.pre.range10 \
range-covered-pk.pre.range100 \
range-covered-si.pre.range100 \
range-notcovered-pk.pre.range100 \
range-notcovered-si.pre.range100 \
read-only.pre.range10000 \
read-only.pre.range100 \
read-only.pre.range10 \
)

tPost=( \
point-query.range100 \
points-covered-pk.range100 \
points-covered-si.range100 \
points-notcovered-pk.range100 \
points-notcovered-si.range100 \
random-points.range1000 \
random-points.range100 \
random-points.range10 \
range-covered-pk.range100 \
range-covered-si.range100 \
range-notcovered-pk.range100 \
range-notcovered-si.range100 \
read-only.range10000 \
read-only.range100 \
read-only.range10 \
)

nTests=${#tPre[@]}

for x1 in $( seq 1 $nTests ) ; do
  x=$(( $x1 - 1 ))
  preName=sb.r.qps.${tPre[$x]}.pk${pk}
  postName=sb.r.qps.${tPost[$x]}.pk${pk}
  preQps=$( cat $preName | awk '{ print $1 }' )
  postQps=$( cat $postName | awk '{ print $1 }' )
  ratio=$( echo $preQps $postQps | awk '{ printf "%.2f", $2 / $1 }' )
  echo -e "$preQps\t$postQps\t$ratio\t$postName"
done
