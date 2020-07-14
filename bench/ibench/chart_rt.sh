m=$1

shift 1

ifiles=( l.i0 l.i1 )
qfiles=( q100.2 q200.2 q400.2 q600.2 q800.2 q1000.2 )
q2files=( q.L2.ips100 q.L4.ips200 q.L6.ips400 q.L8.ips600 q.L10.ips800 q.L12.ips1000 )

for f in "${ifiles[@]}" "${q2files[@]}" ; do
outf="rt${m}/mrg.$f.rt.insert.some"
head -1 rt${m}/mrg.$f.rt.insert > $outf
for e in "$@" ; do
  grep "$e\$" rt${m}/mrg.$f.rt.insert >> $outf
done 
done

for f in "${q2files[@]}" ; do
outf="rt${m}/mrg.$f.rt.query.some"
head -1 rt${m}/mrg.$f.rt.query > $outf
for e in "$@" ; do
  grep "$e\$" rt${m}/mrg.$f.rt.query >> $outf
done 
done

# Generate summary table in HTML format

function get_row_col {
  rowNum=$1
  colNum=$2
  inf=$3
  head -${rowNum} $inf | tail -1 | awk '{ printf "%s", $x }' x=${colNum}
}

# Code removed by comments was there to color-code values in the table but it didn't turn out well
function make_table {
  f=$1
  y=$2

  inf="rt${m}/mrg.$f.rt.$y.some"
  outf="rt${m}/mrg.$f.rt.$y.ht"
  nRows=$( wc -l $inf | awk '{ print $1 }' )

  printf "<style type=\"text/css\">\n" > $outf

  for n in $( seq 0 20 ); do
    hexn=$( echo $n | awk '{ printf "%x", 254 - ($1 * 2) }' )
    printf "table td#c$n { background-color:#${hexn}${hexn}${hexn} }\n" >> $outf
  done

  printf "table td#cmaxr { background-color:#FF9A9A }\n" >> $outf
  printf "table td#cminr { background-color:#81FFA6 }\n" >> $outf
  printf " { text-align: right }\n" >> $outf

  printf "</style>\n" >> $outf
  printf "<table border=\"1\" cellpadding=\"8\" >\n" >> $outf
  printf "<tr>\n" >> $outf

  # Get max and min values from the "max" column
  minv=$( awk 'BEGIN { mv=999999999 } { if (NR > 1 && $11 < mv) { mv=$11 } } END { print mv }' $inf )
  maxv=$( awk 'BEGIN { mv=0 }         { if (NR > 1 && $11 > mv) { mv=$11 } } END { print mv }' $inf )
  gap4th=$( echo "$maxv $minv" | awk '{ printf "%.3f", ($1 - $2) / 4.0 }' )
  topq=$( echo "$maxv $gap4th" | awk '{ printf "%.0f", ($1 - $2) * 1000.0 }' )
  botq=$( echo "$minv $gap4th" | awk '{ printf "%.0f", ($1 + $2) * 1000.0 }' )

  r=1
  printf "<th>dbms</th>" >> $outf
  for c in $( seq 1 11 ); do
    v=$( get_row_col 1 $c $inf )
    printf "<th>$v</th>" >> $outf
  done
  printf "</tr>\n" >> $outf

  for r in $( seq 2 $nRows ); do
    printf "<tr>" >> $outf
    for c in 12 $( seq 1 11 ); do
      v=$( get_row_col $r $c $inf )

      if [[ $v == "0.000" ]]; then
        printf "<td></td>" >> $outf

      elif [[ $c -eq 11 ]]; then
        # This is the "max" column
        v1000=$( echo $v | awk '{ printf "%.0f", $1 * 1000.0 }' )
        if [[ ${v1000} -ge $topq ]]; then
          printf "<td id=\"cmaxr\">${v}</td>" >> $outf
        elif [[ ${v1000} -le $botq ]]; then
          printf "<td id=\"cminr\">${v}</td>" >> $outf
        else
          printf "<td>${v}</td>" >> $outf
        fi

      else
        vn=$( echo $v | awk '{ printf "%.0f", $1 / 5.0 }' )
        printf "<td id=\"c${vn}\">$v</td>" >> $outf
        # printf "<td>$v</td>" >> $outf
      fi
    done
    printf "</tr>\n" >> $outf
  done

  printf "</table>\n" >> $outf
}

for f in "${ifiles[@]}" ; do
  make_table $f insert
done

for f in "${q2files[@]}" ; do
  make_table $f insert
  make_table $f query
done

