
dop=$1
v4v5=$2

if [ -f benchmark_overwriteandwait.t${dop}.s0.log ]; then
  owaw="overwriteandwait"
else
  owaw="overwrite"
fi

my_dir=$( dirname $0 )

if [ $v4v5 == "yes" ]; then
  resum="$my_dir/resum.v4.sh"
else
  resum="$my_dir/resum.sh"
fi

bash $resum benchmark_fillseq.wal_disabled.v400.log   	fillseq.wal_disabled.v400       fillseq yes
bash $resum benchmark_revrange.t1.log                 	revrange.t1                     seekrandom no
bash $resum benchmark_readrandom.t${dop}.log          	readrandom.t${dop}              readrandom no
bash $resum benchmark_fwdrange.t${dop}.log            	fwdrange.t${dop}                seekrandom no
bash $resum benchmark_multireadrandom.t${dop}.log     	multireadrandom.t${dop}         multireadrandom no
bash $resum benchmark_overwritesome.t${dop}.s0.log    	overwritesome.t${dop}.s0        overwrite no
bash $resum benchmark_revrangewhilewriting.t${dop}.log  revrangewhilewriting.t${dop}    seekrandomwhilewriting no
bash $resum benchmark_fwdrangewhilewriting.t${dop}.log  fwdrangewhilewriting.t${dop}    seekrandomwhilewriting no
bash $resum benchmark_readwhilewriting.t${dop}.log    	readwhilewriting.t${dop}        readwhilewriting no
bash $resum benchmark_${owaw}.t${dop}.s0.log            ${owaw}.t${dop}                 overwrite no
