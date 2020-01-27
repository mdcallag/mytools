for s in s0 s1 ; do
for d in mem io ; do
  fna=g.$s.$d
  echo "LOAD" > $fna
  echo l.pre sync $s, data $d >> $fna
  cat pall.$s/p.l.pre.eff.op.$d >> $fna
  echo >> $fna
  cat pall.$s/p.l.pre.eff.sec.$d >> $fna
  echo >> $fna
  cat pall.$s/p.l.rt.$d >> $fna

  echo >> $fna
  echo "QUERY" >> $fna
  for p in L1.P1 L3.P4 L4.P4 ; do
    echo r $p  >> $fna
    cat pall.$s/p.r.eff.op.${p}.$d >> $fna
    echo >> $fna
    cat pall.$s/p.r.eff.sec.${p}.$d >> $fna
    echo >> $fna
    cat pall.$s/p.r.rt.node.${p}.$d >> $fna
    echo >> $fna
    cat pall.$s/p.r.rt.link.${p}.$d >> $fna
  done
done
done
