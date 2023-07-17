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

rm -rf $resdir; mkdir -p $resdir
bash $bdir/mrg3.sh $sumdir $resdir ${m}m $( cat $etldirs )

# TODO - delete this
# d=latest; for f in l.i0 l.x l.i1 q100.1 q100.2 q200.1 q200.2 q400.1 q400.2 q600.1 q600.2 q800.1 q800.2 q1000.1 q1000.2 ; do cat res.$d/mrg.$f | awk -f ../../sum_met.awk > res.$d/rel.$f ; done
# d=latest; for f in l.i0 l.x l.i1 q100.2 q200.2 q800.2 q1000.2; do echo; echo $f ; cat res.$d/mrg.$f ; done

# TODO - delete this
# cd sum
# ls | grep sum | grep -v grep > o.a
# bash ~/git/mytools/bench/ibench/mrg3.sh 40m $( cat o.a )
# cd ..

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
bash $bdir/gen_html.sh "${m}M docs and $dop client(s)" $m $ht $resdir $rtdir > report/all.html

mv z1 z1f z1q z2.asRel0 z2.asRel1 z3 ztmp tput.tab tputr.tab do.ch tput_hdr iput.tab report
mv do.gp.* report
rm -rf report.$etldirs; mv report report.$etldirs

