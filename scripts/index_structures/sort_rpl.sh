
# Input looks like this:
# L	F	wa-I	wa-C	sa	ca	Nruns	ph	pm	rs	rn
# ZL2	L	207.8	33.0	1.01	0.004	3	62.1	62.0	78.0	2.2
# ZL3	L	65.0	34.0	1.04	0.004	4	73.7	73.0	105.0	2.3

if [ $# -ne 7 ]; then
  echo "requires 6 args: pct-i pct-p pct-r nps max-wa-io max-wa-cpu max-sa"
  echo "  pct-i, pct-p, prt-r: percentage of ops that are insert, point, range"
  echo "  nps: number of calls to range-next per range-seek"
  echo "  max-wa-io: ignore configs with IO write-amp that exceeds this"
  echo "  max-wa-cpu: ignore configs with CPU write-amp that exceeds this"
  echo "  max-sa: ignore configs with space-amp that exceeds this"
  exit 1
fi

pcti=$1
pctp=$2
pctr=$3
nps=$4
maxwai=$5
maxwac=$6
maxsa=$7

if [ $(( ($pctp + $pctr + $pcti) )) -ne 100 ]; then
  echo pct-i, pct-p and pct-r must sum to 100
  exit 1
fi

#echo $pcti $pctp $pctr $nps
awk '{ if ($3 <= maxwai && $4 <= maxwac && $5 <= $maxsa) { printf "%s\t%.1f\n", $0, ((pctp * $8) + (pctr * ($10 + ($11 * nps))) + (pcti * $4)) / 100.0 } }' \
    pcti=$pcti pctp=$pctp pctr=$pctr nps=$nps maxsa=$maxsa maxwac=$maxwac maxwai=$maxwai
