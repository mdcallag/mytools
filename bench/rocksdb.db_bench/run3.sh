
nrows=$1
rowsz=$2
nsecs=$3
wbmb=$4
l1mb=$5
bcmb=$6

nfiles=45000
dbdir=/data/m/rx

for rv in v64 v611 v612 v613 v614 v615 v616 v617 ; do
  rm -rf $dbdir; mkdir $dbdir
  bash all3.sh $dbdir $nrows $nsecs 1 $rowsz 1024 $wbmb 2 4 $l1mb 8 3 none $bcmb 2048 60 5.8 ~/d/db_bench.$rv 10 45000 2>& 1 | tee o.$rv
  rm -rf res.$rv; mkdir res.$rv; mv o.* res.$rv
done

