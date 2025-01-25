
suffix=$1
testname=$2
dbms_config=$3

bdir="res.${testname}.${suffix}"
mkdir $bdir

dop=1
bash run_all.batch0.sh $testname $dbms_config >& all.out
rdir="${bdir}/dop_${dop}"
mkdir $rdir
python3 plot.py --dataset $testname >& o.plot
mv o.* results/${testname}.png $rdir

for dop in 2 4 8 12 16 20 24 28 32 36 40 44 48 ; do
  bash run_all.batch1.sh $testname $dbms_config $dop > all.out 2>&1
  rdir="${bdir}/dop_${dop}"
  mkdir $rdir
  python3 plot.py --dataset $testname --batch >& o.plot
  mv o.* results/${testname}-batch.png $rdir
done

mv all.out $bdir
