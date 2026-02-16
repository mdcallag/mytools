
doperf=$1
samples_per_sec=$2
# ma, my, pg
dbms=$3

for vu in 1 6 ; do
for wh in 100 1000 2000 ; do
  echo $vu $wh $dbms at $( date )
  bash all${dbms}.N.sh $doperf 8 $vu $wh 5 120 c8r32 $samples_per_sec >& out.all${dbms}
  mkdir res.${dbms}.load8.vu${vu}.w${wh}.5.120
  mv out.all${dbms}* o.${dbms}* res.${dbms}.load8.vu${vu}.w${wh}.5.120
done
done
