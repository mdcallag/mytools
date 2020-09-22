m=$1
dop=$2

bdir=$( dirname $0 )

for x in mo44 mo42 mo40 mo in pg rx pg.in.rx mo44.pg mo44.in mo44.pg.in ; do
  bash $bdir/plot.sh 200 50 ${dop}u.$x $dop ${m}m n 1.2 $( cat pl.$x )
  mv do.gp do.gp.$x
  gnuplot do.gp.$x
  rm -rf pl.$x.r
  mkdir pl.$x.r
  mv ${dop}u.$x.* pl.$x.r
done
