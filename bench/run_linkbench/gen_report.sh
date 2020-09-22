v=$1
# path to ch.inno.nocomp
ch=$2
# path to config.ht.nocomp
ht=$3
m=$4

rm -f p.l.* p.r.* z1.* z2.* z3.* z4.* 
rm -rf report report.${m}m.$v

for t in L1.P8 L2.P8 L3.P12 L4.P12 L5.P16 L6.P16 ; do
  bash ~/git/mytools/bench/run_linkbench/etl.sh $PWD $t yes no a ec2\-user $( cat o.$v )
done

bash ~/git/mytools/bench/run_linkbench/chart_all.sh $( cat $ch )
bash ~/git/mytools/bench/run_linkbench/gen_html.sh "Linkbench with maxid1=${m}m" $m $ht 3600 > report/all.html

rm -rf r.$v; mkdir r.$v
mv p.l.* p.r.* z.* z1.* z2.* z3.* z4.* r.$v
mv report report.${m}m.$v
