
dirtofix=$1
pk=$2
dop=$3

cat $dirtofix/sb.o.scan.range100.pk${pk}.dop${dop} \
  | grep "time elapsed" \
  | awk '{ print $3 }' \
  | tr 's' ' ' \
  | awk '{ printf "%.1f\tinnodb scan range=100\n", 1000000.0 / $1 }' \
  > $dirtofix/sb.r.qps.scan.range100.pk${pk}

