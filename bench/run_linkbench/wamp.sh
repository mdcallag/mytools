udir=$1

startFWB=$( grep rocksdb_flush_write_bytes $udir/l.post.gs.* | awk '{ print $2 }' )
startCWB=$( grep rocksdb_compact_write_bytes $udir/l.post.gs.* | awk '{ print $2 }' )

endFWB=$( grep rocksdb_flush_write_bytes $udir/r.gs.*.L3.P* | awk '{ print $2 }' )
endCWB=$( grep rocksdb_compact_write_bytes $udir/r.gs.*.L3.P* | awk '{ print $2 }' )

cGB=$( echo "( $endCWB - $startCWB) / ( 1024 * 1024 * 1024 )" | bc -l | awk '{ printf "%.3f", $1 }' )
fGB=$( echo "( $endFWB - $startFWB) / ( 1024 * 1024 * 1024 )" | bc -l | awk '{ printf "%.3f", $1 }' )
wamp=$( echo "( $endCWB - $startCWB) / ( $endFWB - $startFWB )" | bc -l | awk '{ printf "%.1f", $1 }' )

printf "$wamp\t$cGB\t$fGB\t(wamp, cGB, fGB) for $udir\n"

