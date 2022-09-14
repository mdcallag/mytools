
dop=$1

if [ -f benchmark_overwriteandwait.t${dop}.s0.log ]; then
  owaw="overwriteandwait"
else
  owaw="overwrite"
fi

bash /data/rx2.aug/resum.sh benchmark_fillseq.wal_disabled.v400.log	fillseq.wal_disabled.v400 	fillseq yes
bash /data/rx2.aug/resum.sh benchmark_revrange.t1.log			revrange.t1			seekrandom no
bash /data/rx2.aug/resum.sh benchmark_readrandom.t${dop}.log		readrandom.t${dop}		readrandom no
bash /data/rx2.aug/resum.sh benchmark_fwdrange.t${dop}.log		fwdrange.t${dop}		seekrandom no
bash /data/rx2.aug/resum.sh benchmark_multireadrandom.t${dop}.log	multireadrandom.t${dop}		multireadrandom no
bash /data/rx2.aug/resum.sh benchmark_overwritesome.t${dop}.s0.log	overwritesome.t${dop}.s0	overwrite no
bash /data/rx2.aug/resum.sh benchmark_revrangewhilewriting.t${dop}.log	revrangewhilewriting.t${dop}	seekrandomwhilewriting no
bash /data/rx2.aug/resum.sh benchmark_fwdrangewhilewriting.t${dop}.log	fwdrangewhilewriting.t${dop}	seekrandomwhilewriting no
bash /data/rx2.aug/resum.sh benchmark_readwhilewriting.t${dop}.log	readwhilewriting.t${dop}	readwhilewriting no
bash /data/rx2.aug/resum.sh benchmark_${owaw}.t${dop}.s0.log		${owaw}.t${dop}			overwrite no
