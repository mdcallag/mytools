fn=$1
client=$2
ddir=$3
maxid=$4
dname=$5
wdop=$6
secs=$7
myORmo=$8
ddl=$9
dbhost=${10}
ldop=${11}

echo Load at $( date )
bash load.sh $fn $client $ddir $maxid $dname $ldop true $myORmo $ddl $dbhost

# Warmup
echo Warmup at $( date )
bash run.sh $fn.W.P${wdop} $client $ddir $maxid $dname $wdop $secs $myORmo $dbhost

shift 11

loop=1
if [[ $# -gt 0 ]]; then
  doparr=( "$@" )

  for mydop in "${doparr[@]}" ; do
    echo Run dop=$mydop at $( date )
    bash run.sh $fn.L${loop}.P${mydop} $client $ddir $maxid $dname $mydop $secs $myORmo $dbhost
    loop=$(( $loop + 1 ))
  done
fi


