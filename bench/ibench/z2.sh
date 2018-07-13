
bd=/data/users/mcallaghan/orig5635
e=innodb
et=inno.o5635

for nthr in 16 32 ; do
for onet in no yes; do
cd $bd; bash ini.sh >& o.i; cd /data/users/mcallaghan/ibench; sleep 10
bash iq.sh $e "" $bd/bin/mysql $bd/data md2 1 $nthr no no $onet 0 no 2000000000 no 
mkdir my.2b.${nthr}c.onet.${onet}.${et}
mv l scan q100* my.2b.${nthr}c.onet.${onet}.${et}
sleep 60
done
done

