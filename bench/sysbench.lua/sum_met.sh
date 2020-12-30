pfx=$1 bdir=$2
dop=$3

shift 3

for f in $( ls -rt $bdir/${pfx}.*dop${dop} | grep -v point-query.warm ); do
  basef=$( basename $f )
  echo $basef

  echo "--- absolute"
  printf "cpu/o\t\trKB/o\twKB/o\to/s\tdbms\n"
  cat $f | awk '{ if (NR == 6) { printf "%s\t", $5 } }'
  cat $f | awk '{ if (NR == 3) { printf "%s\t%s\t%.0f\t%s\n", $7, $8, $9, bdir } }' bdir=$bdir

  for odir in "$@"; do
    cat $odir/$basef | awk '{ if (NR == 6) { printf "%s\t", $5 } }'
    cat $odir/$basef | awk '{ if (NR == 3) { printf "%s\t%s\t%.0f\t%s\n", $7, $8, $9, odir } }' odir=$odir
  done

  echo "--- relative to first result"
  #printf "cpu/o\t\trKB/o\twKB/o\to/s\tdbms\n"

  b1=$( cat $f | awk '{ if (NR == 6) { printf "%s", $5 } }' )
  b2=$( cat $f | awk '{ if (NR == 3) { printf "%s", $7 } }' )
  b3=$( cat $f | awk '{ if (NR == 3) { printf "%s", $8 } }' )
  b4=$( cat $f | awk '{ if (NR == 3) { printf "%.0f", $9 } }' )

  for odir in "$@"; do
    o1=$( cat $odir/$basef | awk '{ if (NR == 6) { printf "%s", $5 } }' )
    o2=$( cat $odir/$basef | awk '{ if (NR == 3) { printf "%s", $7 } }' )
    o3=$( cat $odir/$basef | awk '{ if (NR == 3) { printf "%s", $8 } }' )
    o4=$( cat $odir/$basef | awk '{ if (NR == 3) { printf "%.0f", $9 } }' )

    r1=$( echo $o1 $b1 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )
    r2=$( echo $o2 $b2 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )
    r3=$( echo $o3 $b3 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )
    r4=$( echo $o4 $b4 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )

    printf "%s\t\t%s\t%s\t%s\t%s\n" $r1 $r2 $r3 $r4 $odir
  done

  echo ""
done

