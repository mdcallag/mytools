th=$1
tw=$2
name=$3
dop=$4
remove=$5
logscale=$6

ns=3

shift 6

bdir=$( dirname $0 )

farr=("$@")
f1=${farr[0]}

for y in l q1000 q100 ; do
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    grep -v iibench $f/$y/o.ib.dop${dop}.ns${ns}.1 | grep -v seconds | awk '{ if (NF==9) { print $3, $6 }}' > $f/$y/gpi.6
    grep -v iibench $f/$y/o.ib.dop${dop}.ns${ns}.1 | grep -v seconds | awk '{ if (NF==9) { print $3, $9 }}' > $f/$y/gpi.9
  fi
done
done

echo "set xlabel \"Time(s)\"" > do.gp

if [ $logscale == "y" ]; then
  echo "set logscale y" >> do.gp
fi

# for inserts, gpi.6

for y in l q1000 q100 ; do
  echo "set ylabel \"IPS\"" >> do.gp
  echo "set title \"IPS vs Time for load\"" >> do.gp

  echo "set terminal dumb $th, $tw" >> do.gp
  echo "set output '${name}.$y.i.txt'" >> do.gp
  printf "plot " >> do.gp
  for f in "$@"; do
    if [ $f != "BREAK" ]; then
      asx=$( echo $f | sed "s/${remove}\.//g" )
      printf "\"$f/$y/gpi.6\" using 1:2 title \"$asx\", " >> do.gp
    fi
  done
  echo >> do.gp

  echo "set terminal png" >> do.gp
  echo "set output '${name}.$y.i.png'" >> do.gp
  printf "plot " >> do.gp
  for f in "$@"; do
    if [ $f != "BREAK" ]; then
      asx=$( echo $f | sed "s/${remove}\.//g" )
      printf "\"$f/$y/gpi.6\" using 1:2 title \"$asx\", " >> do.gp
    fi
  done
  echo >> do.gp
done

# for queries, gpi.9

for y in q1000 q100 ; do
  echo "set ylabel \"QPS\"" >> do.gp
  echo "set title \"QPS vs Time for workload $y\"" >> do.gp

  echo "set terminal dumb $th, $tw" >> do.gp
  echo "set output '${name}.$y.q.txt'" >> do.gp
  printf "plot " >> do.gp
  for f in "$@"; do
    if [ $f != "BREAK" ]; then
      asx=$( echo $f | sed "s/${remove}\.//g" )
      printf "\"$f/$y/gpi.9\" using 1:2 title \"$asx\", " >> do.gp
    fi
  done
  echo >> do.gp

  echo "set terminal png" >> do.gp
  echo "set output '${name}.$y.q.png'" >> do.gp
  printf "plot " >> do.gp
  for f in "$@"; do
    if [ $f != "BREAK" ]; then
      asx=$( echo $f | sed "s/${remove}\.//g" )
      printf "\"$f/$y/gpi.9\" using 1:2 title \"$asx\", " >> do.gp
    fi
  done
  echo >> do.gp
done
