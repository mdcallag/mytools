# run like: dio=1; nf=8; fp=64; gb=100; time bash all_fio2.sh 300 $gb yes $nf $fp $dio 2> /dev/null | tee out.s300.gb${gb}.nf${nf}.fper${fp}.dio${dio}

runsecs=$1
filegb=$2
create=$3
nfiles=$4
fsyncper=$5
dio=$6

ns=1000000

files="td1"
for x in $( seq 2 $nfiles ); do files+=":td$x"; done; echo "Files: $files"

if [[ $create == "yes" ]]; then
  rm -rf td*
fi

opt1="--ioengine=psync --filesize=${filegb}g --runtime=$runsecs --group_reporting --filename=$files"

echo Write the files the first time. Do this before running --rw=write.
fio --name=seqread --rw=read --direct=0 --bs=1m --numjobs=1 $opt1 --fdatasync=32 >& o.fio.setup

for bs in 4k 8k 16k 32k 64k 128k 256k ; do
for nj in 1 2 4 8 12 16 20 24 32 ; do
echo "Sequential write at $( date ) with j=$nj bs=$bs dio=$dio nfiles=$nfiles fsyncper=$fsyncper"
sfx="seq.w.nj${nj}.bs${bs}.dio${dio}.nf${nfiles}.fper${fsyncper}"
iostat -y -kx 5 $ns >& o.io.$sfx &
ipid=$!
vmstat 5 >& o.vm.$sfx &
vpid=$!
opt2="--randrepeat=0"
if [[ $dio -eq 0 ]]; then
  opt2+="--fdatasync=$fsyncper"
fi
echo fio --name=seqwrite --rw=write --direct=$dio --bs=$bs --numjobs=$nj $opt1 $opt2 to o.fio.$sfx
fio --name=seqwrite --rw=write --direct=$dio --bs=$bs --numjobs=$nj $opt1 $opt2 >& o.fio.$sfx
grep "iops\=" o.fio.$sfx
kill $ipid >& /dev/null
kill $vpid >& /dev/null
done
done

for bs in 4k 8k 16k 32k 64k 128k 256k ; do
for nj in 1 2 4 8 12 16 20 24 32 ; do
echo "Sequential read at $( date ) with j=$nj bs=$bs dio=$dio nfiles=$nfiles fsyncper=$fsyncper"
sfx="seq.r.nj${nj}.bs${bs}.dio${dio}.nf${nfiles}.fper${fsyncper}"
iostat -y -kx 5 $ns >& o.io.$sfx &
ipid=$!
vmstat 5 >& o.vm.$sfx &
vpid=$!
opt2="--randrepeat=0"
if [[ $dio -eq 0 ]]; then
  opt2+="--fdatasync=$fsyncper"
fi
echo fio --name=seqread --rw=read --direct=$dio --bs=$bs --numjobs=$nj $opt1 $opt2 to o.fio.$sfx
fio --name=seqread --rw=read --direct=$dio --bs=$bs --numjobs=$nj $opt1 $opt2 >& o.fio.$sfx
grep "iops\=" o.fio.$sfx
kill $ipid >& /dev/null
kill $vpid >& /dev/null
done
done

for bs in 4k 8k 16k 32k 64k 128k 256k ; do
for nj in 1 2 4 8 12 16 20 24 32 ; do
echo "Random read at $( date ) with j=$nj bs=$bs dio=$dio nfiles=$nfiles fsyncper=$fsyncper"
sfx="rand.r.nj${nj}.bs${bs}.dio${dio}.nf${nfiles}.fper${fsyncper}"
iostat -y -kx 5 $ns >& o.io.$sfx &
ipid=$!
vmstat 5 >& o.vm.$sfx &
vpid=$!
opt2="--randrepeat=0"
if [[ $dio -eq 0 ]]; then
  opt2+="--fdatasync=$fsyncper"
fi
echo fio --name=randread --rw=randread --direct=$dio --bs=$bs --numjobs=$nj $opt1 $opt2 to o.fio.$sfx
fio --name=randread --rw=randread --direct=$dio --bs=$bs --numjobs=$nj $opt1 $opt2 >& o.fio.$sfx
grep "iops\=" o.fio.$sfx
kill $ipid >& /dev/null
kill $vpid >& /dev/null
done
done

for bs in 4k 8k 16k 32k 64k 128k 256k ; do
for nj in 1 2 4 8 12 16 20 24 32 ; do
echo "Random write at $( date ) with j=$nj bs=$bs dio=$dio nfiles=$nfiles fsyncper=$fsyncper"
sfx="rand.w.nj${nj}.bs${bs}.dio${dio}.nf${nfiles}.fper${fsyncper}"
iostat -y -kx 5 $ns >& o.io.$sfx &
ipid=$!
vmstat 5 >& o.vm.$sfx &
vpid=$!
opt2="--randrepeat=0"
if [[ $dio -eq 0 ]]; then
  opt2+="--fdatasync=$fsyncper"
fi
echo fio --name=randwrite --rw=randwrite --direct=$dio --bs=$bs --numjobs=$nj $opt1 $opt2 to o.fio.$sfx
fio --name=randwrite --rw=randwrite --direct=$dio --bs=$bs --numjobs=$nj $opt1 $opt2 >& o.fio.$sfx
grep "iops\=" o.fio.$sfx
kill $ipid >& /dev/null
kill $vpid >& /dev/null
done
done

for bs in 4k 8k 16k 32k 64k 128k 256k ; do
for nj in 1 2 4 8 12 16 20 24 32 ; do
echo "Random write + random read at $( date ) with j=$nj bs=$bs dio=$dio nfiles=$nfiles fsyncper=$fsyncper"
sfx="rand.rw.nj${nj}.bs${bs}.dio${dio}.nf${nfiles}.fper${fsyncper}"
iostat -y -kx 5 $ns >& o.io.$sfx &
ipid=$!
vmstat 5 >& o.vm.$sfx &
vpid=$!
opt2="--randrepeat=0"
if [[ $dio -eq 0 ]]; then
  opt2+="--fdatasync=$fsyncper"
fi
echo fio --name=randrw --rw=randrw --direct=$dio --bs=$bs --numjobs=$nj --rwmixread=80 $opt1 $opt2 to o.fio.$sfx
fio --name=randrw --rw=randrw --direct=$dio --bs=$bs --numjobs=$nj --rwmixread=80 $opt1 $opt2 >& o.fio.$sfx
grep "iops\=" o.fio.$sfx
kill $ipid >& /dev/null
kill $vpid >& /dev/null
done
done

for bs in 4k 8k 16k 32k 64k 128k 256k ; do
for nj in 1 2 4 8 12 16 20 24 32 ; do
echo "Random write 256k + random read at $( date ) with j=$nj bs=$bs dio=$dio nfiles=$nfiles fsyncper=$fsyncper"
sfx="rand.rw256.nj${nj}.bs${bs}.dio${dio}.nf${nfiles}.fper${fsyncper}"
iostat -y -kx 5 $ns >& o.io.$sfx &
ipid=$!
vmstat 5 >& o.vm.$sfx &
vpid=$!
opt2="--randrepeat=0"
if [[ $dio -eq 0 ]]; then
  opt2+="--fdatasync=$fsyncper"
fi
echo fio --name=randrw --rw=randrw --direct=$dio --bs=$bs,256k,256k --numjobs=$nj --rwmixread=95 $opt1 $opt2 to o.fio.$sfx
fio --name=randrw --rw=randrw --direct=$dio --bs=$bs,256k,256k --numjobs=$nj --rwmixread=95 $opt1 $opt2 >& o.fio.$sfx
grep "iops\=" o.fio.$sfx
kill $ipid >& /dev/null
kill $vpid >& /dev/null
done
done
