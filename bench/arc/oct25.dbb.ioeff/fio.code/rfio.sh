
gb1=400; runsecs=600; rampsecs=1; tag=test; buffered=0

#for ioengine in io_uring sync; do
for ioengine in sync; do
for njobs in 1 6 ;  do
  bash ./fio_run_randread.sh $njobs $gb1 $runsecs $rampsecs $tag $buffered $ioengine >& out.njobs${njobs}.gb1${gb1}.runsecs${runsecs}.direct.ioengine${ioengine}
done
done
