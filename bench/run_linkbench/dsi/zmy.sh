dev=$1

heap=2000

bash zmy1.sh  4000001 1800 /media/ephemeral1 $dev 1 1 $heap 1 2 4 8
mkdir 4m; mv a.* 4m

bash zmy1.sh  10000001 3600 /media/ephemeral1 $dev 8 8 $heap 8 8 12 12 16 16
mkdir 10m; mv a.* 10m

bash zmy2.sh 200000001 3600 /media/ephemeral1 $dev 8 8 $heap 8 8 12 12 16 16
mkdir 200m; mv a.* 200m

