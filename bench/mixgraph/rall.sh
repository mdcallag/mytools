
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

if [ $load == "yes" ]; then
  dbpath="/data/m/rx.k_$mkeys.${dbpfx}.bs_4096"
  rm -rf $dbpath
  rm -rf $dbpath.bak
  bash load.sh $mkeys 4096 1 1 $numdb
  mv $dbpath $dbpath.bak 
fi

for cgb in 1 2 4 8 16 32 64 128 ; do
for j in hwperf all_random all_dist prefix_random prefix_dist ; do
  echo $j with cgb $cgb at $( date )
  bash run.sh $mkeys 4096 $cgb 1 $nsecs yes $j all $numdb
done
done

