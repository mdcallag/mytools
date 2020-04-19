dev=$1

bash zmy1.sh  10000001 3600 /media/ephemeral1 $dev 16 16
mkdir 10m; mv a.* 10m

bash zmy2.sh 200000001 3600 /media/ephemeral1 $dev 16 16
mkdir 200m; mv a.* 200m

