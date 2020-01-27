egarg=$1

for t in s0 s1 ; do
  for d2 in c0.orig c0 c1 ; do
    bash proc.sh "$t/$d2" L1.P1 L2.P2 L3.P4 L4.P4
  done

  bash proc2.sh $t "$egarg" L1.P1 L2.P2 L3.P4 L4.P4
  mkdir pall.$t
  mv p.* pall.$t
done

