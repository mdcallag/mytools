
versions=( 6.26.0 6.23.3 6.24.2 6.25.3 )
secs=1800
secs_ro=600

nt=16
for orig in no yes ; do
for cm in 1 0 ; do
odir=bm.nt${nt}.orig${orig}.cm${cm}
echo Run with $odir at $( date )
NKEYS=200000000 CACHE_MB=8096 NSECS=$secs NSECS_RO=$secs_ro MB_WPS=2 NTHREADS=$nt COMP_TYPE=lz4 ML2_COMP=3 ORIGINAL=$orig WRITE_BUF_MB=32 SST_MB=32 L1_MB=128 MAX_BG_JOBS=8 CACHE_META=$cm bash perf_cmp.sh /data/m/rx $odir ${versions[@]}
done
done

nt=1
orig=no
for cm in 1 0 ; do
odir=bm.nt${nt}.orig${orig}.cm${cm}
echo Run with $odir at $( date )
NKEYS=200000000 CACHE_MB=8096 NSECS=$secs NSECS_RO=$secs_ro MB_WPS=2 NTHREADS=$nt COMP_TYPE=lz4 ML2_COMP=3 ORIGINAL=$orig WRITE_BUF_MB=32 SST_MB=32 L1_MB=128 MAX_BG_JOBS=8 CACHE_META=$cm bash perf_cmp.sh /data/m/rx $odir ${versions[@]}
done
