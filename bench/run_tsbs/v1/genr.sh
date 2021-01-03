h=$1
m=$2

shift 2

for qtype in \
cpu-max-all-1 \
cpu-max-all-8 \
lastpoint \
single-groupby-5-1-1 \
single-groupby-5-1-12 \
single-groupby-5-8-1 \
single-groupby-1-1-1 \
single-groupby-1-8-1 \
single-groupby-1-1-12 \
groupby-orderby-limit \
double-groupby-1 \
double-groupby-5 \
double-groupby-all \
high-cpu-1 \
high-cpu-all \
; do 
printf "min\tmed\tmean\tmax\tstddev\tcount\tNdays\t${qtype}\n"
for n in "$@" ; do 
for d in o.q.run.${n}day.${qtype}.${m}month.${h}host; do 
  grep stddev $d | tail -1 | awk '{ print $2, $4, $6, $8, $10, $14 }' | sed 's/ms,//g' | \
  awk '{ if ($1 >= 100) { $1 = sprintf("%.0f", $1); }; print $1, $2, $3, $4, $5, $6 }' | \
  awk '{ if ($2 >= 100) { $2 = sprintf("%.0f", $2); }; print $1, $2, $3, $4, $5, $6 }' | \
  awk '{ if ($3 >= 100) { $3 = sprintf("%.0f", $3); }; print $1, $2, $3, $4, $5, $6 }' | \
  awk '{ if ($4 >= 100) { $4 = sprintf("%.0f", $4); }; print $1, $2, $3, $4, $5, $6 }' | \
  awk '{ if ($5 >= 100) { $5 = sprintf("%.0f", $5); }; print $1, $2, $3, $4, $5, $6 }' | \
  awk '{ printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $1, $2, $3, $4, $5, $6, n }' n=$n 
done
done
done

#min:    18.72ms, med:    19.79ms, mean:    20.61ms, max:  530.98ms, stddev:    16.20ms, sum:  20.6sec, count: 1000


