tag=$1

bash r.sh 1 50000000 600 900 $( df -h | awk '{ if ( $6 == "/data" ) { print $1 } }' | tr '/' ' ' | awk '{ print $2 }' ) 1 1 1
mkdir res.dop1.$tag
mv x.* res.dop1.$tag

bash r.sh 4 20000000 300 600 $( df -h | awk '{ if ( $6 == "/data" ) { print $1 } }' | tr '/' ' ' | awk '{ print $2 }' ) 1 1 4
mkdir res.dop4.$tag
mv x.* res.dop4.$tag

