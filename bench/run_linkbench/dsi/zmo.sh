dev=$1

bash zmo1.sh  10000001 3600 /media/ephemeral1 $dev 12 12
mkdir 10m; mv a.* 10m

bash zmo2.sh 200000001 3600 /media/ephemeral1 $dev 12 12
mkdir 200m; mv a.* 200m
