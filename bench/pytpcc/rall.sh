v=$1

w=1024
secs=1200

ldop=4; bash all2.sh $w $ldop $secs yes $v 1 8 16 32 48 64 80
for ldop in 8 12 16 24 32 48 64 80 ; do bash all2.sh $w $ldop $secs yes $v ; done
