
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

#ma100244_rel_withdbg.z12a_${config_suffix} \
#ma100339_rel_withdbg.z12a_${config_suffix} \
#ma100434_rel_withdbg.z12a_${config_suffix} \
#ma100529_rel_withdbg.z12a_${config_suffix} \
#ma100623_rel_withdbg.z12a_${config_suffix} \
#ma100708_rel_withdbg.z12a_${config_suffix} \
#ma100808_rel_withdbg.z12a_${config_suffix} \
#ma100908_rel_withdbg.z12a_${config_suffix} \
#ma101007_rel_withdbg.z12a_${config_suffix} \
#ma101114_rel_withdbg.z12a_${config_suffix} \
#ma110408_rel_withdbg.z12b_${config_suffix} \
#ma110803_rel_withdbg.z12b_${config_suffix} \
#ma120101_rel_withdbg.z12b_${config_suffix} \

#ma100230_rel_withdbg.z12a_${config_suffix} \
#ma100309_rel_withdbg.z12a_${config_suffix} \
#ma100408_rel_withdbg.z12a_${config_suffix} \
#ma100506_rel_withdbg.z12a_${config_suffix} \
#ma100605_rel_withdbg.z12a_${config_suffix} \
#ma101104_rel_withdbg.z12a_${config_suffix} \
#ma120101_rel_withdbg.z12b_ahi1_${config_suffix} \

for dcnf in \
ma100230_rel_withdbg.z12a_${config_suffix} \
ma100309_rel_withdbg.z12a_${config_suffix} \
ma100408_rel_withdbg.z12a_${config_suffix} \
ma100506_rel_withdbg.z12a_${config_suffix} \
ma100605_rel_withdbg.z12a_${config_suffix} \
ma101104_rel_withdbg.z12a_${config_suffix} \
ma120101_rel_withdbg.z12b_ahi1_${config_suffix} \
ma100244_rel_withdbg.z12a_${config_suffix} \
ma100339_rel_withdbg.z12a_${config_suffix} \
ma100434_rel_withdbg.z12a_${config_suffix} \
ma100529_rel_withdbg.z12a_${config_suffix} \
ma100623_rel_withdbg.z12a_${config_suffix} \
ma100708_rel_withdbg.z12a_${config_suffix} \
ma100808_rel_withdbg.z12a_${config_suffix} \
ma100908_rel_withdbg.z12a_${config_suffix} \
ma101007_rel_withdbg.z12a_${config_suffix} \
ma101114_rel_withdbg.z12a_${config_suffix} \
ma110408_rel_withdbg.z12b_${config_suffix} \
ma110803_rel_withdbg.z12b_${config_suffix} \
ma120101_rel_withdbg.z12b_${config_suffix} \
; do
  dbms=$( echo $dcnf | tr '.' ' ' | awk '{ print $1 }' )
  cnf=$( echo $dcnf | tr '.' ' ' | awk '{ print $2 }' )
  echo Run $dbms $cnf
  cd /home/mdcallag/d/$dbms
  bash ini.sh $cnf >& o.ini.$cnf ; sleep 5
  cd /opt/HammerDB-5.0

  sfx=ma.$dcnf

  echo "Build at $( date )"
  HAMMER_BUILD_VU=$build_vu HAMMER_WAREHOUSE=$warehouse \
      ./hammerdbcli auto testscripts/mariabuildN.tcl > o.$sfx.build.out 2> o.$sfx.build.err 

  du -hs /data/m/* > o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/my/* >> o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/my/data/* >> o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/my/data/tpcc/* >> o.$sfx.build.df

  cd /home/mdcallag/d/$dbms
  bin/mysql -uroot -ppw tpcc -e 'show table status' -E > o.$sfx.build.tablestatus

  bin/mysql -uroot -ppw information_schema -e \
      'select (num_rows) / (1024*1024) as Mrows, \
       clust_index_size / (1024*1024*1024.0) as PK_gb, \
       other_index_size / (1024*1024*1024.0) as SI_gb, \
       (clust_index_size + other_index_size) / (1024*1024*1024.0) as TOT_gb, \
       name \
       from innodb_sys_tablestats where name like "tpcc%"' > o.$sfx.build.tablesize

  cd /opt/HammerDB-5.0
  mv /home/mdcallag/d/$dbms/o.$sfx.* .

  # let hardware and DBMS cool off
  sleep 300

  echo "Run at $( date )"
  HAMMER_RUN_VU=$run_vu HAMMER_WAREHOUSE=$warehouse HAMMER_RAMPUP=$rampup HAMMER_DURATION=$duration \
      ./hammerdbcli auto testscripts/mariarunN.tcl > o.$sfx.run.out 2> o.$sfx.run.err &
  hpid=$!

  # don't collect vmstat and iostat during rampup
  sleep $( 60 * $rampup )

  vmstat 1 10000000 >& o.$sfx.run.vm &
  vmpid=$!
  iostat -y -kx 1 10000000 >& o.$sfx.run.io &
  iopid=$!

  if [[ $doperf -eq 1 ]]; then
    echo Collecting perf
    dbbpid=$( ps aux | grep mariadbd | grep -v mariadbd-safe | grep -v \/usr\/bin\/time | grep -v timeout | grep -v grep | awk '{ print $2 }' )
    if [ -z $dbbpid ]; then
      echo Cannot get MariaDB PID
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
       from innodb_sys_tablestats where name like "tpcc%"' > o.$sfx.run.tablesize

  rm -f o.$sfx.createtable
  for t in customer district history item new_order order_line orders stock warehouse ; do
    bin/mysql -uroot -ppw tpcc -e "show create table $t" -E >> o.$sfx.createtable
    echo >> o.$sfx.createtable
  done

  bash down.sh >& o.$sfx.down
  cd /opt/HammerDB-5.0
  mv /home/mdcallag/d/$dbms/o.$sfx.* .
done
