
#for v in 0 1; do bash ~/join_perfstat_sb.sh mysome $v x.my5651_rel_o2nofp.z11a_c8r32.pk1 x.my5710_rel_o2nofp.z11a_c8r32.pk1 x.my5744_rel_o2nofp.z11a_c8r32.pk1 x.my8011_rel_o2nofp.z11a_c8r32.pk1 x.my8028_rel_o2nofp.z11a_c8r32.pk1 x.my8037_rel_o2nofp.z11a_c8r32.pk1 ; done

prefix=$1
v=$2

dn1="$3"
shift 3

for tn in \
sb.perf.hw.hot-points.range100.pk1.${v}.sorted \
sb.perf.hw.point-query.pre.range100.pk1.${v}.sorted \
sb.perf.hw.point-query.range100.pk1.${v}.sorted \
sb.perf.hw.point-query.warm.range100.pk1.${v}.sorted \
sb.perf.hw.points-covered-pk.pre.range100.pk1.${v}.sorted \
sb.perf.hw.points-covered-pk.range100.pk1.${v}.sorted \
sb.perf.hw.points-covered-si.pre.range100.pk1.${v}.sorted \
sb.perf.hw.points-covered-si.range100.pk1.${v}.sorted \
sb.perf.hw.points-notcovered-pk.pre.range100.pk1.${v}.sorted \
sb.perf.hw.points-notcovered-pk.range100.pk1.${v}.sorted \
sb.perf.hw.points-notcovered-si.pre.range100.pk1.${v}.sorted \
sb.perf.hw.points-notcovered-si.range100.pk1.${v}.sorted \
sb.perf.hw.random-points.pre.range1000.pk1.${v}.sorted \
sb.perf.hw.random-points.pre.range100.pk1.${v}.sorted \
sb.perf.hw.random-points.pre.range10.pk1.${v}.sorted \
sb.perf.hw.random-points.range1000.pk1.${v}.sorted \
sb.perf.hw.random-points.range100.pk1.${v}.sorted \
sb.perf.hw.random-points.range10.pk1.${v}.sorted \
sb.perf.hw.range-covered-pk.pre.range100.pk1.${v}.sorted \
sb.perf.hw.range-covered-pk.range100.pk1.${v}.sorted \
sb.perf.hw.range-covered-si.pre.range100.pk1.${v}.sorted \
sb.perf.hw.range-covered-si.range100.pk1.${v}.sorted \
sb.perf.hw.range-notcovered-pk.pre.range100.pk1.${v}.sorted \
sb.perf.hw.range-notcovered-pk.range100.pk1.${v}.sorted \
sb.perf.hw.range-notcovered-si.pre.range100.pk1.${v}.sorted \
sb.perf.hw.range-notcovered-si.range100.pk1.${v}.sorted \
sb.perf.hw.read-only.pre.range10000.pk1.${v}.sorted \
sb.perf.hw.read-only.pre.range100.pk1.${v}.sorted \
sb.perf.hw.read-only.pre.range10.pk1.${v}.sorted \
sb.perf.hw.read-only.range10000.pk1.${v}.sorted \
sb.perf.hw.read-only.range100.pk1.${v}.sorted \
sb.perf.hw.read-only.range10.pk1.${v}.sorted \
sb.perf.hw.scan.range100.pk1.${v}.sorted \
sb.perf.hw.read-write.range100.pk1.${v}.sorted \
sb.perf.hw.read-write.range10.pk1.${v}.sorted \
sb.perf.hw.update-index.range100.pk1.${v}.sorted \
sb.perf.hw.update-inlist.range100.pk1.${v}.sorted \
sb.perf.hw.update-nonindex.range100.pk1.${v}.sorted \
sb.perf.hw.update-one.range100.pk1.${v}.sorted \
sb.perf.hw.update-zipf.range100.pk1.${v}.sorted \
sb.perf.hw.write-only.range10000.pk1.${v}.sorted \
sb.perf.hw.delete.range100.pk1.${v}.sorted \
sb.perf.hw.insert.range100.pk1.${v}.sorted \
; do
  cp ${dn1}/${tn} join${v}.abs.${prefix}.${tn}
  for next_dn in "$@" ; do
    join join${v}.abs.${prefix}.${tn} ${next_dn}/${tn} > jointmp ;  mv jointmp join${v}.abs.${prefix}.${tn}
  done

  cat join${v}.abs.${prefix}.${tn} | awk '{ for (cn = 3; cn <= NF; cn += 1) { if ($2 != 0) { printf "%.3f\t", $cn / $2 } else { printf "INF\t" } }; printf "%s\n", $1 }' > join${v}.rel.${prefix}.${tn}
done
