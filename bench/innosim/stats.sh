max_concur=$1

for d in 0 6 17 25 100 ; do rm -f dr.$d dw.$d p.$d percentile_iops.$d report.$d ; done
rm -f r 

u=1
while [ $u -le $max_concur ]; do
for d in 0 6 17 25 100 ; do

grep final o.bl_1.trx_1.dblwr_1.wthr_8.uthr_${u}.dirty_$d* | grep read: | awk '{ printf "%.0f\t%s\t%s\t\n", $5, $7, $11 }' >> dr.$d 
grep final o.bl_1.trx_1.dblwr_1.wthr_8.uthr_${u}.dirty_$d* | grep ^write: | awk '{ printf "%.0f\t%s\t%s\t\n", $5, $7, $11 }' >> dw.$d 

done
u=$(( $u * 2 ))
done

u=1
while [ $u -le $max_concur ]; do
grep final o.bl_1.trx_1.dblwr_1.wthr_8.uthr_${u}.dirty_0* | grep read:
u=$(( $u * 2 ))
done | awk '{ printf "%.0f\n", $5 }' > r

for d in 0 6 17 25 100 ; do paste dr.$d dw.$d r > p.$d ; done

for d in 0 6 17 25 100 ; do

echo "r_IO - average read IOPs" > report.$d
echo "r_avlat - average read IO latency in millisecs" >> report.$d
echo "r_99lat - 99th percentile read latency in millisecs" >> report.$d
echo "w_IO - average write IOPs" >> report.$d
echo "w_avlat - average write IO latency in millisecs" >> report.$d
echo "w_99lat - 99th percentile write latency in millisecs" >> report.$d
echo "ro_axIO - average read IOPs for read-only test with same concurrency" >> report.$d
echo "" >> report.$d
echo r_IO r_avlat r_99lat w_IO w_avlat w_99lat ro_maxIO | awk '{ printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, $3, $4, $5, $6, $7 }' >> report.$d

awk '{ printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, $3, $4, $5, $6, $7 }' p.$d >> report.$d

done

for d in 0 6 17 25 100 ; do

echo "read IOPs at different percentiles over per-interval output" > percentile_iops.$d
echo p50 p75 p90 p95 p96 p97 p98 p99 | \
    awk '{ printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, $3, $4, $5, $6, $7, $8 }' >> \
    percentile_iops.$d

u=1
while [ $u -le $max_concur ]; do

grep "^final percentile rd IOPs" o.bl_1.trx_1.dblwr_1.wthr_8.uthr_$u.dirty_$d.* | \
    awk '{ printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $5, $7, $9, $11, $13, $15, $17, $19 }'

u=$(( $u * 2 ))
done >> percentile_iops.$d
done

