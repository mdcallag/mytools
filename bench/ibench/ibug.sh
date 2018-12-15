
nuser=$1
only1table=$2
nrows=$3
dbuser=$4
dbpass=$5
dbname=$6

seed=$( date +%s )

if [[ $only1table != "yes" ]]; then
  echo $nuser users and $nuser tables

  for nu in $( seq 1 $nuser ); do
    python iibench.py --db_name=$dbname --rows_per_report=100000 --db_host=127.0.0.1 --db_user=$dbuser --db_password=$dbpass --engine=innodb --unique_checks=1 --bulk_load=0 --max_rows=$nrows --table_name=pi${nu} --setup --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=100 --inserts_per_second=0 --query_threads=0 --seed=$(( $seed + $nu )) >& o.ib.no.$nu &

    pids[${nu}]=$!
  done

  for nu in $( seq 1 $nuser ) ; do
    wait ${pids[${nu}]}
  done

else
echo $nuser users and 1 table

  python iibench.py --db_name=$dbname --rows_per_report=100000 --db_host=127.0.0.1 --db_user=$dbuser --db_password=$dbpass --engine=innodb --unique_checks=1 --bulk_load=0 --max_rows=$nrows --table_name=pi1 --setup --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=100 --inserts_per_second=0 --query_threads=0 --seed=$(( $seed + 1 )) >& o.ib.yes.1 &
  pids[1]=$!

  for nu in $( seq 2 $nuser ); do
    python iibench.py --db_name=$dbname --rows_per_report=100000 --db_host=127.0.0.1 --db_user=$dbuser --db_password=$dbpass --engine=innodb --unique_checks=1 --bulk_load=0 --max_rows=$nrows --table_name=pi1 --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=100 --inserts_per_second=0 --query_threads=0 --seed=$(( $seed + $nu )) >& o.ib.yes.$nu &
    pids[${nu}]=$!
  done

  for nu in $( seq 1 $nuser ) ; do
    wait ${pids[${nu}]}
  done

fi
