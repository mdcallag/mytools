pfx=$1
bdir=$2
dop=$3
ratio=$4

shift 4

for f in $( ls -rt $bdir/${pfx}.*dop${dop} | grep -v point-query.warm ); do
  basef=$( basename $f )
  echo $basef

  if [[ $ratio -eq 0 ]]; then
    printf "cpu/o\t\trKB/o\twKB/o\to/s\tdbms\n"
    cat $f | awk '{ if (NR == 6) { printf "%s\t", $5 } }'
    cat $f | awk '{ if (NR == 3) { printf "%s\t%s\t%.0f\t%s\n", $7, $8, $9, bdir } }' bdir=$bdir

    for odir in "$@"; do
      cat $odir/$basef | awk '{ if (NR == 6) { printf "%s\t", $5 } }'
      cat $odir/$basef | awk '{ if (NR == 3) { printf "%s\t%s\t%.0f\t%s\n", $7, $8, $9, odir } }' odir=$odir
    done

  else
    baseCols=()
    for colno in $( seq 1 $ncols ); do
      baseCols[$colno]=$( cat $f | cut -f 1-${ncols} | awk '{ print $cno }' bdir=$bdir cno=$colno )
    done
    for odir in "$@"; do
      for colno in $( seq 1 $ncols ); do
        myCol=$( cat $odir/$basef | cut -f 1-${ncols} | awk '{ print $cno }' odir=$odir cno=$colno )
        # echo base ${baseCols[$colno]} my $myCol for col $colno
        echo $myCol ${baseCols[$colno]} | awk '{ printf "%.2f\t", $1 / $2 }'
      done
      cat $odir/$basef | cut -f ${ncols}- | awk '{ printf "%s\n", $0 }'
    done
  fi

  echo ""

done

