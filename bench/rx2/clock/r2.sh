
sz=$1
# clock0 clock1 clock2 clock3
c=$2

#benchmark_compare.sh  benchmark.sh.clock0  benchmark.sh.clock1  benchmark.sh.clock2  benchmark.sh.clock3

for d in no 64.512 8.64 ; do
  rm -f benchmark_compare.sh
  ln -s skew.$d/benchmark_compare.sh benchmark_compare.sh

  rm -f benchmark.sh
  ln -s skew.$d/benchmark.sh.$c benchmark.sh

  rm -f x.sh
  ln -s skew.$d/x.$c.sh x.sh

  for dop in 8 16 32 64 96 128 ; do
    bash x3.sh $dop no 1800 c40r256 40000000 4000000000 $sz
    mv res.$sz res.$sz.$c.$dop.skew.$d
  done

done
