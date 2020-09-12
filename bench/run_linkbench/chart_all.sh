
steps=( l.pre l.post L1.P8 L2.P8 L3.P12 L4.P12 L5.P16 L6.P16 )
lsteps=( l.pre l.post )
tsteps=( L1.P8 L2.P8 L3.P12 L4.P12 L5.P16 L6.P16 )

# Get IPS and TPS per dbms in z.*.xps
# Get all metrics per dbms in z*.eff.sec and z.*.eff.op

# head -1 because there can be dups in searched file

for f in "${lsteps[@]}" ; do
for e in "$@" ; do
  grep "$e\$" z1.${f}.eff.op | head -1
done | awk '{ if (NF == 14) { printf "%s\t%s\n", $1, $14 } }' > z.${f}.xps

head -1 z1.${f}.eff.op > z.${f}.eff.op
for e in "$@" ; do grep "$e\$" z1.${f}.eff.op | head -1 ; done >> z.${f}.eff.op

head -1 z1.${f}.eff.sec > z.${f}.eff.sec
for e in "$@" ; do grep "$e\$" z1.${f}.eff.sec | head -1 ; done >> z.${f}.eff.sec
done

for f in "${tsteps[@]}" ; do
for e in "$@" ; do
  grep "$e\$" z3.r.eff.op.${f} | head -1
done | awk '{ if (NF == 14) { printf "%s\t%s\n", $1, $14 } }' > z.${f}.xps

head -1 z3.r.eff.op.${f} > z.${f}.eff.op
for e in "$@" ; do grep "$e\$" z3.r.eff.op.${f} | head -1 ; done >> z.${f}.eff.op

head -1 z3.r.eff.sec.${f} > z.${f}.eff.sec
for e in "$@" ; do grep "$e\$" z3.r.eff.sec.${f} | head -1 ; done >> z.${f}.eff.sec

head -1 z4.r.rt.link.${f} > z.${f}.rt.link
for e in "$@" ; do grep "$e\$" z4.r.rt.link.${f} | head -1 ; done >> z.${f}.rt.link

head -1 z4.r.rt.node.${f} > z.${f}.rt.node
for e in "$@" ; do grep "$e\$" z4.r.rt.node.${f} | head -1 ; done >> z.${f}.rt.node

done

# Generate gnuplot commands for throughput bar charts

for f in "${lsteps[@]}" "${tsteps[@]}" ; do

cat <<GpEOF
set boxwidth 0.7
set xtics rotate 90
set style fill solid
set yrange [0:]
set output "ch.$f.xps.png"
set term png
plot "z.${f}.xps" using 1:xtic(2) notitle with boxes
GpEOF

done > do.ch

mkdir -p report
gnuplot do.ch
mv -f ch*.png report

awk '{ print $2 }' z.l.pre.xps > z1.all

c=2
for f in "${lsteps[@]}" "${tsteps[@]}" ; do
  fn="z.${f}.xps"
  minv=$( awk 'BEGIN { mv=999999999 } { if ($1 < mv) { mv=$1 } } END { print mv }' $fn )
  maxv=$( awk 'BEGIN { mv=0 }         { if ($1 > mv) { mv=$1 } } END { print mv }' $fn )
  gap=$(( $maxv - $minv ))
  gap4th=$( echo "scale=0; (0.25 * $gap)/1.0" | bc -l )
  topq[$c]=$(( $maxv - $gap4th ))
  botq[$c]=$(( $minv + $gap4th ))
  awk '{ print $1 }' $fn > z1.tmp
  if [ -a z1.all ]; then
    paste z1.all z1.tmp > z1.tmp2; mv z1.tmp2 z1.all
  else
    mv z1.tmp z1.all
  fi
  c=$(( $c + 1 ))
done

# Generate summary table in HTML format

function get_row_col {
  rowNum=$1
  colNum=$2
  fn=$3
  head -${rowNum} $fn | tail -1 | awk '{ printf "%s", $x }' x=${colNum}
}

nRows=$( wc -l z1.all | awk '{ print $1 }' )

for r in $( seq 1 $nRows ); do
for c in $( seq 1 9 ); do
  val=$( get_row_col $r $c z1.all )
  if [[ $c -eq 1 ]]; then
    printf "<tr><td>%s</td>" $val
  else
    if [[ $val -ge ${topq[$c]} ]]; then
      printf "<td id=\"cmax\">%s</td>" $val
    elif [[ $val -le ${botq[$c]} ]]; then
      printf "<td id=\"cmin\">%s</td>" $val
    else
      printf "<td>%s</td>" $val
    fi

    if [[ $c -eq 9 ]]; then printf "</tr>\n" ; fi
  fi
done
done > z2.tab

cat <<TabEOF > z2.1
<table border="1" cellpadding="8" >
<tr><th>dbms</th><th>l.pre</th><th>l.post</th><th>L1.P8</th><th>L2.P8</th><th>L3.P12</th><th>L4.P12</th><th>L5.P16</th><th>L6.P16</th></tr>
TabEOF

cat z2.1 z2.tab > z2.tmp
printf "</table>\n" >> z2.tmp
mv z2.tmp z2.tab

