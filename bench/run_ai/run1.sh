nr=$1
engine=$2
mysql=$3
maxdop=$4
myu=$5
myp=$6
myd=$7
tn=$8
mysock=$9
tag=${10}

if [[ ${11} == "yes" ]]; then
  setup="--setup"
else
  setup=""
fi

nqs=${12}
nis=${13}

run_mysql="$mysql -u$myu -p$myp -S$mysock $myd -A"

dop=1
rm -f ${tag}.*
TIMEFORMAT='%R'
while [[ $dop -le $maxdop ]]; do

  i=1
  while [[ $i -le $dop ]]; do
    if [[ ${11} == "yes" ]]; then
      $run_mysql -e "drop table if exists ${tn}${i}"
    fi
    max_rows_per=$(( $nr / $dop ))
    ../ibench/aibench.py --engine=$engine \
        --db_name=$myd --db_user=$myu --db_password=$myp --db_sock=$mysock \
        $setup --num_query_sessions=$nqs --num_insert_sessions=$nis \
        --max_rows=$max_rows_per --rows_per_report=10000 --table_name=${tn}${i} \
        >& ${tag}.${i}_of_${dop} &
    p[$i]=$!
    i=$(( $i + 1))
  done
  i=1
  while [[ $i -le $dop ]]; do
    wait ${p[ $i ]}
    i=$(( $i + 1))
  done
  grep "^$max_rows_per " ${tag}.*_of_${dop} | awk '{ print $3 }' | sort -n | tail -1 | awk '{ print "maxtime", $1 }'
  $run_mysql -e "show table status like 'tn%'"

  dop=$(( $dop * 2 ))

done

