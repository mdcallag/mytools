myhw=$1
secs=$2
secs_ro=$3
nkeys=$4
nthreads=$5
odirect=$6
comp=$7
bcomp=$8
numa=$9
valbytes=${10}
gcac=${11}
gcft=${12}

shift 12

# Options: ${12}+ lists db_bench binaries to use, this is optional

dflags=""
if [ $odirect -eq 1 ]; then
  dflags="USE_O_DIRECT=y"
fi

six_versions=( 6.0.gcc 6.1.gcc 6.2.gcc 6.3.gcc 6.4.gcc 6.5.gcc 6.6.gcc 6.7.gcc 6.8.gcc 6.9.gcc 6.10.gcc 6.11.gcc 6.12.gcc 6.13.gcc 6.14.gcc 6.15.gcc 6.16.gcc 6.17.gcc 6.18.gcc 6.19.gcc 6.20.gcc 6.21.gcc 6.22.gcc 6.23.gcc 6.24.gcc 6.25.gcc 6.26.gcc 6.27.gcc 6.28.gcc 6.29.gcc )
seven_versions=( 7.0.gcc 7.1.gcc 7.2.gcc 7.3.gcc 7.4.gcc 7.5.gcc 7.6.gcc 7.7.gcc 7.8.gcc 7.9.gcc 7.10.gcc )
eight_versions=( 8.0.gcc 8.1.gcc 8.2.gcc 8.3.gcc 8.4.gcc 8.5.gcc 8.6.gcc 8.7.gcc 8.8.gcc 8.9.gcc 8.10.gcc 8.11.gcc )
nine_versions=( 9.0.gcc 9.1.gcc 9.2.gcc 9.3.gcc 9.4.gcc 9.5.gcc 9.6.gcc 9.7.gcc 9.9.gcc 9.9.gcc 9.10.gcc 9.11.gcc )
ten_versions=( 10.0.gcc 10.1.gcc 10.2.gcc 10.3.gcc 10.4.gcc 10.5.gcc 10.6.gcc )

some_six_versions=( 6.0.gcc 6.10.gcc 6.20.gcc 6.29.gcc )
some_seven_versions=( 7.0.gcc 7.3.gcc 7.6.gcc 7.10.gcc )
some_eight_versions=( 8.0.gcc 8.4.gcc 8.8.gcc 8.11.gcc )
some_nine_versions=( 9.0.gcc 9.4.gcc 9.8.gcc 9.11.gcc )

#use_versions="${some_six_versions[@]} ${some_seven_versions[@]} ${some_eight_versions[@]} ${some_nine_versions[@]} ${ten_versions[@]}"

use_versions=( 10.2.gcc )
#use_versions=( 10.2.nojem )

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
  cache_mb=$(( 1024 * 10 ))
  nsub=2
  ;;
c4bc1g)
  # Options for 4-core, 1g block cache
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=3 )
  cache_mb=$(( 1024 * 1 ))
  nsub=2
  ;;
c8r16)
  # Options for 8-core, 16g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=4 )
  cache_mb=$(( 1024 * 10 ))
  nsub=2
  ;;
c8r32)
  # Options for 8-core, 32g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=4 )
  cache_mb=$(( 1024 * 20 ))
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
c24r64)
  # Options for 24-core, 64g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=12 )
  cache_mb=$(( 1024 * 48 ))
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
c32r128)
  # Options for 32-core, 128g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=8 )
  cache_mb=$(( 1024 * 90 ))
  nsub=4
  ;;
c48r128)
  # Options for 32-core, 128g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=12 )
  cache_mb=$(( 1024 * 90 ))
  nsub=4
  ;;
*)
  echo "HW config ( $myhw ) not supported"
  exit -1
esac

args+=( NUM_KEYS=$nkeys CACHE_SIZE_MB=$cache_mb )
args+=( DURATION_RW=$secs DURATION_RO=$secs_ro )
args+=( MB_WRITE_PER_SEC=2 NUM_THREADS=$nthreads )
args+=( COMPRESSION_TYPE=$comp BOTTOMMOST_COMPRESSION=$bcomp IBLOB_COMPRESSION_TYPE=$comp )
args+=( $dflags VALUE_SIZE=$valbytes )
args+=( IBLOB_GC_AGE_CUTOFF=$gcac IBLOB_GC_FORCE_THRESHOLD=$gcft )

#iblob_gc_age_cutoff=${IBLOB_GC_AGE_CUTOFF:-"0.25"}
#iblob_gc_force_threshold=${IBLOB_GC_FORCE_THRESHOLD:-1}

if [ $numa -eq 1 ]; then
  args+=( NUMA=1 )
fi

# for leveled
odir=bm.lc.nt${nthreads}.d${odirect}
echo leveled using $odir at $( date )
myargs=( "${args[@]}" )
myargs+=( MIN_LEVEL_TO_COMPRESS=3 COMPACTION_STYLE=leveled CACHE_INDEX_AND_FILTER_BLOCKS=1 )
env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}

exit

# for universal

odir=bm.uc.nt${nthreads}.d${odirect}.sc${nsub}.tm
echo universal+subcomp+trivial_move using $odir at $( date )
myargs=( "${args[@]}" )
#myargs+=( UNIVERSAL_COMPRESSION_SIZE_PERCENT=80 COMPACTION_STYLE=universal SUBCOMPACTIONS=$nsub UNIVERSAL_ALLOW_TRIVIAL_MOVE=1 UNIVERSAL_MAX_SIZE_AMP=100 )
myargs+=( COMPACTION_STYLE=universal SUBCOMPACTIONS=$nsub \
          UNIVERSAL_COMPRESSION_SIZE_PERCENT="-1" UNIVERSAL_ALLOW_TRIVIAL_MOVE=0 UNIVERSAL_MAX_SIZE_AMP=50 UNIVERSAL_SIZE_RATIO=10 \
          LEVEL0_FILE_NUM_COMPACTION_TRIGGER=16 LEVEL0_SLOWDOWN_WRITES_TRIGGER=200 LEVEL0_STOP_WRITES_TRIGGER=200 \
          CACHE_INDEX_AND_FILTER_BLOCKS=0 PARTITION_INDEX_AND_FILTERS=1 PIN_TOP_LEVEL_INDEX_AND_FILTER=1 METADATA_BLOCK_SIZE=65536 \
          BLOCK_SIZE=16384 )

env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}

exit

# for blobDB

odir=bm.bc.nt${nthreads}.d${odirect}
echo integrated blobDB using $odir at $( date )
myargs=( "${args[@]}" )
myargs+=( MIN_LEVEL_TO_COMPRESS=3 COMPACTION_STYLE=blob CACHE_INDEX_AND_FILTER_BLOCKS=1 )
env "${myargs[@]}" bash benchmark_compare.sh /data/m/rx $odir ${versions[@]}

