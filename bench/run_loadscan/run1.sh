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

run_mysql="$mysql -u$myu -p$myp -S$mysock $myd -A"

dop=1
rm -f ${tag}.*
TIMEFORMAT='%R'
while [[ $dop -le $maxdop ]]; do

  # Perform the load
  i=1
  while [[ $i -le $dop ]]; do
    $run_mysql -e "drop table if exists $tn$i"
    python ../ibench/iibench.py --db_name=$myd --db_user=$myu --db_password=$myp --db_sock=$mysock \
        --setup --max_rows=$nr --rows_per_report=10000 --table_name=$tn$i --engine=$engine \
        --insert_only >& ${tag}.${i}_of_${dop} &
    p[$i]=$!
    i=$(( $i + 1))
  done
  i=1
  while [[ $i -le $dop ]]; do
    wait ${p[ $i ]}
    i=$(( $i + 1))
  done
  grep "^$nr " ${tag}.*_of_${dop} | awk '{ print $3 }' | sort -n | tail -1 | awk '{ print "maxloadtime", $1 }'
  $run_mysql -e "show table status like 'tn%'"

  # Perform the scan.
  i=1
  while [[ $i -le $dop ]]; do
    /usr/bin/time -o ${tag}.${i}_of_${dop}.time -f 'scantime %e' \
        $run_mysql -e "select max(productid) from $tn$i" &
    p[$i]=$!
    i=$(( $i + 1))
  done
  i=1
  while [[ $i -le $dop ]]; do
    wait ${p[ $i ]}
    i=$(( $i + 1))
  done
  grep "^scantime " ${tag}*_of_${dop}.time | awk '{ print $2 }' \
      | sort -n | tail -1 | awk '{ print "maxscantime", $1 }'

  # Perform the join
  i=1
  while [[ $i -le $dop ]]; do
    /usr/bin/time -o ${tag}.${i}_of_${dop}.time -f 'jointime %e' \
        $run_mysql -e "select count(*) from $tn$i a, $tn$i b where a.transactionid = b.transactionid" &
    p[$i]=$!
    i=$(( $i + 1))
  done
  i=1
  while [[ $i -le $dop ]]; do
    wait ${p[ $i ]}
    i=$(( $i + 1))
  done
  grep "^jointime " ${tag}*_of_${dop}.time | awk '{ print $2 }' \
      | sort -n | tail -1 | awk '{ print "maxjointime", $1 }'

  i=1
  while [[ $i -le $dop ]]; do
    $run_mysql -e "show create table ${tn}${i}"
    $run_mysql -e "show table status like \"${tn}${i}\""
    $run_mysql -e "drop table ${tn}${i}"
    i=$(( $i + 1))
  done

  dop=$(( $dop * 2 ))


done

