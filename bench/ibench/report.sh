dop=$1
m=$2

# Steps to process results:

# for d in ${m}m.* ; do bash ~/git/mytools/bench/ibench/etl.sh $d $dop /data $m $d ec2\-user 16 > $d/o.sum.c.$d ; cat $d/o.sum.c.$d | tr ',' '\t' > $d/o.sum.t.$d; done
# cp ${m}m.*/o.sum.t.* sum
# cd sum
# ls | grep sum | grep -v grep > o.a
# bash ~/git/mytools/bench/ibench/mrg3.sh 40m $( cat o.a )
# cd ..

m=40; rm -rf rt${m}; mkdir rt${m}; bash ~/git/mytools/bench/ibench/mrg.extra.sh rt${m} ${m}m $( cat o.${m}m )
dop=8; bash ~/git/mytools/bench/ibench/chart_all.sh $dop $( cat ../ch.all.rc13 )
m=40; bash ~/git/mytools/bench/ibench/chart_rt.sh $m $( cat ../ch.all.rc13 )
m=40; mkdir -p report; bash ~/git/mytools/bench/ibench/plot_report.sh $m $dop $( cat ../ch.all.rc13 )
m=40; mkdir -p report; bash ~/git/mytools/bench/ibench/gen_html.sh "${m}M docs and $dop clients" $m ../config.ht > report/x.html
