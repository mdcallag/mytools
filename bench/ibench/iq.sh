e=$1
eo=$2
client=$3
data=$4
dname=$5
checku=$6
dop=$7
mongo=$8
short=$9
only1t=${10}
bulk=${11}
secatend=${12}
nr=${13}

bash np.sh $nr $e "$eo" 3 $client $data  $dop 10 20 0 $dname $only1t $checku 100 0 0 yes $mongo $short $bulk $secatend
mkdir l
mv o.* l

# Run for 5000 seconds regardless of concurrency
bash np.sh $(( 5000000 * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 100 1000 1 no $mongo $short 0 no
mkdir q1000
mv o.* q1000

# Run for 5000 seconds regardless of concurrency
bash np.sh $(( 500000 * $dop )) $e "$eo" 3 $client $data $dop 10 20 0 $dname $only1t 1 100 100 1 no $mongo $short 0 no
mkdir q100
mv o.* q100

