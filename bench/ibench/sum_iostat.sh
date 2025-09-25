iof=$1
dname=$2
format=$3  # all, header,data

if [[ $format == "all" ]]; then
  printf "average values from iostat for $dname\n"
fi

if [[ $format == "all" || $format == "header" ]]; then
  cat $iof | grep Device | head -1 | awk '{ for (x=2; x <= NF; x++) { printf "%s\t", substr($x, 1, 7) } } END { printf "\n" }'
fi

if [[ $format == "all" || $format == "data" ]]; then
  cat $iof | grep $dname | awk '{ c += 1; nf=NF; for (x=2 ; x <= NF; x++) { sm[x] += $x } } END { for (x=2; x <= nf; x++) { v = sm[x]/c; if (v >= 100000) {printf "%.0f\t", v} else if (v >= 100) { printf "%.1f\t", v } else if (v >= 10) { printf "%.2f\t", v } else { printf "%.3f\t", v}}; printf "\n" }'
fi

if [[ $format != "all" && $format != "data" && $format != "header" ]]; then
  echo format __ "$format" __ not recognized
  exit 1
fi


