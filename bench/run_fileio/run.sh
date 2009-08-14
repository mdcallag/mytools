# max value for --num-threads
maxdop=$1

file_num=$2
file_total_size=$3

# rndrd rndwr rndrw seqrd seqwr
file_test_mode=$4

# direct, ""
file_extra_flags=$5

max_time=$6

sbargs="--test=fileio --file-num=$file_num --file-total-size=$file_total_size \
        --file-test-mode=$file_test_mode --file-extra-flags=$file_extra_flags"

rm -f test_file.*

rm -f fi.o.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags}
rm -f fi.r.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags}
touch fi.o.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags}

dop=1
while [[ $dop -le $maxdop ]]; do
  echo prepare $dop
  echo "sysbench $sbargs prepare" >> \
      fi.o.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags}
  ../sysbench $sbargs prepare >> \
      fi.o.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags}

  echo run $dop
  echo "sysbench $sbargs --num-threads=$dop --max-time=$max_time run" >> \
      fi.o.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags}
  ../sysbench $sbargs --num-threads=$dop --max-time=$max_time run >> \
      fi.o.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags}
  dop=$(( $dop * 2 ))
done

grep "Requests/sec executed" fi.o.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags} | \
   awk '{ printf "%s ", $1 }' >> \
       fi.r.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags}
echo >> fi.r.fn_${file_num}.fts_${file_total_size}.ftm_${file_test_mode}.fef_${file_extra_flags}
