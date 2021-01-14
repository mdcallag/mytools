d=$1
s=$2
dbms=$3
user=$4
pass=$5
# mysql=3306, pg=5432
port=$6
host=$7
maxsecs=$8
nworkers=$9
rdir=${10}

#d=28, s=100
#d=84, s=1000

d2=bm${d}x${s}

dn=$( dirname $0 )

for y in 12hr.scale${s} 7day.scale${s} 28day.scale${s}; do
# for y in 12hr.scale${s} ; do
mkdir -p $rdir/${y}.res
bash $dn/runq.sh $d2 $user $pass $port $host $dn/${y} $rdir/${y}.res true $dbms cpu-only.scale${s}.seed1 $maxsecs $nworkers | tee $rdir/${y}.res/o.${d}
done

