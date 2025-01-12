
( cd ~/d/pg172_o2nofp ; bash ini_vector.sh x10a_c8r32 ; sleep 10 )
time POSTGRES_CONN_ARGS=root:pw:127.0.0.1:5432 POSTGRES_DB_NAME=ib python3 -u run.py  --algorithm pgvector --dataset fashion-mnist-784-euclidean --local --force --batch >& o.batch1.pgvector
time POSTGRES_CONN_ARGS=root:pw:127.0.0.1:5432 POSTGRES_DB_NAME=ib python3 -u run.py  --algorithm pgvector_halfvec --dataset fashion-mnist-784-euclidean --local --force --batch >& o.batch1.pgvector_halfvec
( cd ~/d/pg172_o2nofp ; bash down.sh ; sleep 10 )

( cd ~/d/ma110701_rel_withdbg ; bash ini.sh z11b_lwas4k_vector_c8r32 ; sleep 10 )
time MARIADB_CONN_ARGS=root:pw:127.0.0.1:3306 MARIADB_DB_NAME=test python3 -u run.py  --algorithm mariadb --dataset fashion-mnist-784-euclidean --local --force --batch  >& o.batch1.mariadb
( cd ~/d/ma110701_rel_withdbg ; bash down.sh )
