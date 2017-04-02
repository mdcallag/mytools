fn=$1
client=$2
ddir=$3
maxid=$4
dname=$5
qdop=$6
secs=$7
myORmo=$8
ddl=$9
loops=${10}
dbhost=${11}
ldop=${12}

benchdir=$PWD

echo Load
bash load.sh $fn $client $ddir $maxid $dname $ldop true $myORmo $ddl $dbhost

for loop in $( seq 1 $loops ); do
bash run.sh $fn.L${loop}.P${qdop} $client $ddir $maxid $dname $qdop $secs $myORmo $dbhost
done

shift 12

if [[ $# -gt 0 ]]; then
  doparr=( "$@" )

  for mydop in "${doparr[@]}" ; do
    loop=$(( $loop + 1 ))
    bash run.sh $fn.L${loop}.P${mydop} $client $ddir $maxid $dname $mydop $secs $myORmo $dbhost
  done
fi


