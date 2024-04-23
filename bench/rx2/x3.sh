nt=$1
v4v5=$2
secs=$3
cfg=$4
nk_mem=$5
nk_io=$6

shift 6

# secs=1800
# nt=1  cfg=c4.r16   nk_mem=20000000 nk_io=200000000
# nt=1  cfg=c8.r32  nk_mem=40000000 nk_io=400000000
# nt=16 cfg=c16.r64  nk_mem=40000000 nk_io=800000000
# nt=32 cfg=c40.r256 nk_mem=40000000 nk_io=4000000000

for workload in $*; do

  case $workload in
    byrx)
      comp=none
      dio=0
      nk=$nk_mem
      ;;
    byos)
      comp=none
      dio=0
      nk=$nk_mem
      ;;
    iobuf)
      comp=lz4
      dio=0
      nk=$nk_io
      ;;
    iodir)
      comp=lz4
      dio=1
      nk=$nk_io
      ;;
    *)
      echo "Workload not supported: $workload"
      exit 1
  esac

  dn="res.$workload"
  if [ -d $dn ]; then echo "$dn exists"; exit 1; fi
  mkdir $dn

  if [ $v4v5 == "yes" ]; then
    bash x.v4.sh $cfg $secs $secs $nk $nt $dio $comp 1 400 0.25 1
    bash x.v5.sh $cfg $secs $secs $nk $nt $dio $comp 1 400 0.25 1
  fi
  bash x.sh $cfg $secs $secs $nk $nt $dio $comp 1 400 0.25 1

  mv bm.* $dn
done

