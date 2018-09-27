max_level=$1
db_gb=$2
wb_mb=$3
format=$4

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
allo=o1.tsv

if [[ $format == "csv" ]]; then
fmt="--csv"
pf0=xa.csv
pf1=x1.csv
allo=o1.csv
fi

db_mb=$(( db_gb * 1024 ))

total_fanout=$( printf "%.1f" $( echo "$db_mb / $wb_mb" | bc ) )
echo total fanout is $total_fanout

function expand_leveled {
  max_lv=$1
  max_lvn=$2
  level_fo=$3
  leveln_fo=$4
  rpl=$5
  family=$6
  label=$7

  # echo leveled max_lv=$max_lv max_lvn=$max_lvn total_fo=$total_fanout level_fo=$level_fo 

  level_cnf=""
  for x in $( seq 1 $max_lv ); do
    if [[ $x -gt 1 ]]; then level_cnf+="-"; fi
    if [[ $x -eq 1 ]]; then
      level_cnf+="l:$level_fo:$rpl"
    elif [[ $x -le $max_lvn ]]; then
      level_cnf+="l:$leveln_fo:$rpl"
    elif [[ $x -eq $(( $max_lvn + 1 )) ]]; then
      level_cnf+="l:$leveln_fo:1"
    else
      level_cnf+="l:$level_fo:1"
    fi
  done

  echo lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --family=$family --label=$label $fmt
  sfx=$family.$label.$level_cnf
  python lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --family=$family --label=$label $fmt > $pf0.$sfx
  tail -1 $pf0.$sfx > $pf1.$sfx
  tail -1 $pf0.$sfx >> $allo
}

function expand_tiered {
  maxt=$1
  level_fo=$2
  max_level_rpl=$3
  rpl_lo=$4
  rpl_hi=$5
  label=$6

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

    if [[ $x -gt 1 ]]; then level_cnf+="-"; fi

    if   [[ $x -eq 1 ]]; then
      level_cnf+="t:1:$rpl"
    elif [[ $x -lt $maxt ]]; then
      level_cnf+="t:$prev_rpl:$rpl"
    else
      level_cnf+="t:$prev_rpl:$max_level_rpl"
    fi

    prev_rpl=$rpl
  done

  echo lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --family=T --label=$label $fmt
  sfx=$family.$label.$level_cnf
  python lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --family=T $fmt > $pf0.$sfx
  tail -1 $pf0.$sfx > $pf1.$sfx
  tail -1 $pf0.$sfx >> $allo
}

function expand_tiered_leveled {
  lvls=$1
  last_t=$2
  first_l=$3
  tiered_fo1=$4
  tiered_fo2=$5
  leveledn_fo=$6
  leveled_fo=$7
  last_ln=$8
  ln_rpl=$9
  family=${10}
  label=${11}

  echo expand_tiered_leveled with $lvls lvls, $last_t last_t, $first_l first_l, $tiered_fo1 : $tiered_fo2 tiered_fo, $leveledn_fo : $leveled_fo leveled_fo, $last_ln last_ln, $ln_rpl ln_rpl

  level_cnf=""

  for x in $( seq 1 $lvls ); do

    if [[ $x -gt 1 ]]; then level_cnf+="-"; fi

    if [[ $x -eq 1 ]]; then
      if [[ $x -eq $last_t ]]; then
        level_cnf+="t:1:$tiered_fo2"
      else  
        level_cnf+="t:1:$tiered_fo1"
      fi
    elif [[ $x -lt $last_t ]]; then
      level_cnf+="t:$tiered_fo1:$tiered_fo1"
    elif [[ $x -eq $last_t ]]; then
      level_cnf+="t:$tiered_fo1:$tiered_fo2"
    elif [[ $x -le $last_ln ]]; then
      level_cnf+="l:$leveledn_fo:$ln_rpl"
    elif [[ $x -eq $(( $last_ln + 1 )) ]]; then
      level_cnf+="l:$leveledn_fo:1"
    else
      level_cnf+="l:$leveled_fo:1"
    fi

  done

  echo lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --family=$family --label=$label $fmt
  sfx=$family.$label.$level_cnf
  python lsm_rpl_rws.py --level_config=$level_cnf --database_gb=$db_gb --memtable_mb=$wb_mb --family=$family --label=$label $fmt > $pf0.$sfx
  tail -1 $pf0.$sfx > $pf1.$sfx
  tail -1 $pf0.$sfx >> $allo
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
  expand_leveled $max_lv 0 $level_fo $level_fo 1 L L$max_lv
done

# expand: l+ using 2..8 runs per level but max level has 1 run
for max_lv in $( seq 2 $max_level ); do
  # per-level fanout is nth root of total fanout
  level_fo=$( printf "%.3f" $( echo "e(l($total_fanout) / $max_lv)" | bc -l ) )
  # the max number of runs-per-level for leveled-N is < (level fanout / 2)
  x=$( printf "%.0f" $level_fo )
  max_rpl=$(( ($x / 2) - 1 ))
  # Limit to at most 8 runs-per-level
  if [[ $max_rpl -gt 8 ]]; then max_rpl=8; fi

  #echo expand_leveled-N with $max_lv max_lv, $level_fo level_fo, $rpl rpl

  # first generate with same per-level fanout for all levels
  for max_lvn in $( seq 1 $(( $max_lv - 1 )) ); do
    for rpl in $( seq 2 $max_rpl ); do
      # echo leveled-N: $max_lv max_lv, $max_lvn max_lvn, $rpl rpl, $level_fo fanout
      expand_leveled $max_lv $max_lvn $level_fo $level_fo $rpl LN LNC${max_lvn}L${max_lv}
    done
  done

  # then generate with same write-amp per level -- more fanout when input level
  # has more than one run. This computes fanout that minimizes write-amp for level-N

  for max_lvn in $( seq 1 $(( $max_lv - 1 )) ); do
    for rpl in $( seq 2 $max_rpl ); do
      k=$( echo "$rpl ^ $max_lvn" | bc )
      level_fo=$( printf "%.3f" $( echo "e(l($total_fanout / $k) / $max_lv)" | bc -l ) )
      leveln_fo=$( printf "%.3f" $( echo "$rpl * $level_fo" | bc -l ) )
      echo $max_lvn max_lvn, $rpl rpl, $max_lv max_lv : $k $leveln_fo $level_fo
      # echo leveled-N: $max_lv max_lv, $max_lvn max_lvn, $rpl rpl, $level_fo fanout
      expand_leveled $max_lv $max_lvn $level_fo $leveln_fo $rpl LN LNA${max_lvn}L${max_lv}
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
    # expand_tiered $maxt $level_fo $max_level_rpl $rpl_lo $rpl_hi T$maxt
    echo skip expand_tiered
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
    expand_tiered_leveled $lvls $last_t $first_l $tiered_fo $tiered_fo $leveled_fo $leveled_fo 0 0 TL T${last_t}L${lvls}

    for n in 3 2 1; do
      divr=$(( ($tiered_fo * $n) / 4 ))
      if [[ $divr -ge 2 ]] ; then
        expand_tiered_leveled $lvls $last_t $first_l $tiered_fo $divr $leveled_fo $leveled_fo 0 0 TL T${last_t}L${lvls}
      fi
      ldivr=$divr
    done
    for m in 2 4 8; do
      if [[ $m -lt $ldivr ]]; then
        expand_tiered_leveled $lvls $last_t $first_l $tiered_fo $m $leveled_fo $leveled_fo 0 0 TL T${last_t}L${lvls}
      fi
    done

    # the max number of runs-per-level for leveled-N is < (level fanout / 2)
    x=$( printf "%.0f" $leveled_fo )
    max_rpl=$(( ($x / 2) - 1 ))
    # Limit to at most 8 runs-per-level
    if [[ $max_rpl -gt 8 ]]; then max_rpl=8; fi

    for adjust in 0 1 ; do
      if [[ $first_l -lt $lvls ]]; then
        for last_ln in $( seq $first_l $(( $lvls - 1 )) ) ; do
          if [[ $max_rpl -ge 2 ]]; then
            for rpl in $( seq 2 $max_rpl ); do
              if [[ $adjust -eq 1 ]]; then
                # Then use different fanouts so that leveled-N and leveled levels have same write-amp
                total_leveled_fo=$( printf "%.3f" $( echo "$total_fanout / $total_tiered_fo" | bc -l ) )
                nln=$(( $last_ln - $last_t + 1 ))
                nl=$(( $lvls - $last_ln - 1 ))
                k=$( echo "$rpl ^ $nln" | bc )
                l_fo=$( printf "%.3f" $( echo "e(l($total_leveled_fo / $k) / ($nln + $nl))" | bc -l ) )
                ln_fo=$( printf "%.3f" $( echo "$rpl * $l_fo" | bc -l ) )
                # echo foobar $rpl rpl, $total_leveled_fo tlfo, $nln nln, $nl nl, $k k, $l_fo l_fo, $ln_fo lnfo
              else
                l_fo=$leveled_fo
                ln_fo=$leveled_fo
              fi
              expand_tiered_leveled $lvls $last_t $first_l $tiered_fo $tiered_fo $ln_fo $l_fo $last_ln $rpl TLN T${last_t}LN${last_ln}L${lvls}X$adjust
              for n in 3 2 1; do
                 divr=$(( ($tiered_fo * $n) / 4 ))
                if [[ $divr -ge 2 ]] ; then
                  expand_tiered_leveled $lvls $last_t $first_l $tiered_fo $divr $ln_fo $l_fo $last_ln $rpl TLN T${last_t}LN${last_ln}L${lvls}X$adjust
                fi
                ldivr=$divr
              done
              for m in 2 4 8; do
                if [[ $m -lt $ldivr ]]; then
                  expand_tiered_leveled $lvls $last_t $first_l $tiered_fo $m $ln_fo $l_fo $last_ln $rpl TLN T${last_t}LN${last_ln}L${lvls}X$adjust
                fi
              done
            done
          fi
        done
      fi
    done
  done
done


