import time
from multiprocessing import Barrier, Process

import numpy as np
import psycopg2

from learning.environment import BaseEnvironment

class AutoVacEnv(BaseEnvironment):
    def env_init(self, env_info={}):
        """
        Setup for the environment called when the experiment first starts.
        """

        self.env_info = env_info
        self.module = __import__(env_info['module_name'])
        self.workload_fn = getattr(self.module, env_info['function_name'])
        self.workload_thread = None

        self.db_name = env_info['db_name']
        self.db_host = env_info['db_host']
        self.db_user = env_info['db_user']
        self.db_pwd = env_info['db_pwd']
        self.table_name = env_info['table_name']

        self.num_live_tuples_buffer = []
        self.num_dead_tuples_buffer = []
        self.num_read_tuples_buffer = []

        self.live_pct_buffer = []
        self.num_read_deltapct_buffer = []
        self.num_read_delta_buffer = []

    def update_stats(self):
        try:
            self.cursor.execute("select pg_total_relation_size('public.purchases_index')")
            total_space = self.cursor.fetchall()[0][0]

            self.cursor.execute("select pg_table_size('public.purchases_index')")
            used_space = self.cursor.fetchall()[0][0]
        except psycopg2.errors.UndefinedTable:
            print("Table does not exist. Skipping update...")
            return

        self.cursor.execute("select n_live_tup, n_dead_tup, seq_tup_read from pg_stat_user_tables where relname = '%s'" % self.table_name)
        stats = self.cursor.fetchall()[0]

        n_live_tup = stats[0]
        n_dead_tup = stats[1]
        seq_tup_read = stats[2]
        #print("Live tup: %d, Dead dup: %d, Seq reads: %d" % (n_live_tup, n_dead_tup, seq_tup_read))

        live_raw_pct = 0.0 if n_live_tup+n_dead_tup == 0 else n_live_tup/(n_live_tup+n_dead_tup)

        used_pct = used_space/total_space
        live_pct = 100*live_raw_pct*used_pct
        dead_pct = 100*(1.0-live_raw_pct)*used_pct
        free_pct = 100*(1.0-used_pct)

        #print("Total: %d, Used: %d, Live raw pct: %.2f, Live pct: %.2f"
        #      % (total_space, used_space, live_raw_pct, live_pct))

        delta = 0.0 if len(self.num_read_tuples_buffer) == 0 else seq_tup_read - self.num_read_tuples_buffer[0]
        if delta < 0:
            delta = 0
        delta_pct = 0.0 if n_live_tup == 0 else delta / n_live_tup

        if len(self.num_live_tuples_buffer) >= 10:
            self.num_live_tuples_buffer.pop()
            self.num_dead_tuples_buffer.pop()
            self.num_read_tuples_buffer.pop()
            self.live_pct_buffer.pop()
            self.num_read_deltapct_buffer.pop()
            self.num_read_delta_buffer.pop()

        self.num_live_tuples_buffer.insert(0, n_live_tup)
        self.num_dead_tuples_buffer.insert(0, n_dead_tup)
        self.num_read_tuples_buffer.insert(0, seq_tup_read)
        self.live_pct_buffer.insert(0, live_pct)
        self.num_read_deltapct_buffer.insert(0, delta_pct)
        self.num_read_delta_buffer.insert(0, delta)

    def generate_state(self):
        l1 = np.pad(self.live_pct_buffer, (0, 10-len(self.live_pct_buffer)), 'constant', constant_values=(0, 0))
        l2 = np.pad(self.num_read_deltapct_buffer, (0, 10-len(self.num_read_deltapct_buffer)), 'constant', constant_values=(0, 0))
        result = list(map(float, [*l1, *l2]))
        #print("Generated state: ", result)
        return result

    def generate_reward(self, did_vacuum):
        last_live_tup = self.num_live_tuples_buffer[0]
        last_dead_tup = self.num_dead_tuples_buffer[0]
        last_read = self.num_read_delta_buffer[0]
        #print("Last live tup:", last_live_tup, "Last dead tup:", last_dead_tup, "Last_read:", last_read)

        # -1 unit of reward equivalent to scanning the entire table (live + dead tuples).
        # The reward is intended to be scale free.
        sum = last_live_tup+last_dead_tup
        if sum == 0:
            reward = 0
        else:
            reward = last_read/sum
            if did_vacuum:
                # Assume vacuuming is approximately 100x more expensive than scanning the table once.
                reward -= 100

        #print("Returning reward:", reward)
        return reward

    def env_start(self):
        """
        The first method called when the experiment starts, called before the
        agent starts.

        Returns:
            The first state observation from the environment.
        """

        barrier = Barrier(2)
        self.workload_thread = Process(target=self.workload_fn, args=(barrier, self.env_info))
        self.workload_thread.start()
        # We wait until the workload is initialized and ready to start
        barrier.wait()
        print("Starting agent...")

        self.time_started = time.time()

        self.last_autovac_time = time.time()
        self.delay_adjustment_count = 0

        # Connect to Postgres
        conn = psycopg2.connect(dbname=self.db_name, host=self.db_host, user=self.db_user, password=self.db_pwd)
        conn.set_session(autocommit=True)

        self.cursor = conn.cursor()
        self.cursor.execute("alter table %s set ("
                            "autovacuum_enabled = off,"
                            "autovacuum_vacuum_scale_factor = 0,"
                            "autovacuum_vacuum_insert_scale_factor = 0,"
                            "autovacuum_vacuum_threshold = 0,"
                            "autovacuum_vacuum_cost_delay = 0,"
                            "autovacuum_vacuum_cost_limit = 10000"
                            ")" % self.table_name)


        self.update_stats()
        initial_state = self.generate_state()

        is_terminal = not self.workload_thread.is_alive()
        reward = self.generate_reward(False)
        self.reward_obs_term = (reward, initial_state, is_terminal)
        return self.reward_obs_term[1]

    def env_step(self, action):
        """A step taken by the environment.

        Args:
            action: The action taken by the agent

        Returns:
            (float, state, Boolean): a tuple of the reward, state observation,
                and boolean indicating if it's terminal.
        """

        time.sleep(1)

        # effect system based on action
        did_vacuum = False
        if action == 0:
            # Not vacuuming
            #print("Action 0: Not vacuuming.")
            pass
        elif action == 1:
            # Vacuuming
            did_vacuum = True
            self.delay_adjustment_count += 1
            #print("Action 1: Vacuuming...")
        else:
            assert("Invalid action")

        self.update_stats()
        current_state = self.generate_state()

        is_terminal = not self.workload_thread.is_alive()
        if is_terminal:
            print("Terminating.")
            print("Delay adjustments: %d" % self.delay_adjustment_count)

        # compute reward before doing the vacuum (will clear dead tuples)
        reward = self.generate_reward(did_vacuum)
        if did_vacuum:
            self.cursor.execute("vacuum %s" % self.table_name)
            #print("..done")

        self.reward_obs_term = (reward, current_state, is_terminal)

        #self.cursor.execute("select vacuum_count, autovacuum_count from pg_stat_user_tables where relname = '%s'" % self.table_name)
        #internal_vac_count, internal_autovac_count = self.cursor.fetchall()[0]
        #print("===================> Time %.2f: Internal vac: %d, Internal autovac: %d"
        #      % (time.time()-self.time_started, internal_vac_count, internal_autovac_count))

        return self.reward_obs_term
