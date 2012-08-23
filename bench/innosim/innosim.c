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
#include <sys/types.h>
#include <sys/stat.h>
#include <zlib.h>

typedef unsigned long long ulonglong;
typedef long long longlong;
typedef unsigned long ulong;
typedef unsigned int uint;

/* Configurable */

volatile int shutdown = 0;

/* zero means no compression */
int compress_level = 0;

/* Percentage of writes that require recompressing a page */
int recompress_on_write_hit_pct = 5;

/* Percentage of reads that hit in the buffer pool that require
   uncompressing a page.
*/
int uncompress_on_read_hit_pct = 5;

int scheduler_sleep_usecs = 100000;

int test_duration = 60;

int prepare = 0;

int doublewrite = 1;
int binlog = 1;
int trxlog = 1;

int doublewrite_pages = 0;
int doublewrite_writes = 0;
double total_doublewrite_pages = 0;
double total_doublewrite_writes = 0;

int binlog_write_size = 128;
int trxlog_write_size = 512;

longlong binlog_file_size = 10L * 1024 * 1024;
longlong trxlog_file_size = 10L * 1024 * 1024;
longlong data_file_size = 10L * 1024 * 1024;
longlong data_block_size = 16L*1024;

longlong buffer_pool_bytes = 1024 * 1024 * 100;
longlong buffer_pool_pages = (1024 * 1024 * 100) / (16 * 1024);
char* buffer_pool_mem = NULL;

char* compressed_page = NULL;
unsigned int compressed_page_len = 0;

int num_writers = 8;
int num_users = 8;

int dirty_pct = 30;
int read_hit_pct = 0;

#define BUFFER_POOL_MAX 1000000

int max_dirty_pages = BUFFER_POOL_MAX;

int stats_interval=1;

const char* data_fname = "DATA";
const char* doublewrite_fname = NULL;
const char* binlog_fname = "BINLOG";
const char* trxlog_fname = "TRXLOG";

/* Not configurable */

#define DOUBLEWRITE_SIZE 64

int data_fd;
int doublewrite_fd = -1;
int binlog_fd;
int trxlog_fd;

longlong binlog_offset = 0;
longlong trxlog_offset = 0;

char* binlog_buf = NULL;
char* trxlog_buf = NULL;

size_t n_blocks = 0;

#define MYMIN(x,y) ((x) < (y) ? (x) : (y))
#define MYMAX(x,y) ((x) > (y) ? (x) : (y))

/* Statistics */
pthread_mutex_t stats_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t binlog_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t trxlog_mutex = PTHREAD_MUTEX_INITIALIZER;

pthread_mutex_t buffer_pool_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t buffer_pool_cond = PTHREAD_COND_INITIALIZER;
pthread_cond_t buffer_pool_list_not_empty = PTHREAD_COND_INITIALIZER;
pthread_cond_t buffer_pool_list_not_full = PTHREAD_COND_INITIALIZER;

#define INTERVAL_MAX  100000
#define TOTAL_MAX    1000000

typedef struct {
  int total_requests;
  longlong total_latency;
  long total_max;
  long total_latencies[TOTAL_MAX];
  long interval_requests;
  long interval_latency;
  long interval_max;
  long interval_latencies[INTERVAL_MAX];
  unsigned long adler;
  char* compress_buf;
} operation_stats;

operation_stats* writer_stats;
operation_stats* user_stats;

operation_stats scheduler_stats;
operation_stats binlog_write_stats;
operation_stats binlog_fsync_stats;
operation_stats trxlog_write_stats;
operation_stats trxlog_fsync_stats;
operation_stats doublewrite_stats;

typedef struct {
  int dirty_pages;
  int list_head;
  int list_tail;
  int list_count;
  longlong list[BUFFER_POOL_MAX]; /* bounded by list_head and list_tail */
} buffer_pool_t;

buffer_pool_t buffer_pool;

void check_pwrite(int fd, void* buf, size_t size, longlong offset, const char* msg) {
  int r = pwrite64(fd, buf, size, offset);
  if (r != size) {
    fprintf(stderr, "pwrite of %d bytes from %p at %llu returned %d on file descriptor %d with errno %d\n", (int) size, buf, offset, r, fd, errno);
    perror(msg);
    assert(0);
  }
}

void check_write(int fd, void* buf, size_t size, const char* msg) {
  int r = write(fd, buf, size);
  if (r != size) {
    fprintf(stderr, "write of %d bytes returned %d on file descriptor %d\n", (int) size, r, fd);
    perror(msg);
    assert(0);
  }
}

void init_rand_ctx(struct drand48_data* ctx) {
  static long state = 0;
  static int done = 0;

  if (!done) {
    struct timeval tv;

    assert(!gettimeofday(&tv, NULL));
    done = 1;
    state = tv.tv_usec + (tv.tv_sec * 1000000);
  }
  assert(!srand48_r(state++, ctx));
}

double rand_double(struct drand48_data* ctx) {
  double r;
  assert(!drand48_r(ctx, &r));
  return r;
}

longlong rand_block(struct drand48_data* ctx) {
  longlong block_no = (rand_double(ctx) * (n_blocks - DOUBLEWRITE_SIZE)) +
                      DOUBLEWRITE_SIZE;
  return MYMIN(block_no, (n_blocks-1));
}

char* rand_buffer_pool_ptr(long long bytes_from_end, struct drand48_data* ctx) {
 return (buffer_pool_mem +
         (longlong) (rand_double(ctx) * buffer_pool_bytes) -
         bytes_from_end);
}

char* rand_buffer_pool_page(struct drand48_data* ctx) {
 longlong buf_pool_page_num = (longlong) (rand_double(ctx) * (buffer_pool_pages - 1));
 return (buffer_pool_mem + (buf_pool_page_num * data_block_size));
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

void serialize_int(char* dest, unsigned int source) {
  dest[3] = source & 0xff;
  source >>= 8;
  dest[2] = source & 0xff;
  source >>= 8;
  dest[1] = source & 0xff;
  source >>= 8;
  dest[0] = source & 0xff;
}

unsigned int deserialize_int(char* dest) {
  unsigned int result = (unsigned int) dest[0] & 0xff;
  result <<= 8;
  result |= (unsigned int) dest[1] & 0xff;
  result <<= 8;
  result |= (unsigned int) dest[2] & 0xff;
  result <<= 8;
  result |= (unsigned int) dest[3] & 0xff;
  return result;
}

#define PAGE_NUM_OFFSET 0
#define PAGE_CHECKSUM_OFFSET 4
#define PAGE_DATA_OFFSET 8
#define PAGE_DATA_BYTES (data_block_size - PAGE_DATA_OFFSET)

void page_fill(char* page, unsigned int page_num) {
  memset(page + PAGE_DATA_OFFSET, page_num, PAGE_DATA_BYTES);
}

void page_check_checksum(char* page, unsigned int page_num) {
    int computed_cs = adler32(0, page + PAGE_DATA_OFFSET, PAGE_DATA_BYTES);
    int stored_cs = (int) deserialize_int(page + PAGE_CHECKSUM_OFFSET);
    int stored_page_num = (int) deserialize_int(page + PAGE_NUM_OFFSET);

    if (computed_cs != stored_cs || page_num != stored_page_num) {
      fprintf(stderr,
              "Cannot validate page, checksum stored(%d) and computed(%d), "
              "page# stored(%d) and expected(%d)\n",
              stored_cs, computed_cs, stored_page_num, page_num);
      exit(-1);
    }
}

void page_write_checksum(char* page, unsigned int page_num) {
    int checksum = adler32(0, page + PAGE_DATA_OFFSET, PAGE_DATA_BYTES);
    serialize_int(page + PAGE_CHECKSUM_OFFSET, checksum);
    serialize_int(page + PAGE_NUM_OFFSET, page_num);
    page_check_checksum(page, page_num); /* TODO remove this */
}


void decompress_page(char* decomp_buf, unsigned int decomp_buf_len) {
  z_stream stream;
  int err;

  stream.next_in = compressed_page;
  stream.avail_in = compressed_page_len;
  stream.next_out = decomp_buf;
  stream.avail_out = decomp_buf_len;

  stream.zalloc = (alloc_func) 0;
  stream.zfree = (free_func) 0;

  err = inflateInit(&stream);
  assert(err == Z_OK);
  err = inflate(&stream, Z_FINISH);
  assert(err == Z_STREAM_END);
  err = inflateEnd(&stream);
}

unsigned int
compress_page(char* source, unsigned int source_len,
              char* dest, unsigned int dest_len) {
  z_stream stream;
  int err;
  unsigned int compressed_size;

  stream.next_in = source;
  stream.avail_in = source_len;
  stream.next_out = dest;
  stream.avail_out = dest_len;
  stream.zalloc = (alloc_func) 0;
  stream.zfree = (free_func) 0;
  stream.opaque = NULL;

  err = deflateInit(&stream, compress_level);
  assert(err == Z_OK);

  err = deflate(&stream, Z_FINISH);
  assert(err == Z_STREAM_END);
  compressed_size = stream.total_out;
  err = deflateEnd(&stream);
  return compressed_size;
}


void stats_report_with_latency(operation_stats* stats,
                               long latency,
       		               struct drand48_data* randctx) {
  int sample_index;

  stats->total_requests++;
  stats->total_latency += latency;

  stats->interval_requests++;
  stats->interval_latency += latency;

  if (latency > stats->interval_max)
    stats->interval_max = latency;

  if (latency > stats->total_max)
    stats->total_max = latency;

  /* Use Reservoir sampling */

  if (stats->interval_requests <= INTERVAL_MAX)
    sample_index = stats->interval_requests - 1;
  else
    sample_index = rand_double(randctx) * stats->interval_requests;
  if (sample_index < INTERVAL_MAX)
    stats->interval_latencies[sample_index] = latency; 

  if (stats->total_requests <= TOTAL_MAX)
    sample_index = stats->total_requests - 1;
  else
    sample_index = rand_double(randctx) * stats->total_requests;
  if (sample_index < TOTAL_MAX)
    stats->total_latencies[sample_index] = latency; 
}

void stats_report(operation_stats* stats,
                  struct timeval *start,
		  struct drand48_data* randctx) {
  long latency;
  struct timeval stop;

  now(&stop);
  latency = now_minus_then_usecs(&stop, start);

  pthread_mutex_lock(&stats_mutex);
  stats_report_with_latency(stats, latency, randctx);
  pthread_mutex_unlock(&stats_mutex);
}

void stats_init(operation_stats* stats) {
  stats->total_requests = 0;
  stats->total_latency = 0;
  stats->total_max = 0;
  stats->interval_requests = 0;
  stats->interval_latency = 0;
  stats->interval_max = 0;
  stats->adler = 0;
  stats->compress_buf = 0;
}

int lcompare(const void* a, const void* b) {
  long const* la = (long const*) a;
  long const* lb = (long const*) b;
  return *la - *lb;
}

int icompare(const void* a, const void* b) {
  int const* ia = (int const*) a;
  int const* ib = (int const*) b;
  return *ia - *ib;
}

void stats_summarize_interval(operation_stats* stats,
                              long* p95, long* p99, double* avg,
                              long* maxv, long* requests, longlong* latency) {
  int nsamples = MYMIN(stats->interval_requests, INTERVAL_MAX);

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

void stats_summarize_total(operation_stats* stats,
                           long* p95, long* p99, double* avg,
                           long* maxv, long* requests, longlong* latency) {
  int nsamples = MYMIN(stats->total_requests, TOTAL_MAX);

  qsort(&(stats->total_latencies[0]), nsamples, sizeof(long), lcompare);

  *requests = stats->total_requests;
  *latency = stats->total_latency;
  *maxv = stats->total_max;
  *p95 = stats->total_latencies[(int) (nsamples * 0.95)];
  *p99 = stats->total_latencies[(int) (nsamples * 0.99)];
  *avg = (double) stats->total_latency / (double) stats->total_requests;
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
               operation_stats* write_stats, operation_stats* fsync_stats, struct drand48_data* ctx) {

    struct timeval start;
    int x;

    pthread_mutex_lock(mux);
 
    for (x=0; x < write_size; ++x)
      buf[x] = (char) x;

    if (*offset >= file_size) {
      if (truncate_if_max)
        assert(!ftruncate(fd, 0));

      *offset = 0;
      assert(!lseek(fd, 0, SEEK_SET));
    }

    now(&start);

    write_stats->adler = adler32(0, buf, write_size);
    if (!truncate_if_max)
      check_pwrite(fd, buf, write_size, *offset, "write_log for trxlog");
    else
      check_write(fd, buf, write_size, "write_log for binlog");

    *offset += write_size;
    stats_report(write_stats, &start, ctx);

    now(&start);
    assert(!fsync(fd));
    stats_report(fsync_stats, &start, ctx);

    pthread_mutex_unlock(mux);
}

void buffer_pool_dirty_page(buffer_pool_t* pool, struct drand48_data* ctx) {
  char *ptr = rand_buffer_pool_ptr(100, ctx);
  int x;

  pthread_mutex_lock(&buffer_pool_mutex);

  while ((pool->dirty_pages + pool->list_count) >= max_dirty_pages)
    pthread_cond_wait(&buffer_pool_list_not_full, &buffer_pool_mutex);    

  pool->dirty_pages++;
  pthread_mutex_unlock(&buffer_pool_mutex);

  /* Simulate modifying data in the page */
  for (x=0; x < 100; ++x, ++ptr)
    *ptr = (char) x;

  if (trxlog) {
    write_log(&trxlog_mutex, &trxlog_offset, trxlog_file_size, trxlog_write_size, 0,
              trxlog_fd, trxlog_buf, &trxlog_write_stats, &trxlog_fsync_stats, ctx);
  }

  if (binlog) {
    write_log(&binlog_mutex, &binlog_offset, binlog_file_size, binlog_write_size, 1,
              binlog_fd, binlog_buf, &binlog_write_stats, &binlog_fsync_stats, ctx);
  }
}

int buffer_pool_schedule_writes(buffer_pool_t* pool, struct drand48_data* ctx, char* doublewrite_buf) {
  int pages = 0, x;
  struct timeval start;
  longlong page_array[DOUBLEWRITE_SIZE];
 
  pthread_mutex_lock(&buffer_pool_mutex);
  if (pool->dirty_pages) {
    pages = MYMIN(pool->dirty_pages, DOUBLEWRITE_SIZE);
    pool->dirty_pages -= pages;
  }
  pthread_mutex_unlock(&buffer_pool_mutex);

  if (!pages)
    return 0;

  for (x = 0; x < pages; ++x)
    page_array[x] = rand_block(ctx);

  if (doublewrite) {
    for (x = 0; x < pages; ++x) {
      char *page = rand_buffer_pool_page(ctx);

      memcpy(doublewrite_buf + (x * data_block_size),
             page,
             data_block_size);
    }

    now(&start);

    check_pwrite(doublewrite_fd, doublewrite_buf, pages * data_block_size, 0, "doublewrite buffer write");
    doublewrite_writes++;
    doublewrite_pages += pages;
    total_doublewrite_writes++;
    total_doublewrite_pages += pages;

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
  struct drand48_data ctx;
  size_t block_num;
  off_t offset;
  char* data;
  struct timeval start;
  char *decomp_buf = malloc(data_block_size);

  init_rand_ctx(&ctx);

  assert(!posix_memalign((void**) &data, data_block_size, data_block_size));

  while (!shutdown) {
    block_num = rand_block(&ctx);
    offset = block_num * data_block_size;

    if (!read_hit_pct || (rand_double(&ctx) * 100) > read_hit_pct) {
      /* Do the read when it misses the pretend cache */
      now(&start);
      assert(pread64(data_fd, data, data_block_size, offset) == data_block_size);
      page_check_checksum(data, (unsigned int) block_num);

      if (compress_level)
        decompress_page(decomp_buf, data_block_size);

      /* Note the FB patch fixed this to prevent zlib from computing an
         internal checksum which is redundant with the innodb page
         checksum.
      */
      stats->adler = adler32(0, data, data_block_size);
   

      stats_report(stats, &start, &ctx);
    } else {
      /* Do some work to simulate reading data from the buffer pool */
      int x;
      char *ptr = rand_buffer_pool_ptr(100, &ctx);

      for (x=0; x < 100; ++x, ++ptr)
        stats->adler += *ptr;

      if (compress_level &&
          (rand_double(&ctx) * 100) <= (double) uncompress_on_read_hit_pct)
        decompress_page(decomp_buf, data_block_size);
    }

    if ((rand_double(&ctx) * 100) <= (double) dirty_pct) {
      buffer_pool_dirty_page(&buffer_pool, &ctx);

      if (compress_level &&
          (rand_double(&ctx) * 100) <= (double) recompress_on_write_hit_pct) {
        char *page = rand_buffer_pool_page(&ctx);
        compress_page(page, data_block_size, stats->compress_buf, data_block_size+100);
      }
    }
  }

  free(decomp_buf);
  free(data);
  return NULL;
}

void* write_scheduler_func(void* arg) {
  operation_stats* stats = (operation_stats*) arg;
  struct timeval start;
  char *data;
  struct drand48_data ctx;

  init_rand_ctx(&ctx);
  assert(!posix_memalign((void**) &data, data_block_size, DOUBLEWRITE_SIZE * data_block_size));

  while (!shutdown) {
    
    now(&start);
    while (buffer_pool_schedule_writes(&buffer_pool, &ctx, data)) {
      stats_report(stats, &start, &ctx);
      now(&start);
    }

    usleep(scheduler_sleep_usecs); /* TODO mdcallag: do something better */
  }

  free(data);
  return NULL;
}

void* writer(void* arg) {
  operation_stats* stats = (operation_stats*) arg;
  longlong block_num;
  off_t offset;
  char* data;
  struct timeval start;
  struct drand48_data ctx;

  init_rand_ctx(&ctx);
  assert(!posix_memalign((void**) &data, data_block_size, data_block_size));

  while (!shutdown) {

    pthread_mutex_lock(&buffer_pool_mutex);
    while (!shutdown &&
           -1 == buffer_pool_list_pop(&buffer_pool, &block_num)) {
        pthread_cond_wait(&buffer_pool_list_not_empty, &buffer_pool_mutex);
    }
    pthread_mutex_unlock(&buffer_pool_mutex);

    if (shutdown)
      goto end;

    offset = block_num * data_block_size;

    memcpy(data, rand_buffer_pool_page(&ctx), data_block_size);
    page_write_checksum(data, (unsigned int) block_num);

    now(&start);
    check_pwrite(data_fd, data, data_block_size, offset, "writer thread");
    stats_report(stats, &start, &ctx);
  }

end:
  free(data);
  return NULL;
}

int process_stats(operation_stats* const stats, int num, const char* msg, int loop, int final) {
  long max_maxv = 0;
  longlong sum_latency = 0;
  int sx, rx;
  struct drand48_data randctx;
  long requests, p95, p99, maxv;
  longlong latency;
  double avg;
  int sum_requests = 0;
  operation_stats* curstats;
  operation_stats* combined = (operation_stats*) malloc(sizeof(operation_stats));

  stats_init(combined);
  init_rand_ctx(&randctx);

  if (!final) {
    /* Merge into combined before interval_latencies are cleared */
    for (sx = 0, curstats=stats; sx < num; ++sx, ++curstats)
      for (rx = 0; rx < MYMIN(INTERVAL_MAX, curstats->interval_requests); ++rx)
        stats_report_with_latency(combined, curstats->interval_latencies[rx], &randctx);

    /* And then summarize */
    for (sx = 0, curstats=stats; sx < num; ++sx, ++curstats) {
      stats_summarize_interval(curstats, &p95, &p99, &avg, &maxv, &requests, &latency);
      sum_requests += requests;
      sum_latency += latency;
      if (maxv > max_maxv) max_maxv = maxv;
    }
   
  } else {
    /* Merge into combined */
    for (sx = 0, curstats=stats; sx < num; ++sx, ++curstats)
      for (rx = 0; rx < MYMIN(TOTAL_MAX, curstats->total_requests); ++rx)
        stats_report_with_latency(combined, curstats->total_latencies[rx], &randctx);

    /* And then summarize  */
    for (sx = 0, curstats=stats; sx < num; ++sx, ++curstats) {
      stats_summarize_total(curstats, &p95, &p99, &avg, &maxv, &requests, &latency);
      sum_requests += requests;
      sum_latency += latency;
      if (maxv > max_maxv) max_maxv = maxv;
    }

  }

  stats_summarize_interval(combined, &p95, &p99, &avg, &maxv, &requests, &latency);
  free(combined);

  if (!final) {
    printf("%s: %d loop, %u ops, %.3f millis/op, %.3f p95, %.3f p99, %.3f max\n",
           msg, loop, sum_requests,
           ((double) sum_latency / sum_requests) / 1000.0,
           p95 / 1000.0, p99 / 1000.0, max_maxv / 1000.0);
  } else {
    printf("%s: final, %u ops, %.1f ops/sec, %.3f millis/op, %.3f p95, %.3f p99, %.3f max\n",
           msg, sum_requests,
           (double) sum_requests / (loop * stats_interval),
           ((double) sum_latency / sum_requests) / 1000.0,
           p95 / 1000.0, p99 / 1000.0, max_maxv / 1000.0);
  }

  return sum_requests;
}

void buffer_pool_fill() {
  int x;
  int page_num = 0;

  for (x=0; x < buffer_pool_pages; ++x) {
    char* page = buffer_pool_mem + (x * data_block_size);
    page_fill(page, page_num);
    page_write_checksum(page, page_num);
    ++page_num;
    if (page_num >= n_blocks)
      page_num = 0;
  }

  compressed_page_len =
      compress_page(buffer_pool_mem, data_block_size,
                    compressed_page, data_block_size+100);
}

void prepare_file(const char* fname, longlong size) {
  int fd;
  struct stat stat_buf;
  const int BUF_SIZE = 1024 * 1024;
  int buf_len = MYMIN(BUF_SIZE, size);

  fprintf(stderr, "preparing file %s\n", fname);
  fd = open(fname, O_CREAT|O_WRONLY, 0644);
  assert(fd >= 0);

  if (fstat(fd, &stat_buf)) {
    perror("fstat failed");
    printf("cannot prepare %s\n", fname);
    exit(-1);
  }

  if (stat_buf.st_size < size) {
    longlong offset = 0;
    char* buf = (char*) malloc(buf_len);

    assert(buf);
    memset(buf, 105, buf_len);

    fprintf(stderr, "...must extend %s from %llu to %llu bytes\n",
            fname, (longlong) stat_buf.st_size, size);
    while (offset < size) {
      assert(write(fd, buf, buf_len) == buf_len);
      offset += buf_len;
    }
    free(buf);
  } else {
    fprintf(stderr, "...%s is %llu bytes\n", fname, (longlong) stat_buf.st_size);
  }

  fsync(fd);
  close(fd);
}

void prepare_data_file() {
  int fd;
  int page_num;
  char* buf;
  longlong offset;
  const int BUF_SIZE = 1024 * 1024;

  buf = (char*) malloc(BUF_SIZE);

  fprintf(stderr, "preparing data file %s\n", data_fname);
  fd = open(data_fname, O_CREAT|O_RDWR|O_TRUNC, 0644);
  assert (fd >= 0);

  for (page_num=0; page_num < n_blocks; ++page_num) {
    page_fill(buf, page_num);
    page_write_checksum(buf, page_num);
    assert(pwrite64(fd, buf, data_block_size, data_block_size * page_num) == data_block_size);
  }

  fsync(fd);
  close(fd);
  free(buf);
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
"To simulate a write-intensive workload that does few reads because reads are cached, set \n"
"--read-hit-pct to a non-zero value\n"
"\n"
"Use --max-dirty-pages to limit the maximum number of pages that are currently marked dirty\n"
"and rate-limit a write-mostly benchmark\n"
"\n"
"Statistics are reported every --stats-interval seconds. One line is reported for each of:\n"
"reads done by the user threads, writes done by the writer threads, binlog writes, \n"
"transaction log writes, binlog fsyncs and transaction log fsyncs. Each line includes the \n"
"number of operations, and latencies (average, 95th percentile, 99th percentile and max).\n"
"All latencies are in milliseconds.\n"
"\n"
"Options:\n"
"  --help -- print help message and exit\n"
"  --prepare 1|0         -- 1: create files and then run, 0: assume files exist, run\n"
"  --doublewrite 1|0     -- 1: use doublewrite buffer, 0: don't use it\n"
"  --binlog-file-name s  -- pathname for binlog file\n"
"  --trxlog-file-name s  -- pathname for transaction log file\n"
"  --data-file-name s    -- pathname for database file\n"
"  --doublewrite-file-name s -- pathname for doublewrite file, when not set use first 2MB of data file\n"
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
"  --max-dirty-pages n   -- maximum number of dirty pages, used to rate limit write-mostly workloads\n"
"  --dirty-pct n         -- percent of user transactions that dirty a page\n"
"  --read-hit-pct n      -- for transactions that dirty a page, percentage of time a read is not needed because it was cached\n"
"  --stats-interval n    -- interval in seconds at which stats are reported\n"
"  --test-duration n     -- number of seconds to run the test\n"
"  --scheduler-sleep-usecs n -- page writes are scheduled every n microseconds\n"
"  --buffer-pool-mb n    -- size of DBMS buffer pool in MB\n"
"  --compress-level n    -- zlib compression level, when 0 no compression is used\n"
"  --recompress-on-write-pct n -- when compression is used, pct of page writes that require recompression\n"
"  --uncompress-on-read-hit-pct n -- when compression is used, pct of page reads that need decompression after buffer pool hit\n"
);

  exit(0);
}

void process_options(int argc, char **argv) {
  int x;
  int buffer_pool_mb;

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

    } else if (!strcmp(argv[x], "--doublewrite-file-name")) {
      if (x == (argc - 1)) { printf("--doublewrite-file-name needs an arg\n"); exit(-1); }
      doublewrite_fname = argv[++x];

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
      binlog_file_size = atoll(argv[++x]);

    } else if (!strcmp(argv[x], "--trxlog-file-size")) {
      if (x == (argc - 1)) { printf("--trxlog-file-size needs an arg\n"); exit(-1); }
      trxlog_file_size = atoll(argv[++x]);

    } else if (!strcmp(argv[x], "--data-file-size")) {
      if (x == (argc - 1)) { printf("--data-file-size needs an arg\n"); exit(-1); }
      data_file_size = atoll(argv[++x]);

    } else if (!strcmp(argv[x], "--data-block-size")) {
      if (x == (argc - 1)) { printf("--data-block-size needs an arg\n"); exit(-1); }
      data_block_size = atoll(argv[++x]);

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

    } else if (!strcmp(argv[x], "--read-hit-pct")) {
      if (x == (argc - 1)) { printf("--read-hit-pct needs an arg\n"); exit(-1); }
      read_hit_pct = atoi(argv[++x]);
      if (read_hit_pct < 0 || read_hit_pct > 100) {
        printf("--read-hit-pct set to %d and should be between 0 and 100\n", read_hit_pct);
        exit(-1);
      }

    } else if (!strcmp(argv[x], "--max-dirty-pages")) {
      if (x == (argc - 1)) { printf("--max-dirty-pages needs an arg\n"); exit(-1); }
      max_dirty_pages = atoi(argv[++x]);
      if (max_dirty_pages < 1 || max_dirty_pages > BUFFER_POOL_MAX) {
        printf("--max-dirty-pages set to %d and should be between 1 and %d\n",
               max_dirty_pages, BUFFER_POOL_MAX);
        exit(-1);
      }

    } else if (!strcmp(argv[x], "--scheduler-sleep-usecs")) {
      if (x == (argc - 1)) { printf("--scheduler-sleep-usecs needs an arg\n"); exit(-1); }
      scheduler_sleep_usecs = atoi(argv[++x]);
      if (scheduler_sleep_usecs < 1 || scheduler_sleep_usecs > 1000000) {
        printf("--scheduler-sleep-usecs set to %d and should be between 1 and 1000000\n",
               scheduler_sleep_usecs);
        exit(-1);
      }

    } else if (!strcmp(argv[x], "--stats-interval")) {
      if (x == (argc - 1)) { printf("--stats-interval needs an arg\n"); exit(-1); }
      stats_interval = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--test-duration")) {
      if (x == (argc - 1)) { printf("--test-duration needs an arg\n"); exit(-1); }
      test_duration = atoi(argv[++x]);
  
    } else if (!strcmp(argv[x], "--buffer-pool-mb")) {
      buffer_pool_mb = atoi(argv[++x]);
      if (buffer_pool_mb < 1 || buffer_pool_mb > 1000000) {
        printf("--buffer-pool-mb set to %d and should be between 1 and 1000000\n",
               buffer_pool_mb);
        exit(-1);
      }
      buffer_pool_bytes = 1024LL * 1024LL * buffer_pool_mb;

    } else if (!strcmp(argv[x], "--compress-level")) {
      compress_level = atoi(argv[++x]);
      if (compress_level < 0 || compress_level > 9) {
        printf("--compress-level set to %d and should be between 0 and 9\n",
               compress_level);
        exit(-1);
      }

    } else if (!strcmp(argv[x], "--recompress-on-write")) {
      recompress_on_write_hit_pct = atoi(argv[++x]);
      if (recompress_on_write_hit_pct < 0 || recompress_on_write_hit_pct > 99) {
        printf("--recompress-on-write set to %d and should be between 0 and 99\n",
               recompress_on_write_hit_pct);
        exit(-1);
      }

    } else if (!strcmp(argv[x], "--uncompress-on-read-hit")) {
      uncompress_on_read_hit_pct = atoi(argv[++x]);
      if (uncompress_on_read_hit_pct < 0 || uncompress_on_read_hit_pct > 99) {
        printf("--uncompress-on-read-hit set to %d and should be between 0 and 99\n",
               uncompress_on_read_hit_pct);
        exit(-1);
      }
    }
  }

  compressed_page = malloc(data_block_size+100);

  buffer_pool_pages = buffer_pool_bytes / data_block_size;

  printf("Prepare files: %d\n", prepare);
  printf("Doublewrite buffer enabled: %d\n", doublewrite);
  printf("Binlog file name: %s\n", binlog_fname);
  printf("Transaction log file name: %s\n", trxlog_fname);
  printf("Database file name: %s\n", data_fname);
  printf("Doublewrite file name: %s\n", doublewrite_fname ? doublewrite_fname : "<not set>");
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
  printf("Read hit percent: %d\n", read_hit_pct);
  printf("Max dirty pages: %d\n", max_dirty_pages);
  printf("Stats interval: %d\n", stats_interval);
  printf("Test duration: %d\n", test_duration);
  printf("Scheduler sleep microseconds: %d\n", scheduler_sleep_usecs);
  printf("Buffer pool MB: %lld, pages %lld\n",
         buffer_pool_bytes / (1024 * 1024), buffer_pool_pages);
  printf("Use compression=%s with level %d\n",
         compress_level > 0 ? "yes" : "no", compress_level);
  printf("recompress-on-write-pct: %d, uncompress-on-read-hit-pct: %d\n",
         recompress_on_write_hit_pct, uncompress_on_read_hit_pct);
}

void print_percentiles(int *per_interval, const char* msg, int max_loops)
{
  printf("final percentile %s IOPs: %d p50, %d p75, %d p90, %d p95, %d p96, %d p97, %d p98, %d p99\n",
         msg,
         per_interval[(int) (max_loops * 0.50)],
         per_interval[(int) (max_loops * 0.25)],
         per_interval[(int) (max_loops * 0.10)],
         per_interval[(int) (max_loops * 0.05)],
         per_interval[(int) (max_loops * 0.04)],
         per_interval[(int) (max_loops * 0.03)],
         per_interval[(int) (max_loops * 0.02)],
         per_interval[(int) (max_loops * 0.01)]);
}
 
int main(int argc, char **argv) {
  pthread_t *writer_threads;
  pthread_t *user_threads;
  pthread_t write_scheduler;
  int i, test_loop = 0;
  struct stat stat_buf;
  int *reads_per_interval;
  int *writes_per_interval;
  int max_loops;
  void* retval;

  process_options(argc, argv);

  n_blocks = data_file_size / data_block_size;
  if (n_blocks >= 0xffffffff) {
    fprintf(stderr, "data-file-size/data-block-size must be "
            "less than 0xffffffff\n");
    exit(-1);
  }

  stats_init(&scheduler_stats);
  stats_init(&doublewrite_stats);
  stats_init(&binlog_write_stats);
  stats_init(&binlog_fsync_stats);

  stats_init(&trxlog_write_stats);
  stats_init(&trxlog_fsync_stats);
 
  buffer_pool_init(&buffer_pool);

  if (prepare)
    prepare_data_file();

  max_loops = test_duration / stats_interval;
  reads_per_interval = (int*) malloc((1 + max_loops) * sizeof(int));
  memset(reads_per_interval, 0, sizeof(int) * (1 + max_loops));

  writes_per_interval = (int*) malloc((1 + max_loops) * sizeof(int));
  memset(writes_per_interval, 0, sizeof(int) * (1 + max_loops));

  buffer_pool_mem = malloc(buffer_pool_bytes);
  if (!buffer_pool_mem) {
    fprintf(stderr, "Cannot allocate %d MB for the buffer pool\n",
            (int) (buffer_pool_bytes / (1024 * 1024)));
    exit(-1);
  }
  buffer_pool_fill(buffer_pool_bytes);

  if (!reads_per_interval || !writes_per_interval) {
    fprintf(stderr, "Cannot allocate for test_duration / stats_interval samples\n");
    exit(-1);
  }

  if (binlog) { 
    binlog_fd = open(binlog_fname, O_CREAT|O_WRONLY|O_TRUNC, 0644);
    assert(binlog_fd >= 0);
    binlog_buf = (char*) malloc(binlog_write_size);
    fprintf(stderr, "binlog %s uses file descriptor %d\n", binlog_fname, binlog_fd);
  }

  if (trxlog) { 
    prepare_file(trxlog_fname, trxlog_file_size);
    trxlog_fd = open(trxlog_fname, O_CREAT|O_WRONLY, 0644);
    assert(trxlog_fd >= 0);
    lseek(trxlog_fd, 0, SEEK_SET);
    trxlog_buf = (char*) malloc(trxlog_write_size);
    fprintf(stderr, "trxlog %s uses file descriptor %d\n", trxlog_fname, trxlog_fd);
  }

  data_fd = open(data_fname, O_CREAT|O_RDWR|O_DIRECT|O_LARGEFILE, 0644);
  assert(data_fd >= 0);
  lseek(data_fd, 0, SEEK_SET);
  fprintf(stderr, "data %s uses file descriptor %d\n", data_fname, data_fd);

  if (fstat(data_fd, &stat_buf)) {
    perror("stat for --data-file-name failed");
    printf("Do you need to prepare files? (use --prepare 1)\n");
    exit(-1);
  }

  if (doublewrite_fname) {
    prepare_file(doublewrite_fname, DOUBLEWRITE_SIZE * data_block_size);
    doublewrite_fd = open(doublewrite_fname, O_CREAT|O_WRONLY|O_DIRECT, 0644);
    assert(doublewrite_fd >= 0);
    lseek(doublewrite_fd, 0, SEEK_SET);
    fprintf(stderr, "doublewrite %s uses file descriptor %d\n", doublewrite_fname, doublewrite_fd);
  } else {
    doublewrite_fd = data_fd;
    fprintf(stderr, "doublewrite uses the data file\n");
  }

  printf("Filesystem block size for %s is %d\n", data_fname, (int) stat_buf.st_blksize);
  if (stat_buf.st_size < data_file_size) {
    printf("Datafile %s is too small (%llu) and must be at least %llu bytes\n",
           data_fname, (ulonglong) stat_buf.st_size, (ulonglong) data_file_size);
    printf("Do you need to prepare files? (use --prepare 1)\n");
    exit(-1);
  }
  if ((stat_buf.st_blocks * 512LL) < stat_buf.st_size) {
    printf("Datafile %s has holes. It has %llu blocks and requires %llu blocks with no holes\n",
           data_fname, (ulonglong) stat_buf.st_blocks, (ulonglong) stat_buf.st_size / 512ULL);
    printf("Do you need to prepare files? (use --prepare 1)\n");
    exit(-1);
  }

  user_threads = (pthread_t*) malloc(sizeof(pthread_t) * num_users);
  user_stats = (operation_stats*) malloc(sizeof(operation_stats) * num_users);
  for (i = 0; i < num_users; ++i) {
    stats_init(&user_stats[i]);
    user_stats[i].compress_buf = malloc(data_block_size+100);
    pthread_create(&user_threads[i], NULL, user_func, &user_stats[i]);
  }

  writer_threads = (pthread_t*) malloc(sizeof(pthread_t) * num_writers);
  writer_stats = (operation_stats*) malloc(sizeof(operation_stats) * num_writers);
  for (i = 0; i < num_writers; ++i) {
    stats_init(&writer_stats[i]);
    pthread_create(&writer_threads[i], NULL, writer, &writer_stats[i]);
  }

  pthread_create(&write_scheduler, NULL, write_scheduler_func, &scheduler_stats);

  for (test_loop = 1; test_loop <= max_loops; ++test_loop) {
    sleep(stats_interval);

    pthread_mutex_lock(&stats_mutex);

    reads_per_interval[test_loop - 1] =
        process_stats(user_stats, num_users, "read", test_loop, 0);

    writes_per_interval[test_loop - 1] =
        process_stats(writer_stats, num_writers, "write", test_loop, 0);

    process_stats(&scheduler_stats, 1, "scheduler", test_loop, 0);
    process_stats(&doublewrite_stats, 1, "doublewrite", test_loop, 0);
    process_stats(&binlog_write_stats, 1, "binlog_write", test_loop, 0);
    process_stats(&binlog_fsync_stats, 1, "binlog_fsync", test_loop, 0);
    process_stats(&trxlog_write_stats, 1, "trxlog_write", test_loop, 0);
    process_stats(&trxlog_fsync_stats, 1, "trxlog_fsync", test_loop, 0);
    printf("other: %d dirty, %d pending, %.1f avg pages per doublewrite write\n",
           buffer_pool.dirty_pages, buffer_pool.list_count,
           doublewrite_pages / MYMAX((double) doublewrite_writes, 1.0));
    doublewrite_pages = 0;
    doublewrite_writes = 0;
 
    pthread_mutex_unlock(&stats_mutex);
  }

  pthread_mutex_lock(&buffer_pool_mutex);
  shutdown = 1;
  pthread_cond_broadcast(&buffer_pool_list_not_empty);
  pthread_mutex_unlock(&buffer_pool_mutex);

  fprintf(stderr, "waiting for user threads to stop\n");
  for (i = 0; i < num_users; ++i)
    pthread_join(user_threads[i], &retval);

  fprintf(stderr, "waiting for writer threads to stop\n");
  for (i = 0; i < num_writers; ++i)
    pthread_join(writer_threads[i], &retval);

  fprintf(stderr, "waiting for write scheduler to stop\n");
  pthread_join(write_scheduler, &retval);

  pthread_mutex_lock(&stats_mutex);
  process_stats(user_stats, num_users, "read", test_loop - stats_interval, 1);
  process_stats(writer_stats, num_writers, "write", test_loop - stats_interval, 1);
  process_stats(&scheduler_stats, 1, "scheduler", test_loop - stats_interval, 1);
  process_stats(&doublewrite_stats, 1, "doublewrite", test_loop - stats_interval, 1);
  process_stats(&binlog_write_stats, 1, "binlog_write", test_loop - stats_interval, 1);
  process_stats(&binlog_fsync_stats, 1, "binlog_fsync", test_loop - stats_interval, 1);
  process_stats(&trxlog_write_stats, 1, "trxlog_write", test_loop - stats_interval, 1);
  process_stats(&trxlog_fsync_stats, 1, "trxlog_fsync", test_loop - stats_interval, 1);
  printf("final other: %d dirty, %d pending, %.1f avg pages per doublewrite write\n",
         buffer_pool.dirty_pages, buffer_pool.list_count,
         total_doublewrite_pages / MYMAX(total_doublewrite_writes, 1.0));

  qsort(reads_per_interval, max_loops, sizeof(int), icompare);
  qsort(writes_per_interval, max_loops, sizeof(int), icompare);

  print_percentiles(reads_per_interval, "rd", max_loops);
  print_percentiles(writes_per_interval, "wr", max_loops);

  pthread_mutex_unlock(&stats_mutex);

  if (binlog)
    free(binlog_buf);
  if (trxlog)
    free(trxlog_buf);

  free(compressed_page);
  free(buffer_pool_mem);
  for (i = 0; i < num_users; ++i) 
    free(user_stats[i].compress_buf);

  free(user_stats);
  free(user_threads);
  free(writer_threads);
  free(writer_stats);
  free(reads_per_interval);
  free(writes_per_interval);

  return 0;
}
