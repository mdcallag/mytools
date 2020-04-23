odir=$1
remove=$2

shift 2

bdir=$( dirname $0 )

farr=("$@")
f1=${farr[0]}

for y in l q1000 q1000 ; do
head -1 ${f1}/$y/o.rt.t.insert > $odir/mrg.$y.rt.insert
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    grep pct: $f/$y/o.rt.t.insert | sed "s/DBMS/$f/g" | sed "s/pct\:${remove}\.//g"
  fi
done >> $odir/mrg.$y.rt.insert
done

for y in q1000 q1000 ; do
head -1 ${f1}/$y/o.rt.t.query > $odir/mrg.$y.rt.query
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    grep pct: $f/$y/o.rt.t.query | sed "s/DBMS/$f/g" | sed "s/pct\:${remove}\.//g"
  fi
done >> $odir/mrg.$y.rt.query
done

for y in l q1000 q100 ; do
rm -f $odir/mrg.$y.rate.insert
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    echo "-"
    printf "qps-1\tqps-2\tqps-3\tqps-4\tqps-5\tqps-6\tqps-7\tqps-8\tqps-9\tqps-10\ttag\n"
    cat $f/$y/o.rate.t.6 | sed "s/DBMS/$f/g" | sed "s/${remove}\.//g"
  fi
done >> $odir/mrg.$y.rate.insert
done

for y in q1000 q100 ; do
rm -f $odir/mrg.$y.rate.query
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    echo "-"
    printf "qps-1\tqps-2\tqps-3\tqps-4\tqps-5\tqps-6\tqps-7\tqps-8\tqps-9\tqps-10\ttag\n"
    cat $f/$y/o.rate.t.9 | sed "s/DBMS/$f/g" | sed "s/${remove}\.//g"
  fi
done >> $odir/mrg.$y.rate.query
done
