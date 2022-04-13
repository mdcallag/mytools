nt=$1
v4v5=$2
secs=$3
dio=$4
max_thread=$5

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

iobuf=no
bc1g=yes
cached=yes

function next_threads {
  cur_thread=$1

  case $cur_thread in
    1)
      next_thread=2
      ;;
    2)
      next_thread=4
      ;;
    4)
      next_thread=8
      ;;
    8)
      next_thread=16
      ;;
    *)
      next_thread=$(( $cur_thread + 8 ))
      ;;
  esac

  echo $next_thread
}

nt=1
while :; do

echo Run for $nt threads

for dn in res.byrx res.byos res.iobuf res.iodir ; do
  if [ -d $dn ]; then echo "$dn exists"; exit 1; fi
done
for dn in res.byrx res.byos res.iobuf res.iodir ; do mkdir $dn; done

if [ $cached == "yes" ]; then
nk=$nk1
comp=none
cfg=${cx}${rx}
if [ $v4v5 == "yes" ]; then
  bash x.v4.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
  bash x.v5.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
fi
bash x.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
mv bm.* res.byrx
fi

if [ $bc1g == "yes" ]; then
nk=$nk1
comp=none
cfg=${cx}bc1g
if [ $v4v5 == "yes" ]; then
  bash x.v4.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
  bash x.v5.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
fi
bash x.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
mv bm.* res.byos
fi

if [ $iobuf == "yes" ]; then
nk=$nk2
comp=lz4
cfg=${cx}${rx}
if [ $v4v5 == "yes" ]; then
  bash x.v4.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
  bash x.v5.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
fi
bash x.sh $cfg $secs $secs $nk $nt 0 $comp 1 400 0.25 1 0
mv bm.* res.iobuf
fi

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

mkdir r.nt${nt}
mv res.* r.nt${nt}

nt=$( next_threads $nt )
if [ $nt -gt $max_thread ]; then
  exit 0
fi

done
