BEGIN {
  chdl = ""; chd = ""; cx = 0; chco = ""; maxv = 0;
  c[0] = "FF0000"; c[1] = "00FF00"; c[2] = "0000FF";
  c[3] = "FFFF00"; c[4] = "FF00FF"; c[5] = "00FFFF";
  c[6] = "000000"; c[7] = "800000"; c[8] = "008000";
  c[9] = "000080"; c[10] = "808000"; c[11] = "800080";
}

function pow2(x) {
  s = 1;
  while (x > 0) {
    s *= 2;
    x -= 1;
  }
  return s;
}

function scale_val(val, x) {
  if (mul > 1) {
    return ((mul * pow2(x - 3))  / val);
  } else {
    return val;
  }
}

// {
  if (chdl == "") { chdl = "chdl=" $1 "-" $2 } else { chdl = chdl "|" $1 "-" $2 }

  for (i = 3; i <= NF; i++) { scale_i = scale_val($i, i); if (scale_i > maxv) { maxv = scale_i } }
  maxf=NF

  d = sprintf("%.0f", scale_val($3, 3));
  for (i = 4; i <= NF; i++) { if ($i == 0) { $i = -1 }; d = d "," sprintf("%.0f", scale_val($i, i)) }

  if (chd == "") { chd = "chd=t:" d } else { chd = chd "|" d }

  if (chco == "") { chco = "chco=" c[cx] } else { chco = chco "," c[cx] }
  cx = cx + 1;
}

END {
  base = "http://chart.apis.google.com/chart?";
  chs = "chs=400x200";
  type1 = "cht=lc";
  type2 = "chxt=x,y,x,y";
  title = "chtt=" tt
  flds="1"
  for (i = 4; i <= NF; i++) { flds = flds "|" pow2(i-3) }
  chxl = "chxl=" "0:|" flds "|2:|Concurrent users|" "|3:|QPS|"
  chxp = "chxp=2,50|3,50"
  maxy = sprintf("%.0f", maxv);
  maxv = "chds=0," sprintf("%.0f", maxv);

  # print base chs "&" type1 "&" type2 "&" chd "&" chdl "&" title "&" chco "&" maxv
  print base chs "&" type1 "&" type2 "&" chd "&" chdl "&" title "&" chco "&" maxv "&" "chxr=1,0," maxy "&" chxl "&" chxp "&" "chg=10,10"
}
