myhw=$1
secs=$2
secs_ro=$3
nkeys=$4
nthreads=$5
odirect=$6
comp=$7
numa=$8
valbytes=$9
gcac=${10}
gcft=${11}

shift 11

# Options: ${12}+ lists db_bench binaries to use, this is optional

dflags=""
if [ $odirect -eq 1 ]; then
  dflags="USE_O_DIRECT=y"
fi

cm=1

all_versions=( \
v6.0.2 \
v6.1.2 \
v6.2.4 \
v6.3.6 \
v6.4.6 \
v6.5.3 \
v6.6.4 \
v6.7.3 \
v6.8.1 \
v6.9.4 \
v6.10.2 \
v6.11.6 \
v6.12.7 \
v6.13.3 \
v6.14.6 \
v6.15.5 \
v6.16.4 \
v6.17.3 \
v6.18.1 \
v6.19.3 \
v6.20.3 \
v6.21.3 \
v6.22.1 \
v6.23.3 \
v6.24.2 \
v6.25.3 \
v6.26.1 \
v6.27.3 \
v6.28.2 \
)

some_versions=( \
v6.0.2 \
v6.7.3 \
v6.14.6 \
v6.22.1 \
v6.23.3 \
v6.24.2 \
v6.25.3 \
v6.26.1 \
)

latest_versions=( v6.28.2 )
first_last_versions=( v6.0.2 v6.28.2 )
t_versions=( v5.1.4 )

#use_versions="${some_versions[@]}"
#use_versions="${latest_versions[@]}"
use_versions="${t_versions[@]}"

if [ "$#" -eq 0 ] ; then
  versions="${use_versions[@]}"
  echo "No version args"
else
  versions="$@"
  echo Commmand line lists versions: "${versions[@]}"
fi

case $myhw in
c4r16)
  # Options for 4-core, 16g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=3 )
  cache_mb=$(( 1024 * 12 ))
  nsub=2
  ;;
c4bc1g)
  # Options for 4-core, 1g block cache
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=3 )
  cache_mb=$(( 1024 * 1 ))
  nsub=2
  ;;
c16r16)
  # Options for 16-core, 16g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 12 ))
  nsub=4
  ;;
c16r64)
  # Options for 16-core, 64g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 48 ))
  nsub=4
  ;;
c16r64b)
  # Options for 16-core, 64g RAM
  args=( WRITE_BUFFER_SIZE_MB=128 TARGET_FILE_SIZE_BASE_MB=8 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 48 ))
  nsub=4
  ;;
c16bc1g)
  # Options for 16-core, 1g block cache
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 1 ))
  nsub=4
  ;;
c40r256)
  # Options for 40-core, 256g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=16 )
  cache_mb=$(( 1024 * 210 ))
  nsub=4
  ;;
c40bc1g)
  # Options for 40-core, 256g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=16 )
  cache_mb=$(( 1024 * 1 ))
  nsub=4
  ;;
c30r240)
  # Options for 30-core, 240g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=16 )
  cache_mb=$(( 1024 * 180 ))
  nsub=4
  ;;
*)
  echo "HW config ( $myhw ) not supported"
  exit -1
esac

args+=( NUM_KEYS=$nkeys CACHE_SIZE_MB=$cache_mb )
args+=( DURATION_RW=$secs DURATION_RO=$secs_ro )
args+=( MB_WRITE_PER_SE=2 NUM_THREADS=$nthreads )
args+=( COMPRESSION_TYPE=$comp IBLOB_COMPRESSION_TYPE=$comp )
args+=( CACHE_INDEX_AND_FILTER_BLOCKS=$cm $dflags VALUE_SIZE=$valbytes )
args+=( IBLOB_GC_AGE_CUTOFF=$gcac IBLOB_GC_FORCE_THRESHOLD=$gcft )

#iblob_gc_age_cutoff=${IBLOB_GC_AGE_CUTOFF:-"0.25"}
#iblob_gc_force_threshold=${IBLOB_GC_FORCE_THRESHOLD:-1}

if [ $numa -eq 1 ]; then
  args+=( NUMA=1 )
fi

# for leveled
odir=bm.lc.nt${nthreads}.cm${cm}.d${odirect}
echo leveled using $odir at $( date )
myargs=( "${args[@]}" )
myargs+=( MIN_LEVEL_TO_COMPRESS=3 COMPACTION_STYLE=leveled )
env "${myargs[@]}" bash benchmark_compare.v5.sh /data/m/rx $odir ${versions[@]}

# for universal

odir=bm.uc.nt${nthreads}.cm${cm}.d${odirect}.sc${nsub}.tm
echo universal+subcomp+trivial_move using $odir at $( date )
myargs=( "${args[@]}" )
myargs+=( UNIVERSAL_COMPRESSION_SIZE_PERCENT=80 COMPACTION_STYLE=universal SUBCOMPACTIONS=$nsub UNIVERSAL_ALLOW_TRIVIAL_MOVE=1 )
env "${myargs[@]}" bash benchmark_compare.v5.sh /data/m/rx $odir ${versions[@]}

