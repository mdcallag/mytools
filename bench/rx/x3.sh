nt=$1
v4v5=$2
secs=$3
dio=$4

# secs=1800

if [ $nt -eq 1 ]; then
  cx=c4
  rx=r16
  nk1=20000000
  nk2=200000000
elif [ $nt -eq 16 ]; then
  cx=c16
  rx=r64
  nk1=40000000
  nk2=800000000
elif [ $nt -eq 32 ]; then
  cx=c40
  rx=r256
  nk1=40000000
  nk2=4000000000
else
  echo "nt :: $nt :: not supported"
  exit 1
fi

for dn in res.byrx res.byos res.iobuf res.iodir ; do
  if [ -d $dn ]; then echo "$dn exists"; exit 1; fi
done
for dn in res.byrx res.byos res.iobuf res.iodir ; do mkdir $dn; done

nk=$nk1
comp=none
cfg=${cx}${rx}
if [ $v4v5 == "yes" ]; then
  bash x.v4.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
  bash x.v5.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
fi
bash x.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
mv bm.* res.byrx

nk=$nk1
comp=none
cfg=${cx}bc1g
if [ $v4v5 == "yes" ]; then
  bash x.v4.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
  bash x.v5.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
fi
bash x.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
mv bm.* res.byos

nk=$nk2
comp=lz4
cfg=${cx}${rx}
if [ $v4v5 == "yes" ]; then
  bash x.v4.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
  bash x.v5.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
fi
bash x.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
mv bm.* res.iobuf

if [ $dio == "yes" ]; then
nk=$nk2
comp=lz4
cfg=${cx}${rx}
if [ $v4v5 == "yes" ]; then
  bash x.v4.sh $cfg $secs $secs $nk $nt 1 $comp 1 400 0.25 1 0
  bash x.v5.sh $cfg $secs $secs $nk $nt 1 $comp 1 400 0.25 1 0
fi
bash x.sh $cfg $secs $secs $nk $nt 1 $comp 1 400 0.25 1 0
mv bm.* res.iodir
fi
