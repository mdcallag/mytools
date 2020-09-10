tag=$1
pfx=$2
dop=$3
grepme=$4

if=$tag/$pfx/o.ib.dop${dop}

grep "${grepme}" ${if}.1 | head -1 | awk '{ for (x=3; x<NF; x++) { printf "%s,", $x }; printf "%s,tag\n", $NF }' 

for i in $( seq 1 $dop ); do
  grep "${grepme}" ${if}.${i} | tail -1
done | \
  awk '{ for (x=3; x<NF; x++) { maxs=(NF-1); if ($NF > mnf) { mnf = $NF }; ts += $x; s[x] += $x; printf "%s,", $x}; printf "%.3f,t%s:%s\n", $NF, NR, "DBMS" } \
    END { for (x=3; x<=maxs; x++) { printf "%s,", s[x] }; printf "%.3f,sum:%s\n", mnf, "DBMS"; for (x=3; x<=maxs; x++) { v = sprintf("%.3f", 100*(s[x]/ts)); if (s[x] > 0 && v == "0.000") v = "nonzero"; printf "%s,", v }; printf "%.3f,pct:%s\n", mnf, "DBMS"; }' 
