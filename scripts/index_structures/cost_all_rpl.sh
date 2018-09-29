fn=$1
nps=$2
sfx=$3
min_cost_level=$4

# Run for workloads X constraints

# workloads
#   point-only
#   range-only
#   range+point
#   insert-only
#   insert+point
#   insert+range
#   insert+point+range

# constraints
#   c1: max-wa-io < 10, max-wa-cpu <= 40  && max-sa <= 2.5
#   c2: max-wa-io < 20, max-wa-cpu <= 40  && max-sa <= 2
#   c3: max-wa-io < 30, max-wa-cpu <= 60  && max-sa <= 2
#   c4: max-wa-io < 40, max-wa-cpu <= 80  && max-sa <= 1.5
#   c5: max-wa-io < 80, max-wa-cpu <= 160 && max-sa <= 1.25

function gen {
  wa_io=$1
  wa_cpu=$2
  sa=$3
  wl_i=$4
  wl_p=$5
  wl_r=$6
  of=$7

  printf "cost\twa-I\twa-C\tsa\tca\tNruns\tNlvls\tph\tpm\trs\trn\tisdom\tF\tL\tC\n" > $of.$sfx
  # grep False to only consider plans that are not dominated
  grep -v Nruns $fn | grep False | bash cost_rpl.sh $wl_i $wl_p $wl_r $nps $wa_io $wa_cpu $sa | sort -nk 1,1 | head -5 >> $of.$sfx
  echo "---" >> $of.$sfx
  grep -v Nruns $fn | grep False | bash cost_rpl.sh $wl_i $wl_p $wl_r $nps 10000 10000 1000 | grep 'T1L' | awk '{ if ($7 >= mcl) { print $0 } }' mcl=$min_cost_level | sort -nk 1,1 | head -1 >> $of.$sfx
}

#   point-only
wl="0 100 0"
pfx=po
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  40 2    $wl cr.$pfx.c2
gen 30  60 2    $wl cr.$pfx.c3
gen 40  80 1.5  $wl cr.$pfx.c4
gen 80 160 1.25 $wl cr.$pfx.c5
for x in 1 2 3 4 5; do echo $x; cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   range-only
wl="0 0 100"
pfx=ro
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  40 2    $wl cr.$pfx.c2
gen 30  60 2    $wl cr.$pfx.c3
gen 40  80 1.5  $wl cr.$pfx.c4
gen 80 160 1.25 $wl cr.$pfx.c5
for x in 1 2 3 4 5; do echo $x; cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   range+point
wl="0 50 50"
pfx=rp
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  40 2    $wl cr.$pfx.c2
gen 30  60 2    $wl cr.$pfx.c3
gen 40  80 1.5  $wl cr.$pfx.c4
gen 80 160 1.25 $wl cr.$pfx.c5
for x in 1 2 3 4 5; do echo $x; cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   insert-only
wl="100 0 0"
pfx=io
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  40 2    $wl cr.$pfx.c2
gen 30  60 2    $wl cr.$pfx.c3
gen 40  80 1.5  $wl cr.$pfx.c4
gen 80 160 1.25 $wl cr.$pfx.c5
for x in 1 2 3 4 5; do echo $x; cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   insert+point
for i in 5 10 20 40 ; do
  p=$(( 100 - $i ))
  wl="$i $p 0"
  pfx=ip.${i}.${p}.0
  gen 10  40 2.5  $wl cr.$pfx.c1
  gen 20  40 2    $wl cr.$pfx.c2
  gen 30  60 2    $wl cr.$pfx.c3
  gen 40  80 1.5  $wl cr.$pfx.c4
  gen 80 160 1.25 $wl cr.$pfx.c5
  for x in 1 2 3 4 5; do echo $x; cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv
done

#   insert+range
for i in 5 10 20 40 ; do
  r=$(( 100 - $i ))
  wl="$i 0 $r"
  pfx=ir.${i}.0.${r}
  gen 10  40 2.5  $wl cr.$pfx.c1
  gen 20  40 2    $wl cr.$pfx.c2
  gen 30  60 2    $wl cr.$pfx.c3
  gen 40  80 1.5  $wl cr.$pfx.c4
  gen 80 160 1.25 $wl cr.$pfx.c5
  for x in 1 2 3 4 5; do echo $x; cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv
done

#   insert+point+range
for i in 5 10 20 40 ; do
  p=$(( (( 100 - $i ) * 2) / 3 ))
  r=$(( 100 - $i - $p ))
  wl="$i $p $r"
  pfx=ipr.${i}.${p}.${r}
  gen 10  40 2.5  $wl cr.$pfx.c1
  gen 20  40 2    $wl cr.$pfx.c2
  gen 30  60 2    $wl cr.$pfx.c3
  gen 40  80 1.5  $wl cr.$pfx.c4
  gen 80 160 1.25 $wl cr.$pfx.c5
  for x in 1 2 3 4 5; do echo $x; cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv
done
