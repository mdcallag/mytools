
#ops_sec	mb_sec	lsm_sz	blob_sz	c_wgb	w_amp	c_mbps	c_wsecs	c_csecs	b_rgb	b_wgb	usec_op	p50	p99	p99.9	p99.99	pmax	uptime	stall%	Nstall	u_cpu	s_cpu	rss	test	date	version	job_id
#978892	20.431	8GB	0.0GB,	7.8	1.0	396.5	19	18	0	0	1.0	0.5	2	4	1151	7401	20	31.1	143	0.0	0.0	0.2	fillseq.wal_disabled.v400	2022-06-2T05:11:54	7.3	
#210581	1800.002	8GB	0.0GB,	0.0		0.0	0	0	0	0	4.7	4.5	6	13	22	14489	1780	0.0	0	1.8	0.0	8.4	readrandom.t1	2022-06-2T05:12:16	7.3	
#60518	1800.004	8GB	0.0GB,	0.0		0.0	0	0	0	0	16.5	16.8	22	157	242	14453	1781	0.0	0	1.8	0.0	8.4	fwdrange.t1	2022-06-2T05:42:18	7.3	
#206086	1800.003	8GB	0.0GB,	0.0		0.0	0	0	0	0	4.9	42.7	68	420	853	14942	1780	0.0	0	1.8	0.0	8.4	multireadrandom.t1	2022-06-2T06:12:19	7.3	
#262355	7.623										3.8	3.2	6	12	59	8198				0.0	0.0	0.0	overwritesome.t1.s0	2022-06-2T06:42:21	7.3	
#26250	1800.071	9GB	0.0GB,	48.1	13.5	27.6	121	94	0	0	38.1	35.6	142	233	1338	13015	1784	0.0	0	1.8	0.1	12.3	revrangewhilewriting.t1	2022-06-2T06:42:41	7.3	
#38259	1800.096	9GB	0.0GB,	48.7	13.7	27.9	121	96	0	0	26.1	24.7	114	304	547	34410	1784	0.0	0	1.8	0.1	12.3	fwdrangewhilewriting.t1	2022-06-2T07:12:43	7.3	
#116401	1800.059	9GB	0.0GB,	48.8	13.7	28.0	122	96	0	0	8.6	8.0	16	104	167	16307	1784	0.0	0	1.8	0.1	12.3	readwhilewriting.t1	2022-06-2T07:42:45	7.3	
#127320	1800.001	20GB	0.0GB,	653.9	7.3	375.9	3564	1624	0	0	7.9	3.3	13	1174	1290	140323	1782	48.0	4750	1.9	0.8	4.1	overwrite.t1.s0	2022-06-2T08:12:48	7.3	

#br.7.3.fb/benchmark_fillseq.wal_disabled.v400.log  br.7.3.fb/benchmark_fwdrange.t1.log              br.7.3.fb/benchmark_multireadrandom.t1.log   br.7.3.fb/benchmark_overwrite.t1.s0.log  br.7.3.fb/benchmark_readwhilewriting.t1.log
#br.7.3.fb/benchmark_flush_mt_l0.log                br.7.3.fb/benchmark_fwdrangewhilewriting.t1.log  br.7.3.fb/benchmark_overwritesome.t1.s0.log  br.7.3.fb/benchmark_readrandom.t1.log    br.7.3.fb/benchmark_revrangewhilewriting.t1.log

sdir=$( dirname $0 )

nt=$1
xdir=$2

valsz=400

bash $sdir/resum.sh $xdir/benchmark_fillseq.wal_disabled.v${valsz}.log fillseq.wal_disabled.v${valsz} fillseq            yes
bash $sdir/resum.sh $xdir/benchmark_readrandom.t${nt}.log              readrandom.t${nt}              readrandom         no 
bash $sdir/resum.sh $xdir/benchmark_fwdrange.t${nt}.log                fwdrange.t${nt}                seekrandom         no
bash $sdir/resum.sh $xdir/benchmark_multireadrandom.t${nt}.log         multireadrandom.t${nt}         multireadrandom    no
bash $sdir/resum.sh $xdir/benchmark_overwritesome.t${nt}.s0.log        overwritesome.t${nt}.s0        overwrite          no
bash $sdir/resum.sh $xdir/benchmark_revrangewhilewriting.t${nt}.log    revrangewhilewriting.t${nt}    seekrandomwhile    no
bash $sdir/resum.sh $xdir/benchmark_fwdrangewhilewriting.t${nt}.log    fwdrangewhilewriting.t${nt}    seekrandomwhile    no
bash $sdir/resum.sh $xdir/benchmark_readwhilewriting.t${nt}.log        readwhilewriting.t${nt}        readwhilewriting   no
bash $sdir/resum.sh $xdir/benchmark_overwrite.t${nt}.s0.log            overwrite.t${nt}.s0            overwrite          no

