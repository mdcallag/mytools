
dbName=$1
user=$2
pass=$3
port=$4
hosts=$5
qDir=$6
rDir=$7
pWarm=$8
dbms=$9
name=${10}
maxSecs=${11}
nworkers=${12}

pInt=0
monSecs=1

xa="--db-name=$dbName --user=$user --pass=$pass --port=$port --hosts=$hosts "
xa+="--print-interval=$pInt "
xa+="--prewarm-queries=$pWarm "

killall vmstat 2> /dev/null
killall iostat 2> /dev/null

mkdir -p $rDir

for qt in \
cpu-max-all-8 cpu-max-all-1 \
high-cpu-all high-cpu-1 \
lastpoint \
groupby-orderby-limit \
single-groupby-1-1-1 single-groupby-1-8-1 single-groupby-5-8-1 \
single-groupby-1-1-12 single-groupby-5-1-1 single-groupby-5-1-12 \
double-groupby-1 double-groupby-5 double-groupby-all \
; do 

#hdr="--hdr-latencies=${rDir}/lat.${name}.${qt}"; pa=5; pb=3
hdr=""; pa=4; pb=2

sfx=${name}.${qt}
iostat -y -kx $monSecs >& ${rDir}/io.$sfx &
ipid=$!
vmstat $monSecs        >& ${rDir}/vm.$sfx &
vpid=$!

if [[ $maxSecs == "none" ]]; then
  maxArg=""
else
  maxArg="--max-total-duration=$maxSecs"
fi

echo Start $qt for $dbName at $( date ) with $maxSecs timeout and $nworkers workers with $qDir dir

echo "tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --show-explain" > ${rDir}/exp.${name}.${qt} 
./tsbs_run_queries_${dbms}     $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --show-explain >> ${rDir}/exp.${name}.${qt} 

echo "tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --workers=$nworkers $maxArg" > ${rDir}/res.${name}.${qt} 
./tsbs_run_queries_${dbms}     $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --workers=$nworkers $maxArg >> ${rDir}/res.${name}.${qt} 

kill $ipid
kill $vpid

tail -${pa} ${rDir}/res.${name}.${qt} | head -1
tail -${pb} ${rDir}/res.${name}.${qt} | head -1

done

