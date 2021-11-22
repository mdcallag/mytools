versions=( \
v6.0.2 \
v6.1.2 \
v6.2.4 \
v6.3.6 \
v6.4.6 \
v6.5.3 \
v6.6.4 \
v6.7.3 \
v6.8.1 \
v6.10.2 \
v6.11.6 \
v6.12.7 \
v6.13.3 \
v6.14.6 \
v6.15.5 \
v6.16.4 \
v6.17.3 \
v6.19.3 \
v6.22.1 \
v6.20.3 \
v6.23.3 \
v6.24.2 \
v6.25.3 \
v6.26.0 \
)

# versions=( 6.26.0 6.23.3 6.24.2 6.25.3 )
secs=1800
secs_ro=1800
cache_mb=$(( 1024 * 12 ))
nkeys=200000000

# for buffered IO
nt=8
# for orig in no yes ; do
for orig in no ; do
#for cm in 1 0 ; do
for cm in 1 ; do
odir=bm.nt${nt}.orig${orig}.cm${cm}.d0
echo Run with $odir at $( date )
NKEYS=$nkeys CACHE_MB=$cache_mb NSECS=$secs NSECS_RO=$secs_ro MB_WPS=2 NTHREADS=$nt COMP_TYPE=lz4 ML2_COMP=3 ORIGINAL=$orig WRITE_BUF_MB=32 SST_MB=32 L1_MB=128 MAX_BG_JOBS=8 CACHE_META=$cm bash perf_cmp.sh /data/m/rx $odir ${versions[@]}
done
done

# now for O_DIRECT
nt=8
orig=no
cm=1
odir=bm.nt${nt}.orig${orig}.cm${cm}.d1
echo Run with $odir at $( date )
NKEYS=$nkeys CACHE_MB=$cache_mb NSECS=$secs NSECS_RO=$secs_ro MB_WPS=2 NTHREADS=$nt COMP_TYPE=lz4 ML2_COMP=3 ORIGINAL=$orig WRITE_BUF_MB=32 SST_MB=32 L1_MB=128 MAX_BG_JOBS=8 CACHE_META=$cm DIRECT_IO=y bash perf_cmp.sh /data/m/rx $odir ${versions[@]}

exit 0

nt=1
orig=no
for cm in 1 0 ; do
odir=bm.nt${nt}.orig${orig}.cm${cm}.d0
echo Run with $odir at $( date )
NKEYS=$nkeys CACHE_MB=$cache_mb NSECS=$secs NSECS_RO=$secs_ro MB_WPS=2 NTHREADS=$nt COMP_TYPE=lz4 ML2_COMP=3 ORIGINAL=$orig WRITE_BUF_MB=32 SST_MB=32 L1_MB=128 MAX_BG_JOBS=8 CACHE_META=$cm bash perf_cmp.sh /data/m/rx $odir ${versions[@]}
done
