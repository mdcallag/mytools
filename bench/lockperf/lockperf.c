/* Copyright (C) 2021 Mark Callaghan
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
#include <math.h>

typedef unsigned long long ulonglong;
typedef long long longlong;
typedef unsigned long ulong;
typedef unsigned int uint;

/* Configurable */

/* Seed for RNG */
int seed = 1;

/* Think time between lock requests */
int think_usecs = 1;

/* Amount of time to hold the lock */
int hold_usecs = 1;

/* Number of intergers to sort in a loop for think and hold time */
int sort_ints = 1024;

/* Number of seconds per test */
int nseconds = 10;

/* Minimum number of threads for which test is run */
int min_threads = 1;

/* Maximum number of threads for which test is run */
int max_threads = 4;

/* Percentage of lock requests that use shared mode */
int read_lock_percent = 10;

/* Use regular mutex when 0, else use adaptive */
int adaptive_mutex = 0;

/* Not configurable */

/* Worker threads stop when this is set */
volatile int shutdown_user = 0;

/* Number of sort loops to satisfy think_usecs and hold_usecs */
int think_sort_loops = -1;
int hold_sort_loops = -1;

/* #define MYMIN(x,y) ((x) < (y) ? (x) : (y))
#define MYMAX(x,y) ((x) > (y) ? (x) : (y)) */

/* Statistics */
pthread_mutex_t mutex_regular = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_adaptive = PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP;
pthread_mutex_t *mutex_use = NULL;

pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;

typedef struct {
  int wr_locks;
  int rd_locks;
} lock_stats;

lock_stats stats;

void check_err(int result, const char* message) {
  if (result) {
    perror(message);
    abort();
  }
}

void init_rand_ctx(int rng_seed, struct drand48_data* ctx) {
  assert(!srand48_r(rng_seed, ctx));
}

double rand_double(struct drand48_data* ctx) {
  double r;
  assert(!drand48_r(ctx, &r));
  return r;
}

long rand_long(struct drand48_data* ctx) {
  long l;
  assert(!lrand48_r(ctx, &l));
  return l;
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

void stats_init(lock_stats* stats) {
  stats->rd_locks = 0;
  stats->wr_locks = 0;
}

int icompare(const void* a, const void* b) {
  int const* ia = (int const*) a;
  int const* ib = (int const*) b;
  return *ia - *ib;
}

void busy_loop(int *sort_buf, int *sort_from, int nloops) {
  int i;

  for (i=0; i < nloops; i++) {
    memcpy(sort_buf, sort_from, sort_ints * sizeof(int));
    qsort(sort_buf, sort_ints, sizeof(int), icompare);
  }
}

void do_lock(int mutex, int is_read) {
  if (mutex) {
    check_err(pthread_mutex_lock(mutex_use), "do_lock() mutex");
  } else if (is_read) {
    check_err(pthread_rwlock_rdlock(&rwlock), "do_lock() rdlock");
  } else {
    check_err(pthread_rwlock_wrlock(&rwlock), "do_lock() wrlock");
  }
}

void do_unlock(int mutex, int is_read) {
  if (mutex) {
    check_err(pthread_mutex_unlock(mutex_use), "do_unlock() mutex");
  } else if (is_read) {
    check_err(pthread_rwlock_unlock(&rwlock), "do_unlock() rdlock");
  } else {
    check_err(pthread_rwlock_unlock(&rwlock), "do_unlock() wrlock");
  }
}

typedef struct {
  int id;
  int seed;
  int mutex;
} work_args;

void* work_func(void* arg) {
  work_args *wargs = *((work_args*)arg;
  struct drand48_data ctx;
  struct timeval start;
  double read_frac = read_lock_percent / 100.0;
  int *sort_buf;

  sort_buf = (int*) malloc(sort_ints * sizeof(int));
  assert(sort_buf);

  init_rand_ctx(wargs->seed, &ctx);

  while (!shutdown_user) {
    int is_read;

    /* TODO -- randomize to reduce convoys */
    busy_loop(sort_buf, sort_from, think_sort_loops);

    is_read = rand_double(&ctx) < read_frac;

    do_lock(wargs->mutex, is_read);

    busy_loop(sort_buf, sort_from, hold_sort_loops);

    do_unlock(wargs->mutex, is_read);
  }

  free(sort_buf);
  return NULL;
}

void print_help() {
  printf(
"Measures rw-lock vs mutex overhead.\n"
"Options:\n"
"  --seed INT : seed for RNG\n"
"  --think_usecs INT : average number of microseconds for think time\n"
"  --hold_usecs INT : average number of microseconds for lock hold time\n"
"  --sort_ints INT : number of integers in array to sort during think and hold time\n"
"  --min_threads INT : minimum number of threads to test\n"
"  --max_threads INT : maximum number of threads to test\n"
"  --read_lock_percent INT : percent of lock requests that use share mode\n"
"  --adaptive_mutex : use adaptive mutex, otherwise use default\n");
  exit(0);
}

void process_options(int argc, char **argv) {
  int x;

  for (x = 1; x < argc; ++x) {
    if (!strcmp(argv[x], "--help")) {
      print_help();

    } else if (!strcmp(argv[x], "--seed")) {
      if (x == (argc - 1)) { printf("--seed needs an arg\n"); exit(-1); }
      seed = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--think_usecs")) {
      if (x == (argc - 1)) { printf("--think_usecs needs an arg\n"); exit(-1); }
      think_usecs = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--hold_usecs")) {
      if (x == (argc - 1)) { printf("--hold_usecs needs an arg\n"); exit(-1); }
      hold_usecs = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--sort_ints")) {
      if (x == (argc - 1)) { printf("--sort_ints needs an arg\n"); exit(-1); }
      sort_ints = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--nseconds")) {
      if (x == (argc - 1)) { printf("--nseconds needs an arg\n"); exit(-1); }
      nseconds = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--min_threads")) {
      if (x == (argc - 1)) { printf("--min_threads needs an arg\n"); exit(-1); }
      min_threads = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--max_threads")) {
      if (x == (argc - 1)) { printf("--max_threads needs an arg\n"); exit(-1); }
      max_threads = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--read_lock_percent")) {
      if (x == (argc - 1)) { printf("--read_lock_percent needs an arg\n"); exit(-1); }
      read_lock_percent = atoi(argv[++x]);

    } else if (!strcmp(argv[x], "--adaptive_mutex")) {
      adaptive_mutex = 1;
    }
  }

  printf("seed: %d\n", seed);
  printf("think_usecs: %d\n", think_usecs);
  printf("hold_usecs: %d\n", hold_usecs);
  printf("sort_ints: %d\n", sort_ints);
  printf("min_threads: %d\n", min_threads);
  printf("max_threads: %d\n", max_threads);
  printf("read_lock_percent: %d\n", read_lock_percent);
  printf("adaptive_mutex: %d\n", adaptive_mutex);
}

void report(int num_threads, int duration, lock_stats *mutex_stats, lock_stats *rwlock_stats) {
  int mutex_ops = mutex_stats->rd_locks + mutex_stats->wr_locks;
  int rwlock_ops = rwlock_stats->rd_locks + rwlock_stats->wr_locks;

  printf("%d\t%d\t%d\t%.2f\n",
         num_threads,
	 mutex_ops,
	 rwlock_ops,
	 (1.0 * mutex_ops) / rwlock_ops);
}

int do_work(int num_threads, int mutex) {
  int i;
  pthread_t *work_threads = (pthread_t*) malloc(sizeof(pthread_t) * num_threads);
  work_args *wargs = (work_args*) malloc(sizeof(work_args) * num_threads);

  assert(wargs);
  assert(work_threads);

  stats_init(&stats);

  for (i = 0; i < num_threads; i++) {
    wargs[i].id = i;
    /* Start at i+1 because the main thread uses "seed" */
    wargs[i].seed = i + 1;
    wargs[i].mutex = mutex;
    pthread_create(&work_threads[i], NULL, work_func, &wargs[i]);
  }

  sleep(nseconds);

  shutdown_user = 1;

  fprintf(stderr, "waiting for user threads to stop\n");
  for (i = 0; i < num_threads; i++)
    pthread_join(work_threads[i], &retval);

  shutdown_user = 0;
  free(work_threads);
  free(wargs);
}

int main(int argc, char **argv) {
  int num_threads, test_loop = 0;
  struct drand48_data randctx;
  void *retval;

  process_options(argc, argv);
  init_rand_ctx(seed, &randctx);

  if (adaptive_mutex)
    use_mutex = &mutex_adaptive;
  else
    use_mutex = &mutex_regular;
  
  for (num_threads = min_threads; num_threads <= max_threads; num_threads++) {
    do_work(num_threads, 1);
    lock_stats mutex_stats = stats;

    do_work(num_threads, 0);
    report(num_threads, nseconds, &mutex_stats, &stats);
  }

  return 0;
}

