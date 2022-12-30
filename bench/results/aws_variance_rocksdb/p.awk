{
  if (index($1, "ops_sec")) {
    print $0; x=1; s=0;
  } else if (x >= 1 && x <= 3) {
    s += $1; va[x]=$1; x += 1; print $0;
  } else if (x == 4) {
    x = 5; m = s/3; s2 = 0;
    for (i=1; i<4; i += 1) {
      d = m - va[i];
      s2 += (d * d);
    }
    s2 = s2 / 3
    sdev = sqrt(s2);
    printf "mean=%s\tstddev=%.1f\tsdev/mean=%.3f\n\n", m, sdev, sdev/m
  } else {
    print $0
  }
}
