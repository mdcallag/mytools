ntab=$1
nthr=$2
# fbmy8028.ay9c
rxnamec6i=$3
# fbmy8028_cpunative.ay9c
rxnamec7g=$4
# pg151.x7
pgnamec6i=$5
pgnamec7g=$6
# my8031.y9
innamec6i=$7
innamec7g=$8

rm -rf x.fbmy8028.*
for p in 0 1; do
  cp -r ../r.20m.${ntab}tab.${nthr}thr.c6i/x.${rxnamec6i}.pk$p x.${rxnamec6i}.c6i.pk$p
  cp -r ../r.20m.${ntab}tab.${nthr}thr.c7g/x.${rxnamec7g}.pk$p x.${rxnamec7g}.c7g.pk$p
  for z in point range write ; do
    bash ../sum_qps_csv.sh crx$p 1 $z x.${rxnamec6i}.c6i.pk$p x.${rxnamec7g}.c7g.pk$p
    if [ $z == "point" ]; then
      cat sum.crx$p.$z | awk -F ',' '{ printf("%s", $1); for (c=3; c<=NF; c++) { printf ",%.2f", $c/$2 }; printf("\n"); }' > rel.rx$p.csv
    else
      cat sum.crx$p.$z | awk -F ',' '{ printf("%s", $1); for (c=3; c<=NF; c++) { printf ",%.2f", $c/$2 }; printf("\n"); }' >> rel.rx$p.csv
    fi
  done
  cat rel.rx$p.csv | tr ',' '\t' > rel.rx$p.tsv
done
join rel.rx0.tsv rel.rx1.tsv | tr ' ' ',' > rel.rx.csv
join rel.rx0.tsv rel.rx1.tsv | tr ' ' '\t' > rel.rx.tsv

rm -rf x.pg151.*
for p in 0 1; do
  cp -r ../r.20m.${ntab}tab.${nthr}thr.c6i/x.${pgnamec6i}.pk$p x.${pgnamec6i}.c6i.pk$p
  cp -r ../r.20m.${ntab}tab.${nthr}thr.c7g/x.${pgnamec7g}.pk$p x.${pgnamec7g}.c7g.pk$p
  for z in point range write ; do
    bash ../sum_qps_csv.sh cpg$p 1 $z x.${pgnamec6i}.c6i.pk$p x.${pgnamec7g}.c7g.pk$p
    if [ $z == "point" ]; then
      cat sum.cpg$p.$z | awk -F ',' '{ printf("%s", $1); for (c=3; c<=NF; c++) { printf ",%.2f", $c/$2 }; printf("\n"); }' > rel.pg$p.csv
    else
      cat sum.cpg$p.$z | awk -F ',' '{ printf("%s", $1); for (c=3; c<=NF; c++) { printf ",%.2f", $c/$2 }; printf("\n"); }' >> rel.pg$p.csv
    fi
  done
  cat rel.pg$p.csv | tr ',' '\t' > rel.pg$p.tsv
done
join rel.pg0.tsv rel.pg1.tsv | tr ' ' ',' > rel.pg.csv
join rel.pg0.tsv rel.pg1.tsv | tr ' ' '\t' > rel.pg.tsv

rm -rf x.my8031.*
for p in 0 1; do
  cp -r ../r.20m.${ntab}tab.${nthr}thr.c6i/x.${innamec6i}.pk$p x.${innamec6i}.c6i.pk$p
  cp -r ../r.20m.${ntab}tab.${nthr}thr.c7g/x.${innamec7g}.pk$p x.${innamec7g}.c7g.pk$p
  for z in point range write ; do
    bash ../sum_qps_csv.sh cin$p 1 $z x.${innamec6i}.c6i.pk$p x.${innamec7g}.c7g.pk$p
    if [ $z == "point" ]; then
      cat sum.cin$p.$z | awk -F ',' '{ printf("%s", $1); for (c=3; c<=NF; c++) { printf ",%.2f", $c/$2 }; printf("\n"); }' > rel.in$p.csv
    else
      cat sum.cin$p.$z | awk -F ',' '{ printf("%s", $1); for (c=3; c<=NF; c++) { printf ",%.2f", $c/$2 }; printf("\n"); }' >> rel.in$p.csv
    fi
  done
  cat rel.in$p.csv | tr ',' '\t' > rel.in$p.tsv
done
join rel.in0.tsv rel.in1.tsv | tr ' ' ',' > rel.in.csv
join rel.in0.tsv rel.in1.tsv | tr ' ' '\t' > rel.in.tsv

join rel.rx.tsv rel.pg.tsv > rel.rxpg.tsv
join rel.rxpg.tsv rel.in.tsv | tr ' ' ',' > rel.all.csv
cat rel.all.csv | tr ',' '\t' > rel.all.tsv
rm rel.rxpg.tsv
