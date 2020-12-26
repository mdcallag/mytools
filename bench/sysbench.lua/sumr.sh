pfx=$1
bdir=$2
ncols=$3
ratio=$4

shift 4

for f in $( ls -rt $bdir/${pfx}.* | grep -v point-query.warm ); do
  basef=$( basename $f )
  echo $basef

  if [[ $ratio -eq 0 ]]; then
    cat $f | cut -f 1-${ncols} | awk '{ printf "%s\t%s\n", $0, bdir }' bdir=$bdir
    for odir in "$@"; do
      cat $odir/$basef | cut -f 1-${ncols} | awk '{ printf "%s\t%s\n", $0, odir }' odir=$odir
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

