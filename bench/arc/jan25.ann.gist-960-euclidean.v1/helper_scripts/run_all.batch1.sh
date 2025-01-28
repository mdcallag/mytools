
# fashion-mnist-784-euclidea
# sift-128-euclidean
# gist-960-euclidean
dataset=$1

config_suffix=$2

# number of concurrent sessions
concur=$3

common_args="--timeout -1 --local --force --respect_config_order --batch --runs 3"

dopg=1
if [[ dopg -eq 1 ]]; then

( cd ~/d/pg172_o2nofp ; bash ini_vector.sh x10a_vector_${config_suffix} ; sleep 10 )

while :; do echo $( date ); ps auxwww | sort -rnk 5,5 | head -10 ; echo ; ps auxwww | sort -rnk 6,6 | head -10 ; sleep 5; done >& o.ps.pgvector.${concur} &
pspid=$!
vmstat 1 >& o.vm.pgvector.${concur} &
vmpid=$!
COLUMNS=400 LINES=50 top -b -d 30 -c -w >& o.top.pgvector.${concur} &
topid=$!
time POSTGRES_CONN_ARGS=root:pw:127.0.0.1:5432 POSTGRES_DB_NAME=ib POSTGRES_BATCH_CONCURRENCY=$concur python3 -u run.py --algorithm pgvector --dataset $dataset $common_args >& o.batch1.pgvector.${concur}
kill $pspid
kill $vmpid
kill $topid

while :; do echo $( date ); ps auxwww | sort -rnk 5,5 | head -10 ; echo ; ps auxwww | sort -rnk 6,6 | head -10 ; sleep 5; done >& o.ps.pgvector_halfvec.${concur} &
pspid=$!
vmstat 1 >& o.vm.pgvector_halfvec.${concur} &
vmpid=$!
COLUMNS=400 LINES=50 top -b -d 30 -c -w >& o.top.pgvector_halfvec.${concur} &
topid=$!
time POSTGRES_CONN_ARGS=root:pw:127.0.0.1:5432 POSTGRES_DB_NAME=ib POSTGRES_BATCH_CONCURRENCY=$concur python3 -u run.py --algorithm pgvector_halfvec --dataset $dataset $common_args >& o.batch1.pgvector_halfvec.${concur}
kill $pspid
kill $vmpid
kill $topid

( cd ~/d/pg172_o2nofp ; bash down.sh ; sleep 10 )
fi

doma=1
if [[ doma -eq 1 ]]; then

( cd ~/d/ma110701_rel_withdbg ; bash ini.sh z11b_lwas4k_vector_${config_suffix} ; sleep 10 )
while :; do echo $( date ); ps auxwww | sort -rnk 5,5 | head -10 ; echo ; ps auxwww | sort -rnk 6,6 | head -10 ; sleep 5; done >& o.ps.mariadb.${concur} &
pspid=$!
vmstat 1 >& o.vm.mariadb.${concur} &
vmpid=$!
COLUMNS=400 LINES=50 top -b -d 30 -c -w >& o.top.mariadb.${concur} &
topid=$!
time MARIADB_CONN_ARGS=root:pw:127.0.0.1:3306 MARIADB_DB_NAME=test MARIADB_BATCH_CONCURRENCY=$concur python3 -u run.py --algorithm mariadb --dataset $dataset $common_args  >& o.batch1.mariadb.${concur}
kill $pspid
kill $vmpid
kill $topid
( cd ~/d/ma110701_rel_withdbg ; bash down.sh )

fi
