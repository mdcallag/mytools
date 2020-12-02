dop=$1
m=$2

# Steps to process results:

# dop=X; m=Y; for d in ${m}m.* ; do bash ~/git/mytools/bench/ibench/etl.sh $d $dop /data $m $d ec2\-user 16 > $d/o.sum.c.$d ; cat $d/o.sum.c.$d | tr ',' '\t' > $d/o.sum.t.$d; done
# cp ${m}m.*/o.sum.t.* sum
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
