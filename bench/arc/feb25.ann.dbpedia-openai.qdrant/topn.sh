
dbms=$1

sfx=""
for d in "$@" ; do
  if [ -z $sfx ]; then
    sfx=$d
  else
    sfx=$sfx.$d
  fi
done

for topN in 1 3; do
for lim in 1.000 0.99 0.98 0.97 0.96 0.95 ; do
  echo "Best QPS with recall >= $lim"
  # for inf in qr.pgvector.qps qr.pgvector_halfvec.qps qr.maria.qps ; do
  for d in "$@" ; do
    inf="qr.$d.qps"
    #echo try for $inf
    cat $inf | awk '{ if ($1 >= lim) { print $0 } }' lim=$lim | head -${topN}
    if [[ topN -gt 1 ]]; then echo; fi
  done
  if [[ topN -eq 1 ]]; then echo; fi
done > qr.topN.$topN.$sfx
done
