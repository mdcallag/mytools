t1=$1
t2=$2
tag=$3

bash r.sh 1 30000000 $t1 $t2 $( df -h | awk '{ if ( $6 == "/data" ) { print $1 } }' | tr '/' ' ' | awk '{ print $2 }' ) 1 1 1
mkdir $tag.dop1 ; mv x.* $tag.dop1

bash r.sh 1 30000000 $t1 $t2 $( df -h | awk '{ if ( $6 == "/data" ) { print $1 } }' | tr '/' ' ' | awk '{ print $2 }' ) 1 1 6
mkdir $tag.dop6 ; mv x.* $tag.dop6
