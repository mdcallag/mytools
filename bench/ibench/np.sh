nr=$1
e=$2
eo=$3
dbdir=$4

rm -f o.res
for maxn in 1 2 4 8 12 16 20 24 28 32 ; do
  maxr=$(( $nr / $maxn ))

  mysql -uroot -ppw -A -h127.0.0.1 -e 'drop database ib'
  mysql -uroot -ppw -A -h127.0.0.1 -e 'create database ib'

  python mstat.py --db_user=root --db_password=pw --db_host=127.0.0.1 --loops=10000000 --interval=10 2> /dev/null > o.mstat.${maxn} &
  mpid=$!

  start_secs=$( date +%s )

  for n in $( seq 1 $maxn ); do
    python iibench.py --db_name=ib --rows_per_report=100000 --db_host=127.0.0.1 --db_user=root --db_password=pw --max_rows=${maxr} --engine=$e --engine_options=$eo --table_name=pi${n} --setup --insert_only >& o.ib.${maxn}.${n} &
    pids[${n}]=$!
    # echo Started ${pids[${n}]} $n
  done

  for n in $( seq 1 $maxn ); do
    # echo Wait for ${pids[${n}]} $n
    wait ${pids[${n}]} 
  done

  stop_secs=$( date +%s )
  tot_secs=$(( $stop_secs - $start_secs ))
  insert_rate=$( echo "scale=1; $nr / $tot_secs" | bc )
  insert_per=$( echo "scale=1; $insert_rate / $maxn" | bc )
  echo $maxn processes, $maxr rows-per-process, $tot_secs seconds, $insert_rate rows-per-second, $insert_per rows-per-second-per-user
  echo $maxn processes, $maxr rows-per-process, $tot_secs seconds, $insert_rate rows-per-second, $insert_per rows-per-second-per-user >> o.res

  kill -9 $mpid >& /dev/null

  mysql -uroot -ppw -A -h127.0.0.1 -e 'show engine innodb status\G' > o.esi.${maxn}
  mysql -uroot -ppw -A -h127.0.0.1 -e 'show engine rocksdb status\G' > o.esr.${maxn}
  mysql -uroot -ppw -A -h127.0.0.1 -e 'show global status' > o.gs.${maxn}
  mysql -uroot -ppw -A -h127.0.0.1 -e 'show global variables' > o.gv.${maxn}

  du -hs $dbdir > o.sz.${maxn}
  du --apparent-size -hs $dbdir >> o.sz.${maxn}

done

echo
cat o.res
