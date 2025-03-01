
#for dop in 1 2 4 8 12 16 20 24 28 30 40 50 60 ; do
for dop in 4 8 12 16 20 24 28 30 40 50 60 ; do
  bash r.sh 8 10000000 90 90 md1 1 1 $dop
  mkdir res.dop${dop}
  mv x.250219* res.dop${dop}
  #mv x.250219_hash6a6026e768.rxa1_c60r93.pk1 x.250219_hash6a6026e768.rxa1_c60r93.pk1.8tab.${dop}user
done
