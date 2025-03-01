# bash ../sum_qps_csv.sh in8031 0 x.my8031_rel_withdbg.y9.pk1 x.my8031_rel.y9.pk1

tag=$1
as_csv=$2

shift 2
bn=$1

function parse_one {
group=$1
shift 1

if [ $group == "point" ]; then
  ls $bn/sb.r.qps.* | sort | xargs cat | grep point | grep -v warm | grep -v pre | awk '{ for (f=3; f <= NF ; f++) { printf "%s ", $f }; printf "\n" }' | \
      tr ' ' '_' | awk '{ print substr($0, 1, length($0) - 1 ) }'  > xrsh.lines.point
elif [ $group == "range" ]; then
  ls $bn/sb.r.qps.* | sort | xargs cat | grep -v point | grep -v pre | egrep -v 'delete|insert|update|write' | awk '{ for (f=3; f <= NF ; f++) { printf "%s ", $f }; printf "\n" }' | \
      tr ' ' '_' | awk '{ print substr($0, 1, length($0) - 1 ) }'  > xrsh.lines.range
elif [ $group == "write" ]; then
  ls $bn/sb.r.qps.* | sort | xargs cat | egrep 'delete|insert|update|write' | awk '{ for (f=3; f <= NF ; f++) { printf "%s ", $f }; printf "\n" }' | \
      tr ' ' '_' | awk '{ print substr($0, 1, length($0) - 1 ) }'  > xrsh.lines.write
else
  echo group arg must be one of: point, range, write
  exit 0
fi

y=1
for x in "$@" ; do
  echo "col-${y} : $x"
  y=$(( y + 1 ))
done > xrsh.inputs.abs
echo >> xrsh.inputs.abs

y=1
for x in "$@" ; do
  if [ $y -eq 1 ] ; then
    echo "Relative to: $x"
  else
    ym1=$(( y - 1 ))
    echo "col-${ym1} : $x"
  fi
  y=$(( y + 1 ))
done > xrsh.inputs.rel
echo >> xrsh.inputs.rel

y=1
for x in "$@" ; do
  if [ $y -eq 1 ]; then
    echo -n "col-${y}";
  else
    echo -e -n "\tcol-${y}";
  fi
  y=$(( y + 1 ))
done > xrsh.header.abs
echo >> xrsh.header.abs

y=0
for x in "$@" ; do
  if [ $y -eq 1 ]; then
    echo -e -n "col-${y}";
  elif [ $y -gt 1 ]; then
    echo -e -n "\tcol-${y}";
  fi
  y=$(( y + 1 ))
done > xrsh.header.rel
echo >> xrsh.header.rel

y=1
for x in "$@" ; do
  if [ $group == "point" ]; then
    ls $x/sb.r.qps.* | sort | xargs cat | grep point | grep -v warm | grep -v pre | awk '{ print $1 }' > $x.qps
  elif [ $group == "range" ]; then
    ls $x/sb.r.qps.* | sort | xargs cat | grep -v point | grep -v pre | egrep -v 'delete|insert|update|write' | awk '{ print $1 }' > $x.qps
  else
    ls $x/sb.r.qps.* | sort | xargs cat | egrep 'delete|insert|update|write' | awk '{ print $1 }' > $x.qps
  fi

  if [ $y -eq 1 ]; then
    cp $x.qps xrsh.abs
  elif [ $as_csv -eq 1 ]; then
    paste -d ',' xrsh.abs $x.qps > xrsh.abs.tmp; mv xrsh.abs.tmp xrsh.abs
  else
    paste xrsh.abs $x.qps > xrsh.abs.tmp; mv xrsh.abs.tmp xrsh.abs
  fi
  y=$(( y + 1 ))
done

if [ $as_csv -eq 1 ]; then
  cat xrsh.abs | awk -F ',' '{ for (c=2; c <= NF; c++) { printf "%.2f", $c/$1; if (c < NF) { printf "," } else { printf "\n" }}}' > xrsh.rel
else
  cat xrsh.abs | awk '{ for (c=2; c <= NF; c++) { printf "%.2f", $c/$1; if (c < NF) { printf "\t" } else { printf "\n" }}}' > xrsh.rel
fi

mv xrsh.abs xrsh.abs.${group}
mv xrsh.rel xrsh.rel.${group}
}

parse_one point "$@"
parse_one range "$@"
parse_one write "$@"

if [ $as_csv -eq 1 ]; then
  rm -f qps.abs.$tag.csv; touch qps.abs.$tag.csv
  for g in point range write ; do
    paste -d ',' xrsh.lines.$g xrsh.abs.$g >> qps.abs.$tag.csv
  done

  rm -f qps.rel.$tag.csv; touch qps.rel.$tag.csv
  for g in point range write ; do
    paste -d ',' xrsh.lines.$g xrsh.rel.$g >> qps.rel.$tag.csv
  done

else
  cat xrsh.inputs.abs xrsh.header.abs > qps.abs.$tag.tsv
  for g in point range write ; do
    paste xrsh.abs.$g xrsh.lines.$g >> qps.abs.$tag.tsv
  done

  cat xrsh.inputs.rel xrsh.header.rel > qps.rel.$tag.tsv
  for g in point range write ; do
    paste xrsh.rel.$g xrsh.lines.$g >> qps.rel.$tag.tsv
  done

fi


