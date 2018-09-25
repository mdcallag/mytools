max_level=$1
db_gb=$2
wb_mb=$3

odir=rpl.mxl.${max_level}.dbgb.${db_gb}.wbmb.${wb_mb}
rm -rf $odir
mkdir $odir
rm -f xa.* x1.* cr.*

bash gen_rpl.sh $max_level $db_gb $wb_mb tsv
grep -h Nruns xa.tsv.* | head -1 > o2.tsv.tmp
cat o2.tsv.tmp o1.tsv > o2.tsv; rm -f o2.tsv.tmp

bash cost_all_rpl.sh o2.tsv 100 tsv

python rpl_dom.py --file=o2.tsv --max_sa=1.1 --max_ca=1.1 --max_nruns=1000 >> o3.tsv

# mv xa.* x1.* cr.* o1.tsv o2.tsv o3.tsv $odir

