
# when =1, then run perf to collect some samples (not working)
doperf=$1
# an integer, number of virtual users during load to support parallel load
build_vu=$2
# comma separated list of integers, benchmark repeated for each number of virtual users
run_vu=$3
# an integer, number of warehouses
warehouse=$4
# an integer, duration in minutes for rampup
rampup=$5
# an integer, duration in minutes to run test 
duration=$6
config_suffix=$7

export LD_LIBRARY_PATH=/home/mdcallag/d/my8406_rel_o2nofp/lib:$LD_LIBRARY_PATH
echo LD_LIBRARY_PATH set to $LD_LIBRARY_PATH

for dcnf in \
my5651_rel_o2nofp.z12a_${config_suffix} \
my5744_rel_o2nofp.z12a_${config_suffix} \
my8044_rel_o2nofp.z12a_${config_suffix} \
my8407_rel_o2nofp.z12a_${config_suffix} \
my9400_rel_o2nofp.z12a_${config_suffix} \
my9500_rel_o2nofp.z12a_${config_suffix} \
; do
  dbms=$( echo $dcnf | tr '.' ' ' | awk '{ print $1 }' )
  cnf=$( echo $dcnf | tr '.' ' ' | awk '{ print $2 }' )
  echo Run $dbms $cnf
  cd /home/mdcallag/d/$dbms
  bash ini.sh $cnf >& o.ini.$cnf ; sleep 5
  cd /opt/HammerDB-5.0

  mysock=$( /home/mdcallag/d/$dbms/bin/mysql -uroot -ppw -A -h 127.0.0.1 -e 'show global variables like "socket"' -E | grep Value: | awk '{ print $2 }' )
  /home/mdcallag/d/$dbms/bin/mysql -uroot -ppw -A -h 127.0.0.1 -e 'show global variables like "socket"' -E
  echo Socket is :: $mysock ::

  sfx=my.$dcnf

  vmstat 1 10000000 >& o.$sfx.build.vm &
  vmpid=$!
  iostat -y -kx 1 10000000 >& o.$sfx.build.io &
  iopid=$!

  while :; do date; ps aux | sort -rnk 6,6 | head -20 ; sleep 10; done >& o.$sfx.build.ps &
  pspid=$!

  echo "Build at $( date )"
  HAMMER_BUILD_VU=$build_vu HAMMER_WAREHOUSE=$warehouse HAMMER_MYSOCK=$mysock \
      ./hammerdbcli auto testscripts/mysqlbuildN.tcl > o.$sfx.build.out 2> o.$sfx.build.err 

  du -hs /data/m/* > o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/my/* >> o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/my/data/* >> o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/my/data/tpcc/* >> o.$sfx.build.df

  kill $vmpid
  kill $iopid
  kill $pspid

  cd /home/mdcallag/d/$dbms
  bin/mysql -uroot -ppw tpcc -e 'show table status' -E > o.$sfx.build.tablestatus

  bin/mysql -uroot -ppw information_schema -e \
      'select (num_rows) / (1024*1024) as Mrows, \
       clust_index_size / (1024*1024*1024.0) as PK_gb, \
       other_index_size / (1024*1024*1024.0) as SI_gb, \
       (clust_index_size + other_index_size) / (1024*1024*1024.0) as TOT_gb, \
       name \
       from innodb_tablestats where name like "tpcc%"' > o.$sfx.build.tablesize

  cd /opt/HammerDB-5.0
  mv /home/mdcallag/d/$dbms/o.$sfx.* .

  # let hardware and DBMS cool off
  sleep 300

  echo "Run at $( date )"
  HAMMER_RUN_VU=$run_vu HAMMER_WAREHOUSE=$warehouse HAMMER_RAMPUP=$rampup HAMMER_DURATION=$duration HAMMER_MYSOCK=$mysock \
      ./hammerdbcli auto testscripts/mysqlrunN.tcl > o.$sfx.run.out 2> o.$sfx.run.err &
  hpid=$!

  while :; do date; ps aux | sort -rnk 6,6 | head -20 ; sleep 10; done >& o.$sfx.run.ps &
  pspid=$!

  # don't collect vmstat and iostat during rampup
  sleep $(( 60 * $rampup ))

  vmstat 1 10000000 >& o.$sfx.run.vm &
  vmpid=$!
  iostat -y -kx 1 10000000 >& o.$sfx.run.io &
  iopid=$!

  if [[ $doperf -eq 1 ]]; then
    echo Collecting perf
    dbbpid=$( ps aux | grep mysqld | grep -v mysqld_safe | grep -v \/usr\/bin\/time | grep -v timeout | grep -v grep | awk '{ print $2 }' )
    if [ -z $dbbpid ]; then
      echo Cannot get mysqld PID
    else
      for loop in 1 2 3 4 5 6 7 8 9 ; do
        #perf record -F 333 -p PID -- sleep 15
        #perf record -F 333 -p $dbbpid -g -- sleep 15
        perf record -F 333 -a -g -- sleep 15

        perf report --stdio -g graph > o.$sfx.perf.rep.g.graph.loop${loop}
        perf report --stdio -g flat  > o.$sfx.perf.rep.g.flat.looop${loop}

	fgp="$HOME/git/FlameGraph"
        if [ ! -d $fgp ]; then
	  echo FlameGraph not found
	else
          perf script | $fgp/stackcollapse-perf.pl > o.$sfx.perf.loop${loop}.folded
          cat o.$sfx.perf.loop${loop}.folded | $fgp/flamegraph.pl > o.$sfx.perf.loop${loop}.svg
	fi

	#perf stat -o o.$sfx.perf.stat.loop${loop} -p $dbbpid -- sleep 15
	perf stat -o o.$sfx.perf.stat.loop${loop} -a -- sleep 15

	# TODO - collect all samples into one big sample
	sleep 30
      done

      cat o.$sfx.perf.loop*.folded |  $fgp/flamegraph.pl > o.$sfx.perf.all.svg
      rm o.$sfx.perf.loop*.folded 
    fi

  fi

  wait $hpid
  cat o.$sfx.run.out | grep "System achieved"
  echo

  kill $vmpid
  kill $iopid
  kill $pspid

  du -hs /data/m/* > o.$sfx.run.df
  echo >> o.$sfx.run.df
  du -hs /data/m/my/* >> o.$sfx.run.df
  echo >> o.$sfx.run.df
  du -hs /data/m/my/data/* >> o.$sfx.run.df
  echo >> o.$sfx.run.df
  du -hs /data/m/my/data/tpcc/* >> o.$sfx.run.df

  cd /home/mdcallag/d/$dbms
  bin/mysql -uroot -ppw -e 'show engine innodb status' -E > o.$sfx.seis
  bin/mysql -uroot -ppw -e 'show global status' > o.$sfx.sgs
  bin/mysql -uroot -ppw -e 'show global variables' > o.$sfx.sgv
  bin/mysql -uroot -ppw tpcc -e 'show table status' -E > o.$sfx.run.tablestatus

  bin/mysql -uroot -ppw information_schema -e \
      'select (num_rows) / (1024*1024) as Mrows, \
       clust_index_size / (1024*1024*1024.0) as PK_gb, \
       other_index_size / (1024*1024*1024.0) as SI_gb, \
       (clust_index_size + other_index_size) / (1024*1024*1024.0) as TOT_gb, \
       name \
       from innodb_tablestats where name like "tpcc%"' > o.$sfx.run.tablesize

  rm -f o.$sfx.createtable
  for t in customer district history item new_order order_line orders stock warehouse ; do
    bin/mysql -uroot -ppw tpcc -e "show create table $t" -E >> o.$sfx.createtable
    echo >> o.$sfx.createtable
  done

  bash down.sh >& o.$sfx.down
  cd /opt/HammerDB-5.0
  mv /home/mdcallag/d/$dbms/o.$sfx.* .
done
