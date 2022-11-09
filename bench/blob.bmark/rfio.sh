
ioengine=$1
nfiles=$2
filegb=$3
devname=$4

shift 4

for iot in dir buf ; do
  bash do_fio.sh 1 600 4096 $devname $iot /data/m $nfiles $filegb yes $ioengine "$@" | tee out.fio.$iot.4096.$ioengine
  bash do_fio.sh 1 600 8192 $devname $iot /data/m $nfiles $filegb  no $ioengine "$@" | tee out.fio.$iot.8192.$ioengine
  mkdir res.$iot.$ioengine
  mv out.fio.* o.fio.* res.$iot.$ioengine
done

