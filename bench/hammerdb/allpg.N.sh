
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

for d in \
x10b_${config_suffx} \
; do
  echo Run $d
  cd /home/mdcallag/d/pg180_o2nofp
  bash ini.sh $d >& o.ini.$d ; sleep 5
  cd /opt/HammerDB-5.0

  sfx=pg.$d

  echo "Build at $( date )"
  HAMMER_BUILD_VU=$build_vu HAMMER_WAREHOUSE=$warehouse \
      ./hammerdbcli auto testscripts/postgresbuildN.tcl > o.$sfx.build.out 2> o.$sfx.build.err 

  du -hs /data/m/* > o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/pg/* >> o.$sfx.build.df
  echo >> o.$sfx.build.df
  du -hs /data/m/pg/base/* >> o.$sfx.build.df

  cd /home/mdcallag/d/pg180_o2nofp
  rm -f o.$sfx.build.sizes
  for t in customer district history item new_order order_line orders stock warehouse ; do
    echo "Sizes: $t" >> o.$sfx.build.sizes
    bin/psql tpcc -c \
"select to_char(pg_table_size('$t'::regclass) / (1024 * 1024 * 1024.0), '9999.99') as GB_table, \
     to_char(pg_indexes_size('$t'::regclass) / (1024 * 1024 * 1024.0), '9999.99') as GB_indexes, \
     to_char(pg_total_relation_size('$t'::regclass) / (1024 * 1024 * 1024.0), '9999.99') as GB_total" >> o.$sfx.build.sizes
    echo >> o.$sfx.build.sizes
  done

  rm -f o.$sfx.build.frag
  for t in customer district history item new_order order_line orders stock warehouse ; do
    echo $t table >> o.$sfx.build.frag   
    bin/psql tpcc -c "SELECT * FROM pgstattuple('$t')" >> o.$sfx.build.frag
  done

  for t in customer district item new_order order_line orders stock warehouse ; do
    echo $t PK >> o.$sfx.build.frag   
    bin/psql tpcc -c "SELECT * FROM pgstatindex('${t}_i1')"  >> o.$sfx.build.frag
  done

  for t in customer orders ; do
    echo $t PK >> o.$sfx.build.frag   
    bin/psql tpcc -c "SELECT * FROM pgstatindex('${t}_i2')" >> o.$sfx.build.frag
  done

  cd /opt/HammerDB-5.0

  # let hardware and DBMS cool off
  sleep 300

  echo "Run at $( date )"
  HAMMER_RUN_VU=$run_vu HAMMER_WAREHOUSE=$warehouse HAMMER_RAMPUP=$rampup HAMMER_DURATION=$duration \
      ./hammerdbcli auto testscripts/postgresrunN.tcl > o.$sfx.run.out 2> o.$sfx.run.err &
  hpid=$!

  # don't collect vmstat and iostat during rampup
  sleep $( 60 * $rampup )

  vmstat 1 10000000 >& o.$sfx.run.vm &
  vmpid=$!
  iostat -y -kx 1 10000000 >& o.$sfx.run.io &
  iopid=$!

  if [[ $doperf -eq 1 ]]; then
    echo Collecting perf
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

  wait $hpid
  cat o.$sfx.run.out | grep "System achieved" 
  echo

  kill $vmpid
  kill $iopid

  du -hs /data/m/* > o.$sfx.run.df
  echo >> o.$sfx.run.df
  du -hs /data/m/pg/* >> o.$sfx.run.df
  echo >> o.$sfx.run.df
  du -hs /data/m/pg/base/* >> o.$sfx.run.df

  cp /home/mdcallag/d/pg180_o2nofp/logfile o.$sfx.logfile
  cd /home/mdcallag/d/pg180_o2nofp

  bin/psql tpcc -c 'show all' > o.$sfx.conf
  bin/psql tpcc -x -c 'select * from pg_stat_io' > o.$sfx.pgs.io
  bin/psql tpcc -x -c 'select * from pg_stat_bgwriter' > o.$sfx.pgs.bg
  bin/psql tpcc -x -c 'select * from pg_stat_database' > o.$sfx.pgs.db
  bin/psql tpcc -x -c "select * from pg_stat_all_tables where schemaname='public'" > o.$sfx.pgs.tabs
  bin/psql tpcc -x -c "select * from pg_stat_all_indexes where schemaname='public'" > o.$sfx.pgs.idxs
  bin/psql tpcc -x -c "select * from pg_statio_all_tables where schemaname='public'" > o.$sfx.pgi.tabs
  bin/psql tpcc -x -c "select * from pg_statio_all_indexes where schemaname='public'" > o.$sfx.pgi.idxs
  bin/psql tpcc -x -c 'select * from pg_statio_all_sequences' > o.$sfx.pgi.seq

  rm -f o.$sfx.createtable
  for t in customer district history item new_order order_line orders stock warehouse ; do
    bin/psql tpcc -x -c "\d+ $t" >> o.$sfx.createtable
    echo >> o.$sfx.createtable
  done

  rm -f o.$sfx.run.sizes
  for t in customer district history item new_order order_line orders stock warehouse ; do
    echo "Sizes: $t" >> o.$sfx.run.sizes
    bin/psql tpcc -c \
"select to_char(pg_table_size('$t'::regclass) / (1024 * 1024 * 1024.0), '9999.99') as GB_table, \
     to_char(pg_indexes_size('$t'::regclass) / (1024 * 1024 * 1024.0), '9999.99') as GB_indexes, \
     to_char(pg_total_relation_size('$t'::regclass) / (1024 * 1024 * 1024.0), '9999.99') as GB_total" >> o.$sfx.run.sizes
    echo >> o.$sfx.run.sizes
  done

  rm -f o.$sfx.run.frag
  for t in customer district history item new_order order_line orders stock warehouse ; do
    echo $t table >> o.$sfx.run.frag   
    bin/psql tpcc -c "SELECT * FROM pgstattuple('$t')" >> o.$sfx.run.frag
  done

  for t in customer district item new_order order_line orders stock warehouse ; do
    echo $t PK >> o.$sfx.run.frag   
    bin/psql tpcc -c "SELECT * FROM pgstatindex('${t}_i1')"  >> o.$sfx.run.frag
  done

  for t in customer orders ; do
    echo $t PK >> o.$sfx.run.frag   
    bin/psql tpcc -c "SELECT * FROM pgstatindex('${t}_i2')" >> o.$sfx.run.frag
  done

  bash down.sh >& o.down.$d
  cd /opt/HammerDB-5.0
  mv /home/mdcallag/d/pg180_o2nofp/o.$sfx.* .

done
