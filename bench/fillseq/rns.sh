for ns in 1 2 4 8 16 32; do bash r.nstream.sh 100000000 $ns ; done
for ns in 64 128 256 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 ;  do bash r.nstream.sh 100000000 $ns ; done
