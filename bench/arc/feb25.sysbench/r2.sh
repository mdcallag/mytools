t1=$1
t2=$2
tag=$3
dop1=$4
dop2=$5
ntabs=$6
nrows=$7

bash r.sh $ntabs $nrows $t1 $t2 $( df -h | awk '{ if ( $6 == "/data" ) { print $1 } }' | tr '/' ' ' | awk '{ print $2 }' ) 1 1 $dop1
mkdir $tag.dop${dop1} ; mv x.* $tag.dop${dop1}

bash r.sh $ntabs $nrows $t1 $t2 $( df -h | awk '{ if ( $6 == "/data" ) { print $1 } }' | tr '/' ' ' | awk '{ print $2 }' ) 1 1 $dop2
mkdir $tag.dop${dop2} ; mv x.* $tag.dop${dop2}

