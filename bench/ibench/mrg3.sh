sumdir=$1
resdir=$2
rmprefix=$3

# echo mrg3: $@

shift 3

bdir=$( dirname $0 )

farr=("$@")
f1=$sumdir/o.sum.t.${farr[0]}

# new
# ips     qps     rps     rkbps   wkbps   rpq     rkbpq   wkbpi   csps    cpups   cspq    cpupq   dbgb1   dbgb2   rss     maxop   p50     p90     tag
# 75472   0       0.0     0       30937   0.000   0.000   0.410   6822    11.1    0.090   24      0.390   1.101   0.0     0.004   75813   75415   4m.pg123.c8b40

# prev
# ips     qps     rps     rkbps   wkbps   rpq     rkbpq   wkbpq   csps    cpups   cspq    cpupq   ccpupq  dbgb    vsz     rss     maxop   p50     p90     tag
# 1846.5        0       0.0     0       252327  0.000   0.000   1.315   21711   63.0    0.113   53      2       55      NA      NA      0.458   28103.5 4253.4  pg12.c7b40

linemap=( none none l.i0 l.x l.i1 l.i2 qr100.L1 qp100.L2 qr500.L3 qp500.L4 qr1000.L5 qp1000.L6 )
alen=${#linemap[@]}

for x in $( seq 2 $(( $alen - 1 )) ) ; do
  outf="mrg.${linemap[$x]}"
  # echo mrg3: x is $x, outf is $outf
  # echo "f1 is :: $f1 ::"
  head -1 $f1 > $resdir/$outf
  for inf in "$@"; do
    inf2=$sumdir/o.sum.t.$inf
    if [ $inf != "BREAK" ]; then
      head -${x} $inf2 | tail -1 | \
        awk -v FS='\t' -v OFS='\t' '{ $1=sprintf("%.0f", $1); $2=sprintf("%.0f", $2); $3=sprintf("%.0f", $3); if ($16 >= 10) { $16=sprintf("%.1f", $16) } print $0 }'
        # awk -v FS='\t' -v OFS='\t' '{ $1=sprintf("%.0f", $1); $2=sprintf("%.0f", $2); $3=sprintf("%.0f", $3); $18=sprintf("%.0f", $18); $19=sprintf("%.0f", $19); print $0 }'
    else
      echo "-"
    fi
  done | sed "s/${rmprefix}\.//g" >> $resdir/$outf
done

# i0, x, l1 -> lines 2,3,4
#100,100 -> lines 5,6
#200,200 -> lines 7,8
#400,400 -> lines 9,10
#600,600 -> lines 11,12
#800,800 -> lines 13,14
#1000,1000 -> lines 15,16

#ips     qps     rps     rkbps   wkbps   rpq     rkbpq   wkbpq   csps    cpups   cspq    cpupq   ccpupq  dbgb    vsz     rss     maxop   p50     p90     tag
#212766  0       0.0     0       43606   0.000   0.000   0.205   22236   39.3    0.105   30      1       1.2     1.2     0.6     0.189   64342.7 48308.4 10m.rx56.c5b40
#250250  0       3.7     102     19580   0.000   0.000   0.078   551     13.0    0.002   8       0       1.9     2.4     1.3     0.019   NA      NA      10m.rx56.c5b40
#27778   0       0.0     0       7806    0.000   0.000   0.281   2785    8.1     0.100   47      1       2.0     2.4     1.2     0.014   NA      NA      10m.rx56.c5b40
#816     18376   711.4   6814    15159   0.039   0.371   0.825   74893   41.0    4.076   357     11      2.1     3.6     2.3     0.041   NA      NA      10m.rx56.c5b40
#816     19291   0.0     0       163     0.000   0.000   0.008   77421   40.7    4.013   338     11      2.1     3.7     2.3     0.015   NA      NA      10m.rx56.c5b40
#1631    19460   0.0     0       318     0.000   0.000   0.016   76965   40.9    3.955   336     11      2.1     3.7     2.3     0.026   NA      NA      10m.rx56.c5b40
#1631    19507   0.0     0       319     0.000   0.000   0.016   77099   41.2    3.952   338     11      2.1     3.7     2.4     0.026   NA      NA      10m.rx56.c5b40
#3262    19184   0.0     0       1430    0.000   0.000   0.075   75677   42.0    3.945   350     11      2.3     3.7     2.4     0.032   NA      NA      10m.rx56.c5b40
#3262    18981   0.0     0       1419    0.000   0.000   0.075   75171   41.8    3.960   352     11      2.4     3.7     2.4     0.023   NA      NA      10m.rx56.c5b40
#4893    18671   0.0     0       1739    0.000   0.000   0.093   73993   42.7    3.963   366     11      2.6     3.8     2.4     0.031   NA      NA      10m.rx56.c5b40
#4893    18402   0.0     0       946     0.000   0.000   0.051   73160   42.6    3.976   370     11      2.6     3.8     2.5     0.030   NA      NA      10m.rx56.c5b40
#6524    18540   0.0     0       5954    0.000   0.000   0.321   73982   43.5    3.990   375     11      2.8     4.0     2.7     0.031   NA      NA      10m.rx56.c5b40
#6524    18243   0.0     0       2053    0.000   0.000   0.113   72926   43.0    3.997   377     11      3.0     4.1     2.8     0.036   NA      NA      10m.rx56.c5b40
#8155    17764   0.0     0       2359    0.000   0.000   0.133   71272   43.5    4.012   392     12      3.1     4.1     2.9     0.034   NA      NA      10m.rx56.c5b40
#8155    18114   0.0     0       9270    0.000   0.000   0.512   72291   44.2    3.991   390     11      3.4     4.6     3.2     0.035   NA      NA      10m.rx56.c5b40
