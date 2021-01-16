dop=$1
m=$2

# Steps to process results:

# dop=X; m=Y; for d in ${m}m.* ; do bash ~/git/mytools/bench/ibench/etl.sh $d $dop /data $m $d ec2\-user 16 > $d/o.sum.c.$d ; cat $d/o.sum.c.$d | tr ',' '\t' > $d/o.sum.t.$d; done
# cp ${m}m.*/o.sum.t.* sum

#dop=1; for m in 20 100 500 ; do for d in ${m}m.* ; do bash ~/git/mytools/bench/ibench/etl.sh $d $dop /data $m $d mdcallag 4 > $d/o.sum.c.$d ; cat $d/o.sum.c.$d | tr ',' '\t' > $d/o.sum.t.$d; done; cp ${m}m.*/o.sum.t.* sum.${m}m; done
# m=500; for d in a a2 in pg rx latest; do mkdir -p res.$d; bash ../../mrg3.sh ${m}m $( cat o.$d ); mv mrg.* res.$d; done

# d=latest; for f in l.i0 l.x l.i1 q100.1 q100.2 q200.1 q200.2 q400.1 q400.2 q600.1 q600.2 q800.1 q800.2 q1000.1 q1000.2 ; do cat res.$d/mrg.$f | awk -f ../../sum_met.awk > res.$d/rel.$f ; done
# d=latest; for f in l.i0 l.x l.i1 q100.2 q200.2 q800.2 q1000.2; do echo; echo $f ; cat res.$d/mrg.$f ; done

# cd sum
# ls | grep sum | grep -v grep > o.a
# bash ~/git/mytools/bench/ibench/mrg3.sh 40m $( cat o.a )
# cd ..

echo A
rm -rf rt${m}; mkdir rt${m}; bash ~/git/mytools/bench/ibench/mrg.extra.sh rt${m} ${m}m $( cat o.${m}m )
echo B
bash ~/git/mytools/bench/ibench/chart_all.sh $dop $( cat ch.all )
echo C
bash ~/git/mytools/bench/ibench/chart_rt.sh $m $( cat ch.all)
echo D
mkdir -p report; bash ~/git/mytools/bench/ibench/plot_report.sh $m $dop $( cat ch.all )
echo E
mkdir -p report; bash ~/git/mytools/bench/ibench/gen_html.sh "${m}M docs and $dop client(s)" $m config.ht > report/all.html
