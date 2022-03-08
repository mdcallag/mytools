
# if yes then wipe the database directory and run load.sh
load=$1
# if > 1 then --num_multi_db is used
numdb=$2
# --num (number of keys) in millions, with --num_multi_db this is per-database, 1000 ~= 144gb of data
mkeys=$3
# --duration, number of seconds for which mixgraph runs
nsecs=$4

if [ $numdb -gt 1 ]; then
  dbpfx="multidb_$numdb"
  dbopt="--num_multi_db=$numdb"
else
  dbpfx="db_apdx"
  dbopt=""
fi

for cgb in 1 2 4 8 16 32 64 128 ; do
echo; echo cgb $cgb
for j in hwperf all_random all_dist prefix_random prefix_dist ; do
  echo; echo $j with cgb $cgb
  cat o.run.sum.k_${mkeys}.${dbpfx}.bs_4096.cgb_${cgb}.wfmb_1.${j}.op_all | grep -v ZZ
done
done > o.run.sum.1

echo "Block cache hit rate by block cache size in GB, database size is 574 GB" > o.run.sum.2
for cgb in 1 2 4 8 16 32 64 128 ; do
  echo -e -n "$cgb\t"
done >> o.run.sum.2
echo "cache-size/mixgraph-config" >> o.run.sum.2

for j in hwperf all_random all_dist prefix_random prefix_dist ; do
for cgb in 1 2 4 8 16 32 64 128 ; do
  bchp=$( grep "^block cache hit percent" o.run.sum.k_${mkeys}.${dbpfx}.bs_4096.cgb_${cgb}.wfmb_1.${j}.op_all | awk '{ print $5 }' )
  echo -e -n "$bchp\t"
done
echo $j 
done >> o.run.sum.2

