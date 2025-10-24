
# for f in  o.test.rr.*.out  ; do echo $f; sed -i 's/max= /max=/' $f; done

gb1=400; runsecs=600; rampsecs=1; tag=test; buffered=0

for ioengine in sync; do
for njobs in 1 6 ;  do
  bash ./f2.sh $njobs $gb1 $runsecs $rampsecs $tag $buffered $ioengine >& out.njobs${njobs}.gb1${gb1}.runsecs${runsecs}.direct.ioengine${ioengine}
done
done
