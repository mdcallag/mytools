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

latest_versions=( 6.28.gcc )
six_versions=( 6.0.gcc 6.1.gcc 6.2.gcc 6.3.gcc 6.4.gcc 6.5.gcc 6.6.gcc 6.7.gcc 6.8.gcc 6.9.gcc 6.10.gcc 6.11.gcc 6.12.gcc 6.13.gcc 6.14.gcc 6.15.gcc 6.16.gcc 6.17.gcc 6.18.gcc 6.19.gcc 6.20.gcc 6.21.gcc 6.22.gcc 6.23.gcc 6.24.gcc 6.25.gcc 6.26.gcc 6.27.gcc 6.28.gcc 6.29.gcc )
seven_versions=( 7.0.gcc 7.1.gcc 7.2.gcc 7.3.gcc 7.4.gcc 7.5.gcc 7.6.gcc 7.7.gcc 7.8.gcc 7.9.gcc 7.10.gcc )
eight_versions=( 8.0.gcc 8.1.gcc 8.2.gcc 8.3.gcc 8.4.gcc 8.5.gcc 8.6.gcc 8.7.gcc 8.8.gcc 8.9.gcc 8.10.gcc 8.11.gcc )
nine_versions=( 9.0.gcc 9.1.gcc )

some_seven_versions=( 7.0.gcc 7.3.gcc 7.6.gcc 7.10.gcc )
some_eight_versions=( 8.0.gcc 8.3.gcc 8.6.gcc 8.9.gcc 8.11.gcc )

#use_versions="${some_seven_versions[@]} ${some_eight_versions[@]} ${nine_versions[@]}"
use_versions="${eight_versions[@]}"

if [ "$#" -eq 0 ] ; then
  versions="${use_versions[@]}"
  echo "No version args"
else
  versions="$@"
  echo Commmand line lists versions: "${versions[@]}"
fi

case $myhw in
c8r32)
  # Options for 8-core, 32g RAM
  args=( WRITE_BUFFER_SIZE_MB=16 TARGET_FILE_SIZE_BASE_MB=16 MAX_BYTES_FOR_LEVEL_BASE_MB=64 MAX_BACKGROUND_JOBS=4 )
  cache_mb=$(( 1024 * 20 ))
  nsub=2
  ;;
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

exit

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

