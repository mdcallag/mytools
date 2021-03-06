odir=$1
remove=$2

shift 2

bdir=$( dirname $0 )

farr=("$@")
f1=${farr[0]}

for y in l.i0 l.i1 q.L2.ips100 q.L4.ips200 q.L6.ips400 q.L8.ips600 q.L10.ips800 q.L12.ips1000 ; do
head -1 ${f1}/$y/o.rt.t.insert > $odir/mrg.$y.rt.insert
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    grep pct: $f/$y/o.rt.t.insert | sed "s/DBMS/$f/g" | sed "s/pct\:${remove}\.//g"
  else
    echo "-"
  fi
done >> $odir/mrg.$y.rt.insert
done

for y in q.L2.ips100 q.L4.ips200 q.L6.ips400 q.L8.ips600 q.L10.ips800 q.L12.ips1000 ; do
head -1 ${f1}/$y/o.rt.t.query > $odir/mrg.$y.rt.query
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    grep pct: $f/$y/o.rt.t.query | sed "s/DBMS/$f/g" | sed "s/pct\:${remove}\.//g"
  else
    echo "-"
  fi
done >> $odir/mrg.$y.rt.query
done

for y in q.L2.ips100 q.L4.ips200 q.L6.ips400 q.L8.ips600 q.L10.ips800 q.L12.ips1000 ; do
rm -f $odir/mrg.$y.rate.insert
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    echo "-"
    printf "qps-1\tqps-2\tqps-3\tqps-4\tqps-5\tqps-6\tqps-7\tqps-8\tqps-9\tqps-10\ttag\n"
    cat $f/$y/o.rate.t.3 | sed "s/DBMS/$f/g" | sed "s/${remove}\.//g"
  else
    echo "-"
  fi
done >> $odir/mrg.$y.rate.insert
done

for y in q.L2.ips100 q.L4.ips200 q.L6.ips400 q.L8.ips600 q.L10.ips800 q.L12.ips1000 ; do
rm -f $odir/mrg.$y.rate.query
for f in "$@"; do
  if [ $f != "BREAK" ]; then
    echo "-"
    printf "qps-1\tqps-2\tqps-3\tqps-4\tqps-5\tqps-6\tqps-7\tqps-8\tqps-9\tqps-10\ttag\n"
    cat $f/$y/o.rate.t.5 | sed "s/DBMS/$f/g" | sed "s/${remove}\.//g"
  else
    echo "-"
  fi
done >> $odir/mrg.$y.rate.query
done
