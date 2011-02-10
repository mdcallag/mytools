for d in 6 17 25 ; do rm -f d.$d p.$d percentile_iops.$d report.$d ; done

rm -f r

for u in 1 4 8 16 32 64 ; do
for d in 6 17 25 ; do

grep final o.bl_1.trx_1.dblwr_1.wthr_8.uthr_${u}.dirty_$d* | grep read: | awk '{ printf "%.0f\t%s\t%s\t\n", $5, $7, $11 }' >> d.$d 

done
done

for u in 1 4 8 16 32 64 ; do

grep final o.bl_1.trx_1.dblwr_1.wthr_8.uthr_${u}.dirty_0* | grep read:

done | awk '{ printf "%.0f\n", $5 }' > r

for d in 6 17 25 ; do paste d.$d r > p.$d ; done

for d in 6 17 25 ; do

awk '{ printf "%s\t%s\t%s\t%s\t%.3f\n", $1, $2, $3, $4, ($1 * ((100 + d + d) / 100)) / $4 }' d=$d p.$d > report.$d 

done

for d in 6 17 25 ; do
for u in 1 4 8 16 32 64  ; do

grep "^final percentile rd IOPs" o.bl_1.trx_1.dblwr_1.wthr_8.uthr_$u.dirty_$d.* | \
    awk '{ printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $5, $7, $9, $11, $13, $15, $17, $19 }'

done >> percentile_iops.$d
done

