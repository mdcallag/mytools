BEGIN {
  chdl = ""; chd = ""; cx = 0; chco = ""; maxv = 0;
  c[0] = "FF0000"; c[1] = "00FF00"; c[2] = "0000FF";
  c[3] = "FFFF00"; c[4] = "FF00FF"; c[5] = "00FFFF";
  c[6] = "000000"; c[7] = "800000"; c[8] = "008000";
  c[9] = "000080"; c[10] = "808000"; c[11] = "800080";
}

// {
  if (chdl == "") { chdl = "chdl=" $1 } else { chdl = chdl "|" $1 }

  for (i = 3; i <= NF; i++) { if ($i > maxv) { maxv = $i } }

  d = sprintf("%.0f", $3);
  for (i = 4; i <= NF; i++) { if ($i == 0) { $i = -1 }; d = d "," sprintf("%.0f", $i) }

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
  chxl = "chxl=" "0:|1|2|4|8|16|32|64" "|2:|Concurrent users|" "|3:|Throughput|"
  chxp = "chxp=2,50|3,50"
  maxy = sprintf("%.0f", maxv);
  maxv = "chds=0," sprintf("%.0f", maxv);

  # print base chs "&" type1 "&" type2 "&" chd "&" chdl "&" title "&" chco "&" maxv
  print base chs "&" type1 "&" type2 "&" chd "&" chdl "&" title "&" chco "&" maxv "&" "chxr=1,0," maxy "&" chxl "&" chxp "&" "chg=10,10"
}
