d=$1
s=$2
dbms=$3
user=$4
pass=$5
# mysql=3306, pg=5432
port=$6
host=$7
maxsecs=$8

#d=28, s=100
#d=84, s=1000

d2=bm${d}x${s}

fast=1000
slow=100

for y in 12hr.scale${s} 7day.scale${s} 28day.scale${s}; do
mkdir -p ~/tsbs/${y}.r2
bash ~/tsbs/runq.sh $d2 $user $pass $port $host ~/tsbs/${y} ~/tsbs/${y}.r2 true $dbms cpu-only.scale${s}.seed1 $fast $slow $maxsecs | tee ~/tsbs/${y}.r2/o.${d}
done

