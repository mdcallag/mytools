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

#include <dirent.h>
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

int test_duration = 60;

int prepare = 0;

int fanout = 10;

int dirty_pct = 30;

int redolog = 1;
int redolog_write_size = 512;
longlong redolog_file_size = 10L * 1024 * 1024;

/* zero means no compression */
int compress_level = 0;

/* Percentage of user requests that are updates */
int update_pct = 0;

/* When != 0 use fsync after redolog writes */
int redolog_sync = 0;

/* Wait this long for group fsync on the redolog */
int redolog_sync_wait_millis = 0;

longlong data_file_size = 2L * 1024 * 1024;
longlong data_block_size = 16L*1024;
longlong compact_read_blocks = 4;

int num_data_files = 101;
int data_file_counter = 0;

int num_compact = 1;
int num_users = 1;

int compact_read_miss_pct = 100;

int checksum_write = 1;
int checksum_verify = 1;
int checksum_assert = 1;

const char* data_dir = ".";

#define MAX_FNAME 256

int stats_interval=10;

const char* data_fname = "DATA";
const char* redolog_fname = "REDOLOG";

typedef struct {
  int       dfile_fd;
  longlong  dfile_len;
  int       dfile_locked;
  char     *dfile_fname;
} DFILE;

DFILE* dfiles = NULL;
DFILE* recycle_dfiles = NULL;

int file_recycle_limit = 0;
int file_recycle_count = 0;
int file_recycle_truncate = 0;

int use_sync_file_range = 0;

int redolog_fd;
longlong redolog_offset = 0;
char* redolog_buf = NULL;

size_t n_blocks = 0;

char* compressed_page;
int compressed_page_len;

char* uncompressed_page;
int uncompressed_page_len;

#define MYMIN(x,y) ((x) < (y) ? (x) : (y))
#define MYMAX(x,y) ((x) > (y) ? (x) : (y))

#define SYNC_NO                0
#define SYNC_FSYNC             1
#define SYNC_FDATASYNC         2
#define SYNC_ODIRECT           3
#define SYNC_ODIRECT_FSYNC     4
#define SYNC_ODIRECT_SYNC      5

char* sync_names[] = {
  "no",
  "fsync",
  "fdatasync",
  "odirect",
  "odirect_fsync",
  "odirect_sync"
};

int sync_type = SYNC_NO;
int advise_user = 0;
int advise_compact = 0;
longlong write_bytes_per_second = 0;
double secs_per_loop_per_thr = 0.0;

/* Statistics */
pthread_mutex_t stats_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t redolog_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t dfiles_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t recycle_dfiles_mutex = PTHREAD_MUTEX_INITIALIZER;

#define INTERVAL_MAX  100000
#define TOTAL_MAX    1000000
 
typedef struct {
  int total_requests;
  longlong total_latency;
  long total_max;
  long total_latencies[TOTAL_MAX];
  longlong total_bytes_read;
  longlong total_bytes_written;
  long interval_requests;
  long interval_latency;
  long interval_max;
  long interval_latencies[INTERVAL_MAX];
  longlong interval_bytes_read;
  longlong interval_bytes_written;
  unsigned long adler;
} operation_stats;

operation_stats redolog_write_stats;
operation_stats redolog_sync_stats;

int open_options() {

  switch (sync_type) {
  case SYNC_ODIRECT:
  case SYNC_ODIRECT_FSYNC:
    return O_DIRECT;
  case SYNC_ODIRECT_SYNC:
    return O_DIRECT | O_SYNC;
  default:
    return 0;
  }
}

void set_user_options(int fd) {
  if (advise_user) {
    assert(!posix_fadvise(fd, 0, 0, POSIX_FADV_RANDOM));
  }
}

void set_compact_options(int fd) {
  int flags;

  if (advise_compact)
    flags = POSIX_FADV_SEQUENTIAL;
  else
    flags = POSIX_FADV_NORMAL;

  assert(!posix_fadvise(fd, 0, 0, flags));
}

void sync_after_writes(int fd) {
  if (sync_type == SYNC_FSYNC ||
      sync_type == SYNC_ODIRECT_FSYNC)
    assert(!fsync(fd));
  else if (sync_type == SYNC_FDATASYNC)
    assert(!fdatasync(fd));
}

void check_write(int fd, void* buf, size_t size, const char* msg) {
  int r = write(fd, buf, size);
  if (r != size) {
    fprintf(stderr,
            "write of %d bytes returned %d on file descriptor %d\n",
            (int) size, r, fd);
    perror(msg);
    assert(0);
  }
}

void check_pread(int fd, void* buf, size_t size, off_t offset,
		 const char* msg, const char* fname) {
  int r = pread64(fd, buf, size, offset);
  if (r != size) {
    fprintf(stderr, "read %d, expected %d at offset %lld from %s\n",
	    r, (int) size, (longlong) offset, fname);
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

/* Return value from 0 to max-1 */
int rand_choose(struct drand48_data* ctx, int max) {
  double r = rand_double(ctx);
  int ir = (int) (r * max);
  assert(ir < max);
  return ir;
}

longlong rand_block(struct drand48_data* ctx, longlong len) {
  longlong block_no = (longlong) (rand_double(ctx) * (len-1)) / data_block_size;
  assert((block_no * data_block_size) <= (len - data_block_size));
  return block_no;
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

void page_check_checksum(char* page) {
    if (!checksum_verify)
      return;
    else {
      int computed_cs = adler32(0, (unsigned char*) page + PAGE_DATA_OFFSET, PAGE_DATA_BYTES);
      int stored_cs = (int) deserialize_int(page + PAGE_CHECKSUM_OFFSET);
      /* int stored_page_num = (int) deserialize_int(page + PAGE_NUM_OFFSET); */

      if (checksum_assert && computed_cs != stored_cs) {
        fprintf(stderr,
                "Cannot validate page, checksum stored(%d) and computed(%d)\n",
                stored_cs, computed_cs);
        exit(-1);
      }
    }
}

void page_write_checksum(char* page, unsigned int page_num) {
    if (!checksum_write)
        return;
    else {
        int checksum = adler32(0, (unsigned char*) page + PAGE_DATA_OFFSET, PAGE_DATA_BYTES);
        serialize_int(page + PAGE_CHECKSUM_OFFSET, checksum);
        serialize_int(page + PAGE_NUM_OFFSET, page_num);
    }
}

void decompress_page(char* decomp_buf, unsigned int decomp_buf_len) {
  z_stream stream;
  int err;

  stream.next_in = (unsigned char*) compressed_page;
  stream.avail_in = compressed_page_len;
  stream.next_out = (unsigned char*) decomp_buf;
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

  stream.next_in = (unsigned char*) source;
  stream.avail_in = source_len;
  stream.next_out = (unsigned char*) dest;
  stream.avail_out = dest_len;
  stream.zalloc = (alloc_func) 0;
  stream.zfree = (free_func) 0;
  stream.opaque = NULL;

  err = deflateInit(&stream, compress_level);
  assert(err == Z_OK);

  err = deflate(&stream, Z_FINISH);
  assert(err == Z_STREAM_END || err == Z_OK);
  compressed_size = stream.total_out;
  err = deflateEnd(&stream);
  return compressed_size;
}


void stats_report_with_latency(operation_stats* stats,
                               long latency,
       		               struct drand48_data* randctx,
			       longlong bytes_read,
			       longlong bytes_written) {
  int sample_index;

  stats->total_requests++;
  stats->total_latency += latency;
  stats->total_bytes_read += bytes_read;
  stats->total_bytes_written += bytes_written;

  stats->interval_requests++;
  stats->interval_latency += latency;
  stats->interval_bytes_read += bytes_read;
  stats->interval_bytes_written += bytes_written;

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
		  struct drand48_data* randctx,
		  longlong bytes_read,
		  longlong bytes_written) {
  long latency;
  struct timeval stop;

  now(&stop);
  latency = now_minus_then_usecs(&stop, start);

  pthread_mutex_lock(&stats_mutex);
  stats_report_with_latency(stats, latency, randctx,
                            bytes_read, bytes_written);
  pthread_mutex_unlock(&stats_mutex);
}

void stats_init(operation_stats* stats) {
  stats->total_requests = 0;
  stats->total_latency = 0;
  stats->total_max = 0;
  stats->total_bytes_read = 0;
  stats->total_bytes_written = 0;
  stats->interval_requests = 0;
  stats->interval_latency = 0;
  stats->interval_max = 0;
  stats->interval_bytes_read = 0;
  stats->interval_bytes_written = 0;
  stats->adler = 0;
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
                              long* maxv, long* requests, longlong* latency,
			      longlong* bytes_read,
			      longlong* bytes_written,
                              longlong* bytes_total) {
  int nsamples = MYMIN(stats->interval_requests, INTERVAL_MAX);

  qsort(&(stats->interval_latencies[0]), nsamples, sizeof(long), lcompare);

  *requests = stats->interval_requests;
  *latency = stats->interval_latency;
  *maxv = stats->interval_max;
  *p95 = stats->interval_latencies[(int) (nsamples * 0.95)];
  *p99 = stats->interval_latencies[(int) (nsamples * 0.99)];
  *avg = (double) stats->interval_latency / (double) stats->interval_requests;
  *bytes_read = stats->interval_bytes_read;
  *bytes_written = stats->interval_bytes_written;
  *bytes_total = *bytes_read + *bytes_written;

  stats->interval_bytes_read = 0;
  stats->interval_bytes_written = 0;
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

void open_file(int truncate, DFILE* dfile, char* existing_name) {
  int x;
  char fname[MAX_FNAME*2+1];
  int fd;
  int options;

  if (!existing_name) {
    pthread_mutex_lock(&dfiles_mutex);
    x = data_file_counter++;
    pthread_mutex_unlock(&dfiles_mutex);

    sprintf(fname, "%s/%s.%d", data_dir, data_fname, x);
  } else {
    sprintf(fname, "%s/%s", data_dir, existing_name);
    int num;

    if (sscanf(existing_name + strlen(data_fname) + strlen("."), "%d", &num) != 1) {
      fprintf(stderr, "Unable to scan file number from: %s\n", existing_name);
      assert(0);
    } else {
      /* fprintf(stderr, "Scanned file number %d from %s\n", num, existing_name); */
    }

    pthread_mutex_lock(&dfiles_mutex);
    data_file_counter = MYMAX(data_file_counter, num+1);
    pthread_mutex_unlock(&dfiles_mutex);
  }

  options = open_options();

  if (truncate) {
    fd = open(fname, O_CREAT|O_RDWR|O_TRUNC|options, 0644);
  } else {
    fd = open(fname, O_CREAT|O_RDWR|options, 0644);
  }

  assert(fd >= 0);
  set_user_options(fd);

  dfile->dfile_fd = fd;
  dfile->dfile_locked = 0;
  dfile->dfile_len = 0;
  dfile->dfile_fname = strdup(fname);
}

int lock_random_file(struct drand48_data* ctx) {
  int x;

  pthread_mutex_lock(&dfiles_mutex);

  do {
    x = rand_choose(ctx, num_data_files);
  } while (dfiles[x].dfile_locked);

  assert(dfiles[x].dfile_locked == 0);
  dfiles[x].dfile_locked = 1;
  
  pthread_mutex_unlock(&dfiles_mutex);
  return x;
}

void* user_func(void* arg) {
  operation_stats* stats = (operation_stats*) arg;
  struct timeval start;
  struct drand48_data ctx;
  char* buf;
  void* vbuf;
  char* zbuf = (char*) malloc(data_block_size*3);
  int zbuf_len = data_block_size*3;

  assert(!posix_memalign(&vbuf, data_block_size, data_block_size));
  buf = vbuf;

  init_rand_ctx(&ctx);

  while (!shutdown) {
    int x = lock_random_file(&ctx);
    DFILE* dfile = &dfiles[x];
    longlong block_no = rand_block(&ctx, dfile->dfile_len);
    longlong offset = block_no * data_block_size;

    now(&start);
    check_pread(dfile->dfile_fd, buf, data_block_size,
		offset, "user", dfile->dfile_fname);

    page_check_checksum(buf);

    if (compress_level)
      decompress_page(zbuf, zbuf_len);

    stats_report(stats, &start, &ctx, data_block_size, 0);

    pthread_mutex_lock(&dfiles_mutex);
    assert(dfiles[x].dfile_locked == 1);
    dfiles[x].dfile_locked = 0;
    pthread_mutex_unlock(&dfiles_mutex);
  }

  free(buf);
  free(zbuf);
  return arg;
}

int get_recycled_files(DFILE* new_dfiles, int limit) {
  int i, found = 0;

  if (!file_recycle_limit)
    return 0;

  pthread_mutex_lock(&recycle_dfiles_mutex);
  for (i = 0; i < limit && file_recycle_count; ++i, --file_recycle_count) {
    assert(file_recycle_count >= 0 && file_recycle_count < file_recycle_limit);
    new_dfiles[i] = recycle_dfiles[file_recycle_count - 1];
  }
  pthread_mutex_unlock(&recycle_dfiles_mutex);
  found = i;

  /* This isn't done in handle_old_files to avoid mutex waits */
  if (file_recycle_truncate)
    for (i = 0; i < found; ++i) {
      assert(!lseek(new_dfiles[i].dfile_fd, 0, SEEK_SET));
      assert(!ftruncate(new_dfiles[i].dfile_fd, 0));
    }

  return found;
}

void delete_files() {
  int i;
  pthread_mutex_lock(&recycle_dfiles_mutex);
  for (i = 0; i < file_recycle_count; ++i) {
    assert(!close(recycle_dfiles[i].dfile_fd));
    assert(!unlink(recycle_dfiles[i].dfile_fname));
    free(recycle_dfiles[i].dfile_fname);
  }
  file_recycle_count = 0;
  pthread_mutex_unlock(&recycle_dfiles_mutex);

  if (recycle_dfiles)
    free(recycle_dfiles);

  for (i = 0; i < num_data_files; ++i)
    free(dfiles[i].dfile_fname);
  free(dfiles);
}

void handle_old_files(int count, int* fds, char** fnames) {
  int i;

  pthread_mutex_lock(&recycle_dfiles_mutex);
  for (i = 0; i < count && file_recycle_count < (file_recycle_limit-1); ++i, ++file_recycle_count) {
    assert(file_recycle_count >= 0 && file_recycle_count < (file_recycle_limit-1));
    recycle_dfiles[file_recycle_count].dfile_fd = fds[i];
    recycle_dfiles[file_recycle_count].dfile_len = 0;
    recycle_dfiles[file_recycle_count].dfile_locked = 0;
    recycle_dfiles[file_recycle_count].dfile_fname = fnames[i];
  }
  pthread_mutex_unlock(&recycle_dfiles_mutex);

  for (; i < count; ++i) {
    assert(!close(fds[i]));

    if (unlink(fnames[i])) {
      fprintf(stderr, "unlink failed for %s\n", fnames[i]);
      perror("Unlink failed");
      assert(0);
    }
    free(fnames[i]);
  }
}


void* compact_func(void* arg) {
  operation_stats* stats = (operation_stats*) arg;
  char** data;
  struct timeval start;
  struct drand48_data ctx;
  int* input_x;
  DFILE* new_dfiles;
  char** old_fnames;
  int* old_fds;
  int i;
  long long read_size = data_block_size * compact_read_blocks;
  char* zbuf = (char*) malloc(data_block_size*3);
  int zbuf_len = data_block_size*3;
  double usecs_per_loop = 1000000.0 * secs_per_loop_per_thr;
  struct timeval rate_start;

  now(&rate_start);

  old_fds = (int*) malloc(sizeof(int) * (fanout+1));
  old_fnames = (char**) malloc(sizeof(char*) * (fanout+1));

  data = (char**) malloc(sizeof(char*) * (fanout+2));
  for (i=0; i < (fanout+2); ++i)
    assert(!posix_memalign((void**) &data[i], data_block_size, read_size));

  input_x = (int*) malloc(sizeof(int) * (fanout+1));
  new_dfiles = (DFILE*) malloc(sizeof(DFILE) * (fanout+1));

  init_rand_ctx(&ctx);

  while (!shutdown) {
    longlong read_offset = 0;
    longlong output_offset = 0;
    int output_x = 0;
    longlong bytes_read = 0;
    longlong bytes_written = 0;
    /* When a compaction uses "cached reads" all of the compaction reads
       use the same input file to simulate most of the reads hitting
       in the OS filesystem cache.
    */
    int uncached_reads = rand_choose(&ctx, 100) < compact_read_miss_pct;

    for (i=0; i < (fanout+1); ++i) {
      int x = lock_random_file(&ctx);

      input_x[i] = x;
      set_compact_options(dfiles[x].dfile_fd);
    }

    now(&start);

    i = get_recycled_files(new_dfiles, fanout+1);

    for (; i < (fanout+1); ++i)
      open_file(1, &new_dfiles[i], NULL);

    while (read_offset < data_file_size) {

      for (i=0; i < (fanout+1); ++i) {
	int b;
        int read_fd_idx = uncached_reads ? input_x[i] : 0;

        check_pread(dfiles[read_fd_idx].dfile_fd, data[i],
                    read_size, read_offset, "compact",
                    dfiles[read_fd_idx].dfile_fname);
        if (uncached_reads)
	  bytes_read += read_size;

	for (b=0; b < compact_read_blocks; ++b) {
	  page_check_checksum(data[i] + (b * data_block_size));
	  if (compress_level)
	    decompress_page(zbuf, zbuf_len);
	}

      }
      read_offset += read_size;

      for (i=0; i < (fanout+1); ++i) {
	int b;

	for (b=0; b < compact_read_blocks; ++b) {
	  page_write_checksum(data[i] + (b * data_block_size), i+b);
	  if (compress_level)
	    compress_page(compressed_page, compressed_page_len, zbuf, zbuf_len);
	}

        check_write(new_dfiles[output_x].dfile_fd, data[i], read_size,
		    "compaction write");
	bytes_written += read_size;

        output_offset += read_size;
        if (output_offset >= data_file_size) {
          new_dfiles[output_x].dfile_len = output_offset;
          if (use_sync_file_range) {
            sync_file_range(new_dfiles[output_x].dfile_fd, 0, 0,
                            SYNC_FILE_RANGE_WRITE);
          } else {
  	    sync_after_writes(new_dfiles[output_x].dfile_fd);
          }
          ++output_x;
          output_offset = 0;
        }
      }
    }

    if (use_sync_file_range)
      for (i=0; i < (fanout+1); ++i)
        sync_after_writes(new_dfiles[i].dfile_fd);

    stats_report(stats, &start, &ctx, bytes_read, bytes_written);

    assert(output_x == (fanout+1));

    pthread_mutex_lock(&dfiles_mutex);
    for (i=0; i < (fanout+1); ++i) {
      DFILE* old_f = &dfiles[input_x[i]];
      DFILE* new_f = &new_dfiles[i];
      
      old_fnames[i] = old_f->dfile_fname;
      old_fds[i] = old_f->dfile_fd;

      *old_f = *new_f;
    }
    pthread_mutex_unlock(&dfiles_mutex);

    handle_old_files(fanout+1, old_fds, old_fnames);

    if (write_bytes_per_second) {
      struct timeval rate_cur;
      long usecs_elapsed;

      now(&rate_cur);
      usecs_elapsed = now_minus_then_usecs(&rate_cur, &rate_start);

      if (usecs_elapsed > 0 && usecs_elapsed < usecs_per_loop) {
        usleep(usecs_per_loop - usecs_elapsed);
        now(&rate_start);
      } else {
        rate_start = rate_cur;
      }
    }
  }

  for (i=0; i < (fanout+2); ++i)
    free(data[i]);
  free(data);
  free(input_x);
  free(new_dfiles);
  free(old_fnames);
  free(old_fds);
  free(zbuf);
  return NULL;
}

int process_stats(operation_stats* const stats, int num, const char* msg, int loop, int final) {
  long max_maxv = 0;
  longlong sum_latency = 0;
  int sx, rx;
  struct drand48_data randctx;
  long requests, p95, p99, maxv;
  longlong latency;
  longlong bytes_read, bytes_written, bytes_total;
  double avg;
  int sum_requests = 0;
  operation_stats* curstats;
  operation_stats* combined = (operation_stats*) malloc(sizeof(operation_stats));

  stats_init(combined);
  init_rand_ctx(&randctx);

  if (!final) {
    /* Merge into combined before interval_latencies are cleared */
    for (sx = 0, curstats=stats; sx < num; ++sx, ++curstats) {
      combined->interval_bytes_read += curstats->interval_bytes_read;
      combined->interval_bytes_written += curstats->interval_bytes_written;
      combined->total_bytes_read += curstats->total_bytes_read;
      combined->total_bytes_written += curstats->total_bytes_written;

      for (rx = 0; rx < MYMIN(INTERVAL_MAX, curstats->interval_requests); ++rx)
        stats_report_with_latency(combined, curstats->interval_latencies[rx],
                                  &randctx, 0, 0);
    }

    /* And then summarize */
    for (sx = 0, curstats=stats; sx < num; ++sx, ++curstats) {
      stats_summarize_interval(curstats, &p95, &p99, &avg, &maxv, &requests,
			       &latency, &bytes_read, &bytes_written,
                               &bytes_total);
      sum_requests += requests;
      sum_latency += latency;
      if (maxv > max_maxv) max_maxv = maxv;
    }
   
  } else {
    /* Merge into combined */
    for (sx = 0, curstats=stats; sx < num; ++sx, ++curstats) {
      combined->interval_bytes_read += curstats->interval_bytes_read;
      combined->interval_bytes_written += curstats->interval_bytes_written;
      combined->total_bytes_read += curstats->total_bytes_read;
      combined->total_bytes_written += curstats->total_bytes_written;

      for (rx = 0; rx < MYMIN(TOTAL_MAX, curstats->total_requests); ++rx)
        stats_report_with_latency(combined, curstats->total_latencies[rx],
                                  &randctx, 0, 0);
    }

    /* And then summarize  */
    for (sx = 0, curstats=stats; sx < num; ++sx, ++curstats) {
      stats_summarize_total(curstats, &p95, &p99, &avg, &maxv, &requests, &latency);
      sum_requests += requests;
      sum_latency += latency;
      if (maxv > max_maxv) max_maxv = maxv;
    }

  }

  stats_summarize_interval(combined, &p95, &p99, &avg, &maxv, &requests, &latency,
                           &bytes_read, &bytes_written, &bytes_total);

  if (!final) {
    printf("%s: %d loop, %u ops, %.1f ops/sec, %.3f millis/op, %.3f p95, %.3f p99, "
           "%.3f max, MB/sec %.1f read, %.1f write, %.1f r+w\n",
           msg, loop, sum_requests,
           (double) sum_requests / stats_interval,
           ((double) sum_latency / sum_requests) / 1000.0,
           p95 / 1000.0, p99 / 1000.0, max_maxv / 1000.0,
	   bytes_read / (1024.0 * 1024) / stats_interval,
	   bytes_written / (1024.0 * 1024) / stats_interval,
	   bytes_total / (1024.0 * 1024) / stats_interval);
  } else {
    printf("%s: final, %u ops, %.1f ops/sec, %.3f millis/op, %.3f p95, %.3f p99, "
           "%.3f max, MB/sec %.1f read, %.1f write, %.1f r+w\n",
           msg, sum_requests,
           (double) sum_requests / test_duration,
           ((double) sum_latency / sum_requests) / 1000.0,
           p95 / 1000.0, p99 / 1000.0, max_maxv / 1000.0,
	   combined->total_bytes_read / (1024.0 * 1024) / test_duration,
	   combined->total_bytes_written / (1024.0 * 1024) / test_duration,
	   (combined->total_bytes_read + combined->total_bytes_written)
               / (1024.0 * 1024) / test_duration);
  }
  free(combined);

  return sum_requests;
}

void open_data_files(int prepare) {
  int page_num;
  char* buf;
  void* vbuf;
  int i;
  struct stat stat_buf;

  assert(!posix_memalign(&vbuf, data_block_size, data_block_size));
  buf = vbuf;
  dfiles = (DFILE*) malloc(num_data_files * sizeof(DFILE));
  if (file_recycle_limit) {
    recycle_dfiles = (DFILE*) malloc(file_recycle_limit * sizeof(DFILE));
  }

  if (prepare) {

    for (i = 0; i < num_data_files; ++i) {
      open_file(1, &dfiles[i], NULL);

      for (page_num=0; page_num < n_blocks; ++page_num) {
	page_fill(buf, page_num);
	page_write_checksum(buf, page_num);
	check_write(dfiles[i].dfile_fd, buf, data_block_size, "prepare_data_file");
      }

      sync_after_writes(dfiles[i].dfile_fd);
      assert(!lseek(dfiles[i].dfile_fd, 0, SEEK_SET));
      dfiles[i].dfile_len = n_blocks * data_block_size;
    }
    
  } else {

    struct dirent* entry;
    DIR* dir = opendir(data_dir);

    fprintf(stderr, "looking for files in: %s\n", data_dir);
    if (!dir) {
      perror("Cannot open data directory");
      assert(0);
    }

    i = 0;

    while ((entry = readdir(dir)) != NULL &&
	   i < num_data_files) {

      if (!strncmp(entry->d_name, data_fname, strlen(data_fname))) {
	/* fprintf(stderr, "Found %s\n", entry->d_name); */

	open_file(0, &dfiles[i], entry->d_name);

	if (fstat(dfiles[i].dfile_fd, &stat_buf)) {
	  perror("stat for --data-file-name failed");
	  printf("Do you need to prepare files? (use --prepare 1)\n");
	  exit(-1);
	}

	/* fprintf(stderr, "Filesystem block size for %s is %d\n",
	   data_fname, (int) stat_buf.st_blksize); */

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

	dfiles[i].dfile_len = data_file_size;
	++i;
      }
    }
    closedir(dir);
    assert(i == num_data_files);
  }

  free(buf);
}

void print_help() {
  printf(
"This is a an LSM simulator.\n"
"\n"
"Options:\n"
"  --help -- print help message and exit\n"
"  --prepare 1|0         -- 1: create files and then run, 0: assume files exist, run\n"
"  --data-file-name s    -- pathname for database files\n"
"  --data-file-size n    -- size of each database file in bytes\n"
"  --data-block-size n   -- size of database blocks in bytes\n"
"  --fanout n            -- LevelDB style fanout\n"
"  --num-data-files n    -- number of database files\n"
"  --num-compact n       -- number of compaction threads\n"
"  --num-users n         -- number of user threads\n"
"  --file-recycle-limit 1|0 -- when > 0 reuse old files instead of deleting\n"
"  --file-recycle-truncate 1|0 -- when > 0 truncate files before reusing them\n"
"  --sync-file-range 1|0 -- when 1 then use sync_file_range to start syncs faster during compaction\n"
"  --compact-read-miss-percent n -- pct of compaction reads that do disk IO\n"
"  --write-bytes-per-second -- rate limit for compaction writes\n"
"  --stats-interval n    -- interval in seconds at which stats are reported\n"
"  --test-duration n     -- number of seconds to run the test\n"
"  --scheduler-sleep-usecs n -- page writes are scheduled every n microseconds\n"
"  --buffer-pool-mb n    -- size of DBMS buffer pool in MB\n"
"  --compress-level n    -- zlib compression level, when 0 no compression is used\n"
"  --sync [no|fsync|fdatasync|odirect|odirect_fsync|odirect_osync]\n"
"  --advise_user 1|0     -- when 1 use POSIX_FADV_RANDOM for random reads\n"
"  --advise_compact 1|0  -- when 1 use POSIX_FADV_SEQUENTIAL for compact reads\n"
"  --checksum-write 1|0  -- write checksums\n"
"  --checksum-verify 1|0 -- verify checksums\n"
"  --update-pct n        -- percentage of user requests that are updates\n"
"  --redolog-sync 1|0    -- when 1 use fsync after redolog writes\n"
"  --redolog-sync-wait n -- wait n milliseconds for group fsync on the redolog\n"
);

  exit(0);
}

void process_options(int argc, char **argv) {
  int x;

  for (x = 1; x < argc; ++x) {
    if (!strcmp(argv[x], "--help")) {
      print_help();

    } else if (!strcmp(argv[x], "--sync")) {
      if (x == (argc - 1)) { printf("--sync needs an arg\n"); exit(-1); }
      ++x;

      if (!strcmp(argv[x], "fsync")) {
	sync_type = SYNC_FSYNC;
      } else if (!strcmp(argv[x], "fdatasync")) {
	sync_type = SYNC_FDATASYNC;
      } else if (!strcmp(argv[x], "odirect")) {
	sync_type = SYNC_ODIRECT;
      } else if (!strcmp(argv[x], "odirect_fsync")) {
	sync_type = SYNC_ODIRECT_FSYNC;
      } else if (!strcmp(argv[x], "odirect_sync")) {
	sync_type = SYNC_ODIRECT_SYNC;
      } else {
	sync_type = SYNC_NO;
      }

    } else if (!strcmp(argv[x], "--sync-file-range")) {
      if (x == (argc - 1)) { printf("--sync-file-range needs an arg\n"); exit(-1); }
      use_sync_file_range = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--file-recycle-limit")) {
      if (x == (argc - 1)) { printf("--file-recycle-limit needs an arg\n"); exit(-1); }
      file_recycle_limit = atoi(argv[++x]);
      if (file_recycle_limit < 0) {
        printf("file-recycle-limit is %d and must be >= 0\n", file_recycle_limit);
        exit(-1);
      }

    } else if (!strcmp(argv[x], "--file-recycle-truncate")) {
      if (x == (argc - 1)) { printf("--file-recycle-truncate needs an arg\n"); exit(-1); }
      file_recycle_truncate = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--advise-user")) {
      if (x == (argc - 1)) { printf("--advise-user needs an arg\n"); exit(-1); }
      advise_user = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--advise-compact")) {
      if (x == (argc - 1)) { printf("--advise-compact needs an arg\n"); exit(-1); }
      advise_compact = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--write-bytes-per-second")) {
      if (x == (argc - 1)) { printf("--write-bytes-per-second needs an arg\n"); exit(-1); }
      write_bytes_per_second = atoll(argv[++x]);

    } else if (!strcmp(argv[x], "--prepare")) {
      if (x == (argc - 1)) { printf("--prepare needs an arg\n"); exit(-1); }
      prepare = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--redolog-sync")) {
      if (x == (argc - 1)) { printf("--redolog-sync needs an arg\n"); exit(-1); }
      redolog_sync = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--redolog-sync-wait-millis")) {
      if (x == (argc - 1)) { printf("--redolog-sync-wait needs an arg\n"); exit(-1); }
      redolog_sync_wait_millis = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--update-pct")) {
      if (x == (argc - 1)) { printf("--update-pct needs an arg\n"); exit(-1); }
      update_pct = atoi(argv[++x]);
    } else if (!strcmp(argv[x], "--checksum-verify")) {
      if (x == (argc - 1)) { printf("--checksum-verify needs an arg\n"); exit(-1); }
      checksum_verify = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--checksum-write")) {
      if (x == (argc - 1)) { printf("--checksum-write needs an arg\n"); exit(-1); }
      checksum_write = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--checksum-assert")) {
      if (x == (argc - 1)) { printf("--checksum-assert needs an arg\n"); exit(-1); }
      checksum_assert = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--data-dir")) {
      if (x == (argc - 1)) { printf("--data-dir needs an arg\n"); exit(-1); }
      data_dir = argv[++x];

    } else if (!strcmp(argv[x], "--data-file-name")) {
      if (x == (argc - 1)) { printf("--data-file-name needs an arg\n"); exit(-1); }
      data_fname = argv[++x];

    } else if (!strcmp(argv[x], "--data-file-size")) {
      if (x == (argc - 1)) { printf("--data-file-size needs an arg\n"); exit(-1); }
      data_file_size = atoll(argv[++x]);

    } else if (!strcmp(argv[x], "--data-block-size")) {
      if (x == (argc - 1)) { printf("--data-block-size needs an arg\n"); exit(-1); }
      data_block_size = atoll(argv[++x]);

    } else if (!strcmp(argv[x], "--compact-read-blocks")) {
      if (x == (argc - 1)) { printf("--compact-read-blocks needs an arg\n"); exit(-1); }
      compact_read_blocks = atoll(argv[++x]);

    } else if (!strcmp(argv[x], "--fanout")) {
      if (x == (argc - 1)) { printf("--fanout needs an arg\n"); exit(-1); }
      fanout = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--num-data-files")) {
      if (x == (argc - 1)) { printf("--num-data-files needs an arg\n"); exit(-1); }
      num_data_files = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--num-compact")) {
      if (x == (argc - 1)) { printf("--num-compact needs an arg\n"); exit(-1); }
      num_compact = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--num-users")) {
      if (x == (argc - 1)) { printf("--num-users needs an arg\n"); exit(-1); }
      num_users = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--compact-read-miss-percent")) {
      if (x == (argc - 1)) { printf("--compact-read-miss-percent needs an arg\n"); exit(-1); }
      compact_read_miss_pct = atoi(argv[++x]);
      if (compact_read_miss_pct > 100 || compact_read_miss_pct < 0) {
        printf("--compact-miss-read-percent is %d and must be between 0 and 100\n",
               compact_read_miss_pct);
        exit(-1);
      }

    } else if (!strcmp(argv[x], "--stats-interval")) {
      if (x == (argc - 1)) { printf("--stats-interval needs an arg\n"); exit(-1); }
      stats_interval = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--test-duration")) {
      if (x == (argc - 1)) { printf("--test-duration needs an arg\n"); exit(-1); }
      test_duration = atoi(argv[++x]);
  
    } else if (!strcmp(argv[x], "--compress-level")) {
      compress_level = atoi(argv[++x]);
      if (compress_level < 0 || compress_level > 9) {
        printf("--compress-level set to %d and should be between 0 and 9\n",
               compress_level);
        exit(-1);
      }
    }
  }

  if ((num_data_files / 10) < fanout) {
    printf("num-data-files must be 10x greater than fanout\n");
    exit(-1);
  }

  /* Compute seconds per loop as:
     1 / (bytes/second * loops/byte)
  */
  if (write_bytes_per_second) {
    secs_per_loop_per_thr = 1 /
      ((write_bytes_per_second / num_compact) *
      (1.0 / ((fanout+1) * data_file_size)));
  }

  printf("Prepare files: %d\n", prepare);
  printf("Sync type: %s\n", sync_names[sync_type]);
  printf("Advise user: %d, compact: %d\n", advise_user, advise_compact);
  printf("Database directory: %s\n", data_dir);
  printf("Database file name: %s\n", data_fname);
  printf("Database file size: %llu\n", data_file_size);
  printf("Database block size: %llu\n", data_block_size);
  printf("Fanout: %d\n", fanout);
  printf("Number of database files: %d\n", num_data_files);
  printf("Number of compaction threads: %d\n", num_compact);
  printf("Number of user threads: %d\n", num_users);
  printf("Use sync_file_range(): %d\n", use_sync_file_range);
  printf("File recycle limit: %d\n", file_recycle_limit);
  printf("File recycle truncate: %d\n", file_recycle_truncate);
  printf("Compact read miss percent: %d\n", compact_read_miss_pct);
  printf("Write bytes per second: %lld\n", write_bytes_per_second);
  printf("Seconds per loop per compact thread: %0.3f\n", secs_per_loop_per_thr);
  printf("Loops per second per compact thread: %0.3f\n", 1 / secs_per_loop_per_thr);
  printf("Stats interval: %d\n", stats_interval);
  printf("Test duration: %d\n", test_duration);
  printf("Use compression=%s with level %d\n",
         compress_level > 0 ? "yes" : "no", compress_level);
  printf("Sync redolog: %d\n", redolog_sync);
  printf("Sync redolog wait milliseconds: %d\n", redolog_sync_wait_millis);
  printf("Update percent: %d\n", update_pct);
  printf("Checksums: %d verify, %d write, %d assert\n",
         checksum_verify, checksum_write, checksum_assert);
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

void setup_compressed_page() {
  struct drand48_data ctx;
  char* uptr;
  int i;

  init_rand_ctx(&ctx);

  /* uncompressed_page should compress by 2x */
  uncompressed_page = (char*) malloc(data_block_size * 3);
  compressed_page = (char*) malloc(data_block_size * 2);

  for (i=0, uptr = uncompressed_page;
       i < (data_block_size / sizeof(int));
       ++i, uptr += sizeof(int)) {
    int ri = rand_choose(&ctx, 1000000);
    memcpy(uptr, &ri, sizeof(ri));
  }
  memcpy(uptr, uncompressed_page, data_block_size);

  uncompressed_page_len = data_block_size * 2;
  compressed_page_len = compress_page(uncompressed_page, data_block_size*2,
		       compressed_page, data_block_size*2);
  printf("compress %d to %d\n", uncompressed_page_len, compressed_page_len);
  
  if (compress_level > 0)
    assert(compressed_page_len <= (data_block_size + 100));
}
 
int main(int argc, char **argv) {
  int i, test_loop = 0;
  int max_loops;
  void* retval;
  pthread_t *compact_threads;
  pthread_t *user_threads;
  int *compact_per_interval;
  int *user_per_interval;
  operation_stats* compact_stats;
  operation_stats* user_stats;

  process_options(argc, argv);

  n_blocks = data_file_size / data_block_size;
  if (n_blocks >= 0xffffffff) {
    fprintf(stderr, "data-file-size/data-block-size must be "
            "less than 0xffffffff\n");
    exit(-1);
  }

  setup_compressed_page();

  open_data_files(prepare);

  max_loops = test_duration / stats_interval;

  /* TODO fstat, stat checks */

  compact_threads = (pthread_t*) malloc(sizeof(pthread_t) * num_compact);
  compact_stats = (operation_stats*) malloc(sizeof(operation_stats) * num_compact);

  user_threads = (pthread_t*) malloc(sizeof(pthread_t) * num_users);
  user_stats = (operation_stats*) malloc(sizeof(operation_stats) * num_users);

  compact_per_interval = (int*) malloc((1 + max_loops) * sizeof(int));
  memset(compact_per_interval, 0, sizeof(int) * (1 + max_loops));

  user_per_interval = (int*) malloc((1 + max_loops) * sizeof(int));
  memset(user_per_interval, 0, sizeof(int) * (1 + max_loops));

  for (i = 0; i < num_compact; ++i) {
    stats_init(&compact_stats[i]);
    pthread_create(&compact_threads[i], NULL, compact_func, &compact_stats[i]);
  }

  for (i = 0; i < num_users; ++i) {
    stats_init(&user_stats[i]);
    pthread_create(&user_threads[i], NULL, user_func, &user_stats[i]);
  }

  for (test_loop = 1; test_loop <= max_loops; ++test_loop) {
    sleep(stats_interval);

    pthread_mutex_lock(&stats_mutex);

    compact_per_interval[test_loop - 1] =
        process_stats(compact_stats, num_compact, "compact", test_loop, 0);

    user_per_interval[test_loop - 1] =
        process_stats(user_stats, num_users, "user", test_loop, 0);

    pthread_mutex_unlock(&stats_mutex);
  }

  shutdown = 1;

  fprintf(stderr, "waiting for compact threads to stop\n");
  for (i = 0; i < num_compact; ++i)
    pthread_join(compact_threads[i], &retval);

  fprintf(stderr, "waiting for user threads to stop\n");
  for (i = 0; i < num_users; ++i)
    pthread_join(user_threads[i], &retval);

  pthread_mutex_lock(&stats_mutex);
  process_stats(compact_stats, num_compact, "compact", test_loop - stats_interval, 1);
  process_stats(user_stats, num_users, "user", test_loop - stats_interval, 1);

  qsort(compact_per_interval, max_loops, sizeof(int), icompare);
  print_percentiles(compact_per_interval, "compact", max_loops);

  qsort(user_per_interval, max_loops, sizeof(int), icompare);
  print_percentiles(user_per_interval, "user", max_loops);

  pthread_mutex_unlock(&stats_mutex);

  delete_files();

  free(compact_threads);
  free(compact_stats);
  free(compact_per_interval);

  free(user_threads);
  free(user_stats);
  free(user_per_interval);

  free(compressed_page);
  free(uncompressed_page);

  return 0;
}
