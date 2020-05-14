for d1 in 80m.* ; do for d2 in l q1000 q100 ; do bash rth.sh ${d1} ${d2} 8 "Insert rt" > ${d1}/${d2}/o.rt.c.insert ; done; done
for d1 in 320m.* ; do for d2 in l q1000 q100 ; do bash rth.sh ${d1} ${d2} 8 "Insert rt" > ${d1}/${d2}/o.rt.c.insert ; done; done

for d1 in 320m.* ; do for d2 in l q1000 q100 ; do bash rth.sh ${d1} ${d2} 8 "Insert rt" | tr ',' '\t' > ${d1}/${d2}/o.rt.t.insert ; done; done
for d1 in 80m.* ; do for d2 in l q1000 q100 ; do bash rth.sh ${d1} ${d2} 8 "Insert rt" | tr ',' '\t' > ${d1}/${d2}/o.rt.t.insert ; done; done

for d1 in 320m.* ; do for d2 in l q1000 q100 ; do bash rth.sh ${d1} ${d2} 8 "Query rt" > ${d1}/${d2}/o.rt.c.query ; done; done
for d1 in 80m.* ; do for d2 in l q1000 q100 ; do bash rth.sh ${d1} ${d2} 8 "Query rt" > ${d1}/${d2}/o.rt.c.query ; done; done

for d1 in 80m.* ; do for d2 in l q1000 q100 ; do bash rth.sh ${d1} ${d2} 8 "Query rt" | tr ',' '\t' > ${d1}/${d2}/o.rt.t.query ; done; done
for d1 in 320m.* ; do for d2 in l q1000 q100 ; do bash rth.sh ${d1} ${d2} 8 "Query rt" | tr ',' '\t' > ${d1}/${d2}/o.rt.t.query ; done; done
