
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
fastMaxQ=${11}
slowMaxQ=${12}
maxSecs=${13}

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

if [[ $qt == "groupby-orderby-limit" ]] ; then
  echo Start $qt for $dbName at $( date ) with $slowMaxQ queries
  echo "tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --max-queries=${slowMaxQ} --max-total-duration=$maxSecs" > ${rDir}/exp.${name}.${qt} 
  echo "tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --max-queries=${slowMaxQ} --show-explain" >> ${rDir}/exp.${name}.${qt} 
  ./tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --max-queries=${slowMaxQ} --show-explain >> ${rDir}/exp.${name}.${qt} 
  ./tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --max-queries=${slowMaxQ} --max-total-duration=$maxSecs > ${rDir}/res.${name}.${qt} 
else
  echo Start $qt for $dbName at $( date ) with $fastMaxQ queries
  echo "tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --max-queries=${fastMaxQ} --max-total-duration=$maxSecs" > ${rDir}/exp.${name}.${qt} 
  echo "tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --max-queries=${fastMaxQ} --show-explain" >> ${rDir}/exp.${name}.${qt} 
  ./tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --max-queries=${fastMaxQ} --show-explain >> ${rDir}/exp.${name}.${qt} 
  ./tsbs_run_queries_${dbms} $xa --file=${qDir}/q.${dbms}.${name}.${qt} $hdr --max-queries=${fastMaxQ} --max-total-duration=$maxSecs > ${rDir}/res.${name}.${qt} 
fi

kill $ipid
kill $vpid

tail -${pa} ${rDir}/res.${name}.${qt} | head -1
tail -${pb} ${rDir}/res.${name}.${qt} | head -1

done

