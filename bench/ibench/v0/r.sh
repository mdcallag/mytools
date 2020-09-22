# dop is the number of concurrent clients
dop=$1
user=$2
password=$3
# nrows is the number of rows to insert per client
nrows=$4
# ips is the target insert rate per client. Each client runs for as long as required to insert $nrows. If a client cannot sustain
# the target insert rate (ips) then it will run longer than expected.
ips=$5

py3=python3

start_secs=$( date +%s )

echo Run for nrows $nrows and DoP $dop at $( date )
for n in $( seq 1 $dop ); do
  cmd="iibench.py --dbms=mongo --db_name=ib --rows_per_report=10000 --db_host=127.0.0.1 --mongo_w=1 --db_user=$user --db_password=$password --max_rows=$nrows --table_name=pi${n} --num_secondary_indexes=3 --data_length_min=10 --data_length_max=20 --rows_per_commit=100 --inserts_per_second=$ips --query_threads=1 --seed=$(( $start_secs + $n )) --dbopt=none --name_cash=caid --name_cust=cuid --name_ts=ts --name_price=prid --name_prod=prod"
  echo $cmd > o.r.ips${ips}.$n
  $py3 $cmd >> o.r.ips${ips}.$n 2>& 1 &
  pids[${n}]=$!
done

for n in $( seq 1 $dop ); do
  echo Wait for run $n
  wait ${pids[${n}]}
done

echo Done
