
rsecs=180
wsecs=180

for dop in 4 ; do
  bash r.sh 1 50000000 $rsecs $wsecs md2 1 1 $dop
  mkdir res.dop${dop}.$rsecs.$wsecs
  mv x.* res.dop${dop}.$rsecs.$wsecs
done

for dop in 8 12 16 20 24 32 40 48 ; do
  bash r.sh 8 10000000 $rsecs $wsecs md2 1 1 $dop
  mkdir res.dop${dop}.$rsecs.$wsecs
  mv x.* res.dop${dop}.$rsecs.$wsecs
done
