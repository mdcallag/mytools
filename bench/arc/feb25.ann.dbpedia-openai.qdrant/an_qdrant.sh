
plotf=$1
quant=$2

# Qdrant((m=8, ef_construct=96, quantization=none, hnsw_ef=20)        0.926      987.192

while read a1 a2 ; do 
  echo
  for efs in 10 20 30 40 80 120 200 300 400 ; do
    grep Qdrant $plotf | grep "m=$a1" | grep "construct=$a2" | grep "hnsw_ef=$efs" | grep "quantization=$quant" | \
        awk '{ printf "%s %.1f     %s %s %s %s\n", $5, $6, $1, $2, $3, $4 }'
  done
done < ../args.qdrant > qr.qdrant.$quant
sort -rnk 1,1 qr.qdrant.$quant | awk '{ if (NF == 6) { print $0 }}' > qr.qdrant.$quant.recall
sort -rnk 2,2 qr.qdrant.$quant | awk '{ if (NF == 6) { print $0 }}' > qr.qdrant.$quant.qps

