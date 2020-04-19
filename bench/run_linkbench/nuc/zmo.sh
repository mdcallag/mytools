dev=$1

bash zmo1.sh   2000001 3600 /home/mdcallag/d $dev 16 16
mkdir 2m; mv a.* 2m

bash zmo1.sh  20000001 3600 /home/mdcallag/d $dev 16 16
mkdir 20m; mv a.* 20m

bash zmo2.sh 100000001 3600 /home/mdcallag/d $dev 16 16
mkdir 100m; mv a.* 100m
