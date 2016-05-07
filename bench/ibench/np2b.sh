e=$1
eo=$2
client=$3
data=$4
dname=$5
checku=$6
dop=$7
mongo=$8

bash np.sh 2000000000 $e "$eo" 3 $client $data  $dop 10 20 0 $dname no $checku 100 0 0 yes $mongo
mkdir l
mv o.* l

bash np.sh 100000000 $e "$eo" 3 $client $data $dop 10 20 0 $dname no 1 100 2000 1 no $mongo
mkdir q2000
mv o.* q2000

bash np.sh  50000000 $e "$eo" 3 $client $data $dop 10 20 0 $dname no 1 100 1000 1 no $mongo
mkdir q1000
mv o.* q1000

bash np.sh   5000000 $e "$eo" 3 $client $data $dop 10 20 0 $dname no 1 100 100 1 no $mongo
mkdir q100
mv o.* q100

