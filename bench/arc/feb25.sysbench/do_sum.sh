

#x.pg1211.x5.pk1  x.pg137.x5.pk1  x.pg143.x5.pk1  x.pg15b1.x5.pk1

nc=1
for r in 0 1; do
echo sumr $r
bash ../sumr.sh sb.r.qps x.pg1211.x5.pk1 $nc $r x.pg137.x5.pk1 x.pg143.x5.pk1 x.pg15b1.x5.pk1 | sed 's/sb\.r\.qps\.//g' | sed 's/sb\.prepare\.o\.//g' | grep -v read\-write\.range100\.pk1 > o.sumr.r${r}.pg
#bash ../sumr.sh sb.r.qps x.fbmy5635.y9c.pk1 $nc $r x.fbmy8020.y9c.pk1 | sed 's/sb\.r\.qps\.//g' | sed 's/sb\.prepare\.o\.//g' | grep -v read\-write\.range100\.pk1 > o.sumr.r${r}.fbmy.1 
done

dop=1
echo sum_met
bash ../sum_met.sh sb.met x.pg1211.x5.pk1 $dop x.pg137.x5.pk1 x.pg143.x5.pk1 x.pg15b1.x5.pk1 | sed 's/sb\.met\.//g' | sed 's/sb\.prepare\.met\.//g' > o.summ.pg
#bash ../sum_met.sh sb.met x.fbmy5635.y9c.pk1 $dop x.fbmy8020.y9c.pk1 | sed 's/sb\.met\.//g' | sed 's/sb\.prepare\.met\.//g' > o.summ.fbmy.1
