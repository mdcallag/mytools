nw=$1
engine=$2
mysql=$3
ddir=$4
myu=$5
myp=$6
myd=$7
rt=$8
mt=$9
dbh=${10}

# extra options for create table
createopt=${11}

# number of concurrent clients
dop=${12}

# suffix for output files
sfx=${13}

sla=${14}

# name of storage device in iostat for database IO
dname=${15}
loops=${16}

bash run1.sh $nw $engine $mysql $ddir $myu $myp $myd $rt $mt yes no $dbh $createopt $dop $sfx $sla $dname

for i in $( seq $loops ) ; do
bash run1.sh $nw $engine $mysql $ddir $myu $myp $myd $rt $mt no yes $dbh $createopt $dop $sfx.${i} $sla $dname
done

