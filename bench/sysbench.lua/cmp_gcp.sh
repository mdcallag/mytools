ntab=$1
nthr=$2
# fbmy8028.ay9c
rxnamec2=$3
# fbmy8028_cpunative.ay9c
rxnamet2a=$4
# pg151.x7
pgnamec2=$5
pgnamet2a=$6
# my8031.y9
innamec2=$7
innamet2a=$8

rm -rf x.fbmy8028.*
for p in 0 1; do
  cp -r ../r.20m.${ntab}tab.${nthr}thr.c2/x.${rxnamec2}.pk$p x.${rxnamec2}.c2.pk$p
  cp -r ../r.20m.${ntab}tab.${nthr}thr.t2a/x.${rxnamet2a}.pk$p x.${rxnamet2a}.t2a.pk$p
  for z in point range write ; do
    bash ../sum_qps_csv.sh crx$p 1 $z x.${rxnamec2}.c2.pk$p x.${rxnamet2a}.t2a.pk$p
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
  cp -r ../r.20m.${ntab}tab.${nthr}thr.c2/x.${pgnamec2}.pk$p x.${pgnamec2}.c2.pk$p
  cp -r ../r.20m.${ntab}tab.${nthr}thr.t2a/x.${pgnamet2a}.pk$p x.${pgnamet2a}.t2a.pk$p
  for z in point range write ; do
    bash ../sum_qps_csv.sh cpg$p 1 $z x.${pgnamec2}.c2.pk$p x.${pgnamet2a}.t2a.pk$p
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
  cp -r ../r.20m.${ntab}tab.${nthr}thr.c2/x.${innamec2}.pk$p x.${innamec2}.c2.pk$p
  cp -r ../r.20m.${ntab}tab.${nthr}thr.t2a/x.${innamet2a}.pk$p x.${innamet2a}.t2a.pk$p
  for z in point range write ; do
    bash ../sum_qps_csv.sh cin$p 1 $z x.${innamec2}.c2.pk$p x.${innamet2a}.t2a.pk$p
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
