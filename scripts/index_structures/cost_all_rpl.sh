fn=$1
nps=$2
sfx=$3

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
#   c2: max-wa-io < 20 ,max-wa-cpu <= 50  && max-sa <= 2
#   c3: max-wa-io < 40, max-wa-cpu <= 100 && max-sa <= 1.5
#   c4: max-wa-io < 80, max-wa-cpu <= 160 && max-sa <= 1.25

function gen {
  wa_io=$1
  wa_cpu=$2
  sa=$3
  wl_i=$4
  wl_p=$5
  wl_r=$6
  of=$7

  printf "wa-I\twa-C\tsa\tca\tNruns\tNlvls\tph\tpm\trs\trn\tcost\tF\tL\n" > $of.$sfx
  grep -v Nruns $fn | bash cost_rpl.sh $wl_i $wl_p $wl_r $nps $wa_io $wa_cpu $sa | sort -nk 12,12 | head -5 >> $of.$sfx
  #echo "---" >> $of.$sfx
  grep -v Nruns $fn | bash cost_rpl.sh $wl_i $wl_p $wl_r $nps 10000 10000 1000 | egrep '^L4|TL4_3_0_0' >> $of.$sfx
}

#   point-only
wl="0 100 0"
pfx=po
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  50 2    $wl cr.$pfx.c2
gen 40 100 1.5  $wl cr.$pfx.c3
gen 80 160 1.25 $wl cr.$pfx.c4
for x in 1 2 3 4; do cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   range-only
wl="0 0 100"
pfx=ro
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  50 2    $wl cr.$pfx.c2
gen 40 100 1.5  $wl cr.$pfx.c3
gen 80 160 1.25 $wl cr.$pfx.c4
for x in 1 2 3 4; do cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   range+point
wl="0 50 50"
pfx=rp
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  50 2    $wl cr.$pfx.c2
gen 40 100 1.5  $wl cr.$pfx.c3
gen 80 160 1.25 $wl cr.$pfx.c4
for x in 1 2 3 4; do cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   insert-only
wl="100 0 0"
pfx=io
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  50 2    $wl cr.$pfx.c2
gen 40 100 1.5  $wl cr.$pfx.c3
gen 80 160 1.25 $wl cr.$pfx.c4
for x in 1 2 3 4; do cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   insert+point
wl="50 50 0"
pfx=ip
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  50 2    $wl cr.$pfx.c2
gen 40 100 1.5  $wl cr.$pfx.c3
gen 80 160 1.25 $wl cr.$pfx.c4
for x in 1 2 3 4; do cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   insert+range
wl="50 0 50"
pfx=ir
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  50 2    $wl cr.$pfx.c2
gen 40 100 1.5  $wl cr.$pfx.c3
gen 80 160 1.25 $wl cr.$pfx.c4
for x in 1 2 3 4; do cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

#   insert+point+range
wl="20 50 30"
pfx=ipr
gen 10  40 2.5  $wl cr.$pfx.c1
gen 20  50 2    $wl cr.$pfx.c2
gen 40 100 1.5  $wl cr.$pfx.c3
gen 80 160 1.25 $wl cr.$pfx.c4
for x in 1 2 3 4; do cat cr.$pfx.c$x.tsv; done > cr.$pfx.tsv

