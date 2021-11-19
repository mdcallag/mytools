# TODO -- remove this file

v=$1
m=$2
dop=$3
# ch.all.nocomp, etc
ch=$4
# config.ht.nocomp, etc
ht=$5
etldirs=$6

rm -rf report.$v; mkdir report.$v
rm -f report; ln -s report.$v report

rm -rf rt${m}.${v}; mkdir rt${m}.${v}; rm -f rt${m}; ln -s rt${m}.${v} rt${m}
bash ~/git/mytools/bench/ibench/mrg.extra.sh rt${m}.${v} ${m}m $( cat $etldirs )
bash ~/git/mytools/bench/ibench/chart_all.sh $dop $( cat $ch )
exit 0
bash ~/git/mytools/bench/ibench/chart_rt.sh $m $( cat $ch )
bash ~/git/mytools/bench/ibench/plot_report.sh $m $dop $( cat $ch )
bash ~/git/mytools/bench/ibench/gen_html.sh "${m}M docs and $dop clients" $m $ht > report.${v}/all.html
