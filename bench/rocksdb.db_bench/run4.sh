
nrows=$1
rowsz=$2
nsecs=$3
wbmb=$4
l1mb=$5
bcmb=$6
nthr=$7

nfiles=45000
dbdir=/data/m/rx

#for rv in v64 v611 v612 v613 v614 v615 v616 v617 ; do
rv=vlperf
ctype=zstd

# secs_debt
#nsdebt=60
nsdebt=600

for mltc in 0 1 ; do
  rm -rf $dbdir; mkdir $dbdir
  bash all4.sh $dbdir $nrows $nsecs $nthr $rowsz 1024 $wbmb 4 4 $l1mb 8 $mltc $ctype $bcmb 2048 $nsdebt 5.8 ~/d/db_bench.$rv 10 45000 2>& 1 | tee o.$rv
  rm -rf res.$rv; mkdir res.$rv.mltc${mltc}; mv o.* res.$rv.mltc${mltc}
done

