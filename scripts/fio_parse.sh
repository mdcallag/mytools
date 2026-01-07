fn=$1

 #IOPS=56k,
 #BW=154MiB/s
 #3 + 3 + 5 = 11

 # write: IOPS=3447, BW=3448MiB/s (3615MB/s)(1024MiB/297msec); 0 zone resets
 # write: IOPS=34.0k, BW=531MiB/s (557MB/s)(156GiB/300001msec); 0 zone resets
 #
 #     clat (msec): min=3, max=732, avg=19.32, stdev=32.07
 #   sync (msec): min=3, max=582, avg=13.92, stdev=15.00
 #   clat (usec): min=1845, max=871768, avg=18108.91, stdev=31006.71

cat $fn | \
awk \
  '/^O_DIRECT/ { if (h != 0) { if (count_slat == 0) { count_slat = 1 }; printf "%s\t%.1f\t%.1f\t%d\t%s_%s\n", sum_iops, sum_bw / (1024*1024), sum_slat/count_slat, count_slat, h, bs }; h = $3; bs = $7; sum_iops=0; sum_bw=0; sum_slat=0; count_slat=0; }; \
  /IOPS=/ { l = length($2); c = substr($2, l-1, 1); hask=0; if (c == "k") { hask=1 }; val = substr($2, 6, l-(6 + hask)); if (hask == 1) { val = val * 1000; }; sum_iops += val; } \
  /BW=/ { l = length($3); z = substr($3, l-4, 3); if (z == "KiB") { m = 1000 } else if (z == "MiB") { m = 1000000 } else if (z == "GiB") { m = 1000000000 } else { printf "cannot parse %s\n", $3; exit 1 }; val = substr($3, 4, l- (4 + 5) + 1); val = val * m; sum_bw += val } \
  /sync \(/ { l = length($5); val = substr($5, 5, l - 5); if ($2 == "(msec):" ) { val = val * 1000; } else if ($2 == "(usec):") { us=1; } else if ($2 == "(nsec):") { val = val / 1000.0 } else { printf "cannot parse %s\n", $2; exit 1 }; l = length($5); sum_slat += val; count_slat += 1; } \
  END { if (h != 0) { if (count_slat == 0) { count_slat = 1 }; printf "%s\t%.1f\t%.1f\t%d\t%s_%s\n", sum_iops, sum_bw / (1024*1024), sum_slat, count_slat, h, bs } }'
