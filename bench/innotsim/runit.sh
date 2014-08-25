retry_after_reserve=${1}
max_spinners=${2}

spinr=30
spind=6

function runme {
  thinkd=${1}
  tloops=${2}
  nmux=${3}

  for y in inno posixadapt posixtimed posixspin posixgnspin posixlnspin ; do
    vmstat 1 >& o.vm.t${thinkd}.$y.mux${nmux} &
    vpid=$!
    for nthr in 1 2 4 8 16 20 24 32 40 48 80 128 256 512 1024 ; do
      nloops=$(( $tloops / $nthr ))
      nloops=$(( $nloops * $nmux ))
      echo nthr $nthr $y think $thinkd nmux $nmux
      echo ./innotsim  $nthr $nloops $thinkd $spinr $spind $y $nmux $retry_after_reserve $max_spinners 
      time ./innotsim  $nthr $nloops $thinkd $spinr $spind $y $nmux $retry_after_reserve $max_spinners > o.t${thinkd}.thr${nthr}.$y.mux${nmux}
      # echo $nthr $nloops $y $( tail -1 o.t${thinkd}.thr${nthr}.$y.mux${nmux} )
    done
    kill $vpid
  done
}

function printme {
  thinkd=${1}
  nmux=${2}

  rm -f all.t${thinkd}.mux${nmux}
  for nthr in 1 2 4 8 16 20 24 32 40 48 80 128 256 512 1024 ; do
    echo $nthr | tee -a all.t${thinkd}.mux${nmux}
    for y in inno posixadapt posixtimed posixspin posixgnspin posixlnspin ; do
      tail -1 o.t${thinkd}.thr${nthr}.$y.mux${nmux} | tee -a all.t${thinkd}.mux${nmux}
    done
  done

  awk '{ if (NF==1) { printf "\n%s", $1 }} { if (NF==5) { printf ",%d", $2 } }' all.t${thinkd}.mux${nmux} > sumt${thinkd}mux${nmux}.txt
}

#runme      0 50000000 1
#printme    0 1
#runme     20 10000000 1
#printme   20 1
#runme    100  2000000 1
#printme  100 1
#runme   1000   200000 1
#printme 1000 1

echo 0 wait
runme      0 100000000 1
printme    0 1
runme      0 100000000 2
printme    0 2
runme      0 100000000 4
printme    0 4
runme      0 100000000 8
printme    0 8
runme      0 100000000 16
printme    0 16

echo 20 wait
runme     20 20000000 1
printme   20 1
runme     20 20000000 2
printme   20 2
runme     20 20000000 4
printme   20 4
runme     20 20000000 8
printme   20 8
runme     20 20000000 16
printme   20 16

echo 100 wait
runme    100  4000000 1
printme  100 1
runme    100  4000000 2
printme  100 2
runme    100  4000000 4
printme  100 4
runme    100  4000000 8
printme  100 8
runme    100  4000000 16
printme  100 16

echo 1000 wait
runme   1000  4000000 1
printme 1000 1
runme   1000  4000000 2
printme 1000 2
runme   1000  4000000 4
printme 1000 4
runme   1000  4000000 8
printme 1000 8
runme   1000  4000000 16
printme 1000 16


