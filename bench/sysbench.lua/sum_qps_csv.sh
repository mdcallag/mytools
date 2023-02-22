tag=$1
as_csv=$2
# point, range or write
group=$3

shift 3

# % | grep -v point | egrep -v 'delete|insert|update|write' |
# % ls x.pg151_cpunative.x7_128gram_64kiops.c7g.pk0/sb.r.qps.* | egrep 'delete|insert|update|write' | wc -l
# % ls x.pg151_cpunative.x7_128gram_64kiops.c7g.pk0/sb.r.qps.* | grep point | wc -l

bn=$1

if [ $group == "point" ]; then
  ls $bn/sb.r.qps.* | sort | xargs cat | grep point | grep -v warm | awk '{ for (f=3; f <= NF ; f++) { printf "%s ", $f }; printf "\n" }' | \
      tr ' ' '_' | awk '{ print substr($0, 1, length($0) - 1 ) }'  > xrsh.lines
elif [ $group == "range" ]; then
  ls $bn/sb.r.qps.* | sort | xargs cat | grep -v point | egrep -v 'delete|insert|update|write' | awk '{ for (f=3; f <= NF ; f++) { printf "%s ", $f }; printf "\n" }' | \
      tr ' ' '_' | awk '{ print substr($0, 1, length($0) - 1 ) }'  > xrsh.lines
elif [ $group == "write" ]; then
  ls $bn/sb.r.qps.* | sort | xargs cat | egrep 'delete|insert|update|write' | awk '{ for (f=3; f <= NF ; f++) { printf "%s ", $f }; printf "\n" }' | \
      tr ' ' '_' | awk '{ print substr($0, 1, length($0) - 1 ) }'  > xrsh.lines
else
  echo group arg must be one of: point, range, write
  exit 0
fi

y=1
for x in "$@" ; do
  echo "col-${y} : $x"
  y=$(( y + 1 ))
done > xrsh.inputs
echo >> xrsh.inputs

y=1
for x in "$@" ; do
  if [ $y -eq 1 ]; then
    echo -n "col-${y}";
  else
    echo -e -n "\tcol-${y}";
  fi
  y=$(( y + 1 ))
done > xrsh.header
echo >> xrsh.header

y=1
for x in "$@" ; do

  if [ $group == "point" ]; then
    ls $x/sb.r.qps.* | sort | xargs cat | grep point | grep -v warm | awk '{ print $1 }' > $x.qps
  elif [ $group == "range" ]; then
    ls $x/sb.r.qps.* | sort | xargs cat | grep -v point | egrep -v 'delete|insert|update|write' | awk '{ print $1 }' > $x.qps
  else
    ls $x/sb.r.qps.* | sort | xargs cat | egrep 'delete|insert|update|write' | awk '{ print $1 }' > $x.qps
  fi

  if [ $y -eq 1 ]; then
    cp $x.qps xrsh.all
  elif [ $as_csv -eq 1 ]; then
    paste -d ',' xrsh.all $x.qps > xrsh.all.tmp; mv xrsh.all.tmp xrsh.all
  else
    paste xrsh.all $x.qps > xrsh.all.tmp; mv xrsh.all.tmp xrsh.all
  fi
  y=$(( y + 1 ))
done

if [ $as_csv -eq 1 ]; then
  paste -d ',' xrsh.lines xrsh.all > xrsh.all.tmp; mv xrsh.all.tmp xrsh.all
  cat xrsh.all > sum.$tag.$group
else
  paste xrsh.all xrsh.lines > xrsh.all.tmp; mv xrsh.all.tmp xrsh.all
  cat xrsh.inputs xrsh.header xrsh.all > sum.$tag.$group
fi


