./db_bench --benchmarks=crc32c --block_size=4096 | grep ^crc
./db_bench --benchmarks=crc32c --block_size=8192 | grep ^crc

./db_bench --benchmarks=xxh3 --block_size=4096 | grep ^xxh3
./db_bench --benchmarks=xxh3 --block_size=8192 | grep ^xxh3

./db_bench --benchmarks=uncompress --block_size=4096 --compression_type=lz4 | grep ^uncompress
./db_bench --benchmarks=uncompress --block_size=8192 --compression_type=lz4 | grep ^uncompress

./db_bench --benchmarks=uncompress --block_size=4096 --compression_type=zstd | grep ^uncompress
./db_bench --benchmarks=uncompress --block_size=8192 --compression_type=zstd | grep ^uncompress

./db_bench --benchmarks=compress --block_size=4096 --compression_type=lz4 | grep ^compress
./db_bench --benchmarks=compress --block_size=8192 --compression_type=lz4 | grep ^compress

./db_bench --benchmarks=compress --block_size=4096 --compression_type=zstd | grep ^compress
./db_bench --benchmarks=compress --block_size=8192 --compression_type=zstd | grep ^compress
