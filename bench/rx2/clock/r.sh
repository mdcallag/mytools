
sz=$1

rm -f x.sh; cp x.76.sh x.sh
for clock in 1 0 ; do

rm -f benchmark.sh
ln -s benchmark.sh.clock${clock} benchmark.sh

for dop in 8 16 32 64 96 128 ; do
  bash x3.sh $dop no 1800 c40r256 40000000 4000000000 $sz
  mv res.$sz res.$sz.clock${clock}.$dop
done
done

rm -f x.sh; cp x.pr.sh x.sh
rm -f benchmark.sh
ln -s benchmark.sh.clock1 benchmark.sh

for dop in 8 16 32 64 96 128 ; do
  bash x3.sh $dop no 1800 c40r256 40000000 4000000000 $sz
  mv res.$sz res.$sz.clock2.$dop
done
