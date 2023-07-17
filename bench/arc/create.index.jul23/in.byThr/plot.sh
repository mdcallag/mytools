# terminal height and width for ascii plots
th=$1
tw=$2
# prefix for result files
name=$3
dop=$4
# string to remove -- 80m, 320m etc
remove=$5
# y or n
logscale=$6
# scale factor for yrange
sf=$7

shift 7

bdir=$( dirname $0 )

farr=("$@")
f1=${farr[0]}

for y in l.i0 l.i1 q.L1.ips100 q.L2.ips500 q.L3.ips1000 ; do
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    grep -v iibench $f/$y/o.ib.dop${dop}.1 | grep -v max_q | awk '{ if (NF==12 || NF==10) { print $2, $3 }}' > $f/$y/gpi.ips
    grep -v iibench $f/$y/o.ib.dop${dop}.1 | grep -v max_q | awk '{ if (NF==12 || NF==10) { print $2, $5 }}' > $f/$y/gpi.qps
    grep -v iibench $f/$y/o.ib.dop${dop}.1 | grep -v max_q | awk '{ if (NF==12 || NF==10) { print $2, $7 }}' > $f/$y/gpi.imax
    grep -v iibench $f/$y/o.ib.dop${dop}.1 | grep -v max_q | awk '{ if (NF==12 || NF==10) { print $2, $8 }}' > $f/$y/gpi.qmax
  fi
done
done

echo "set xlabel \"Time(s)\"" > do.gp

if [ $logscale == "y" ]; then
  echo "set logscale y" >> do.gp
fi

lab=(IPS maxInsertUsecs QPS maxQueryUsecs)
inp=(ips imax qps qmax)

for y in l.i0 l.i1 q.L1.ips100 q.L2.ips500 q.L3.ips1000 ; do
for x in 0 1 2 3 ; do

  if [[ $x -gt 1 && ( $y == "l.i0" || $y == "l.i1" ) ]] ; then
    continue
  fi

  echo "set ylabel \"${lab[$x]}\"" >> do.gp
  echo "set title \"${lab[$x]} vs Time for $y\"" >> do.gp

  #if [[ ${inp[$x]} == "imax" || ${inp[$x]} == "qmax" ]]; then
  #  echo "set logscale y" >> do.gp
  #else
  #  echo "unset logscale y" >> do.gp
  #fi

  # echo "unset yrange" >> do.gp
  # get max value for y-axis
  maxy=$( for f in "$@"; do awk '{ print $2 }' $f/$y/gpi.${inp[$x]}; done | sort -rn | head -1 )
  maxy_adj=$( echo "scale=0; ( $maxy * $sf )/1.0" | bc )
  echo "set yrange [0:${maxy_adj}]" >> do.gp

  echo "set terminal dumb $th, $tw" >> do.gp
  echo "set output '${name}.$y.${inp[$x]}.txt'" >> do.gp
  printf "plot " >> do.gp
  for f in "$@"; do
    if [ $f != "BREAK" ]; then
      asx=$( echo $f | sed "s/${remove}\.//g" )
      printf "\"$f/$y/gpi.${inp[$x]}\" using 1:2 title \"$asx\", " >> do.gp
    fi
  done
  echo >> do.gp

  echo "set terminal png" >> do.gp
  echo "set output '${name}.$y.${inp[$x]}.png'" >> do.gp
  printf "plot " >> do.gp
  for f in "$@"; do
    if [ $f != "BREAK" ]; then
      asx=$( echo $f | sed "s/${remove}\.//g" )
      printf "\"$f/$y/gpi.${inp[$x]}\" using 1:2 title \"$asx\", " >> do.gp
    fi
  done
  echo >> do.gp
done
done

