# Example command line:
#   m=20; for z in pg all my fbmy ; do bash ../../report.sh 1 1 $m mdcallag 4 x.${m}m.${z}.etldirs x.${m}m.${z}.ch x.${m}m.${z}.config.ht ; done

prep=$1
dop=$2
# Number of docs loaded
m=$3
# mdcallag, ec2\-user, etc
user=$4
# number of cpu cores on database host
ncpu=$5
etldirs=$6

# ch.all.nocomp, etc
ch=$7
# config.ht.nocomp, etc
ht=$8

bdir=~/git/mytools/bench/ibench
rtdir="rt.${etldirs}"
resdir="res.${etldirs}"
sumdir="sum.${m}m.dop${dop}"

if [[ $prep -eq 1 ]]; then

mkdir -p $sumdir

for d in ${m}m.* ; do
  bash $bdir/etl.sh $d $dop /data $m $d $user $ncpu > $d/o.sum.c.$d
  cat $d/o.sum.c.$d | tr ',' '\t' > $d/o.sum.t.$d
done
cp ${m}m.*/o.sum.t.* $sumdir

for d2 in l.i0 l.x l.i1 l.i2 qr100.L1 qp100.L2 qr500.L3 qp500.L4 qr1000.L5 qp1000.L6 ; do
  rm -f $sumdir/o.iostat.avg.data.dop${dop}.${d2}
  touch $sumdir/o.iostat.avg.data.dop${dop}.${d2}
  for d in $( cat $ch ); do
    cp ${m}m.${d}/${d2}/o.iostat.avg.header.dop${dop} $sumdir
    cat ${m}m.${d}/${d2}/o.iostat.avg.data.dop${dop} | awk '{ printf "%s\t%s\n", $0, dirnm }' dirnm=$d >> $sumdir/o.iostat.avg.data.dop${dop}.${d2}
  done
done

rm -rf $resdir; mkdir -p $resdir
bash $bdir/mrg3.sh $sumdir $resdir ${m}m $( cat $etldirs )

fi

rm -rf report; mkdir -p report
echo A
rm -rf $rtdir; mkdir $rtdir; bash $bdir/mrg.extra.sh $rtdir ${m}m $( cat $etldirs )
echo B
bash $bdir/chart_all.sh $dop $m $resdir $( cat $ch )
echo C
bash $bdir/chart_rt.sh $m $rtdir $( cat $ch )
echo D
bash $bdir/plot_report.sh $m $dop $( cat $ch )
echo E
bash $bdir/gen_html.sh "${m}M docs and $dop client(s)" $m $ht $resdir $rtdir $sumdir $dop > report/all.html

mv z1 z1f z1q z2.asRel0 z2.asRel1 z3 ztmp tput.tab tputr.tab do.ch tput_hdr iput.tab report
mv do.gp.* report
rm -rf report.$etldirs; mv report report.$etldirs

