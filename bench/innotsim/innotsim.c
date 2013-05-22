
/* Most of this is copied from InnoDB source code.
   See this for license details:
   http://bazaar.launchpad.net/~mysql/mysql-server/5.7/files/head:/storage/innobase
*/

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <sys/time.h>

typedef unsigned long		ulong;
typedef unsigned long		ulint;
typedef char			byte;
typedef byte			lock_word_t;
typedef unsigned char		ibool;
typedef unsigned long long	ib_int64_t;

ulong	srv_n_spin_wait_rounds	= 30;
ulong	srv_spin_wait_delay	= 6;
const ulint	srv_max_n_threads	= 5000;

# define os_atomic_test_and_set_byte(ptr, new_val) \
        __sync_lock_test_and_set(ptr, (byte) new_val)

# define os_atomic_increment(ptr, amount) \
        __sync_add_and_fetch(ptr, amount)

# define os_atomic_increment_ulint(ptr, amount) \
        os_atomic_increment(ptr, amount)

#define ut_a(x)		assert(x)
#define ut_ad(x)	assert(x)

#define ut_malloc(x)	malloc(x)

pthread_mutexattr_t	my_fast_mutexattr;
#define MY_MUTEX_INIT_FAST	&my_fast_mutexattr

#define TRUE	1
#define FALSE	0

#define SRV_SHUTDOWN_EXIT_THREADS	1
#define srv_shutdown_state		0

#define SYNC_MUTEX			17

typedef pthread_t	os_thread_t;
typedef os_thread_t	os_thread_id_t;

/***********************************************************
 * os_fast_mutex_t - wrapper for pthread_mutex_t
 */
typedef pthread_mutex_t os_fast_mutex_t;

void os_fast_mutex_init(os_fast_mutex_t* fast_mutex, ibool really_fast);
void os_fast_mutex_lock(os_fast_mutex_t*);
void os_fast_mutex_unlock(os_fast_mutex_t*);

/***********************************************************
 * os_event_struct_t - the InnoDB variant of a condition variable
 */
typedef struct os_event_struct {
	os_fast_mutex_t	os_mutex;	/*!< this mutex protects the next
					fields */
	ibool		is_set;		/*!< this is TRUE when the event is
					in the signaled state, i.e., a thread
					does not stop if it tries to wait for
					this event */
	ib_int64_t	signal_count;	/*!< this is incremented each time
					the event becomes signaled */
	pthread_cond_t	cond_var;	/*!< condition variable is used in
					waiting for the event */
} os_event_struct_t;

typedef os_event_struct_t*	os_event_t;

/* Sets event to the signalled state, wakes waiting threads */
void os_event_set(os_event_t event);

os_event_t os_event_create(const char* name);

/* Waits for event to be signalled or signal count to advance */
void os_event_wait_low(os_event_t event, ib_int64_t reset_sig_count);

/* Resets event state to the non-signalled state, returns the signal count */
ib_int64_t os_event_reset(os_event_t event);

/***********************************************************
 * mutex_t - the InnoDB mutex
 */
typedef struct mutex_struct {
	os_event_t	event;	/*!< Used by sync0arr.c for the wait queue */
	volatile lock_word_t	lock_word;
				/*!< lock_word is the target
				of the atomic test-and-set instruction when
				atomic operations are enabled. */

	ulint	waiters;	/*!< This ulint is set to 1 if there are (or
				may be) threads waiting in the global wait
				array for this mutex to be released.
				Otherwise, this is 0. */
} mutex_t;

/* Entry point for locking a mutex */
inline void mutex_enter_func(mutex_t* mutex);

/* Used by mutex_enter_func to lock a mutex */
void mutex_spin_wait(mutex_t* mutex);

/* Unlock a mutex */
void mutex_exit(mutex_t* mutex);

/* Changes lock word to indicate the mutex is unlocked */
void mutex_reset_lock_word(mutex_t* mutex);

/* Get and set the value of mutex->waiters */
void mutex_set_waiters(mutex_t* mutex, ulint n);
inline ulint mutex_get_waiters(const mutex_t* mutex);

void mutex_create_func(mutex_t* mutex);

/* Does an atomic test-and-set instruction to mutex->lock_word */
byte mutex_test_and_set(mutex_t* mutex);

/* Returns the value of mutex->lock_word */
inline lock_word_t mutex_get_lock_word(const mutex_t* mutex);

/* Wakes all threads waiting on this mutex */
void mutex_signal_object(mutex_t* mutex);

/***********************************************************
 * sync_array
 */

/** Synchronization wait array cell */
typedef struct sync_cell_struct         sync_cell_t;
/** Synchronization wait array */
typedef struct sync_array_struct        sync_array_t;

/** Parameters for sync_array_create() @{ */
#define SYNC_ARRAY_OS_MUTEX     1       /*!< protected by os_mutex_t */
#define SYNC_ARRAY_MUTEX        2       /*!< protected by mutex_t */
/* @} */

/** A cell where an individual thread may wait suspended
until a resource is released. The suspending is implemented
using an operating system event semaphore. */
struct sync_cell_struct {
	void*		wait_object;	/*!< pointer to the object the
					thread is waiting for; if NULL
					the cell is free for use */
	mutex_t*	old_wait_mutex;	/*!< the latest wait mutex in cell */
	ulint		request_type;	/*!< lock type requested on the
					object */
	os_thread_id_t	thread;		/*!< thread id of this waiting
					thread */
	ibool		waiting;	/*!< TRUE if the thread has already
					called sync_array_event_wait
					on this cell */
	ib_int64_t	signal_count;	/*!< We capture the signal_count
					of the wait_object when we
					reset the event. This value is
					then passed on to os_event_wait
					and we wait only if the event
					has not been signalled in the
					period between the reset and
					wait call. */
	time_t		reservation_time;/*!< time when the thread reserved
					the wait cell */
};

/* NOTE: It is allowed for a thread to wait
for an event allocated for the array without owning the
protecting mutex (depending on the case: OS or database mutex), but
all changes (set or reset) to the state of the event must be made
while owning the mutex. */

/** Synchronization array */
struct sync_array_struct {
	ulint		n_reserved;	/*!< number of currently reserved
					cells in the wait array */
	ulint		n_cells;	/*!< number of cells in the
					wait array */
	sync_cell_t*	array;		/*!< pointer to wait array */
	ulint		protection;	/*!< this flag tells which
					mutex protects the data */
	mutex_t		mutex;		/*!< possible database mutex
					protecting this data structure */
	os_fast_mutex_t	os_mutex;	/*!< Switch from os_mutex_t to
					os_fast_mutex_t to simplify code. */
					/*!< Possible operating system mutex
					protecting the data structure.
					As this data structure is used in
					constructing the database mutex,
					to prevent infinite recursion
					in implementation, we fall back to
					an OS mutex. */
	ulint		sg_count;	/*!< count of how many times an
					object has been signalled */
	ulint		res_count;	/*!< count of cell reservations
					since creation of the array */
};

sync_array_t*	sync_primary_wait_array;

void sync_array_free_cell(sync_array_t*	arr, ulint index);
void sync_array_reserve_cell(sync_array_t* arr, void* object,
			ulint type, ulint* index);
void sync_array_enter(sync_array_t* arr);
void sync_array_exit(sync_array_t* arr);
sync_cell_t* sync_array_get_nth_cell(sync_array_t* arr, ulint n);
os_event_t sync_cell_get_event(sync_cell_t* cell);
void sync_array_wait_event(sync_array_t* arr, ulint index);
sync_array_t* sync_array_create(ulint n_cells, ulint protection);
void sync_array_object_signalled(sync_array_t* arr);

/***********************************************************
 * Other
 */

/** A constant to prevent the compiler from optimizing ut_delay() away. */
volatile ibool	ut_always_false = FALSE;

#define UT_RELAX_CPU() __asm__ __volatile__ ("pause")

void os_thread_yield(void);
os_thread_id_t os_thread_get_curr_id(void);
ulint ut_rnd_gen_next_ulint(ulint rnd);

/* Generate a random ulint */
ulint ut_rnd_gen_ulint(void);

/* Return a ulint between "low" and "high" */
ulint ut_rnd_interval(ulint low, ulint high);

/* Run the busy-wait loop for a thread */
ulint ut_delay(ulint delay);

/*****************************************************************//**
Advises the os to give up remainder of the thread's time slice. */
void
os_thread_yield(void)
/*=================*/
{
        sched_yield();
}

/*****************************************************************//**
Returns the thread identifier of current thread. Currently the thread
identifier in Unix is the thread handle itself. Note that in HP-UX
pthread_t is a struct of 3 fields.
@return	current thread identifier */
os_thread_id_t
os_thread_get_curr_id(void)
/*=======================*/
{
	return(pthread_self());
}

#define UT_RND1			151117737
#define UT_RND2			119785373
#define UT_RND3			 85689495
#define UT_RND4			 76595339
#define UT_SUM_RND2		 98781234
#define UT_SUM_RND3		126792457
#define UT_SUM_RND4		 63498502
#define UT_XOR_RND1		187678878
#define UT_XOR_RND2		143537923

ulint    ut_rnd_ulint_counter;

/********************************************************//**
The following function generates a series of 'random' ulint integers.
@return	the next 'random' number */
inline
ulint
ut_rnd_gen_next_ulint(
/*==================*/
	ulint	rnd)	/*!< in: the previous random number value */
{
	ulint	n_bits;

	n_bits = 8 * sizeof(ulint);

	rnd = UT_RND2 * rnd + UT_SUM_RND3;
	rnd = UT_XOR_RND1 ^ rnd;
	rnd = (rnd << 20) + (rnd >> (n_bits - 20));
	rnd = UT_RND3 * rnd + UT_SUM_RND4;
	rnd = UT_XOR_RND2 ^ rnd;
	rnd = (rnd << 20) + (rnd >> (n_bits - 20));
	rnd = UT_RND1 * rnd + UT_SUM_RND2;

	return(rnd);
}

/********************************************************//**
The following function generates 'random' ulint integers which
enumerate the value space of ulint integers in a pseudo random
fashion. Note that the same integer is repeated always after
2 to power 32 calls to the generator (if ulint is 32-bit).
@return	the 'random' number */
inline
ulint
ut_rnd_gen_ulint(void)
/*==================*/
{
	ulint	rnd;

	ut_rnd_ulint_counter = UT_RND1 * ut_rnd_ulint_counter + UT_RND2;

	rnd = ut_rnd_gen_next_ulint(ut_rnd_ulint_counter);

	return(rnd);
}

/********************************************************//**
Generates a random integer from a given interval.
@return	the 'random' number */
inline
ulint
ut_rnd_interval(
/*============*/
	ulint	low,	/*!< in: low limit; can generate also this value */
	ulint	high)	/*!< in: high limit; can generate also this value */
{
	ulint	rnd;

	ut_ad(high >= low);

	if (low == high) {

		return(low);
	}

	rnd = ut_rnd_gen_ulint();

	return(low + (rnd % (high - low)));
}

/*************************************************************//**
Runs an idle loop on CPU. The argument gives the desired delay
in microseconds on 100 MHz Pentium + Visual C++.
@return dummy value */
ulint
ut_delay(
/*=====*/
        ulint   delay)  /*!< in: delay in microseconds on 100 MHz Pentium */
{
        ulint   i, j;

        j = 0;

        for (i = 0; i < delay * 50; i++) {
                j += i;
                UT_RELAX_CPU();
        }

        if (ut_always_false) {
                ut_always_false = (ibool) j;
        }

        return(j);
}

/*********************************************************//**
Initializes an operating system fast mutex semaphore. */
void
os_fast_mutex_init(
/*===============*/
	os_fast_mutex_t*	fast_mutex,	/*!< in: fast mutex */
	ibool			really_fast)
{
	if (really_fast)
		ut_a(0 == pthread_mutex_init(fast_mutex, MY_MUTEX_INIT_FAST));
	else
		ut_a(0 == pthread_mutex_init(fast_mutex, NULL));
}

/**********************************************************//**
Acquires ownership of a fast mutex. */
void
os_fast_mutex_lock(
/*===============*/
	os_fast_mutex_t*	fast_mutex)	/*!< in: mutex to acquire */
{
	pthread_mutex_lock(fast_mutex);
}

/**********************************************************//**
Releases ownership of a fast mutex. */
void
os_fast_mutex_unlock(
/*=================*/
	os_fast_mutex_t*	fast_mutex)	/*!< in: mutex to release */
{
	pthread_mutex_unlock(fast_mutex);
}

/**********************************************************//**
Sets an event semaphore to the signaled state: lets waiting threads
proceed. */
void
os_event_set(
/*=========*/
	os_event_t	event)	/*!< in: event to set */
{
	os_fast_mutex_lock(&(event->os_mutex));

	if (event->is_set) {
		/* Do nothing */
	} else {
		event->is_set = TRUE;
		event->signal_count += 1;
		ut_a(0 == pthread_cond_broadcast(&(event->cond_var))); 
		/* ut_a(0 == pthread_cond_signal(&(event->cond_var)));  */
	}

	os_fast_mutex_unlock(&(event->os_mutex));
}

/*********************************************************//**
Creates an event semaphore, i.e., a semaphore which may just have two
states: signaled and nonsignaled. The created event is manual reset: it
must be reset explicitly by calling sync_os_reset_event.
@return	the event handle */
os_event_t
os_event_create(
/*============*/
	const char*	name)	/*!< in: the name of the event, if NULL
				the event is created without a name */
{
	os_event_t	event;

	event = ut_malloc(sizeof(struct os_event_struct));

	os_fast_mutex_init(&(event->os_mutex), TRUE);

	ut_a(0 == pthread_cond_init(&(event->cond_var), NULL));

	event->is_set = FALSE;

	/* We return this value in os_event_reset(), which can then be
	be used to pass to the os_event_wait_low(). The value of zero
	is reserved in os_event_wait_low() for the case when the
	caller does not want to pass any signal_count value. To
	distinguish between the two cases we initialize signal_count
	to 1 here. */
	event->signal_count = 1;

	return(event);
}

/**********************************************************//**
Waits for an event object until it is in the signaled state. If
srv_shutdown_state == SRV_SHUTDOWN_EXIT_THREADS this also exits the
waiting thread when the event becomes signaled (or immediately if the
event is already in the signaled state).

Typically, if the event has been signalled after the os_event_reset()
we'll return immediately because event->is_set == TRUE.
There are, however, situations (e.g.: sync_array code) where we may
lose this information. For example:

thread A calls os_event_reset()
thread B calls os_event_set()   [event->is_set == TRUE]
thread C calls os_event_reset() [event->is_set == FALSE]
thread A calls os_event_wait()  [infinite wait!]
thread C calls os_event_wait()  [infinite wait!]

Where such a scenario is possible, to avoid infinite wait, the
value returned by os_event_reset() should be passed in as
reset_sig_count. */
void
os_event_wait_low(
/*==============*/
	os_event_t	event,		/*!< in: event to wait */
	ib_int64_t	reset_sig_count)/*!< in: zero or the value
					returned by previous call of
					os_event_reset(). */
{
	ib_int64_t	old_signal_count;

	os_fast_mutex_lock(&(event->os_mutex));

	if (reset_sig_count) {
		old_signal_count = reset_sig_count;
	} else {
		old_signal_count = event->signal_count;
	}

	for (;;) {
		if (event->is_set == TRUE
		    || event->signal_count != old_signal_count) {

			os_fast_mutex_unlock(&(event->os_mutex));

			if (srv_shutdown_state == SRV_SHUTDOWN_EXIT_THREADS) {

				os_thread_exit(NULL);
			}
			/* Ok, we may return */

			return;
		}

		pthread_cond_wait(&(event->cond_var), &(event->os_mutex));

		/* Solaris manual said that spurious wakeups may occur: we
		have to check if the event really has been signaled after
		we came here to wait */
	}
}

/**********************************************************//**
Resets an event semaphore to the nonsignaled state. Waiting threads will
stop to wait for the event.
The return value should be passed to os_even_wait_low() if it is desired
that this thread should not wait in case of an intervening call to
os_event_set() between this os_event_reset() and the
os_event_wait_low() call. See comments for os_event_wait_low().
@return	current signal_count. */
ib_int64_t
os_event_reset(
/*===========*/
	os_event_t	event)	/*!< in: event to reset */
{
	ib_int64_t	ret = 0;

	os_fast_mutex_lock(&(event->os_mutex));

	if (!event->is_set) {
		/* Do nothing */
	} else {
		event->is_set = FALSE;
	}
	ret = event->signal_count;

	os_fast_mutex_unlock(&(event->os_mutex));

	return(ret);
}

/******************************************************************//**
Performs a reset instruction to the lock_word field of a mutex. This
instruction also serializes memory operations to the program order. */
inline
void
mutex_reset_lock_word(
/*==================*/
	mutex_t*	mutex)	/*!< in: mutex */
{
	/* In theory __sync_lock_release should be used to release the lock.
	Unfortunately, it does not work properly alone. The workaround is
	that more conservative __sync_lock_test_and_set is used instead. */
	os_atomic_test_and_set_byte(&mutex->lock_word, 0);
}

/******************************************************************//**
Sets the waiters field in a mutex. */
void
mutex_set_waiters(
/*==============*/
	mutex_t*	mutex,	/*!< in: mutex */
	ulint		n)	/*!< in: value to set */
{
	volatile ulint*	ptr;		/* declared volatile to ensure that
					the value is stored to memory */
	ut_ad(mutex);

	ptr = &(mutex->waiters);

	*ptr = n;		/* Here we assume that the write of a single
				word in memory is atomic */
}

/******************************************************************//**
Creates, or rather, initializes a mutex object in a specified memory
location (which must be appropriately aligned). The mutex is initialized
in the reset state. Explicit freeing of the mutex with mutex_free is
necessary only if the memory block containing it is freed. */
void
mutex_create_func(
/*==============*/
	mutex_t*	mutex)		/*!< in: pointer to memory */
{
	mutex_reset_lock_word(mutex);
	mutex->event = os_event_create(NULL);
	mutex_set_waiters(mutex, 0);

	/* Check that lock_word is aligned; this is important on Intel */
	ut_ad(((ulint)(&(mutex->lock_word))) % 4 == 0);
}

/******************************************************************//**
Performs an atomic test-and-set instruction to the lock_word field of a
mutex.
@return	the previous value of lock_word: 0 or 1 */
inline
byte
mutex_test_and_set(
/*===============*/
	mutex_t*	mutex)	/*!< in: mutex */
{
	return(os_atomic_test_and_set_byte(&mutex->lock_word, 1));
}

/******************************************************************//**
Gets the value of the lock word. */
inline
lock_word_t
mutex_get_lock_word(
/*================*/
        const mutex_t*  mutex)  /*!< in: mutex */
{
        return(mutex->lock_word);
}


/******************************************************************//**
Reserves a mutex for the current thread. If the mutex is reserved, the
function spins a preset time (controlled by SYNC_SPIN_ROUNDS), waiting
for the mutex before suspending the thread. */
void
mutex_spin_wait(
/*============*/
	mutex_t*	mutex)		/*!< in: pointer to mutex */
{
	ulint	   index; /* index of the reserved wait cell */
	ulint	   i;	  /* spin round count */

mutex_loop:

	i = 0;

	/* Spin waiting for the lock word to become zero. Note that we do
	not have to assume that the read access to the lock word is atomic,
	as the actual locking is always committed with atomic test-and-set.
	In reality, however, all processors probably have an atomic read of
	a memory word. */

spin_loop:

	while (mutex_get_lock_word(mutex) != 0 && i < srv_n_spin_wait_rounds) {
		if (srv_spin_wait_delay) {
			ut_delay(ut_rnd_interval(0, srv_spin_wait_delay));
		}

		i++;
	}

	if (i == srv_n_spin_wait_rounds) {
		os_thread_yield();
	}

	if (mutex_test_and_set(mutex) == 0) {
		/* Succeeded! */
		goto finish_timing;
	}

	/* We may end up with a situation where lock_word is 0 but the OS
	fast mutex is still reserved. On FreeBSD the OS does not seem to
	schedule a thread which is constantly calling pthread_mutex_trylock
	(in mutex_test_and_set implementation). Then we could end up
	spinning here indefinitely. The following 'i++' stops this infinite
	spin. */

	i++;

	if (i < srv_n_spin_wait_rounds) {
		goto spin_loop;
	}

	sync_array_reserve_cell(sync_primary_wait_array, mutex,
				SYNC_MUTEX, &index);

	/* The memory order of the array reservation and the change in the
	waiters field is important: when we suspend a thread, we first
	reserve the cell and then set waiters field to 1. When threads are
	released in mutex_exit, the waiters field is first set to zero and
	then the event is set to the signaled state. */

	mutex_set_waiters(mutex, 1);

	/* Try to reserve still a few times */
	for (i = 0; i < 4; i++) {
		if (mutex_test_and_set(mutex) == 0) {
			/* Succeeded! Free the reserved wait cell */

			sync_array_free_cell(sync_primary_wait_array, index);

			goto finish_timing;

			/* Note that in this case we leave the waiters field
			set to 1. We cannot reset it to zero, as we do not
			know if there are other waiters. */
		}
	}

	/* Now we know that there has been some thread holding the mutex
	after the change in the wait array and the waiters field was made.
	Now there is no risk of infinite wait on the event. */

	sync_array_wait_event(sync_primary_wait_array, index);
	goto mutex_loop;

finish_timing:

	return;
}
/******************************************************************//**
Locks a mutex for the current thread. If the mutex is reserved, the function
spins a preset time (controlled by SYNC_SPIN_ROUNDS), waiting for the mutex
before suspending the thread. */
inline
void
mutex_enter_func(
/*=============*/
	mutex_t*	mutex)		/*!< in: pointer to mutex */
{
	/* Note that we do not peek at the value of lock_word before trying
	the atomic test_and_set; we could peek, and possibly save time. */

	if (!mutex_test_and_set(mutex)) {
		return;	/* Succeeded! */
	}

	mutex_spin_wait(mutex);
}

/******************************************************************//**
Releases the threads waiting in the primary wait array for this mutex. */
void
mutex_signal_object(
/*================*/
	mutex_t*	mutex)	/*!< in: mutex */
{
	mutex_set_waiters(mutex, 0);

	/* The memory order of resetting the waiters field and
	signaling the object is important. See LEMMA 1 above. */
	os_event_set(mutex->event);
	sync_array_object_signalled(sync_primary_wait_array);
}

/******************************************************************//**
Gets the waiters field in a mutex.
@return	value to set */
inline
ulint
mutex_get_waiters(
/*==============*/
	const mutex_t*	mutex)	/*!< in: mutex */
{
	const volatile ulint*	ptr;	/*!< declared volatile to ensure that
					the value is read from memory */
	ut_ad(mutex);

	ptr = &(mutex->waiters);

	return(*ptr);		/* Here we assume that the read of a single
				word from memory is atomic */
}

/******************************************************************//**
Unlocks a mutex owned by the current thread. */
inline
void
mutex_exit(
/*=======*/
	mutex_t*	mutex)	/*!< in: pointer to mutex */
{
	mutex_reset_lock_word(mutex);

	/* A problem: we assume that mutex_reset_lock word
	is a memory barrier, that is when we read the waiters
	field next, the read must be serialized in memory
	after the reset. A speculative processor might
	perform the read first, which could leave a waiting
	thread hanging indefinitely.

	Our current solution call every second
	sync_arr_wake_threads_if_sema_free()
	to wake up possible hanging threads if
	they are missed in mutex_signal_object. */

	if (mutex_get_waiters(mutex) != 0) {

		mutex_signal_object(mutex);
	}
}
/******************************************************************//**
Reserves the mutex semaphore protecting a sync array. */
void
sync_array_enter(
/*=============*/
	sync_array_t*	arr)	/*!< in: sync wait array */
{
	ulint	protection;

	protection = arr->protection;

	if (protection == SYNC_ARRAY_OS_MUTEX) {
		os_fast_mutex_lock(&arr->os_mutex);
	} else if (protection == SYNC_ARRAY_MUTEX) {
		mutex_enter_func(&(arr->mutex));
	} else {
		assert(0);
	}
}

/******************************************************************//**
Releases the mutex semaphore protecting a sync array. */
void
sync_array_exit(
/*============*/
	sync_array_t*	arr)	/*!< in: sync wait array */
{
	ulint	protection;

	protection = arr->protection;

	if (protection == SYNC_ARRAY_OS_MUTEX) {
		os_fast_mutex_unlock(&arr->os_mutex);
	} else if (protection == SYNC_ARRAY_MUTEX) {
		mutex_exit(&(arr->mutex));
	} else {
		assert(0);
	}
}

/*****************************************************************//**
Gets the nth cell in array.
@return	cell */
sync_cell_t*
sync_array_get_nth_cell(
/*====================*/
	sync_array_t*	arr,	/*!< in: sync array */
	ulint		n)	/*!< in: index */
{
	ut_a(arr);
	ut_a(n < arr->n_cells);

	return(arr->array + n);
}

/*******************************************************************//**
Returns the event that the thread owning the cell waits for. */
os_event_t
sync_cell_get_event(
/*================*/
	sync_cell_t*	cell) /*!< in: non-empty sync array cell */
{
	ulint type = cell->request_type;

	if (type == SYNC_MUTEX) {
		return(((mutex_t *) cell->wait_object)->event);
	} else {
		assert(0);
		return NULL;
	}
}

/******************************************************************//**
Frees the cell. NOTE! sync_array_wait_event frees the cell
automatically! */
void
sync_array_free_cell(
/*=================*/
	sync_array_t*	arr,	/*!< in: wait array */
	ulint		index)  /*!< in: index of the cell in array */
{
	sync_cell_t*	cell;

	sync_array_enter(arr);

	cell = sync_array_get_nth_cell(arr, index);

	ut_a(cell->wait_object != NULL);

	cell->waiting = FALSE;
	cell->wait_object =  NULL;
	cell->signal_count = 0;

	ut_a(arr->n_reserved > 0);
	arr->n_reserved--;

	sync_array_exit(arr);
}

/******************************************************************//**
Reserves a wait array cell for waiting for an object.
The event of the cell is reset to nonsignalled state. */
void
sync_array_reserve_cell(
/*====================*/
	sync_array_t*	arr,	/*!< in: wait array */
	void*		object, /*!< in: pointer to the object to wait for */
	ulint		type,	/*!< in: lock request type */
	ulint*		index)	/*!< out: index of the reserved cell */
{
	sync_cell_t*	cell;
	os_event_t      event;
	ulint		i;

	sync_array_enter(arr);

	arr->res_count++;

	/* Reserve a new cell. */
	for (i = 0; i < arr->n_cells; i++) {
		cell = sync_array_get_nth_cell(arr, i);

		if (cell->wait_object == NULL) {

			cell->waiting = FALSE;
			cell->wait_object = object;

			if (type == SYNC_MUTEX) {
				cell->old_wait_mutex = object;
			} else {
				assert(0);
			}

			cell->request_type = type;

			arr->n_reserved++;

			*index = i;

			sync_array_exit(arr);

			/* Make sure the event is reset and also store
			the value of signal_count at which the event
			was reset. */
                        event = sync_cell_get_event(cell);
			cell->signal_count = os_event_reset(event);

			cell->reservation_time = time(NULL);

			cell->thread = os_thread_get_curr_id();

			return;
		}
	}

	assert(0); /* No free cell found */

	return;
}

/******************************************************************//**
This function should be called when a thread starts to wait on
a wait array cell. In the debug version this function checks
if the wait for a semaphore will result in a deadlock, in which
case prints info and asserts. */
void
sync_array_wait_event(
/*==================*/
	sync_array_t*	arr,	/*!< in: wait array */
	ulint		index)	/*!< in: index of the reserved cell */
{
	sync_cell_t*	cell;
	os_event_t	event;

	sync_array_enter(arr);

	cell = sync_array_get_nth_cell(arr, index);

	ut_a(cell->wait_object);
	ut_a(!cell->waiting);
	ut_ad(os_thread_get_curr_id() == cell->thread);

	event = sync_cell_get_event(cell);
		cell->waiting = TRUE;

	sync_array_exit(arr);

	os_event_wait_low(event, cell->signal_count);

	sync_array_free_cell(arr, index);
}

/**********************************************************************//**
Increments the signalled count. */
void
sync_array_object_signalled(
/*========================*/
	sync_array_t*	arr)	/*!< in: wait array */
{
	(void) os_atomic_increment_ulint(&arr->sg_count, 1);
}

/*******************************************************************//**
Creates a synchronization wait array. It is protected by a mutex
which is automatically reserved when the functions operating on it
are called.
@return	own: created wait array */
sync_array_t*
sync_array_create(
/*==============*/
	ulint	n_cells,	/*!< in: number of cells in the array
				to create */
	ulint	protection)	/*!< in: either SYNC_ARRAY_OS_MUTEX or
				SYNC_ARRAY_MUTEX: determines the type
				of mutex protecting the data structure */
{
	ulint		sz;
	sync_array_t*	arr;

	ut_a(n_cells > 0);

	/* Allocate memory for the data structures */
	arr = ut_malloc(sizeof(sync_array_t));
	memset(arr, 0x0, sizeof(*arr));

	sz = sizeof(sync_cell_t) * n_cells;
	arr->array = ut_malloc(sz);
	memset(arr->array, 0x0, sz);

	arr->n_cells = n_cells;
	arr->protection = protection;

	assert(protection == SYNC_ARRAY_OS_MUTEX);
	/* Then create the mutex to protect the wait array complex */
	os_fast_mutex_init(&arr->os_mutex, FALSE);

	return(arr);
}

/******************************************************************//**
Initializes synchronization data structures
*/
void
sync_init(void)
{
	pthread_mutexattr_init(&my_fast_mutexattr);
	pthread_mutexattr_settype(&my_fast_mutexattr, PTHREAD_MUTEX_ADAPTIVE_NP);

	sync_primary_wait_array = sync_array_create(srv_max_n_threads,
					SYNC_ARRAY_OS_MUTEX);
}

unsigned long long timeval_to_usecs(struct timeval* start, struct timeval* stop)
{
	return
		((stop->tv_sec * 1000000) + stop->tv_usec) -
		((start->tv_sec * 1000000) + start->tv_usec);
}

void usecs_sleep(int duration)
{
	struct timeval start, now;
	unsigned long long slept_for;

	gettimeofday(&start, NULL);

	while (1) {
		gettimeofday(&now, NULL);
		slept_for = timeval_to_usecs(&start, &now);
		if (slept_for >= duration) {
			printf("sleep %lld usecs\n", slept_for);
			return;
		}
	}
}

typedef struct {
	void*	mutex;
	int	nloops;
	int	think_usecs;
	ulong	counter;
} thread_args;

void* inno_worker(void* a)
{
	thread_args*	args = a;
	mutex_t* mutex = args->mutex;
	int x;

	for (x=0; x < args->nloops; ++x) {
		mutex_enter_func(mutex);
		++(args->counter);
		usecs_sleep(args->think_usecs);
		mutex_exit(mutex);
	}
}

void* pthr_worker(void* a)
{
	thread_args*	args = a;
	pthread_mutex_t* mutex = args->mutex;
	int x;
	struct timeval s;

	gettimeofday(&s, NULL);

	for (x=0; x < args->nloops; ++x) {
		pthread_mutex_lock(mutex);
		++(args->counter);
		usecs_sleep(args->think_usecs);
		pthread_mutex_unlock(mutex);
	}
}

double timeval_to_secs(struct timeval* start, struct timeval* stop)
{
	return
		(stop->tv_sec + (stop->tv_usec / 1000000.0)) -
		(start->tv_sec + (start->tv_usec / 1000000.0));
}

void print_results(struct timeval* start, int nthreads, int nloops,
		ulong counter, const char* msg, int think_usecs)
{
	struct timeval	stop;
	double		secs;

	gettimeofday(&stop, NULL);
	secs = timeval_to_secs(start, &stop);
	assert(counter == (nthreads * nloops));
	printf("%s: %.1f usecs/loop, %.3f seconds\n",
		msg,
		(secs * 1000000) / (nthreads * nloops),
		secs);
}

int
main(int argc, char **argv)
{
	mutex_t		m1;
	pthread_mutex_t	pfast;
	pthread_mutex_t	pslow;
	int		nthreads;
	int		nloops;
	int		think_usecs;
	int		i;
	pthread_t*	tids;
	thread_args	args;
	struct timeval	start, stop;
	
	if (argc != 6) {
		printf("need 5 args <nthreads> <nloops> <think_usecs> <spin_rounds> <spin_delay>\n");
		exit(-1);
	}

	nthreads = atoi(argv[1]);
	nloops = atoi(argv[2]);
	think_usecs = atoi(argv[3]);
	srv_n_spin_wait_rounds = atoi(argv[4]);
	srv_spin_wait_delay = atoi(argv[5]);

	args.nloops = nloops;
	args.think_usecs = think_usecs;

	tids = (pthread_t*) malloc(nthreads * sizeof(pthread_t));

	sync_init();

	/* Sanity check */
	mutex_create_func(&m1);
	mutex_enter_func(&m1);
	mutex_exit(&m1);

	printf("%d think time usecs\n", think_usecs);
	printf("%d threads\n", nthreads);
	printf("%d loops per thread\n", nloops);
	printf("%d total loops\n", nloops * nthreads);

	gettimeofday(&start, NULL);
	ut_delay(srv_spin_wait_delay);
	gettimeofday(&stop, NULL);
	printf("%ld spin_wait_delay is %.1f delay usecs\n",
		srv_spin_wait_delay,
		timeval_to_secs(&start, &stop) * 1000000.0);

	gettimeofday(&start, NULL);
	for (i=0; i < srv_n_spin_wait_rounds; ++i) ut_delay(srv_spin_wait_delay);
	gettimeofday(&stop, NULL);
	printf("%ld spin_wait_rounds is %.1f delay usecs\n",
		srv_n_spin_wait_rounds,
		timeval_to_secs(&start, &stop) * 1000000.0);

	args.mutex = &m1;
	args.counter = 0;
	gettimeofday(&start, NULL);

	for (i = 0; i < nthreads; ++i) {
		pthread_create(&tids[i], NULL, inno_worker, &args);
	}
	for (i = 0; i < nthreads; ++i) {
		void* retval;
		assert(pthread_join(tids[i], &retval) == 0);
	}
	print_results(&start, nthreads, nloops, args.counter, "inno", think_usecs);

	ut_a(0 == pthread_mutex_init(&pfast, MY_MUTEX_INIT_FAST));
	args.mutex = &pfast;
	args.counter = 0;
	gettimeofday(&start, NULL);

	for (i = 0; i < nthreads; ++i) {
		pthread_create(&tids[i], NULL, pthr_worker, &args);
	}
	for (i = 0; i < nthreads; ++i) {
		void* retval;
		assert(pthread_join(tids[i], &retval) == 0);
	}
	print_results(&start, nthreads, nloops, args.counter, "pfast", think_usecs);

	ut_a(0 == pthread_mutex_init(&pslow, NULL));
	args.mutex = &pslow;
	args.counter = 0;
	gettimeofday(&start, NULL);

	for (i = 0; i < nthreads; ++i) {
		pthread_create(&tids[i], NULL, pthr_worker, &args);
	}
	for (i = 0; i < nthreads; ++i) {
		void* retval;
		assert(pthread_join(tids[i], &retval) == 0);
	}
	print_results(&start, nthreads, nloops, args.counter, "pslow", think_usecs);
}
