/*

Promela/SPIN model of innodb rw_lock

The following flags are recommended when compiling pan:
-DSAFETY -DCOLLAPSE -O2
If pan runs out of memory, add -DMA72: this uses about 1/10th the memory,
but also slows exectution speed down to 1/10th original speed.
Running pan with -n silences the unreachable statements warnings.

Run different tests by making changes to the init function.

Some notes about this model:
All functions in this model operate on the global variable my_lock. Most
functions get passed a thread_type struct "thread" which is used to store 
the local variables for the executing thread.

All variables are initialized to 0 by default.

Author: Ben Handy

*/


#define lock_ini 110
#define lock_decr 10
/* lock_locked = lock_ini - lock_decr */
#define lock_locked 100
#define dummy_writer 255

byte num_write_locks;
byte num_read_locks;

typedef event_type {
	byte counter;
	byte waiters;
        bit is_set;
	bit broadcast;
	bit lock_bit;
};

typedef lock_type {
	event_type wait_event;
	event_type wait_ex_event;
	byte lock_word;
	byte writer_thread;
	bit waiters;
	bit pass;
};

typedef thread_type {
	byte local_lock_word;
	byte reset_val;
	bit pass;
	bit success;
	bit reader;
}

lock_type my_lock;

init {
        //byte b;
	my_lock.lock_word = lock_ini;
	my_lock.writer_thread = dummy_writer;
	
	/* Run processes in an atomic block to get all possible orderings */
	atomic { 
		run write_and_transfer();
		//run reader_twice();
		//run writer_twice();
		//run reader_writer();
		//run writer_reader();
		run reader_writer_twice();
	};
        /*end:*/ //b = 0;
}

inline check_lock_word() {
  assert(my_lock.lock_word <= lock_ini);
  assert(my_lock.lock_word > (lock_locked - lock_decr) ||
         (my_lock.lock_word % lock_decr) == 0);
}

inline check_num_locks() {
  assert(num_read_locks == 0 || num_write_locks == 0);
}

inline inc_num_read_locks() {
  num_read_locks++;
  check_num_locks();
}

inline dec_num_read_locks() {
  num_read_locks--;
  check_num_locks();
}

inline inc_num_write_locks() {
  num_write_locks++;
  check_num_locks();
}

inline dec_num_write_locks() {
  num_write_locks--;
  check_num_locks();
}


/* A thread must call reset before wait. The thread sleeps until
   there has been at least one call to signal since the reset_ex call.*/
inline wait(thread) {
	atomic { (my_lock.wait_event.lock_bit == 0) -> my_lock.wait_event.lock_bit = 1;};
	do
	:: atomic { /* to reduce state space */ (my_lock.wait_event.counter != thread.reset_val) -> 
		my_lock.wait_event.lock_bit = 0; };
		break;
	:: atomic { /* to reduce state space */ (my_lock.wait_event.is_set) -> 
		my_lock.wait_event.lock_bit = 0; }; 
		break;
	:: else -> 
		        atomic { /* to reduce state space */ 
		my_lock.wait_event.waiters++;
		my_lock.wait_event.lock_bit = 0; };
		        atomic { /* to reduce state space */ 
		(my_lock.wait_event.broadcast == 1);
		my_lock.wait_event.waiters--; }
		(my_lock.wait_event.broadcast == 0);
		atomic { (my_lock.wait_event.lock_bit == 0) -> my_lock.wait_event.lock_bit = 1;};
	od
}

/* Record the counter value of the event that readers/writers wait on. */
inline reset(thread) {
	atomic {
		thread.reset_val = my_lock.wait_event.counter;
	        my_lock.wait_event.is_set = 0;
	}
}

/* Signal waiting readers and writers to wake up. */
inline signal() {
	atomic { (my_lock.wait_event.lock_bit == 0) -> my_lock.wait_event.lock_bit = 1;};
	if
	::  (!my_lock.wait_event.is_set) ->
		my_lock.wait_event.is_set = 1;
		my_lock.wait_event.counter++;
		my_lock.wait_event.broadcast = 1;
		        atomic { /* to reduce state space */ 
		(my_lock.wait_event.waiters == 0);
		my_lock.wait_event.broadcast = 0; };
	:: else -> skip
	fi;
	my_lock.wait_event.lock_bit = 0;	
}

/* The next 3 functions are identical to the above functions, but for the 
   wait_ex event. This duplication is ugly, but passing an event to these 
   inline blocks did not work properly.*/

/* A thread must call reset_ex before wait_ex. The thread sleeps until
   there has been at least one call to signal_ex since the reset_ex call.*/
inline wait_ex(thread) {
	atomic { (my_lock.wait_ex_event.lock_bit == 0) -> my_lock.wait_ex_event.lock_bit = 1;};
	do
	:: atomic { /* to reduce state space */ (my_lock.wait_ex_event.counter != thread.reset_val) -> 
		my_lock.wait_ex_event.lock_bit = 0; };
		break;
	:: atomic { /* to reduce state space */ (my_lock.wait_ex_event.is_set) -> 
		my_lock.wait_ex_event.lock_bit = 0; };
		break;
	:: else -> 
		        atomic { /* to reduce state space */ 
		my_lock.wait_ex_event.waiters++;
		my_lock.wait_ex_event.lock_bit = 0; };
		        atomic { /* to reduce state space */ 
		(my_lock.wait_ex_event.broadcast == 1);
		my_lock.wait_ex_event.waiters--; };
		(my_lock.wait_ex_event.broadcast == 0);
		atomic { (my_lock.wait_ex_event.lock_bit == 0) -> my_lock.wait_ex_event.lock_bit = 1;};
	od
}

/* Record the counter value of the next-writer event. */
inline reset_ex(thread) {
        atomic {
  		thread.reset_val = my_lock.wait_ex_event.counter;
	        my_lock.wait_ex_event.is_set = 0;
	}
}

/* Signal the next-writer to wake up. */
inline signal_ex() {
	atomic { (my_lock.wait_ex_event.lock_bit == 0) -> my_lock.wait_ex_event.lock_bit = 1;};
	if
	::  (!my_lock.wait_ex_event.is_set) ->
		my_lock.wait_ex_event.is_set = 1;
		my_lock.wait_ex_event.counter++;
		my_lock.wait_ex_event.broadcast = 1;
		        atomic { /* to reduce state space */ 
		(my_lock.wait_ex_event.waiters == 0);
		my_lock.wait_ex_event.broadcast = 0; };
	:: else -> skip
	fi;
	my_lock.wait_ex_event.lock_bit = 0;
}

/* Read or write waiter thread sleeps until lock is available. */
inline lock_wait(thread) {
	reset(thread);
	my_lock.waiters = 1;
	/* Must check lock_word before waiting. */
	if
	:: (my_lock.lock_word > lock_locked) ->	skip;
	:: else -> wait(thread);
	fi;
}

/* Next-writer thread sleeps until lock is available. */
inline lock_wait_ex(thread) {
	reset_ex(thread);
	/* wait_ex event does not use a flag. */
	/* Must check lock_word before waiting. */
	if
	:: (my_lock.lock_word >= lock_locked) -> skip;
	:: else -> wait_ex(thread);
	fi;
}

/* Performs the lock_word decrement for read or write locking. Does 
   not handle recursive write locks. Before calling this function, 
   thread.reader must be set to 1 for read attempts or 0 for write 
   attempts. Sets thread.success if lock_word was decremented. */
inline lock_word_decr(thread) {
	thread.local_lock_word = my_lock.lock_word;
	/* compare-and-swap is attempted as long as lock_word > 0, 
	   and the swap hasn't occurred. */
	do
	:: (thread.success == 0 && thread.local_lock_word > lock_locked) ->
		/* This large atomic block is really just compare-and-swap. */
		atomic {
		if
		:: (my_lock.lock_word == thread.local_lock_word) -> 
			thread.success = 1;
			if
			:: (thread.reader == 1) ->
				my_lock.lock_word = thread.local_lock_word - 1;
                                check_lock_word();
                                inc_num_read_locks();
				printf("%d: read lock, lw %d\n", 
					_pid, my_lock.lock_word);
			:: else -> 
				my_lock.lock_word = thread.local_lock_word - 
								lock_decr;
                                check_lock_word();
				printf("%d: next-writer lock, lw %d\n",
					_pid, my_lock.lock_word);
			fi;
		:: else -> skip;
		fi; };
		thread.local_lock_word = my_lock.lock_word;
	:: else -> break;
	od;
}

/* Acquires a read lock. Waits until there is no writer or next-writer. */
inline read_lock(thread) {
	thread.success = 0;
	/* Try to lock */
	lock_word_decr(thread);
	do
	:: (!thread.success) ->
		/* Sleep */
		lock_wait(thread);
		/* Try to lock */
		lock_word_decr(thread);
	:: else -> break;	
	od;

}

/* Acquires the write lock. Waits until there are no readers or writers.
   If thread.pass is set to 1 before entering this function, then further 
   recursive locks will not be allowed. */
inline write_lock(thread) {
	thread.success = 0;
	/* Try to lock */
	lock_word_decr(thread);
	do
	:: (!thread.success) ->
		if
		// Swapping the order of writer_thread and pass checks here
		// causes a race in write_and_transfer
		/* Buggy version: */
		//:: (my_lock.writer_thread == _pid) ->
		//	if
		//	:: (my_lock.pass == 0) ->
		/* End buggy version */
		
		/* Good version */
		:: (my_lock.pass == 0) ->
			if
			:: (my_lock.writer_thread == _pid) ->
		/* End good version */

				/* Relock */
				atomic {
					my_lock.lock_word = my_lock.lock_word - lock_decr;
                		        check_lock_word();
					printf("%d: write re-lock, lw %d\n",_pid, my_lock.lock_word);
					inc_num_write_locks();
				};
				my_lock.pass = thread.pass;
				break;
			:: else ->
				/* Sleep */
				lock_wait(thread);
			fi;
		:: else ->
			/* Sleep */
			lock_wait(thread);
		fi;
		/* Try to lock */
		lock_word_decr(thread);
	:: else ->
		/* Wait for readers to exit */
		do
		:: (my_lock.lock_word < lock_locked) ->
			lock_wait_ex(thread);
		:: else -> break;
		od;
		atomic { /* atomic to reduce state space */
			printf("%d: write lock, lw %d\n", 
				_pid, my_lock.lock_word);
			inc_num_write_locks();
			my_lock.writer_thread = _pid;
		};
		my_lock.pass = thread.pass;
		break;
	od;
}

/* Releases the read lock. Thread must have previously called read_lock. */
inline read_unlock(thread) {
	/* This atomic block is atomic-add-and-fetch */
	atomic { 
		my_lock.lock_word = my_lock.lock_word + 1;
                check_lock_word();
		thread.local_lock_word = my_lock.lock_word; 
		dec_num_read_locks();
		printf("%d: read unlock, lw %d\n", _pid, my_lock.lock_word);
		assert(num_write_locks == 0);
	};
	/* We only signal if we are the last s-unlock and there is a 
	   waiting x-lock (lock_word == lock_locked). */
	if
	:: (thread.local_lock_word == lock_locked) -> 
		signal_ex();
	:: else -> skip;
	fi;
}

/* Releases the write lock. Thread must have previously called write_lock. */
inline write_unlock(thread) {
	/* Set writer_thread to dummy while we hold the lock. */
	my_lock.writer_thread = dummy_writer;
	/* This atomic block is atomic-add-and-fetch */
	atomic { 
		my_lock.lock_word = my_lock.lock_word + lock_decr;
                check_lock_word();
	        thread.local_lock_word = my_lock.lock_word; 
		dec_num_write_locks();
	        printf("%d: write unlock, lw %d\n", _pid, my_lock.lock_word);
		assert(num_read_locks == 0);
	}
	/* We only signal if we are the last recursive unlock and the
	   waiters flag is set. */
	if
	:: (thread.local_lock_word == lock_ini && my_lock.waiters == 1) -> 
		my_lock.waiters = 0;
		signal();
	:: (thread.local_lock_word != lock_ini) ->
		/* Set writer_thread correctly if we still hold the lock. */
		my_lock.writer_thread = _pid;
	:: else -> skip;
	fi;
}

/* The calling thread takes ownership of the lock, so it will be allowed to 
relock or unlock it sometime in the future. */
inline move_ownership() {
	my_lock.writer_thread = _pid;
	my_lock.pass = 0;
}

/* This models the aio thread which takes ownership of a lock, relocks for
insert buffer merge, and then releases its lock, and the previous lock. */
proctype own_and_unlock() {
	thread_type thread;
	move_ownership();
	write_lock(thread);
	write_unlock(thread);

	// Remove the original lock
	write_unlock(thread);
}

/* This models an query thread which gets an x_lock, but allows an io
thread to take ownership of the lock. */
proctype write_and_transfer() {
	thread_type thread;
	thread.pass = 1; /* don't allow recursive write */
	write_lock(thread);
	run own_and_unlock();
	write_lock(thread);
	write_unlock(thread);
}



proctype reader_writer_thrice() {
  thread_type thread;
/*  end:*/
  if
    :: true -> thread.reader = 1; read_lock(thread); read_unlock(thread);
    :: true -> thread.reader = 0; write_lock(thread); write_unlock(thread);
  fi;
  if
    :: true -> thread.reader = 1; read_lock(thread); read_unlock(thread);
    :: true -> thread.reader = 0; write_lock(thread); write_unlock(thread);
  fi;
  if
    :: true -> thread.reader = 1; read_lock(thread); read_unlock(thread);
    :: true -> thread.reader = 0; write_lock(thread); write_unlock(thread);
  fi
}

proctype reader_writer_twice() {
  thread_type thread;
/*  end:*/
  if
    :: true -> thread.reader = 1; read_lock(thread); read_unlock(thread);
    :: true -> thread.reader = 0; write_lock(thread); write_unlock(thread);
  fi;
  if
    :: true -> thread.reader = 1; read_lock(thread); read_unlock(thread);
    :: true -> thread.reader = 0; write_lock(thread); write_unlock(thread);
  fi;
}

proctype reader_writer_once() {
  thread_type thread;
/*  end:*/
  if
    :: true -> thread.reader = 1; read_lock(thread); read_unlock(thread);
    :: true -> thread.reader = 0; write_lock(thread); write_unlock(thread);
  fi;

}

proctype reader_once() {
  thread_type thread;
  thread.reader = 1; read_lock(thread); read_unlock(thread);
}

proctype reader_twice() {
  thread_type thread;
  thread.reader = 1; read_lock(thread); read_unlock(thread);
  read_lock(thread); read_unlock(thread);
}

proctype writer_once() {
  thread_type thread;
  write_lock(thread); write_unlock(thread);
}

proctype writer_twice() {
  thread_type thread;
  write_lock(thread); write_unlock(thread);
  write_lock(thread); write_unlock(thread);
}

proctype reader_writer() {
  thread_type thread;
  thread.reader = 1; read_lock(thread); read_unlock(thread);
  thread.reader = 0; write_lock(thread); write_unlock(thread);
}

proctype writer_reader() {
  thread_type thread;
  write_lock(thread); write_unlock(thread);
  thread.reader = 1; read_lock(thread); read_unlock(thread);
}


proctype reader_writer_recurser() {
  thread_type thread;
/*  end:*/
  if
    :: true -> thread.reader = 1; read_lock(thread); read_unlock(thread);
    :: true -> thread.reader = 0; write_lock(thread); write_unlock(thread);
    :: true -> thread.reader = 0; write_lock(thread); write_lock(thread); 
				write_unlock(thread); write_unlock(thread);
  fi;
}

