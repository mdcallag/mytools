

nc=1
for r in 0 1; do
bash ../sumr.sh sb.r.qps x.my5649.y8.pk1 $nc $r x.my5735.y8.pk1 x.my8020.y8.pk1 x.my8022.y8.pk1 x.my8023.y8.pk1 x.my8026.y8.pk1 x.my8027.y8.pk1 | sed 's/sb\.r\.qps\.//g' | sed 's/sb\.prepare\.o\.//g' | grep -v read\-write\.range100\.pk1 > o.sumr.r${r}.my
bash ../sumr.sh sb.r.qps x.pg124.x5.pk1 $nc $r x.pg134.x5.pk1 x.pg140.x5.pk1 | sed 's/sb\.r\.qps\.//g' | sed 's/sb\.prepare\.o\.//g' | grep -v read\-write\.range100\.pk1 > o.sumr.r${r}.pg
bash ../sumr.sh sb.r.qps x.fbmy5635.y9c.pk1 $nc $r x.fbmy8020.y9c.pk1 | sed 's/sb\.r\.qps\.//g' | sed 's/sb\.prepare\.o\.//g' | grep -v read\-write\.range100\.pk1 > o.sumr.r${r}.fbmy.1 
bash ../sumr.sh sb.r.qps x.fbmy5635.y9c.pk1 $nc $r x.fbmy5635.y9a.pk1 x.fbmy5635.y9b.pk1 x.fbmy5635.y9c0.pk1 x.fbmy5635.y9c1.pk1 x.fbmy5635.y9c2.pk1 x.fbmy5635.y13a.pk1 x.fbmy5635.y13b.pk1 | sed 's/sb\.r\.qps\.//g' | sed 's/sb\.prepare\.o\.//g' | grep -v ead\-write\.range100\.pk1 > o.sumr.r${r}.fbmy.2 2> e.r${r}.2
done


dop=1
bash ../sum_met.sh sb.met x.my5649.y8.pk1 $dop x.my5735.y8.pk1 x.my8020.y8.pk1 x.my8022.y8.pk1 x.my8023.y8.pk1 x.my8026.y8.pk1 x.my8027.y8.pk1 | sed 's/sb\.met\.//g' | sed 's/sb\.prepare\.met\.//g' > o.summ.my
bash ../sum_met.sh sb.met x.pg124.x5.pk1 $dop x.pg134.x5.pk1 x.pg140.x5.pk1 | sed 's/sb\.met\.//g' | sed 's/sb\.prepare\.met\.//g' > o.summ.pg
bash ../sum_met.sh sb.met x.fbmy5635.y9c.pk1 $dop x.fbmy8020.y9c.pk1 | sed 's/sb\.met\.//g' | sed 's/sb\.prepare\.met\.//g' > o.summ.fbmy.1
bash ../sum_met.sh sb.met x.fbmy5635.y9c.pk1 $dop x.fbmy5635.y9a.pk1 x.fbmy5635.y9b.pk1 x.fbmy5635.y9c0.pk1 x.fbmy5635.y9c1.pk1 x.fbmy5635.y9c2.pk1 x.fbmy5635.y13a.pk1 x.fbmy5635.y13b.pk1 | sed 's/sb\.met\.//g' | sed 's/sb\.prepare\.met\.//g' > o.summ.fbmy.2 2> e.m.2
