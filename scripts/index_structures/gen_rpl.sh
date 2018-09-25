max_level=$1
db_gb=$2
wb_mb=$3
format=$4

# bash run_rpl.sh 8 1024 64 tsv
# grep Nruns xa.tsv.ZL2 > o1.tsv; grep -h ^Z x1.tsv.Z* | tr -d 'Z' >> o1.tsv
# bash sort_all_rpl.sh o1.tsv 100 tsv

#
# This runs lsm_rpl_rws.py for a variety of configuations including
#  * leveled with 1 run per level
#  * leveled with N runs per level
#  * tiered with 2 to 8 runs per level at Lmax
#  * tiered on the smaller levels, leveled on the larger levels
#  * tiered on the smaller levels, leveled on the larger levels with leveled-N 
#

fmt=""
pf0=xa.tsv
pf1=x1.tsv

if [[ $format == "csv" ]]; then
fmt="--csv"
pf0=xa.csv
pf1=x1.csv
fi

db_mb=$(( db_gb * 1024 ))

total_fanout=$( printf "%.1f" $( echo "$db_mb / $wb_mb" | bc ) )
echo total fanout is $total_fanout

function expand_leveled {
  max_lv=$1
  max_lvn=$2
  level_fo=$3
  rpl=$4
  label=$5
  family=$6

  # echo leveled max_lv=$max_lv max_lvn=$max_lvn total_fo=$total_fanout level_fo=$level_fo label=$label

  level_cnf=""
  for x in $( seq 1 $max_lv ); do
    if [[ $x -gt 1 ]]; then level_cnf+=","; fi
    if [[ $x -le $max_lvn ]]; then
      level_cnf+="l:$level_fo:$rpl"
    else
      level_cnf+="l:$level_fo:1"
    fi
  done

  echo lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --label=$label --family=$family
  python lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --label=$label --family=$family $fmt > $pf0.$label
  grep $label $pf0.$label > $pf1.$label
}

function expand_tiered {
  maxt=$1
  level_fo=$2
  max_level_rpl=$3
  rpl_lo=$4
  rpl_hi=$5

  label=ZT${maxt}_${max_level_rpl}
 
  # echo expand_tiered with $maxt maxt, $level_fo level_fo, $max_level_rpl max_level_rpl, $rpl_lo lo, $rpl_hi hi

  level_cnf=""
  prev_rpl=1

  for x in $( seq 1 $maxt ); do

    if [ $x -lt $rpl_lo ]; then
      rpl=$(( $level_fo + 1 ))
    elif [ $x -gt $rpl_hi ]; then
      rpl=$(( $level_fo - 1 ))
    else
      rpl=$level_fo
    fi

    if [[ $x -gt 1 ]]; then level_cnf+=","; fi

    if   [[ $x -eq 1 ]]; then
      level_cnf+="t:1:$rpl"
    elif [[ $x -lt $maxt ]]; then
      level_cnf+="t:$prev_rpl:$rpl"
    else
      level_cnf+="t:$prev_rpl:$max_level_rpl"
    fi

    prev_rpl=$rpl
  done

  echo lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --label=$label --family=T
  python lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --label=$label --family=T $fmt > $pf0.$label
  grep $label $pf0.$label > $pf1.$label
}

function expand_tiered_leveled {
  lvls=$1
  last_t=$2
  first_l=$3
  tiered_fo=$4
  leveled_fo=$5
  last_ln=$6
  ln_rpl=$7
  family=$8

  # echo expand_tiered_leveled with $lvls lvls, $last_t last_t, $first_l first_l, $tiered_fo tiered_fo, $leveled_fo leveled_fo, $last_ln last_ln, $ln_rpl ln_rpl

  label=ZTL${lvls}_${last_t}_${last_ln}_${ln_rpl}
  level_cnf=""

  for x in $( seq 1 $lvls ); do

    if [[ $x -gt 1 ]]; then level_cnf+=","; fi

    if [[ $x -eq 1 ]]; then
      if [[ $x -lt $last_t ]]; then
        level_cnf+="t:1:$tiered_fo"
      else
        level_cnf+="t:1:$(( $tiered_fo / 2 ))"
      fi
    elif [[ $x -lt $last_t ]]; then
      level_cnf+="t:$tiered_fo:$tiered_fo"
    elif [[ $x -lt $first_l ]]; then
      tfo=$(( $tiered_fo / 2 ))
      level_cnf+="t:$tiered_fo:$(( $tiered_fo / 2 ))"
    elif [[ $x -le $last_ln ]]; then
      level_cnf+="l:$leveled_fo:$ln_rpl"
    else
      level_cnf+="l:$leveled_fo:1"
    fi

  done

  echo lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --label=$label --family=$family
  python lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --label=$label --family=$family $fmt > $pf0.$label
  grep $label $pf0.$label > $pf1.$label
}

function compute_fanout_prod {
  level_fo=$1
  maxt=$2
  rpl_lo=$3
  rpl_hi=$4

  prod=1

  # rpl in Ln-1 determines fanout in Ln
  # fanout in L1 is always 1 for tiered, so there are N-1 levels
  # over which fanout product is computed when Lmax == N.
  for x in $( seq 1 $(( $maxt - 1 )) ); do
    if [ $x -lt $rpl_lo ]; then
      prod=$(( $prod * ($level_fo + 1) ))
    elif [ $x -gt $rpl_hi ]; then
      prod=$(( $prod * ($level_fo - 1) ))
    else
      prod=$(( $prod * $level_fo ))
    fi
  done

  echo $prod
}

# expand: l+ using 1 run per level
for max_lv in $( seq 2 $max_level ); do
  # per-level fanout is nth root of total fanout
  level_fo=$( printf "%.3f" $( echo "e(l($total_fanout) / $max_lv)" | bc -l ) )
  label="ZL${max_lv}"
  expand_leveled $max_lv 0 $level_fo 1 $label L
done

# expand: l+ using 2..8 runs per level
for max_lv in $( seq 2 $max_level ); do
  # per-level fanout is nth root of total fanout
  level_fo=$( printf "%.3f" $( echo "e(l($total_fanout) / $max_lv)" | bc -l ) )
  # the max number of runs-per-level for leveled-N is < (level fanout / 2)
  x=$( printf "%.0f" $level_fo )
  max_rpl=$(( ($x / 2) - 1 ))
  # Limit to at most 8 runs-per-level
  if [[ $max_rpl -gt 8 ]]; then max_rpl=8; fi

  #echo expand_leveled-N with $max_lv max_lv, $level_fo level_fo, $rpl rpl

  for max_lvn in $( seq 1 $max_lv ); do
    for rpl in $( seq 2 $max_rpl ); do
      label="ZLN${max_lv}_${max_lvn}_${rpl}"
      # echo leveled-N: $max_lv max_lv, $max_lvn max_lvn, $rpl rpl, $level_fo fanout, $label label
      expand_leveled $max_lv $max_lvn $level_fo $rpl $label LN
    done
  done
done

# expand: t+
for maxt in $( seq 2 $max_level ); do
  rpl_lo=1
  rpl_hi=$(( $maxt - 1 ))

  if [[ $maxt -gt 2 ]]; then
    # per-level fanout is nth root of total fanout
    level_fo=$( printf "%.0f" $( echo "e(l($total_fanout) / ($maxt - 1))" | bc -l ) )
    fo_prod=$( echo "$level_fo ^ ($maxt - 1)" | bc )
    # The per-level fanout is a float, but runs-per-level is an int. Product of per-level
    # fanouts will ~= total fanout but product of rpl might not because of rounding. If they
    # are within 10% then python script will adjust size of memtable to make things right.
    # Here we make them within 10% by either increasing rpl for smaller levels or decreasing
    # it for larger levels.
    fo_ratio=$( printf "%.0f" $( echo "($total_fanout / $fo_prod) * 100" | bc -l ))
    echo fo_ratio starts at $fo_ratio
    while [[ $fo_ratio -ge 110 ]]; do
      rpl_lo=$(( $rpl_lo + 1 ))
      if [ $rpl_lo -ge $maxt ]; then
        echo "Cannot fit fanout for $total_fanout total_fo, $fo_prod fanout_prod, $maxt max level"
        break
      fi
      prod=$( compute_fanout_prod $level_fo $maxt $rpl_lo $rpl_hi )
      fo_ratio=$( printf "%.0f" $( echo "($total_fanout / $prod) * 100" | bc -l ))
      echo fo_ratio reduced to $fo_ratio
    done
    while [[ $fo_ratio -le 90 ]]; do
      rpl_hi=$(( $rpl_hi - 1 ))
      if [ $rpl_hi -lt 1 ]; then
        echo "Cannot fit fanout for $total_fanout total_fo, $fo_prod fanout_prod, $maxt max level"
        break
      fi
      prod=$( compute_fanout_prod $level_fo $maxt $rpl_lo $rpl_hi )
      fo_ratio=$( printf "%.0f" $( echo "($total_fanout / $prod) * 100" | bc -l ))
      echo fo_ratio increased to $fo_ratio
    done
  else
    level_fo=$( printf "%.0f" $total_fanout )
    fo_prod=$total_fanout
  fi

  mr=8
  if [[ $mr -gt $level_fo ]]; then
    mr=$level_fo
  fi
  for max_level_rpl in $( seq 2 $mr ); do
    # echo et $total_fanout total_fo, $level_fo level_fo, $fo_prod fo_prod, $fo_ratio fo_ratio, $rpl_lo lo, $rpl_hi hi, $maxt maxt
    expand_tiered $maxt $level_fo $max_level_rpl $rpl_lo $rpl_hi 
  done
done

# expand: t+ l+
for lvls in $( seq 2 $max_level ); do
  # fanout from L0 to L1 is 1, so per-level fanout computed using 1 less level
  # this is the per-level fanout for the tiered levels after l1, it must be an integer
  tiered_fo=$( printf "%.0f" $( echo "e(l($total_fanout) / ($lvls - 1))" | bc -l ) )

  for first_l in $( seq 2 $lvls ); do
    last_t=$(( $first_l - 1 ))

    # this is the per-level fanout for the leveled levels, it doesn't have to be an integer
    total_tiered_fo=1
    if [[ $first_l -gt 2 ]]; then
      total_tiered_fo=$( echo "$tiered_fo ^ ($first_l - 2)" | bc )
    fi
    # echo ttf $total_tiered_fo, tfo $tiered_fo, last_t $last_t
    leveled_fo=$( printf "%.3f" $( echo "e(l($total_fanout / $total_tiered_fo) / ($lvls - $first_l + 1))" | bc -l ) )

    # echo $total_fanout total_fo, $tiered_fo tiered_fo, $leveled_fo leveled_fo, $lvls levels, $last_t last_t, $first_l first_l
    expand_tiered_leveled $lvls $last_t $first_l $tiered_fo $leveled_fo 0 0 TL

    # the max number of runs-per-level for leveled-N is < (level fanout / 2)
    x=$( printf "%.0f" $leveled_fo )
    max_rpl=$(( ($x / 2) - 1 ))
    # Limit to at most 8 runs-per-level
    if [[ $max_rpl -gt 8 ]]; then max_rpl=8; fi

    if [[ $first_l -lt $lvls ]]; then
      for last_ln in $( seq $first_l $(( $lvls - 1 )) ) ; do
        if [[ $max_rpl -ge 2 ]]; then
          for rpl in $( seq 2 $max_rpl ); do
            expand_tiered_leveled $lvls $last_t $first_l $tiered_fo $leveled_fo $last_ln $rpl TLN
          done
        fi
      done
    fi

  done
done

grep Nruns xa.tsv.ZL2 > o1; grep -h ^Z x1.tsv.Z* >> o1
