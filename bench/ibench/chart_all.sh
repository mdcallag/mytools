dop=$1

shift 1

ifiles=( l.i0 l.x l.i1 )
qfiles=( q100.2 q200.2 q400.2 q600.2 q800.2 q1000.2 )

# Note - there can be multiple matches for the same value of e because the input list can have dups, thus "head -1"
for f in "${ifiles[@]}" ; do
  for e in "$@" ; do
    grep "$e\$" sum/mrg.$f | head -1
  done | awk '{ if (NF == 19) { printf "%s\t%s\n", $1, $19 } }' > sum/mrg.$f.ips

  head -1 sum/mrg.$f > sum/mrg.$f.some
  for e in "$@" ; do grep "$e\$" sum/mrg.$f | head -1 ; done >> sum/mrg.$f.some
done

# Note - there can be multiple matches for the same value of e because the input list can have dups, thus "head -1"
for f in "${qfiles[@]}" ; do
  for e in "$@" ; do
    grep "$e\$" sum/mrg.$f | head -1
  done | awk '{ if (NF == 19) { printf "%s\t%s\t%s\n", $1, $2, $19 } }' > sum/mrg.$f.qps

  head -1 sum/mrg.$f > sum/mrg.$f.some
  for e in "$@" ; do grep "$e\$" sum/mrg.$f | head -1 ; done >> sum/mrg.$f.some
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
unset title
set boxwidth 0.5
set xtics rotate 90
set style fill solid
set style data histograms
set yrange [0:]
set output "ch.$f.qps.png"
set term png
plot "sum/mrg.$f.qps" using 2:xtic(3) title "QPS", "" using 1 title "IPS"
GpEOF

done >> do.ch

mkdir -p report
gnuplot do.ch
mv ch*.png report

# Generate summary table in HTML format

# Get IPS from insert-only tests and QPS from read+write tests
awk '{ printf "%s\t%s\n", $2, $1 }' sum/mrg.l.i0.ips > z1
for f in l.x l.i1 ; do awk '{ print $1 }' sum/mrg.${f}.ips > ztmp ; paste z1 ztmp > z2; mv z2 z1 ; done
for f in q100.2 q200.2 q400.2 q600.2 q800.2 q1000.2 ; do awk '{ print $2 }' sum/mrg.${f}.qps > ztmp ; paste z1 ztmp > z2; mv z2 z1 ; done

# Get IPS from read+write tests
rm -f z1q; touch z1q
for e in "$@" ; do
  printf "$e" > ztmp
  for f in q100.2 q200.2 q400.2 q600.2 q800.2 q1000.2 ; do
    ips=$( grep "$e\$" sum/mrg.$f.qps | head -1 | awk '{ print $1 }' )
    printf "\t${ips}" >> ztmp
  done
  echo >> ztmp
  cat z1q ztmp > ztmp2; mv ztmp2 z1q
done

function get_row_col {
  rowNum=$1
  colNum=$2
  ifile=$3
  head -${rowNum} $ifile | tail -1 | awk '{ printf "%s", $x }' x=${colNum}
}

cat <<TabEOF > tput_hdr
<style type="text/css">
  table td#cmin { background-color:#FF9A9A }
  table td#cmax { background-color:#81FFA6 }
  table td#csla { background-color:#FFC172 }
  table td#cgray { background-color:#D7D7D7 }
  td {
    text-align:right
  }
</style>
<table border="1" cellpadding="8" >
TabEOF

cat tput_hdr > iput.tab
printf "<tr><th>dbms</th><th>q100.2</th><th>q200.2</th><th>q400.2</th><th>q600.2</th><th>q800.2</th><th>q1000.2</th></tr>\n" >> iput.tab

# accessed by dbms.columnNumber, 0 = did not sustain target insert rate, 1 = sustained target insert rate
declare -A sla

# generate table for insert rates during read+write

r=1
for e in "$@" ; do
  dbms=$( get_row_col $r 1 z1q )
  printf "<tr><td>$dbms</td>"

  c=2
  for rate in 100 200 400 600 800 1000 ; do
    trate=$(( $dop * $rate ))
    t95=$( echo $trate | awk '{ printf "%.0f", ( 0.95 * $1 ) }' )
    val=$( get_row_col $r $c z1q )
    if [[ $val -ge $t95 ]]; then
      printf "<td>$val</td>"
      sla[${e}.${c}]=1
    else
      printf "<td id=\"cmin\">$val</td>"
      sla[${e}.${c}]=0
      # echo "ZZZ $e misses sla for rate $rate"
    fi
    c=$(( $c + 1 ))
  done
  printf "</tr>\n"

  r=$(( $r + 1 ))
done >> iput.tab
printf "<tr><td>target</td><td id="cgray">$(( 100 * $dop ))</td><td id="cgray">$(( 200 * $dop ))</td><td id="cgray">$(( 400 * $dop ))</td><td id="cgray">$(( 600 * $dop ))</td><td id="cgray">$(( 800 * $dop ))</td><td id="cgray">$(( 1000 * $dop ))</td></tr>\n" >> iput.tab
printf "</table>\n" >> iput.tab

function filter_by_sla {
  inf=$1
  outf=$2
  colNum=$3
  shift 3

  cat $inf > $outf

  # This is messy. The sla array uses the column numbering for the table written to iput.tab which excludes
  # the columns for l.i0, l.x and l.i1. So colNum must be adjusted to account for that.

  if [[ $colNum -le 4 ]]; then
    return
  else
    colNum=$(( $colNum - 3 ))
  fi

  for e in "$@" ; do
    if [[ ${sla[${e}.${colNum}]} -eq 0 ]]; then
      # echo "sla 0 for ${e}.${colNum}"
      awk '{ if ($1 != dbms) { print $0 } }' dbms=$e $outf > ${outf}.tmp; mv ${outf}.tmp $outf
    fi
  done
}

# determine min, max, bottom and top quartiles

nRows=$( wc -l z1 | awk '{ print $1 }' )

for c in $( seq 2 10 ) ; do
  minv=$( awk 'BEGIN { mv=999999999 } { if ($x < mv) { mv=$x } } END { print mv }' x=$c z1 )
  filter_by_sla z1 z1f $c "$@"
  maxv=$( awk 'BEGIN { mv=0 }         { if ($x > mv) { mv=$x } } END { print mv }' x=$c z1f )
  gap=$(( $maxv - $minv ))
  gap4th=$( echo "scale=0; (0.25 * $gap)/1.0" | bc -l )
  topq[$c]=$(( $maxv - $gap4th ))
  botq[$c]=$(( $minv + $gap4th ))

  # use red for bottom quartile if minv is less than 80% of maxv
  minv2=$( echo $minv | awk '{ printf "%.0f", $1 * 1000.0 }' )
  maxv2=$( echo $maxv | awk '{ printf "%.0f", $1 * 0.8 * 1000.0 }' )
  if [[ $minv2 -ge $maxv2 ]] ; then botq[$c]=0; fi

  # echo "For col $c: minv $minv, maxv $maxv, gap $gap, gap4th $gap4th, topq ${topq[$c]}, botq ${botq[$c]}"
done

# generate summary table

for r in $( seq 1 $nRows ); do
dbms=$( get_row_col $r 1 z1 )
for c in $( seq 1 10 ); do
  val=$( get_row_col $r $c z1 )
  if [[ $c -eq 1 ]]; then
    printf "<tr><td>%s</td> " $val
  else
    if [[ $val -le ${botq[$c]} ]]; then
      printf "<td id=\"cmin\">%s</td>" $val
    elif [[ $c -gt 4 && ${sla[${dbms}.$(( $c - 3 ))]} -eq 0 ]]; then
      printf "<td id=\"cgray\">%s</td>" $val
    elif [[ $val -ge ${topq[$c]} ]]; then
      printf "<td id=\"cmax\">%s</td>" $val
    else
      printf "<td>%s</td>" $val
    fi
    if [[ $c -eq 10 ]]; then printf "</tr>\n"; fi
  fi
done
done > z2

cat tput_hdr > z3
printf "<tr><th>dbms</th><th>l.i0</th><th>l.x</th><th>l.i1</th><th>q100.2</th><th>q200.2</th><th>q400.2</th><th>q600.2</th><th>q800.2</th><th>q1000.2</th></tr>\n" >> z3
cat z3 z2 > tput.tab
printf "</table>\n" >> tput.tab
