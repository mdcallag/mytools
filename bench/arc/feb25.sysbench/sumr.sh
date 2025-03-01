pfx=$1
bdir=$2
ncols=$3
ratio=$4

shift 4

# Print the result directories, one per line
echo -e "db_1 =\t$bdir"
x=2
for odir in "$@"; do
  echo -e "db_${x} =\t$odir"
  x=$(( $x + 1 ))
done
echo

# Print the header -- result directories on one line
echo -n db_1
x=2
for odir in "$@"; do
  echo -e -n "\tdb_${x}"
  x=$(( $x + 1 ))
done
echo

# first process the prepare step (load). There should only be 1 file, but the "for" loop was inherited from below
for f in $( ls -rt $bdir/sb.prepare.o.* ) ; do
  basef=$( basename $f )

  if [[ $ratio -eq 0 ]]; then
    grep "Load seconds" $f | awk '{ printf "%s", $10 }'
    for odir in "$@"; do
      grep "Load seconds" $odir/$basef | awk '{ printf "\t%s", $10 }'
    done

  else
    baseVal=$( grep "Load seconds" $f | awk '{ printf "%s", $10 }' )
    echo -n -e "1.00"

    for odir in "$@"; do
      myVal=$( grep "Load seconds" $odir/$basef | awk '{ print $10 }' )
      echo $myVal $baseVal | awk '{ printf "\t%.2f", $1 / $2 }'
      # echo $odir
    done
  fi

  echo -e "\t$basef"

done

# then process the run steps
for f in $( ls -rt $bdir/${pfx}.* | grep -v point-query.warm ); do
  basef=$( basename $f )

  # scan only has one column
  isScan=$( echo $f | grep .scan. | wc -l )
  if [[ $isScan -eq 1 ]]; then
    ucols=1
  else
    ucols=$ncols
  fi

  if [[ $ratio -eq 0 ]]; then
    cat $f | cut -f 1-${ucols} | awk '{ printf "%s", $0 }'
    for odir in "$@"; do
      cat $odir/$basef | cut -f 1-${ucols} | awk '{ printf "\t%s", $0 }'
    done

  else
    baseCols=()
    for colno in $( seq 1 $ucols ); do
      baseCols[$colno]=$( cat $f | cut -f 1-${ucols} | awk '{ print $cno }' cno=$colno )
    done
    echo -n -e "1.00"
    for odir in "$@"; do
      for colno in $( seq 1 $ucols ); do
        myCol=$( cat $odir/$basef | cut -f 1-${ucols} | awk '{ printf "\t%s", $cno }' cno=$colno )
        echo $myCol ${baseCols[$colno]} | awk '{ if ($1 == 0 && $2 == 0) { printf "\t1" } else if ($2 == 0) { printf "\tinf" } else { printf "\t%.2f", $1/$2 }}'
      done
    done
  fi

  echo -e "\t$basef"

done

