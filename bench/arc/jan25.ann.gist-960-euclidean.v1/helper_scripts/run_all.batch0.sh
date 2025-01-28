
# fashion-mnist-784-euclidea
# sift-128-euclidean
# gist-960-euclidean
dataset=$1

config_suffix=$2

common_args="--timeout -1 --local --force --respect_config_order --runs 3"
#common_args="--timeout -1 --local --force --respect_config_order "

dopg=1
if [[ dopg -eq 1 ]] ; then

( cd ~/d/pg172_o2nofp ; bash ini_vector.sh x10a_vector_${config_suffix} ; sleep 10 )

while :; do echo $( date ); ps auxwww | sort -rnk 5,5 | head -10 ; echo ; ps auxwww | sort -rnk 6,6 | head -10 ; sleep 5; done >& o.ps.pgvector &
pspid=$!
vmstat 1 >& o.vm.pgvector &
vmpid=$!
time POSTGRES_CONN_ARGS=root:pw:127.0.0.1:5432 POSTGRES_DB_NAME=ib python3 -u run.py --algorithm pgvector --dataset $dataset $common_args >& o.batch0.pgvector
kill $pspid
kill $vmpid

while :; do echo $( date ); ps auxwww | sort -rnk 5,5 | head -10 ; echo ; ps auxwww | sort -rnk 6,6 | head -10 ; sleep 5; done >& o.ps.pgvector_halfvec &
pspid=$!
vmstat 1 >& o.vm.pgvector_halfvec &
vmpid=$!
time POSTGRES_CONN_ARGS=root:pw:127.0.0.1:5432 POSTGRES_DB_NAME=ib python3 -u run.py --algorithm pgvector_halfvec --dataset $dataset $common_args >& o.batch0.pgvector_halfvec
kill $pspid
kill $vmpid
( cd ~/d/pg172_o2nofp ; bash down.sh ; sleep 10 )

fi

doma=1
if [[ doma -eq 1 ]] ; then

( cd ~/d/ma110701_rel_withdbg ; bash ini.sh z11b_lwas4k_vector_${config_suffix} ; sleep 10 )
while :; do echo $( date ); ps auxwww | sort -rnk 5,5 | head -10 ; echo ; ps auxwww | sort -rnk 6,6 | head -10 ; sleep 5; done >& o.ps.mariadb &
pspid=$!
vmstat 1 >& o.vm.mariadb &
vmpid=$!
time MARIADB_CONN_ARGS=root:pw:127.0.0.1:3306 MARIADB_DB_NAME=test python3 -u run.py --algorithm mariadb --dataset $dataset $common_args  >& o.batch0.mariadb
kill $pspid
kill $vmpid
( cd ~/d/ma110701_rel_withdbg ; bash down.sh )

fi
