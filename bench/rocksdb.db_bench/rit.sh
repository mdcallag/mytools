nsecs=$1

for t in 1 2; do for b in 1 8 ; do
echo run t $t and b $b at $( date )
ps aux | grep db_bench | grep -v grep
ps aux | grep all4 | grep -v grep
bash run4.sh 100000000 64 $nsecs 8 32 $(( $b * 1024 * 1024 )) $t >& a.t$t.b$b
mkdir t$t.b$b
mv a.t$t.b$b t$t.b$b
mv res.* t$t.b$b
done
done
