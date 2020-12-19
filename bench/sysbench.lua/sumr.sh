pfx=$1
bdir=$2
ncols=$3

shift 3

for f in $( ls -rt $bdir/${pfx}.* ); do
  basef=$( basename $f )
  echo $basef

  cat $f | cut -f 1-${ncols} | awk '{ printf "%s\t%s\n", $0, bdir }' bdir=$bdir

  for odir in "$@"; do
    cat $odir/$basef | cut -f 1-${ncols} | awk '{ printf "%s\t%s\n", $0, odir }' odir=$odir
  done

done

