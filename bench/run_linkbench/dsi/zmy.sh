dev=$1

bash zmy1.sh  10000001 3600 /media/ephemeral1 $dev 1 1 1
mkdir 10m; mv a.* 10m

bash zmy1.sh  10000001 3600 /media/ephemeral1 $dev 8 8 2 4 8 8 8 8
mkdir 10m; mv a.* 10m

bash zmy2.sh 200000001 3600 /media/ephemeral1 $dev 12 12 2 4 8 12 12 12
mkdir 200m; mv a.* 200m

