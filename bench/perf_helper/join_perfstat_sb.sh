
#bash ~/join_perfstat.sh mysome x.my5651_rel_o2nofp.z11a_c8r32.pk1 x.my5710_rel_o2nofp.z11a_c8r32.pk1 x.my5744_rel_o2nofp.z11a_c8r32.pk1 x.my8011_rel_o2nofp.z11a_c8r32.pk1 x.my8037_rel_o2nofp.z11a_c8r32.pk1

prefix=$1
v=$2

dn1="$3"
shift 3

for tn in \
sorted${v}.sb.perf.last.hot-points.range100.pk1 \
sorted${v}.sb.perf.last.point-query.pre.range100.pk1 \
sorted${v}.sb.perf.last.point-query.range100.pk1 \
sorted${v}.sb.perf.last.point-query.warm.range100.pk1 \
sorted${v}.sb.perf.last.points-covered-pk.pre.range100.pk1 \
sorted${v}.sb.perf.last.points-covered-pk.range100.pk1 \
sorted${v}.sb.perf.last.points-covered-si.pre.range100.pk1 \
sorted${v}.sb.perf.last.points-covered-si.range100.pk1 \
sorted${v}.sb.perf.last.points-notcovered-pk.pre.range100.pk1 \
sorted${v}.sb.perf.last.points-notcovered-pk.range100.pk1 \
sorted${v}.sb.perf.last.points-notcovered-si.pre.range100.pk1 \
sorted${v}.sb.perf.last.points-notcovered-si.range100.pk1 \
sorted${v}.sb.perf.last.random-points.pre.range1000.pk1 \
sorted${v}.sb.perf.last.random-points.pre.range100.pk1 \
sorted${v}.sb.perf.last.random-points.pre.range10.pk1 \
sorted${v}.sb.perf.last.random-points.range1000.pk1 \
sorted${v}.sb.perf.last.random-points.range100.pk1 \
sorted${v}.sb.perf.last.random-points.range10.pk1 \
sorted${v}.sb.perf.last.range-covered-pk.pre.range100.pk1 \
sorted${v}.sb.perf.last.range-covered-pk.range100.pk1 \
sorted${v}.sb.perf.last.range-covered-si.pre.range100.pk1 \
sorted${v}.sb.perf.last.range-covered-si.range100.pk1 \
sorted${v}.sb.perf.last.range-notcovered-pk.pre.range100.pk1 \
sorted${v}.sb.perf.last.range-notcovered-pk.range100.pk1 \
sorted${v}.sb.perf.last.range-notcovered-si.pre.range100.pk1 \
sorted${v}.sb.perf.last.range-notcovered-si.range100.pk1 \
sorted${v}.sb.perf.last.read-only.pre.range10000.pk1 \
sorted${v}.sb.perf.last.read-only.pre.range100.pk1 \
sorted${v}.sb.perf.last.read-only.pre.range10.pk1 \
sorted${v}.sb.perf.last.read-only.range10000.pk1 \
sorted${v}.sb.perf.last.read-only.range100.pk1 \
sorted${v}.sb.perf.last.read-only.range10.pk1 \
sorted${v}.sb.perf.last.scan.range100.pk1 \
sorted${v}.sb.perf.last.read-write.range100.pk1 \
sorted${v}.sb.perf.last.read-write.range10.pk1 \
sorted${v}.sb.perf.last.update-index.range100.pk1 \
sorted${v}.sb.perf.last.update-inlist.range100.pk1 \
sorted${v}.sb.perf.last.update-nonindex.range100.pk1 \
sorted${v}.sb.perf.last.update-one.range100.pk1 \
sorted${v}.sb.perf.last.update-zipf.range100.pk1 \
sorted${v}.sb.perf.last.write-only.range10000.pk1 \
sorted${v}.sb.perf.last.delete.range100.pk1 \
sorted${v}.sb.perf.last.insert.range100.pk1 \
; do
  cp ${dn1}/${tn} join${v}.abs.${prefix}.${tn}
  for next_dn in "$@" ; do
    join join${v}.abs.${prefix}.${tn} ${next_dn}/${tn} > jointmp ;  mv jointmp join${v}.abs.${prefix}.${tn}
  done

  cat join${v}.abs.${prefix}.${tn} | awk '{ for (cn = 3; cn <= NF; cn += 1) { if ($2 != 0) { printf "%.3f\t", $cn / $2 } else { printf "INF\t" } }; printf "%s\n", $1 }' > join${v}.rel.${prefix}.${tn}
done
