
ioengine=$1
nfiles=$2
filegb=$3

for iot in dir buf ; do
  bash do_fio.sh 1 600 4096 /dev/nvme0n1 $iot /data/m $nfiles $filegb yes $ioengine | tee out.fio.$iot.4096.$ioengine
  bash do_fio.sh 1 600 8192 /dev/nvme0n1 $iot /data/m $nfiles $filegb  no $ioengine | tee out.fio.$iot.8192.$ioengine
  mkdir res.me.$iot
  mv out.fio.* o.fio.* res.me.$iot
done

