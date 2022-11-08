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

latest_versions=( 6.28.fb )
first_last_versions=( 6.0.fb 6.29.fb )
six_versions=( 6.0.fb 6.1.fb 6.2.fb 6.3.fb 6.4.fb 6.5.fb 6.6.fb 6.7.fb 6.8.fb 6.9.fb 6.10.fb 6.11.fb 6.12.fb 6.13.fb 6.14.fb 6.15.fb 6.16.fb 6.17.fb 6.18.fb 6.19.fb 6.20.fb 6.21.fb 6.22.fb 6.23.fb 6.24.fb 6.25.fb 6.26.fb 6.27.fb 6.28.fb 6.29.fb )
seven_versions=( 7.0.fb 7.1.fb 7.2.fb 7.3.fb 7.4.fb 7.5.fb 7.6.fb 7.7.fb )
sixseven_versions=( 6.0.fb 6.1.fb 6.2.fb 6.3.fb 6.4.fb 6.5.fb 6.6.fb 6.7.fb 6.8.fb 6.9.fb 6.10.fb 6.11.fb 6.12.fb 6.13.fb 6.14.fb 6.15.fb 6.16.fb 6.17.fb 6.18.fb 6.19.fb 6.20.fb 6.21.fb 6.22.fb 6.23.fb 6.24.fb 6.25.fb 6.26.fb 6.27.fb 6.28.fb 6.29.fb 7.0.fb 7.1.fb 7.2.fb 7.3.fb  7.4.fb 7.5.fb 7.6.fb 7.7.fb )

use_versions="${latest_versions[@]}"

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
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 210 ))
  nsub=4
  ;;
c40r256bc180)
  # Options for 40-core, 256g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 180 ))
  nsub=4
  ;;
c40bc1g)
  # Options for 40-core, 256g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 1 ))
  nsub=4
  ;;
c30r240)
  # Options for 30-core, 240g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 180 ))
  nsub=4
  ;;
c30r240bc150)
  # Options for 30-core, 240g RAM, but with smaller block cache
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 150 ))
  nsub=4
  ;;
*)
  echo "HW config ( $myhw ) not supported"
  exit -1
esac

args+=( NUM_KEYS=$nkeys CACHE_SIZE_MB=$cache_mb )
args+=( DURATION_RW=$secs DURATION_RO=$secs_ro )
args+=( MB_WRITE_PER_SEC=2 NUM_THREADS=$nthreads )
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
env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}

# for universal

odir=bm.uc.nt${nthreads}.cm${cm}.d${odirect}.sc${nsub}.tm
echo universal+subcomp+trivial_move using $odir at $( date )
myargs=( "${args[@]}" )
myargs+=( UNIVERSAL_COMPRESSION_SIZE_PERCENT=80 COMPACTION_STYLE=universal SUBCOMPACTIONS=$nsub UNIVERSAL_ALLOW_TRIVIAL_MOVE=1 UNIVERSAL_MAX_SIZE_AMP=100 )
env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}

exit

# for blobDB

odir=bm.bc.nt${nthreads}.cm${cm}.d${odirect}
echo integrated blobDB using $odir at $( date )
myargs=( "${args[@]}" )
myargs+=( MIN_LEVEL_TO_COMPRESS=3 COMPACTION_STYLE=blob )
env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}

exit

odir=bm.uc.nt${nthreads}.cm${cm}.d${odirect}.tm
echo universal+trivial_move using $odir at $( date )
myargs=( "${args[@]}" )
myargs+=( UNIVERSAL_COMPRESSION_SIZE_PERCENT=80 COMPACTION_STYLE=universal UNIVERSAL_ALLOW_TRIVIAL_MOVE=1 )
env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}

odir=bm.uc.nt${nthreads}.cm${cm}.d${odirect}.sc${nsub}
echo universal+subcomp using $odir at $( date ) 
myargs=( "${args[@]}" )
myargs+=( UNIVERSAL_COMPRESSION_SIZE_PERCENT=80 COMPACTION_STYLE=universal SUBCOMPACTIONS=$nsub )
echo env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}
env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}

odir=bm.uc.nt${nthreads}.cm${cm}.d${odirect}
echo universal using $odir at $( date )
myargs=( "${args[@]}" )
myargs+=( UNIVERSAL_COMPRESSION_SIZE_PERCENT=80 COMPACTION_STYLE=universal )
env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}

