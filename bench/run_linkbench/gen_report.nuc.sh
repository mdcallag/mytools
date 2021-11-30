# text string used to name the test
v=$1
# path to ch.inno.nocomp
ch=$2
# path to config.ht.nocomp
ht=$3
# number of fbobjects loaded in millions, just the number 
m=$4
# user: mdcallag, ec2\-user, etc
u=$5
# number of seconds per test step
secs=$6
# list of per-test directories to search for benchmark output
etldirs=$7

rm -f p.l.* p.r.* z1.* z2.* z3.* z4.* 
rm -rf report report.${m}m.$v

for t in L1.P1 L2.P1 L3.P1 ; do
  echo Run etl.sh for $t using $etldirs
  bash ~/git/mytools/bench/run_linkbench/etl.sh $PWD $t yes no a $u $( cat $etldirs )
done

bash ~/git/mytools/bench/run_linkbench/chart_all.nuc.sh $( cat $ch )

bash ~/git/mytools/bench/run_linkbench/gen_html.sh "Linkbench with maxid1=${m}m" $m $ht $secs > report/all.html

rm -rf r.$v; mkdir r.$v
mv p.l.* p.r.* z.* z1.* z2.* z3.* z4.* r.$v
mv report report.${m}m.$v
