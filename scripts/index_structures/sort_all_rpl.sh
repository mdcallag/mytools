fn=$1
nps=$2

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

#   point-only
wl="0 100 0"
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 10 40  2.5  | sort -nk 12,12 > cr.po.c1
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 20 50  2    | sort -nk 12,12 > cr.po.c2
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 40 100 1.5  | sort -nk 12,12 > cr.po.c3
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 80 160 1.25 | sort -nk 12,12 > cr.po.c4

#   range-only
wl="0 0 100"
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 10 40  2.5  | sort -nk 12,12 > cr.ro.c1
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 20 50  2    | sort -nk 12,12 > cr.ro.c2
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 40 100 1.5  | sort -nk 12,12 > cr.ro.c3
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 80 160 1.25 | sort -nk 12,12 > cr.ro.c4

#   range+point
wl="0 50 50"
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 10 40  2.5  | sort -nk 12,12 > cr.rp.c1
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 20 50  2    | sort -nk 12,12 > cr.rp.c2
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 40 100 1.5  | sort -nk 12,12 > cr.rp.c3
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 80 160 1.25 | sort -nk 12,12 > cr.rp.c4

#   insert-only
wl="100 0 0"
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 10 40  2.5  | sort -nk 12,12 > cr.io.c1
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 20 50  2    | sort -nk 12,12 > cr.io.c2
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 40 100 1.5  | sort -nk 12,12 > cr.io.c3
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 80 160 1.25 | sort -nk 12,12 > cr.io.c4

#   insert+point
wl="50 50 0"
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 10 40  2.5  | sort -nk 12,12 > cr.ip.c1
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 20 50  2    | sort -nk 12,12 > cr.ip.c2
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 40 100 1.5  | sort -nk 12,12 > cr.ip.c3
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 80 160 1.25 | sort -nk 12,12 > cr.ip.c4

#   insert+range
wl="50 0 50"
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 10 40  2.5  | sort -nk 12,12 > cr.ir.c1
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 20 50  2    | sort -nk 12,12 > cr.ir.c2
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 40 100 1.5  | sort -nk 12,12 > cr.ir.c3
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 80 160 1.25 | sort -nk 12,12 > cr.ir.c4

#   insert+point+range
wl="10 60 30"
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 10 40  2.5  | sort -nk 12,12 > cr.ipr.c1
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 20 50  2    | sort -nk 12,12 > cr.ipr.c2
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 40 100 1.5  | sort -nk 12,12 > cr.ipr.c3
grep -v Nruns $fn | bash sort_rpl.sh $wl $nps 80 160 1.25 | sort -nk 12,12 > cr.ipr.c4

