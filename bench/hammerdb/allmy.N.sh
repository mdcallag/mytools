
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

export LD_LIBRARY_PATH=/home/mdcallag/d/my8406_rel_o2nofp/lib
echo LD_LIBRARY_PATH set to $LD_LIBRARY_PATH

#z12a_c8r32 \
#z12a_dw0_c8r32 \
#z12a_md1_c8r32 \
#z12a_pl0_c8r32 \
#z12a_bl0_c8r32 \
#z12a_bl0_pl0_md1_c8r32 \
#z12a_bl0_pl0_dw0_c8r32 \
#z12a_bl0_pl0_md1_dw0_c8r32 \

for d in \
z12a_c8r32 \
; do
  echo Run $d
  cd /home/mdcallag/d/my8406_rel_o2nofp
  bash ini.sh $d >& o.ini.$d ; sleep 5
  cd /opt/HammerDB-5.0

  sfx=my.$d

  echo "Build at $( date )"
  HAMMER_BUILD_VU=$build_vu HAMMER_WAREHOUSE=$warehouse \
      ./hammerdbcli auto ~/testscripts.hammerdb/mysqlbuildN.tcl > o.$sfx.build.out 2> o.$sfx.build.err 

  du -hs /data/m/* > o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/my/* >> o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/my/data/* >> o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/my/data/tpcc/* >> o.$sfx.build.df

  cd /home/mdcallag/d/my8406_rel_o2nofp
  bin/mysql -uroot -ppw tpcc -e 'show table status' -E > o.$sfx.build.tablestatus

  bin/mysql -uroot -ppw information_schema -e \
      'select (num_rows) / (1024*1024) as Mrows, \
       clust_index_size / (1024*1024*1024.0) as PK_gb, \
       other_index_size / (1024*1024*1024.0) as SI_gb, \
       (clust_index_size + other_index_size) / (1024*1024*1024.0) as TOT_gb, \
       name \
       from innodb_tablestats where name like "tpcc%"' > o.$sfx.build.tablesize

  cd /opt/HammerDB-5.0
  mv /home/mdcallag/d/my8406_rel_o2nofp/o.$sfx.* .

  echo "Run at $( date )"
  HAMMER_RUN_VU=$run_vu HAMMER_WAREHOUSE=$warehouse HAMMER_RAMPUP=$rampup HAMMER_DURATION=$duration \
      ./hammerdbcli auto ~/testscripts.hammerdb/mysqlrunN.tcl > o.$sfx.run.out 2> o.$sfx.run.err &
  hpid=$!

  # Assuming ramp time is 2 minutes, don't collect vmstat and iostat during it
  sleep 120

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

  du -hs /data/m/* > o.$sfx.run.df
  echo >> o.$sfx.run.df
  du -hs /data/m/my/* >> o.$sfx.run.df
  echo >> o.$sfx.run.df
  du -hs /data/m/my/data/* >> o.$sfx.run.df
  echo >> o.$sfx.run.df
  du -hs /data/m/my/data/tpcc/* >> o.$sfx.run.df

  cd /home/mdcallag/d/my8406_rel_o2nofp
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
  mv /home/mdcallag/d/my8406_rel_o2nofp/o.$sfx.* .
done

