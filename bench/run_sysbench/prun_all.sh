nr=$1
h=$2
dop=$3
secs=$4
prepare=$5
t=$6
warmup=$7
# yes|no for use innodb compression
c=$8
u=$9
e=${10}

pk=yes
range=10
restart=no

if [ $prepare == "yes" ]; then

for b in orig5710 ; do

bash prun.sh 1 /data/mysql yes root pw test $e $nr 30 $t yes no yes $h $pk u no 1 $u $c $restart $b
done

mkdir -p m.prep; mv sb.* m.prep
exit
fi

for b in orig5710 ; do

echo Run prun
bash prun.sh $dop /data/mysql yes root pw test $e $nr $secs $t no no yes $h $pk u $warmup $range $u $c $restart $b 

mkdir -p m.${t}
mv -f sb.* m.${t}

done
exit

