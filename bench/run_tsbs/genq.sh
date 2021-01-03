format=$1
usecase=$2
scale=$3
seed=$4
tsStart=$5
tsEnd=$6
rdir=$7

xa="--mysql-use-tags=true --timescale-use-time-bucket=false --timescale-use-tags=true --scale=$scale --seed=$seed --scale=$scale --use-case=$usecase "

mkdir -p $rdir

for qt in \
cpu-max-all-8 cpu-max-all-1 \
high-cpu-all high-cpu-1 \
lastpoint \
groupby-orderby-limit \
single-groupby-1-1-1 single-groupby-1-8-1 single-groupby-5-8-1 \
single-groupby-1-1-12 single-groupby-5-1-1 single-groupby-5-1-12 \
double-groupby-1 double-groupby-5 double-groupby-all \
; do 
./tsbs_generate_queries $xa --format=$format --timestamp-start=$tsStart --timestamp-end=$tsEnd --query-type=$qt > $rdir/q.$format.$usecase.scale${scale}.seed${seed}.$qt
./tsbs_generate_queries $xa --format=$format --timestamp-start=$tsStart --timestamp-end=$tsEnd --query-type=$qt > $rdir/e.$format.$usecase.scale${scale}.seed${seed}.$qt
done

