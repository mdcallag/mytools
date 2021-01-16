
#ips     qps     rps     rmbps   wps     wmbps   rpq     rkbpq   wpi     wkbpi   csps    cpups   cspq    cpupq   dbgb1   dbgb2   rss     maxop   p50     p99     tag
#139860  0       1238    4.8     51.3    32.2    0.009   0.035   0.000   0.236   15177   45.7    0.109   13      1.3     41.8    2.0     0.265   143193  18274   my5649.cx6d
#103093  0       0       0.0     73.3    43.2    0.000   0.000   0.001   0.429   12591   42.0    0.122   16      1.9     5.2     0.0     0.005   103490  82210   pg1110.cx5
#-
#85106   0       0       0.0     120.6   22.3    0.000   0.000   0.001   0.269   15506   40.7    0.182   19      1.3     41.9    2.5     0.118   85860   26992   my8022.cx6d
#105820  0       0       0.0     70.7    44.4    0.000   0.000   0.001   0.429   12878   42.8    0.122   16      1.9     5.2     0.0     0.004   106684  101415  pg131.cx5

BEGIN {
  baseSet = 0;
}
{
  if (NF == 21) {
    if ($1 == "ips") {
      print $0;
      baseSet = 0;
    } else if (baseSet == 1) {
      for (x=1; x < 21; x++) {
        if ($x == "NA" || baseVal[x] == "NA") { printf("NA\t"); }
        else if ($x == 0 && baseVal[x] == 0) { printf("1\t"); }
        else if (baseVal[x] == 0) { printf("inf\t"); }
        else { printf("%.2f\t", $x / baseVal[x]); }
      }
      printf("%s\n", $21);
    } else {
      baseSet = 1;
      for (x=1; x < 22; x++) { baseVal[x] = $x; }
    }
  } else {
     print $0;
     baseSet = 0;
  }
}


