nr=$1
nq=$2
engine=$3
dz=$4
maxdop=$5
myu=$6
myp=$7
myd=$8
tn=$9
mysock=${10}
tag=${11}
ic=${12}

run_dz="$dz $myd  -A"
run_dz_nod="$dz -A"
run_mysql="$mysql -u$myu -p$myp -S$mysock $myd -A"
run_mysql_nod="$mysql -u$myu -p$myp -S$mysock -A"
run_mypy="python /data/mycli.py --db_user=$myu --db_password=$myp --db_socket=$mysock --db_name=$myd"
run_slap="/data/5138orig/bin/mysqlslap --user=$myu --password=$myp --socket=$mysock --host=localhost "
run_dslap="/data/drizzle/bin/drizzleslap --user=$myu --password=$myp --socket=$mysock --host=localhost "

rm -f ${tag}.*
TIMEFORMAT='%R'

# Perform the load
$run_dz_nod -e "create database $myd" >&  /dev/null
$run_dz_nod -e "set global pool_of_threads_size=16"

for i in $( seq 1 $maxdop ) ; do

  # create the table
  $run_dz -e "drop table if exists $tn$i" >&  /dev/null

  if [[ $ic == "yes" ]]; then
    $run_dz -e "create table $tn$i(i int auto_increment primary key, j int) engine=$engine row_format=compressed key_block_size=16"
  else
    $run_dz -e "create table $tn$i(i int auto_increment primary key, j int) engine=$engine"
  fi

  # insert rows
  $run_dz -e "insert into $tn$i values (null, 1)"
  row_ct=1
  while [[ $row_ct -le $nr ]]; do
    $run_dz -e "insert into $tn$i select null,1 from $tn$i"
    row_ct=$(( $row_ct * 2 ))
  done
done

# Run the performance test
dop=8
while [[ $dop -le $maxdop ]]; do

  # Perform the scan.
  if [[ 0 -eq 1 ]]; then
    echo Use mysql client
    for i in $( seq 1 $dop ) ; do
      /usr/bin/time -o ${tag}.${i}_of_${dop}.time -f 'scantime %e %S %U %P' \
          $run_dz < q$i | head -20 >& ${tag}.${i}_of_${dop}.out &
      #    $run_mypy q$i >& ${tag}.${i}_of_${dop}.out &
      p[$i]=$!
    done
  
    for i in $( seq 1 $dop ) ; do
      wait ${p[ $i ]}
    done

    grep "^scantime " ${tag}*_of_${dop}.time | awk '{ print $2 }' \
      | sort -n | tail -1 | awk '{ print "maxscantime", $1 }'
  else

    echo Use mysqlslap
    # echo $run_slap --concurrency=$dop --query=q1
    echo $run_dslap --concurrency=$dop --query=q1
    /usr/bin/time -o ${tag}.${dop}.time -f 'scantime %e %S %U %P' \
        $run_dslap --concurrency=$dop --query=q1 >& ${tag}.${dop}.out 

    grep "^scantime " ${tag}.${dop}.time | awk '{ print $2 }' | awk '{ print "maxscantime", $1 }'
  fi

  dop=$(( $dop * 2 ))

done

for i in $( seq 1 $maxdop ) ; do
  $run_dz -e "show create table ${tn}${i}"
  $run_dz -e "show table status like \"${tn}${i}\""
  $run_dz -e "drop table ${tn}${i}"
done
$run_dz -e "show status like '%seconds'"
$run_dz -e "show variables like 'pool%'"
