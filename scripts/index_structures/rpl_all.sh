max_level=$1
db_gb=$2
wb_mb=$3

odir=rpl.mxl.${max_level}.dbgb.${db_gb}.wbmb.${wb_mb}
rm -rf $odir
mkdir $odir
rm -f xa.* x1.* cr.*

# this generates o1.tsv, xa.* and x1.*
bash gen_rpl.sh $max_level $db_gb $wb_mb tsv > o.gen
grep -h Nruns xa.tsv.* | head -1 > o2.tsv.tmp
cat o2.tsv.tmp o1.tsv > o2.tsv; rm -f o2.tsv.tmp

# this generates cr.*
bash cost_all_rpl.sh o2.tsv 100 tsv

# this finds configurations that are dominates (strictly worse) than other configs
python rpl_dom.py --file=o2.tsv --max_sa=1.1 --max_ca=1.1 --max_runs=-1 > o3.tsv 2> e

awk '{ print $12 }' o1.tsv > o1.x
awk '{ print $12 }' o2.tsv > o2.x
awk '{ print $13 }' o3.tsv > o3.x

wc -l o3.tsv > o4
grep False o3.tsv | wc -l >> o4
grep True o3.tsv | wc -l >> o4

mv o.gen xa.* x1.* cr.* o?.tsv o?.x o4 $odir

