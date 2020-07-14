
ifiles=( l.i0 l.x l.i1 )
qfiles=( q100.2 q200.2 q400.2 q600.2 q800.2 q1000.2 )

for f in "${ifiles[@]}" ; do
for e in "$@" ; do
  grep "$e\$" sum/mrg.$f
done | awk '{ if (NF == 19) { printf "%s\t%s\n", $1, $19 } }' > sum/mrg.$f.ips
done

for f in "${qfiles[@]}" ; do
for e in "$@" ; do
  grep "$e\$" sum/mrg.$f
done | awk '{ if (NF == 19) { printf "%s\t%s\n", $2, $19 } }' > sum/mrg.$f.qps
done

for f in "${ifiles[@]}" ; do

tmsg="Inserts/second"
if [[ $f == "l.x" ]]; then
  tmsg="Indexed docs or rows/second"
fi

cat <<GpEOF
set boxwidth 0.7
set xtics rotate 90
set style fill solid
set yrange [0:]
set title "$tmsg"
set output "ch.$f.ips.png"
set term png
plot "sum/mrg.$f.ips" using 1:xtic(2) notitle with boxes
GpEOF

done > do.ch

for f in "${qfiles[@]}" ; do

cat <<GpEOF
set boxwidth 0.7
set xtics rotate 90
set style fill solid
set yrange [0:]
set title "Queries/second"
set output "ch.$f.qps.png"
set term png
plot "sum/mrg.$f.qps" using 1:xtic(2) notitle with boxes
GpEOF

done >> do.ch

mkdir -p report
gnuplot do.ch
mv ch*.png report

# Generate summary table in HTML format

awk '{ printf "%s\t%s\n", $2, $1 }' sum/mrg.l.i0.ips > z1
for f in l.x l.i1 ; do awk '{ print $1 }' sum/mrg.${f}.ips > ztmp ; paste z1 ztmp > z2; mv z2 z1 ; done
for f in q100.2 q200.2 q400.2 q600.2 q800.2 q1000.2 ; do awk '{ print $1 }' sum/mrg.${f}.qps > ztmp ; paste z1 ztmp > z2; mv z2 z1 ; done

for c in $( seq 2 10 ) ; do
  minv=$( awk 'BEGIN { mv=999999999 } { if ($x < mv) { mv=$x } } END { print mv }' x=$c z1 )
  maxv=$( awk 'BEGIN { mv=0 }         { if ($x > mv) { mv=$x } } END { print mv }' x=$c z1 )
  gap=$(( $maxv - $minv ))
  gap4th=$( echo "scale=0; (0.25 * $gap)/1.0" | bc -l )
  topq[$c]=$(( $maxv - $gap4th ))
  botq[$c]=$(( $minv + $gap4th ))
  # echo "For col $c: minv $minv, maxv $maxv, gap $gap, gap4th $gap4th, topq ${topq[$c]}, botq ${botq[$c]}"
done

function get_row_col {
  rowNum=$1
  colNum=$2
  head -${rowNum} z1 | tail -1 | awk '{ printf "%s", $x }' x=${colNum}
}

nRows=$( wc -l z1 | awk '{ print $1 }' )

for r in $( seq 1 $nRows ); do
for c in $( seq 1 10 ); do
  val=$( get_row_col $r $c )
  if [[ $c -eq 1 ]]; then
    printf "<tr><td>%s</td> " $val
  else
    if [[ $val -ge ${topq[$c]} ]]; then
      printf "<td id=\"cmax\">%s</td>" $val
    elif [[ $val -le ${botq[$c]} ]]; then
      printf "<td id=\"cmin\">%s</td>" $val
    else
      printf "<td>%s</td>" $val
    fi
    if [[ $c -eq 10 ]]; then printf "</tr>\n"; fi
  fi
done
done > z2

cat <<TabEOF > z3
<style type="text/css">
  table td#cmin { background-color:#FF9A9A }
  table td#cmax { background-color:#81FFA6 }
  td {
    text-align:right
  }
</style>
<table border="1" cellpadding="8" >
TabEOF

printf "<tr><th>dbms</th><th>l.i0</th><th>l.x</th><th>l.i</th><th>q100.2</th><th>q200.2</th><th>q400.2</th><th>q600.2</th><th>q800.2</th><th>q1000.2</th>\n" >> z3
cat z3 z2 > tput.tab
printf "</table>\n" >> tput.tab
