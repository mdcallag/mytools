z=$1
#dur=1800
dur=$2
#cfg=c40r256bc180
#cfg=c40r256
cfg=$3

k1=6000000000
k2=3000000000
k3=1500000000
k4=750000000

#k1=3000000000
#k2=1500000000
#k3=750000000
#k4=375000000

bash x3.val.sh 32 no $dur $cfg 40000000 $k1 400 $z
echo "mv res.$z res.$z.6b.400b"
mv res.$z res.$z.6b.400b

bash x3.val.sh 32 no $dur $cfg 40000000 $k2 800 $z
echo "mv res.$z res.$z.3b.800b"
mv res.$z res.$z.3b.800b

bash x3.val.sh 32 no $dur $cfg 40000000 $k3 1600 $z
mv res.$z res.$z.1500m.1600b

bash x3.val.sh 32 no $dur $cfg 40000000 $k4 3200 $z
mv res.$z res.$z.750m.3200b
