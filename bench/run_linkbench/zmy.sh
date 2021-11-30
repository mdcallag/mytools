dev=$1
heap=2000

# bash zmy1.sh  2000001 $(( 3600 * 1 )) /home/mdcallag/d $dev 1 1 $heap 1 1 1
bash zmy1.sh  2000001 60 /home/mdcallag/d $dev 1 1 $heap 1 
mkdir 2m; mv a.* 2m

#bash zmy1.sh 100000001 $(( 3600 * 2 )) /home/mdcallag/d $dev 1 1 $heap 1 1 1
#mkdir 100m; mv a.* 100m

