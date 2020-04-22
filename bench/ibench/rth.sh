dop=$1
grepme=$2

tag=DBMS
ns=3

if=o.ib.dop${dop}.ns${ns}

grep "${grepme}" ${if}.1 | head -1 | awk '{ for (x=3; x<NF; x++) { printf "%s,", $x }; printf "%s,tag\n", $NF }' 

for i in $( seq 1 8 ); do
  grep "${grepme}" ${if}.${i} | tail -1
done | \
  awk '{ for (x=3; x<NF; x++) { maxs=(NF-1); if ($NF > mnf) { mnf = $NF }; ts += $x; s[x] += $x; printf "%s,", $x}; printf "%.5f,t%s:%s\n", $NF, NR, tag } \
    END { for (x=3; x<=maxs; x++) { printf "%s,", s[x] }; printf "%.5f,sum:%s\n", mnf, tag; for (x=3; x<=maxs; x++) { printf "%.3f,", 100*(s[x]/ts) }; printf "%.5f,pct:%s\n", mnf, tag; }' tag=$tag
