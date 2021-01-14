pfx=$1
bdir=$2
ncols=$3
ratio=$4

shift 4

# first process the prepare step (load). There should only be 1 file, but the "for" loop was inherited from below
for f in $( ls -rt $bdir/sb.prepare.o.* ) ; do
  basef=$( basename $f )
  echo $basef

  if [[ $ratio -eq 0 ]]; then
    grep "Load seconds" $f | awk '{ printf "%s\t%s\n", $10, bdir }' bdir=$bdir
    for odir in "$@"; do
      grep "Load seconds" $odir/$basef | awk '{ printf "%s\t%s\n", $10, odir }' odir=$odir
    done

  else
    baseVal=$( grep "Load seconds" $f | awk '{ print $10 }' )

    for odir in "$@"; do
      myVal=$( grep "Load seconds" $odir/$basef | awk '{ print $10 }' )
      echo $myVal $baseVal | awk '{ printf "%.2f\t", $1 / $2 }'
      echo $odir
    done
  fi

  echo ""

done

# then process the run steps
for f in $( ls -rt $bdir/${pfx}.* | grep -v point-query.warm ); do
  basef=$( basename $f )
  echo $basef

  # scan only has one column
  isScan=$( echo $f | grep .scan. | wc -l )
  if [[ $isScan -eq 1 ]]; then
    ucols=1
  else
    ucols=$ncols
  fi

  if [[ $ratio -eq 0 ]]; then
    cat $f | cut -f 1-${ucols} | awk '{ printf "%s\t%s\n", $0, bdir }' bdir=$bdir
    for odir in "$@"; do
      cat $odir/$basef | cut -f 1-${ucols} | awk '{ printf "%s\t%s\n", $0, odir }' odir=$odir
    done

  else
    baseCols=()
    for colno in $( seq 1 $ucols ); do
      baseCols[$colno]=$( cat $f | cut -f 1-${ucols} | awk '{ print $cno }' cno=$colno )
    done
    for odir in "$@"; do
      for colno in $( seq 1 $ucols ); do
        myCol=$( cat $odir/$basef | cut -f 1-${ucols} | awk '{ print $cno }' cno=$colno )
        echo $myCol ${baseCols[$colno]} | awk '{ if ($1 == 0 && $2 == 0) { print "1\t" } else if ($2 == 0) { print "inf\t" } else { printf "%.2f\t", $1/$2 }}'
      done
      echo $odir
    done
  fi

  echo ""

done

