
bd=/data/users/mcallaghan/orig803
e=innodb
et=inno.o803

for nthr in 52 48 44 40 36 32 28 24 20 16 12 8 4 2 1 ; do
cd $bd; bash ini.sh >& o.i; cd /data/users/mcallaghan/ibench; sleep 10
bash iq.sh $e "" $bd/bin/mysql $bd/data md2 1 $nthr no no no 0 no 500000000 yes
mkdir my.500m.${nthr}c.${et}.so
mv l scan q100* my.500m.${nthr}c.${et}.so
done

cd $bd; bash ini.sh >& o.i; cd /data/users/mcallaghan/ibench; sleep 10
bash iq.sh $e "" $bd/bin/mysql $bd/data md2 1 1 no no no 0 no 100000000 no 
mkdir my.100m.1t.${et}
mv l scan q100* my.100m.1t.${et}

for nthr in 16 32 ; do
for onet in no yes; do
cd $bd; bash ini.sh >& o.i; cd /data/users/mcallaghan/ibench; sleep 10
bash iq.sh $e "" $bd/bin/mysql $bd/data md2 1 $nthr no no $onet 0 no 500000000 no 
mkdir my.500m.${nthr}c.onet.${onet}.${et}
mv l scan q100* my.500m.${nthr}c.onet.${onet}.${et}
done
done

