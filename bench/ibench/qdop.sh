nr=$1

for i in 1 2 4 8 12 16 20 24 28 32 36 40 44 48 52 ; do
grep "rows-per-second" my.500m.${i}c.*.so/l/o.res.dop${i}.ns3  | awk '{ printf "%.0f\t", $7 }' 
done
echo

for i in 1 2 4 8 12 16 20 24 28 32 36 40 44 48 52 ; do
q4=$( grep "0 explain" my.500m.${i}c.*.so/scan/o.ib.scan | grep "Query 4 scan" | awk '{ print $4 }' )
q5=$( grep "0 explain" my.500m.${i}c.*.so/scan/o.ib.scan | grep "Query 5 scan" | awk '{ print $4 }' )
#echo dop is $i, q4 is $q4, q5 is $q5
mrps=$( echo "scale=3; (2 * $nr) / ($q4 + $q5)" | bc )
printf "%.1f\t" $mrps 
done
echo

