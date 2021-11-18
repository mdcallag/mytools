
versions=( \
v6.26.0 \
v6.25.3 \
v6.24.2 \
v6.23.3 \
v6.22.1 \
v6.20.3 \
v6.19.3 \
v6.17.3 \
v6.16.4 \
v6.15.5 \
v6.14.6 \
v6.13.3 \
v6.12.7 \
v6.11.6 \
v6.10.2 \
v6.8.1 \
v6.7.3 \
v6.6.4 \
v6.5.3 \
v6.4.6 \
v6.3.6 \
v6.2.4 \
v6.1.2 \
v6.0.2 \
)

# versions=( 6.26.0 6.23.3 6.24.2 6.25.3 )
secs=1800
secs_ro=600
cache_mb=$(( 1024 * 12 ))
nkeys=200000000

nt=8
for orig in no yes ; do
for cm in 1 0 ; do
odir=bm.nt${nt}.orig${orig}.cm${cm}
echo Run with $odir at $( date )
NKEYS=$nkeys CACHE_MB=$cache_mb NSECS=$secs NSECS_RO=$secs_ro MB_WPS=2 NTHREADS=$nt COMP_TYPE=lz4 ML2_COMP=3 ORIGINAL=$orig WRITE_BUF_MB=32 SST_MB=32 L1_MB=128 MAX_BG_JOBS=8 CACHE_META=$cm bash perf_cmp.sh /data/m/rx $odir ${versions[@]}
done
done

nt=1
orig=no
for cm in 1 0 ; do
odir=bm.nt${nt}.orig${orig}.cm${cm}
echo Run with $odir at $( date )
NKEYS=$nkeys CACHE_MB=$cache_mb NSECS=$secs NSECS_RO=$secs_ro MB_WPS=2 NTHREADS=$nt COMP_TYPE=lz4 ML2_COMP=3 ORIGINAL=$orig WRITE_BUF_MB=32 SST_MB=32 L1_MB=128 MAX_BG_JOBS=8 CACHE_META=$cm bash perf_cmp.sh /data/m/rx $odir ${versions[@]}
done
