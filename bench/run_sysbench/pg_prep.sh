../sysbench4 --batch --batch-delay=60 --test=oltp --oltp-table-size=4000000 --max-time=1200 --max-requests=0 \
  --db-ps-mode=disable --oltp-table-name=sbtest1 --oltp-dist-type=uniform --oltp-range-size=1 \
  --num-threads=1 --seed-rng=1 \
  --pgsql-user=mysql --pgsql-password="" --pgsql-db=test --db-driver=pgsql \
  prepare
