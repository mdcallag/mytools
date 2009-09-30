d=$1

mkdir -p $d/r8
for e in myisam innodb blackhole; do
for t in rs hs ps; do 
for b in 5084fm2 5084dev 5084noalarm 5138orig 5138fb ; do
  echo $t $b $e
  bash run.sh 8 /data yes root pw mysqlslap no $e 1000 5000000 t no $t $b
  mv ls.*${e}* $d/r8
done
done
done

mkdir -p $d/gp8
for e in myisam innodb blackhole; do
for t in rs hs ps; do
for b in 5084gp 5084gpnoalarm ; do
  CPUPROFILE_FREQUENCY=500; rm -f /data/$b/gp.out; echo $t $b $e 8
  bash run.sh 8 /data yes root pw mysqlslap no $e 1000 5000000 t no $t $b
  mv /data/$b/gp.out $d/gp8/$t.$b.$e.gp
  mv ls.*${e}* $d/gp8
done
done
done

mkdir -p $d/gp1
for e in myisam innodb blackhole; do
for t in rs hs ps; do 
for b in 5084gp 5084gpnoalarm ; do 
  CPUPROFILE_FREQUENCY=500; rm -f /data/$b/gp.out; echo $t $b 1
  bash run.sh 1 /data yes root pw mysqlslap no $e 1000 5000000 t no $t $b
  mv /data/$b/gp.out $d/gp1/$t.$b.$e.gp
  mv ls.*${e}* $d/gp1
done
done
done

