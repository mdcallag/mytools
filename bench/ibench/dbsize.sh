client=$1
host=$2
outname=$3
# database name: ib, etc
dbid=$4
dbms=$5
ddir=$6

moauth="--authenticationDatabase admin -u root -p pw"
myauth="-uroot -ppw"
pgauth="$dbid"

if [[ $dbms == "mongo" ]]; then
  echo "show dbs" | $client $moauth --host $host | grep $dbid | awk '{ print $2 }' | sed 's/GB//g' > $outname
elif [[ $dbms == "mysql" ]]; then
  # SHOW TABLE STATUS and IS.innodb_tablestats are not reliable
  # pageSize=$( $client $myauth -E -e 'show global variables like "innodb_page_size"' | grep "Value:" | awk '{ print $2 }' )
  # nPages=$( $client $myauth information_schema -E -e "select sum(clust_index_size + other_index_size) as npages from innodb_tablestats where name like \"${dbid}/pi%\"" | grep "npages:" | awk '{ print $2 }' )
  # echo $pageSize $nPages | awk '{ printf "%.3f\n", ($1 * $2) / (1024*1024*1024)}' > $outname

  iwc=$( $client $myauth $dbid -e "SHOW TABLE STATUS" | grep -i InnoDB | wc -l )
  rwc=$( $client $myauth $dbid -e "SHOW TABLE STATUS" | grep -i RocksDB | wc -l )

  if [[ $iwc -ge 1 ]]; then
    du -bs $ddir/data/$dbid | awk '{ printf "%.3f\n", $1 / (1024*1024*1024) }' > $outname
  elif [[ $rwc -ge 1 ]]; then
    # This has the size for all data in RocksDB, not just in $dbid
    du -bs $ddir/data/.rocksdb | awk '{ printf "%.3f\n", $1 / (1024*1024*1024) }' > $outname
  else
    echo "dbsize failed: not InnoDB or RocksDB"
    exit -1
  fi
elif [[ $dbms == "postgres" ]]; then
  $client $pgauth -x -c "SELECT pg_database_size('${dbid}') / (1024*1024*1024.0) as gb" | grep "^gb" | awk '{ print $3 }' > $outname
else
  echo $dbms not supported
  exit -1
fi
