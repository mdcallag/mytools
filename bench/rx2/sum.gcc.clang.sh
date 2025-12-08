y=$1

for z in gcc clang clang.lto ; do
  bash ../../recmp.sh 6.29.$z 7.0.$z 7.10.$z 8.0.$z 8.4.$z 8.8.$z 8.11.$z 9.0.$z 9.4.$z 9.8.$z 9.11.$z 10.0.$z 10.1.$z 10.2.$z 10.3.$z 10.4.$z 10.5.$z 10.6.$z 10.7.$z 10.8.$z > sum.$y.$z.txt
done

for z in gcc clang clang.lto ; do
  bash ../../recmp.sh 6.29.gcc 6.29.$z 7.0.$z 7.10.$z 8.0.$z 8.4.$z 8.8.$z 8.11.$z 9.0.$z 9.4.$z 9.8.$z 9.11.$z 10.0.$z 10.1.$z 10.2.$z 10.3.$z 10.4.$z 10.5.$z 10.6.$z 10.7.$z 10.8.$z > sum2.$y.$z.txt
done

for z in gcc clang clang.lto ; do bash ../../format_dbb_benchmark.sh sum.$y.$z.txt 0 0 > csum.$y.$z.csv ; done
for z in gcc clang clang.lto ; do bash ../../format_dbb_benchmark.sh sum2.$y.$z.txt 0 0 > csum2.$y.$z.csv ; done
