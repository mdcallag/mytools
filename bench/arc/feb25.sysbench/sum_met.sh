# Can be run like:
#   bash ../sum_met.sh sb.met x.fbmy5635.y9a.pk1 1 x.fbmy5635.y9b.pk1 x.fbmy5635.y9c.pk1
# where
#   processes files that start with "sb.met"
#   uses results from x.fbmy5635.y9a.pk1 as the base
#   assumes tests were run with dop=1
#   compares the base with results in x.fbmy5635.y9[bc].pk1

pfx=$1
bdir=$2
dop=$3

shift 3

# sb.met.* files look like this
#
#iostat, vmstat normalized by operation rate
#samp    r/s     rMB/s   w/s     wMB/s   r/o     rKB/o   wKB/o   o/s
#305     0.0     0.0     0.0     0.0     0.000   0.000   0.000   149562.68
#
#samp    cs/s    cpu/s   cs/o    cpu/o
#319     567738  67.1    3.796   0.000449

function work() {
  f=$1
  shift 1

  basef=$( basename $f )
  echo $basef

  echo "--- absolute"
  printf "cpu/o\t\tcs/o\tr/o\trKB/o\twKB/o\to/s\tdbms\n"
  cat $f | awk '{ if (NR == 6) { printf "%s\t%s\t", $5, $4 } }'
  cat $f | awk '{ if (NR == 3) { printf "%.6g\t%.6g\t%.6g\t%.0f\t%s\n", $6, $7, $8, $9, bdir } }' bdir=$bdir

  for odir in "$@"; do
    #echo TODO f :: $f :: and basef :: $basef :: and odir :: $odir ::
    cat $odir/$basef | awk '{ if (NR == 6) { printf "%s\t%s\t", $5, $4 } }'
    cat $odir/$basef | awk '{ if (NR == 3) { printf "%.6g\t%.6g\t%.6g\t%.0f\t%s\n", $6, $7, $8, $9, odir } }' odir=$odir
  done

  echo "--- relative to first result"
  #printf "cpu/o\t\tcs/o\trKB/o\twKB/o\to/s\tdbms\n"

  b1=$( cat $f | awk '{ if (NR == 6) { printf "%s", $5 } }' )
  b2=$( cat $f | awk '{ if (NR == 6) { printf "%s", $4 } }' )
  b3=$( cat $f | awk '{ if (NR == 3) { printf "%s", $6 } }' )
  b4=$( cat $f | awk '{ if (NR == 3) { printf "%s", $7 } }' )
  b5=$( cat $f | awk '{ if (NR == 3) { printf "%s", $8 } }' )
  b6=$( cat $f | awk '{ if (NR == 3) { printf "%.0f", $9 } }' )

  for odir in "$@"; do
    o1=$( cat $odir/$basef | awk '{ if (NR == 6) { printf "%s", $5 } }' )
    o2=$( cat $odir/$basef | awk '{ if (NR == 6) { printf "%s", $4 } }' )
    o3=$( cat $odir/$basef | awk '{ if (NR == 3) { printf "%s", $6 } }' )
    o4=$( cat $odir/$basef | awk '{ if (NR == 3) { printf "%s", $7 } }' )
    o5=$( cat $odir/$basef | awk '{ if (NR == 3) { printf "%s", $8 } }' )
    o6=$( cat $odir/$basef | awk '{ if (NR == 3) { printf "%.0f", $9 } }' )

    r1=$( echo $o1 $b1 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )
    r2=$( echo $o2 $b2 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )
    r3=$( echo $o3 $b3 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )
    r4=$( echo $o4 $b4 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )
    r5=$( echo $o5 $b5 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )
    r6=$( echo $o6 $b6 | awk '{ if ($1 == 0 && $2 == 0) { print "1" } else if ($2 == 0) { print "inf" } else { printf "%.2f", $1/$2 }}' )

    printf "%s\t\t%s\t%s\t%s\t%s\t%s\t%s\n" $r1 $r2 $r3 $r4 $r5 $r6 $odir
  done

  echo ""
}

# there should only be one such file, so this loop isn't required
for f in $( ls -rt $bdir/sb.prepare.met.* ); do
  work $f "$@"
done

for f in $( ls -rt $bdir/${pfx}.*dop${dop} | grep -v point-query.warm | grep -v scan ); do
  work $f "$@"
done

for f in $( ls -rt $bdir/${pfx}.*scan*  ); do
  work $f "$@"
done

