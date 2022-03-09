
# if yes then wipe the database directory and run load.sh
load=$1
# if > 1 then --num_multi_db is used
numdb=$2
# --num (number of keys) in millions, with --num_multi_db this is per-database, 1000 ~= 144gb of data
mkeys=$3
# --duration, number of seconds for which mixgraph runs
nsecs=$4
# all, seek, get, put
op=$5

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
  cat o.run.sum.k_${mkeys}.${dbpfx}.bs_4096.cgb_${cgb}.wfmb_1.${j}.op_$op 
done
done > o.run.sum.$op

# block cache hit rate

echo "Block cache hit rate by block cache size in GB" > o.run.sum.hitrate.$op
for cgb in 1 2 4 8 16 32 64 128 ; do
  echo -e -n "$cgb\t"
done >> o.run.sum.hitrate.$op
echo "cache-size/mixgraph-config" >> o.run.sum.hitrate.$op

for j in hwperf all_random all_dist prefix_random prefix_dist ; do
for cgb in 1 2 4 8 16 32 64 128 ; do
  bchp=$( grep "^block cache hit percent" o.run.sum.k_${mkeys}.${dbpfx}.bs_4096.cgb_${cgb}.wfmb_1.${j}.op_$op | awk '{ print $5 }' )
  echo -e -n "$bchp\t"
done
echo $j 
done >> o.run.sum.hitrate.$op

# Using data from o.run.sum.* files ...
# o/s     get/s   put/s   seek/s  r/s     rMB/s   wMB/s   r/o     rKB/o   wKB/o   r/s+g   rKB/s+g wKB/p
# 19256   15983   2697    577     5267    54.2    0.7     0.27    2.88    0.04    0.32    3.35    0.27

names=( o/s get/s put/s seek/s r/s rMB/s wMB/s r/o rKB/o wKB/o r/s+g rKB/s+g wKB/p )

offset=1
for name in "${names[@]}" ; do
  fname=$( echo $name | sed 's/\//_per_/' | sed 's/\+/_plus_/' )
  fname="$fname.$op"
  echo ::$name:: ::$fname::
  echo "$name by block cache size in GB" > o.run.sum.$fname

  for cgb in 1 2 4 8 16 32 64 128 ; do
    echo -e -n "$cgb\t"
  done >> o.run.sum.$fname
  echo "cache-size/mixgraph-config" >> o.run.sum.$fname

  for j in hwperf all_random all_dist prefix_random prefix_dist ; do
  for cgb in 1 2 4 8 16 32 64 128 ; do
    val=$( tail -1 o.run.sum.k_${mkeys}.${dbpfx}.bs_4096.cgb_${cgb}.wfmb_1.${j}.op_${op} | awk '{ print $offset }' offset=$offset )
    echo -e -n "$val\t"
  done
  echo $j 
  done >> o.run.sum.$fname

  offset=$(( $offset + 1 ))
done
