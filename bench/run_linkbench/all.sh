fn=$1
client=$2
ddir=$3
maxid=$4
dname=$5
dop=$6
secs=$7
myORmo=$8
ddl=$9
loops=${10}

benchdir=$PWD

echo Load
bash load.sh $fn $client $ddir $maxid $dname 1 true $myORmo $ddl

for loop in $( seq 1 $loops ); do
bash run.sh $fn.L${loop}.P${dop} $client $ddir $maxid $dname $dop $secs $myORmo
done

shift 10

if [[ $# -gt 0 ]]; then
  doparr=( "$@" )

  for mydop in "${doparr[@]}" ; do
    loop=$(( $loop + 1 ))
    bash run.sh $fn.L${loop}.P${mydop} $client $ddir $maxid $dname $mydop $secs $myORmo
  done
fi


