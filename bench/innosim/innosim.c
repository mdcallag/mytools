/* Copyright (C) 2011 Facebook Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; version 2 of the License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */

#define _GNU_SOURCE
#define _XOPEN_SOURCE 600 /* to get posix_memalign */

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/time.h>
#include <assert.h>

typedef unsigned long long ulonglong;
typedef long long longlong;
typedef unsigned long ulong;
typedef unsigned int uint;

/* Configurable */

int prepare = 0;

int doublewrite = 1;
int binlog = 1;
int trxlog = 1;

int binlog_write_size = 128;
int trxlog_write_size = 512;

longlong binlog_file_size = 10L * 1024 * 1024;
longlong trxlog_file_size = 10L * 1024 * 1024;
longlong data_file_size = 10L * 1024 * 1024;
longlong data_block_size = 16L*1024;

int num_writers = 8;
int num_users = 8;

int dirty_pct = 30;

int stats_interval=1;

const char* data_fname = "DATA";
const char* binlog_fname = "BINLOG";
const char* trxlog_fname = "TRXLOG";

/* Not configurable */

#define DOUBLEWRITE_SIZE 128

int data_fd;
int binlog_fd;
int trxlog_fd;

longlong binlog_offset = 0;
longlong trxlog_offset = 0;

char* binlog_buf = NULL;
char* trxlog_buf = NULL;

size_t n_blocks = 0;

#define MYMIN(x,y) ((x) < (y) ? (x) : (y))

/* Statistics */
pthread_mutex_t stats_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t binlog_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t trxlog_mutex = PTHREAD_MUTEX_INITIALIZER;

pthread_mutex_t buffer_pool_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t buffer_pool_cond = PTHREAD_COND_INITIALIZER;
pthread_cond_t buffer_pool_list_not_empty = PTHREAD_COND_INITIALIZER;
pthread_cond_t buffer_pool_list_not_full = PTHREAD_COND_INITIALIZER;

#define INTERVAL_MAX 10000

typedef struct {
  int total_requests;
  longlong total_latency;
  long interval_requests;
  long interval_latency;
  long interval_max;
  long interval_latencies[INTERVAL_MAX];
} operation_stats;

operation_stats* writer_stats;
operation_stats* user_stats;

operation_stats scheduler_stats;
operation_stats binlog_write_stats;
operation_stats binlog_fsync_stats;
operation_stats trxlog_write_stats;
operation_stats trxlog_fsync_stats;
operation_stats doublewrite_stats;

#define BUFFER_POOL_MAX 1000000

typedef struct {
  int dirty_pages;
  int list_head;
  int list_tail;
  int list_count;
  longlong list[BUFFER_POOL_MAX]; /* bounded by list_head and list_tail */
} buffer_pool_t;

buffer_pool_t buffer_pool;

double rand_double(uint *ctx) {
  int r = rand_r(ctx);
  return (double) r / (double) RAND_MAX;
}

longlong rand_block(uint* ctx) {
  longlong block_no = rand_double(ctx) * n_blocks;
  return MYMIN(block_no, (n_blocks-1));
}

void now(struct timeval* tv) {
  assert(!gettimeofday(tv, NULL));
}

long now_minus_then_usecs(struct timeval const* now,
			  struct timeval const* then) {
  longlong now_usecs = (now->tv_sec * 1000000) + now->tv_usec;
  longlong then_usecs = (then->tv_sec * 1000000) + then->tv_usec;

  if (now_usecs >= then_usecs)
    return (long) (now_usecs - then_usecs);
  else
    return -1;
}

void stats_report(operation_stats* stats,
                  struct timeval *start,
		  uint *randctx) {
  int sample_index;
  long latency;
  struct timeval stop;

  now(&stop);
  latency = now_minus_then_usecs(&stop, start);
  
  pthread_mutex_lock(&stats_mutex);

  stats->total_requests++;
  stats->total_latency += latency;

  stats->interval_requests++;
  stats->interval_latency += latency;

  if (latency > stats->interval_max)
    stats->interval_max = latency;

  /* Use Reservoir sampling for interval_latencies */
  if (stats->interval_requests <= INTERVAL_MAX)
    sample_index = stats->interval_requests - 1;
  else
    sample_index = rand_double(randctx) * stats->interval_requests;

  if (sample_index < INTERVAL_MAX) stats->interval_latencies[sample_index] = latency; 
  pthread_mutex_unlock(&stats_mutex);
}

void stats_init(operation_stats* stats) {
  stats->total_requests = 0;
  stats->total_latency = 0;
  stats->interval_requests = 0;
  stats->interval_latency = 0;
  stats->interval_max = 0;
}

int lcompare(const void* a, const void* b) {
  long const* la = (long const*) a;
  long const* lb = (long const*) b;
  return *la - *lb;
}

void stats_summarize_interval(operation_stats* stats,
                              long* p95, long* p99, double* avg,
                              long* maxv, long* requests, longlong* latency) {
  int nsamples = (stats->interval_requests <  INTERVAL_MAX) ? stats->interval_requests : INTERVAL_MAX;

  qsort(&(stats->interval_latencies[0]), nsamples, sizeof(long), lcompare);

  *requests = stats->interval_requests;
  *latency = stats->interval_latency;
  *maxv = stats->interval_max;
  *p95 = stats->interval_latencies[(int) (nsamples * 0.95)];
  *p99 = stats->interval_latencies[(int) (nsamples * 0.99)];
  *avg = (double) stats->interval_latency / (double) stats->interval_requests;

  stats->interval_requests = 0;
  stats->interval_latency = 0;
  stats->interval_max = 0;
}


void buffer_pool_init(buffer_pool_t* pool) {
  pool->dirty_pages = 0;
  pool->list_head = 0;
  pool->list_tail = 0;
  pool->list_count = 0;
}

int buffer_pool_list_push(buffer_pool_t* pool, longlong page_id) {
  if (pool->list_count == BUFFER_POOL_MAX)
    return -1;

  pool->list[pool->list_tail] = page_id;
  pool->list_count++;
  pool->list_tail = (pool->list_tail + 1) % BUFFER_POOL_MAX;

  return 0;
}

int buffer_pool_list_pop(buffer_pool_t* pool, longlong* page_id) {
  if (!pool->list_count)
    return -1;

  *page_id = pool->list[pool->list_head];
  pool->list_count--;
  pool->list_head = (pool->list_head + 1) % BUFFER_POOL_MAX; 

  pthread_cond_broadcast(&buffer_pool_list_not_full);

  return 0;
}

void write_log(pthread_mutex_t* mux, longlong* offset, longlong file_size, int write_size, 
               int truncate_if_max, int fd, char* buf,
               operation_stats* write_stats, operation_stats* fsync_stats, uint* ctx) {

    struct timeval start;

    pthread_mutex_lock(mux);

    if (*offset >= file_size) {
      if (truncate_if_max)
        assert(!ftruncate(fd, 0));

      *offset = 0;
      assert(!lseek(fd, 0, SEEK_SET));
    }

    now(&start);
    assert(pwrite64(fd, buf, write_size, *offset) == write_size);
    *offset += write_size;
    stats_report(write_stats, &start, ctx);

    now(&start);
    assert(!fsync(fd));
    stats_report(fsync_stats, &start, ctx);

    pthread_mutex_unlock(mux);
}

void buffer_pool_dirty_page(buffer_pool_t* pool, uint* ctx) {
  pthread_mutex_lock(&buffer_pool_mutex);
  pool->dirty_pages++;
  pthread_mutex_unlock(&buffer_pool_mutex);

  if (trxlog) {
    write_log(&trxlog_mutex, &trxlog_offset, trxlog_file_size, trxlog_write_size, 0,
              trxlog_fd, trxlog_buf, &trxlog_write_stats, &trxlog_fsync_stats, ctx);
  }

  if (binlog) {
    write_log(&binlog_mutex, &binlog_offset, binlog_file_size, binlog_write_size, 1,
              binlog_fd, binlog_buf, &binlog_write_stats, &binlog_fsync_stats, ctx);
  }
}

int buffer_pool_schedule_writes(buffer_pool_t* pool, uint* ctx, char* doublewrite_buf) {
  int pages = 0, x;
  struct timeval start;
  longlong page_array[DOUBLEWRITE_SIZE];
 
  pthread_mutex_lock(&buffer_pool_mutex);
  if (pool->dirty_pages) {
    pages = MYMIN(pool->dirty_pages, DOUBLEWRITE_SIZE);
    pool->dirty_pages -= pages;
  }
  pthread_mutex_unlock(&buffer_pool_mutex);

  for (x = 0; x < pages; ++x)
    page_array[x] = rand_block(ctx);

  if (doublewrite) {
    now(&start);
    pwrite64(data_fd, doublewrite_buf, pages * data_block_size, 0);
    stats_report(&doublewrite_stats, &start, ctx);
  }

  pthread_mutex_lock(&buffer_pool_mutex);

  for (x = 0; x < pages; ++x) {
    while (-1 == buffer_pool_list_push(pool, page_array[x])) {
      pthread_cond_wait(&buffer_pool_list_not_full, &buffer_pool_mutex);
    }
  }

  pthread_cond_broadcast(&buffer_pool_list_not_empty);

  pthread_mutex_unlock(&buffer_pool_mutex);

  return pages;
}

void* user_func(void* arg) {
  operation_stats* stats = (operation_stats*) arg;
  uint ctx = (uint) pthread_self();
  size_t block_num;
  off_t offset;
  char* data;
  struct timeval start;

  assert(!posix_memalign((void**) &data, data_block_size, data_block_size));

  while (1) {
    block_num = rand_block(&ctx);
    offset = block_num * data_block_size;

    now(&start);
    pread64(data_fd, data, data_block_size, offset);
    stats_report(stats, &start, &ctx);

    if ((rand_double(&ctx) * 100) <= (double) dirty_pct)
      buffer_pool_dirty_page(&buffer_pool, &ctx);
  }

  free(data);
}

void* write_scheduler_func(void* arg) {
  operation_stats* stats = (operation_stats*) arg;
  uint ctx = (uint) pthread_self();
  struct timeval start;
  char *data;

  assert(!posix_memalign((void**) &data, 128 * data_block_size, data_block_size));

  while (1) {
    
    now(&start);
    while (buffer_pool_schedule_writes(&buffer_pool, &ctx, data)) {
      stats_report(stats, &start, &ctx);
      now(&start);
    }

    usleep(100000); /* TODO mdcallag: do something better */
  }

  free(data);
}

void* writer(void* arg) {
  operation_stats* stats = (operation_stats*) arg;
  uint ctx = (uint) pthread_self();
  longlong block_num;
  off_t offset;
  char* data;
  struct timeval start;

  assert(!posix_memalign((void**) &data, data_block_size, data_block_size));

  while (1) {

    pthread_mutex_lock(&buffer_pool_mutex);
    while (-1 == buffer_pool_list_pop(&buffer_pool, &block_num)) {
        pthread_cond_wait(&buffer_pool_list_not_empty, &buffer_pool_mutex);
    }
    pthread_mutex_unlock(&buffer_pool_mutex);

    offset = block_num * data_block_size;

    now(&start);
    pwrite64(data_fd, data, data_block_size, offset);
    stats_report(stats, &start, &ctx);
  }

  free(data);
}

void process_stats(operation_stats* stats, int num, const char* msg, int loop) {
  long max_p95 = 0, max_p99 = 0, max_maxv = 0;
  longlong sum_latency = 0;
  long sum_requests = 0;
  int i;

  for (i = 0; i < num; ++i, ++stats) {
    long requests, p95, p99, maxv;
    longlong latency;
    double avg;

    stats_summarize_interval(stats, &p95, &p99, &avg, &maxv, &requests, &latency);
    sum_requests += requests;
    sum_latency += latency;
    if (p95 > max_p95) max_p95 = p95;
    if (p99 > max_p99) max_p99 = p99;
    if (maxv > max_maxv) max_maxv = maxv;
  }

  printf("%s: %d loop, %lu ops, %.2f millis/op, %.2f p95, %.2f p99, %.2f max\n",
         msg, loop, sum_requests,
         ((double) sum_latency / sum_requests) / 1000.0,
         max_p95 / 1000.0, max_p99 / 1000.0, max_maxv / 1000.0);
}

void prepare_files() {
  int fd;
  char buf[1024 * 1024 * 8];
  longlong offset;

  memset(buf, 105, sizeof(buf));

  fprintf(stderr, "preparing data file %s\n", data_fname);
  fd = open(data_fname, O_CREAT|O_WRONLY|O_TRUNC, 0644);
  assert (fd >= 0);
  offset = 0;
  while (offset < data_file_size) {
    assert(write(fd, buf, sizeof(buf)) == sizeof(buf));
    offset += sizeof(buf);
  }
  fsync(fd);
  close(fd);

  fprintf(stderr, "preparing trxlog file %s\n", trxlog_fname);
  fd = open(trxlog_fname, O_CREAT|O_WRONLY|O_TRUNC, 0644);
  assert(fd >= 0);
  offset = 0;
  while (offset < trxlog_file_size) {
    assert(write(fd, buf, sizeof(buf)) == sizeof(buf));
    offset += sizeof(buf);
  }
  fsync(fd);
  close(fd);
}

void print_help() {
  printf(
"This is a simple InnoDB IO simulator that models: database file reads, database file writes,\n"
"binlog writes and transaction log writes using configurable numbers of user and writer threads.\n"
"Each user thread reads one page from the database file per transaction. Then dirty_pct is used\n"
"to determine whether the transaction does a write. If a write is done, a page is marked dirty,\n"
"(but not written), a binlog write is done if the binlog is enabled and a transaction log write\n"
"is done if the transaction log is enabled. The user threads do not write pages back to the\n"
"database file as that is usually done by background IO threads in InnoDB. In the simulator\n"
"one thread generates offsets for the pages to be written, performs the sequential large\n"
"write to the doublewrite buffer and then requests that the writer threads perform the\n"
"writes for the pages.\n"
"\n"
"Options:\n"
"  --help -- print help message and exit\n"
"  --prepare 1|0         -- 1: create files and then run, 0: assume files exist, run\n"
"  --doublewrite 1|0     -- 1: use doublewrite buffer, 0: don't use it\n"
"  --binlog-file-name s  -- pathname for binlog file\n"
"  --trxlog-file-name s  -- pathname for transaction log file\n"
"  --data-file-name s    -- pathname for database file\n"
"  --binlog 1|0          -- 1: write to binlog, 0: don't write to it\n"
"  --trxlog 1|0          -- 1: write to transaction log, 0: don't write to it\n"
"  --binlog-write-size n -- size of binlog writes in bytes\n"
"  --trxlog-write-size n -- size of transaction log writes in bytes\n"
"  --binlog-file-size n  -- size of binlog file in bytes\n"
"  --trxlog-file-size n  -- size of transaction log file in bytes\n"
"  --data-file-size n    -- size of database file in bytes\n"
"  --data-block-size n   -- size of database blocks in bytes\n"
"  --num-writers n       -- number of writer threads\n"
"  --num-users n         -- number of user threads\n"
"  --dirty-pct n         -- percent of user transactions that dirty a page\n"
"  --stats-interval n    -- interval in seconds at which stats are reported\n"
);

  exit(0);
}

void process_options(int argc, char **argv) {
  int x;

  for (x = 1; x < argc; ++x) {
    if (!strcmp(argv[x], "--help")) {
      print_help();

    } else if (!strcmp(argv[x], "--prepare")) {
      if (x == (argc - 1)) { printf("--prepare needs an arg\n"); exit(-1); }
      prepare = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--doublewrite")) {
      if (x == (argc - 1)) { printf("--doublewrite needs an arg\n"); exit(-1); }
      doublewrite = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--binlog-file-name")) {
      if (x == (argc - 1)) { printf("--binlog-file-name needs an arg\n"); exit(-1); }
      binlog_fname = argv[++x];

    } else if (!strcmp(argv[x], "--trxlog-file-name")) {
      if (x == (argc - 1)) { printf("--trxlog-file-name needs an arg\n"); exit(-1); }
      trxlog_fname = argv[++x];

    } else if (!strcmp(argv[x], "--data-file-name")) {
      if (x == (argc - 1)) { printf("--data-file-name needs an arg\n"); exit(-1); }
      data_fname = argv[++x];

    } else if (!strcmp(argv[x], "--binlog")) {
      if (x == (argc - 1)) { printf("--binlog needs an arg\n"); exit(-1); }
      binlog = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--trxlog")) {
      if (x == (argc - 1)) { printf("--trxlog needs an arg\n"); exit(-1); }
      trxlog = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--binlog-write-size")) {
      if (x == (argc - 1)) { printf("--binlog-write-size needs an arg\n"); exit(-1); }
      binlog_write_size = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--trxlog-write-size")) {
      if (x == (argc - 1)) { printf("--trxlog-write-size needs an arg\n"); exit(-1); }
      trxlog_write_size = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--binlog-file-size")) {
      if (x == (argc - 1)) { printf("--binlog-file-size needs an arg\n"); exit(-1); }
      binlog_file_size = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--trxlog-file-size")) {
      if (x == (argc - 1)) { printf("--trxlog-file-size needs an arg\n"); exit(-1); }
      trxlog_file_size = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--data-file-size")) {
      if (x == (argc - 1)) { printf("--data-file-size needs an arg\n"); exit(-1); }
      data_file_size = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--data-block-size")) {
      if (x == (argc - 1)) { printf("--data-block-size needs an arg\n"); exit(-1); }
      data_block_size = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--num-writers")) {
      if (x == (argc - 1)) { printf("--num-writers needs an arg\n"); exit(-1); }
      num_writers = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--num-users")) {
      if (x == (argc - 1)) { printf("--num-users needs an arg\n"); exit(-1); }
      num_users = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--dirty-pct")) {
      if (x == (argc - 1)) { printf("--dirty-pct needs an arg\n"); exit(-1); }
      dirty_pct = atoi(argv[++x]);
      if (dirty_pct < 0 || dirty_pct > 100) {
        printf("--dirty-pct set to %d and should be between 0 and 100\n", dirty_pct);
        exit(-1);
      }

    } else if (!strcmp(argv[x], "--stats-interval")) {
      if (x == (argc - 1)) { printf("--stats-interval needs an arg\n"); exit(-1); }
      stats_interval = atoi(argv[++x]);
    }

  }

  printf("Prepare files: %d\n", prepare);
  printf("Doublewrite buffer enabled: %d\n", doublewrite);
  printf("Binlog file name: %s\n", binlog_fname);
  printf("Transaction log file name: %s\n", trxlog_fname);
  printf("Database file name: %s\n", data_fname);
  printf("Binlog enabled: %d\n", binlog);
  printf("Transaction log enabled: %d\n", trxlog);
  printf("Binlog write size: %d\n", binlog_write_size);
  printf("Transaction log write size: %d\n", trxlog_write_size);
  printf("Binlog file size: %llu\n", binlog_file_size);
  printf("Transaction log file size: %llu\n", trxlog_file_size);
  printf("Database file size: %llu\n", data_file_size);
  printf("Database block size: %llu\n", data_block_size);
  printf("Number of writer threads: %d\n", num_writers);
  printf("Number of user threads: %d\n", num_users);
  printf("Dirty percent: %d\n", dirty_pct);
  printf("Stats interval: %d\n", stats_interval);
}
 
int main(int argc, char **argv) {
  pthread_t *writer_threads;
  pthread_t *user_threads;
  pthread_t write_scheduler;
  int i, test_loop = 0;

  process_options(argc, argv);

  n_blocks = data_file_size / data_block_size;

  stats_init(&scheduler_stats);
  stats_init(&doublewrite_stats);
  stats_init(&binlog_write_stats);
  stats_init(&binlog_fsync_stats);

  stats_init(&trxlog_write_stats);
  stats_init(&trxlog_fsync_stats);
 
  buffer_pool_init(&buffer_pool);

  if (prepare)
    prepare_files();

  if (binlog) { 
    binlog_fd = open(binlog_fname, O_CREAT|O_WRONLY|O_TRUNC, 0644);
    assert(binlog_fd >= 0);
    binlog_buf = (char*) malloc(binlog_write_size);
  }

  if (trxlog) { 
    trxlog_fd = open(trxlog_fname, O_CREAT|O_WRONLY, 0644);
    assert(trxlog_fd >= 0);
    lseek(trxlog_fd, 0, SEEK_SET);
    trxlog_buf = (char*) malloc(trxlog_write_size);
  }

  data_fd = open(data_fname, O_CREAT|O_RDWR|O_DIRECT|O_LARGEFILE, 0644);
  assert(data_fd >= 0);
  lseek(data_fd, 0, SEEK_SET);

  user_threads = (pthread_t*) malloc(sizeof(pthread_t) * num_users);
  user_stats = (operation_stats*) malloc(sizeof(operation_stats) * num_users);
  for (i = 0; i < num_users; ++i) {
    stats_init(&user_stats[i]);
    pthread_create(&user_threads[i], NULL, user_func, &user_stats[i]);
  }

  pthread_create(&write_scheduler, NULL, write_scheduler_func, &scheduler_stats);

  writer_threads = (pthread_t*) malloc(sizeof(pthread_t) * num_writers);
  writer_stats = (operation_stats*) malloc(sizeof(operation_stats) * num_writers);
  for (i = 0; i < num_writers; ++i) {
    stats_init(&writer_stats[i]);
    pthread_create(&writer_threads[i], NULL, writer, &writer_stats[i]);
  }

  while (1) {

    sleep(stats_interval);

    pthread_mutex_lock(&stats_mutex);

    process_stats(user_stats, num_users, "read", test_loop);
    process_stats(writer_stats, num_writers, "write", test_loop);
    process_stats(&scheduler_stats, 1, "scheduler", test_loop);
    process_stats(&doublewrite_stats, 1, "doublewrite", test_loop);
    process_stats(&binlog_write_stats, 1, "binlog_write", test_loop);
    process_stats(&binlog_fsync_stats, 1, "binlog_fsync", test_loop);
    process_stats(&trxlog_write_stats, 1, "trxlog_write", test_loop);
    process_stats(&trxlog_fsync_stats, 1, "trxlog_fsync", test_loop);
    printf("other: %d dirty, %d pending\n", buffer_pool.dirty_pages, buffer_pool.list_count);
 
    pthread_mutex_unlock(&stats_mutex);

    test_loop++;
  }

  if (binlog)
    free(binlog_buf);
  if (trxlog)
    free(trxlog_buf);
}
