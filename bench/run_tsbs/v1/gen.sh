gend=$1
genq=$2
load=$3
run=$4
# true or false
doc_per=$5
# for a small database use scale=10
scale=$6
# dbname=tsbsagg
dbname=$7
# generate data for this many months, must be 1 to 12
nmonths=$8
# queries span this many days, must be 1 to 10
devname=$9
mbin=${10}
user=${11}
pw=${12}
# all to run all queries, otherwise the name of query type
queries=${13}
max_queries=${14}
tag=${15}

shift 15

dts1="2016-01-01T00:00:00Z"
dts2=$( printf "2016-%02d-28T23:59:00Z" $nmonths )

echo run for $dts1 to $dts2 for $nmonths months with $scale hosts

nqueries=1000
intsecs=10
lint=${intsecs}s
use=devops
sd=100
durl="mongodb://root:pw@localhost:27017/admin"

sfx=${nmonths}month.${scale}host
ddir=mongo.${sfx}

if [[ $gend == "yes" ]]; then
mkdir -p $ddir
echo generate data from $dts1 to $dts2 at $( date )
~/go/bin/tsbs_generate_data --timestamp-start=$dts1 --timestamp-end=$dts2 --log-interval=$lint --use-case=$use --scale=$scale --seed=$sd --format=mongo | gzip > ${ddir}/mongo-data.gz 2> ${ddir}/e.d.gen.$sfx
fi

if [[ $genq == "yes" ]]; then
base=$( printf "2016-%02d-28" $nmonths )
echo generate queries at $( date )
for ndays in "$@" ; do
  nm1=$(( $ndays - 1 ))
  q_begin=$( date --date "$base -${nm1} days" +"%Y-%m-%dT00:00:00Z" )
  q_end=$( date --date "$base -0 days" +"%Y-%m-%dT23:59:01Z" )
  rdir=${ddir}/${ndays}day
  mkdir -p $rdir
  echo gen queries for $ndays from $q_begin to $q_end
  echo "MONGO_USE_NAIVE=$doc_per FORMATS=mongo SCALE=$scale SEED=$sd TS_START=${q_begin} TS_END=${q_end} QUERIES=$nqueries BULK_DATA_DIR=${rdir} ../scripts/generate_queries.sh"
  MONGO_USE_NAIVE=$doc_per FORMATS=mongo SCALE=$scale SEED=$sd TS_START=${q_begin} TS_END=${q_end} QUERIES=$nqueries BULK_DATA_DIR=${rdir} ../scripts/generate_queries.sh > ${ddir}/o.q.gen.$sfx 2> ${ddir}/e.q.gen.$sfx
done
fi

killall vmstat
killall iostat

function parse_stats {
  ops=$1
  ifn=$2
  vfn=$3
  ofn=$4

  # echo parse_stats for :: ops $ops :: ifn $ifn :: vfn $vfn :: ofn $ofn :: devname $devname ::

  # v1 - Ubuntu 16.04, 14 cols
  #Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
  # v2 - Ubuntu 18.04, 16 cols
  #Device            r/s     w/s     rMB/s     wMB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
  # v3 - Ubuntu 20.04, 21 cols
  #Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm d_await dareq-sz  aqu-sz  %util

  nl=$( grep "^Device" $ifn | head -1 | awk '{ print NF }' )
  if [[ $nl -eq 14 ]]; then
    rmbps=$( grep "^Device" $ifn | head -1 | awk '{ print $6 }' )
    crs=4; cws=5; crmb=6; cwmb=7
  elif [[ $nl -eq 16 ]]; then
    rmbps=$( grep "^Device" $ifn | head -1 | awk '{ print $4 }' )
    crs=2; cws=3; crmb=4; cwmb=5
  elif [[ $nl -eq 21 ]]; then
    rmbps=$( grep "^Device" $ifn | head -1 | awk '{ print $3 }' )
    crs=2; cws=8; crmb=3; cwmb=9
  else
    echo "Cannot parse iostat output"
    exit -1
  fi
  if [[ $rmbps != "rMB/s" ]]; then
    echo "rMB/s not found"
    exit -1
  fi

  printf "\niostat, vmstat normalized by ops/sec\n" >> $ofn
  printf "samp\tr/s\trMB/s\tw/s\twMB/s\tr/o\trKB/o\tw/o\twKB/o\tops\n" >> $ofn

  grep $devname $ifn | \
      awk '{ if (NR>1) { rs += $crs; ws += $cws; rmb += $crmb; wmb += $cwmb; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.0f\t%.1f\t%.3f\t%.3f\t%.3f\t%.3f\t%s\n", c, rs/c, rmb/c, ws/c, wmb/c, rs/c/o, (1024*rmb)/c/o , ws/c/o, (1024*wmb)/c/o, o }' o=$ops crs=$crs cws=$cws crmb=$crmb cwmb=$cwmb >> $ofn

  ncpu=$( grep ^processor /proc/cpuinfo  | wc -l )
  printf "\nsamp\tcs/s\tcpu/s\tcs/o\tcpu(ms)/o\n" >> $ofn
  grep -v swpd $vfn | awk '{ if (NR>1) { cs += $12; cpu += $13 + $14; c += 1 } } END { printf "%s\t%.0f\t%.1f\t%.1f\t%.1f\n", c, cs/c, cpu/c, cs/c/o, ((((cpu/c)/100) * n) * 1000) / o }' o=$ops n=$ncpu >> $ofn
}

if [[ $load == "yes" ]]; then
echo load at $( date )

vmstat 5 >& ${ddir}/o.d.run.vm.$sfx &
vpid=$!
iostat -y -mx 5 >& ${ddir}/o.d.run.io.$sfx &
ipid=$!

start_secs=$( date +%s )
DOC_PER=$doc_per NUM_WORKERS=8 BULK_DATA_DIR=${ddir} DATABASE_NAME=$dbname MONGO_URL=$durl bash ../scripts/load_mongo.sh > ${ddir}/o.d.run.$sfx 2> ${ddir}/e.d.run.$sfx
stop_secs=$( date +%s )
tot_secs=$(( $stop_secs - $start_secs ))

# loaded 24433314 metrics in 76.219sec with 8 workers (mean rate 320568.58 metrics/sec)
nmet=$( tail -1 ${ddir}/o.d.run.$sfx | awk '{ print $2 }' )
persec=$( tail -1 ${ddir}/o.d.run.$sfx | awk '{ print $11 }' )

kill $vpid
kill $ipid
parse_stats $persec ${ddir}/o.d.run.io.$sfx ${ddir}/o.d.run.vm.$sfx ${ddir}/o.d.run.$sfx

fi

nq=$nqueries
if [[ $max_queries -lt $nq ]]; then
  nq=$max_queries
  echo Reduce max-queries from $nqueries to $nq
fi


if [[ $run == "yes" ]]; then
mkdir -p ${ddir}/${tag}
for ndays in "$@" ; do
for qtype in \
cpu-max-all-1 \
cpu-max-all-8 \
lastpoint \
single-groupby-5-1-1 \
single-groupby-5-1-12 \
single-groupby-5-8-1 \
single-groupby-1-1-1 \
single-groupby-1-8-1 \
single-groupby-1-1-12 \
groupby-orderby-limit \
double-groupby-1 \
double-groupby-5 \
double-groupby-all \
high-cpu-1 \
high-cpu-all \
; do 

if [[ $queries == "all" || $queries == $qtype ]]; then
  echo Run $qtype at $( date )
else
  continue
fi

sfx2=${ndays}day.${qtype}.${sfx}

vmstat 1 >& ${ddir}/${tag}/o.q.run.vm.$sfx2 &
vpid=$!
iostat -y -mx 1 >& ${ddir}/${tag}/o.q.run.io.$sfx2 &
ipid=$!

start_secs=$( date +%s )
# TODO do read in a transaction? read concern?
cat ${ddir}/${ndays}day/mongo-${qtype}-queries.gz | gunzip | tsbs_run_queries_mongo \
	--db-name=$dbname --url=$durl \
	--workers=1 \
	--max-queries=$nq \
	--read-timeout=600s \
	> ${ddir}/${tag}/o.q.run.$sfx2 2> ${ddir}/${tag}/e.q.run.$sfx2
stop_secs=$( date +%s )
tot_secs=$(( $stop_secs - $start_secs ))
qps=$( echo $nqueries $tot_secs | awk '{ printf "%.1f", $1 / $2 }' )
kill $vpid
kill $ipid
parse_stats $qps ${ddir}/${tag}/o.q.run.io.$sfx2 ${ddir}/${tag}/o.q.run.vm.$sfx2 ${ddir}/${tag}/o.q.run.$sfx2

cat ${ddir}/${tag}/o.q.run.$sfx2
echo
done
done
fi

echo "show dbs" | $mbin -u $user -p $pw

#	--print-responses \

# for d in o.q.run.*; do tail -2 $d | head -1 | awk '{ printf "%8s\t%8s\t%8s\t%8s\t%8s\t%8d\t", $2, $4, $6, $8, $10, $14 }' | sed 's/ms,//g'; echo $d; done
