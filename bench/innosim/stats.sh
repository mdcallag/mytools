for d in 6 13 17 25 ; do rm -f d.$d p.$d pz.$d q.$d ; done

rm -f r

for u in 1 4 8 16 32 64 128; do
for d in 6 13 17 25 ; do

grep final o.bl_1.trx_1.dblwr_1.wthr_8.uthr_${u}.dirty_$d* | grep read: | awk '{ printf "%.0f\t%s\t%s\t\n", $5, $7, $11 }' >> d.$d 

done
done

for u in 1 4 8 16 32 64 128; do

grep final o.bl_1.trx_1.dblwr_1.wthr_8.uthr_${u}.dirty_0* | grep read:

done | awk '{ printf "%.0f\n", $5 }' > r

for d in 6 13 17 25 ; do paste d.$d r > p.$d ; done

for d in 6 13 17 25 ; do

awk '{ printf "%s\t%s\t%s\t%s\t%.3f\n", $1, $2, $3, $4, ($1 * ((100 + d + d) / 100)) / $4 }' d=$d p.$d > q.$d 

done

for d in 6 13 17 25 ; do
for u in 1 4 8 16 32 64 128 ; do

grep read: o.bl_1.trx_1.dblwr_1.wthr_8.uthr_$u.dirty_$d.* | awk '{ print $4 }' | sort -nk1 > /tmp/o.$u.$d; p50=$( head -600 /tmp/o.$u.$d | tail -1 ); p75=$( head -300 /tmp/o.$u.$d | tail -1 ); p90=$( head -120 /tmp/o.$u.$d | tail -1 ); p95=$( head -60 /tmp/o.$u.$d | tail -1 ); p96=$( head -48 /tmp/o.$u.$d | tail -1 ); p97=$( head -36 /tmp/o.$u.$d | tail -1 ); echo $p50 $p75 $p90 $p95 $p96 $p97 | awk '{ printf "%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, $3, $4, $5, $6 }' 

done >> pz.$d 
done
