engine=$1

for nt in 1 2 4 8 12 16 18 ; do python3 fk.py --engine=$engine --setup --parent_table_size=10000 --test_duration_seconds=20 --threads=$nt --fk >& o.$engine.fk1.$nt ; done

for nt in 1 2 4 8 12 16 18 ; do python3 fk.py --engine=$engine --setup --parent_table_size=10000 --test_duration_seconds=20 --threads=$nt  >& o.$engine.fk0.$nt ; done
