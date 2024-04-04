import time
import psycopg2
from workloads.iibench_driver import run_with_default_settings
from multiprocessing import Barrier, Process
from executors.vacuum_experiment import VacuumExperiment

class PGStatAndVacuum(VacuumExperiment):
    def startExp(self, env_info):
        self.env_info = env_info
        self.db_name = env_info['db_name']
        self.db_host = env_info['db_host']
        self.db_user = env_info['db_user']
        self.db_pwd = env_info['db_pwd']
        self.table_name = env_info['table_name']

        print("Environment info (for PGStatAndVacuum):")
        for x in self.env_info:
            print ('\t', x, ':', self.env_info[x])

        self.is_replay = env_info['is_replay']
        self.replay_filename = env_info['replay_filename_mask'] % env_info['experiment_id']
        self.replay_buffer_index = 0
        self.replay_buffer = []
        if self.is_replay:
            with open(self.replay_filename, 'r') as f:
                self.replay_buffer = f.readlines()
            print("Read %d lines into replay buffer from file '%s'"
                  % (len(self.replay_buffer), self.replay_filename))
        else:
            barrier = Barrier(2)
            self.workload_thread = Process(target=run_with_default_settings, args=(barrier, self.env_info))
            self.workload_thread.start()
            # We wait until the workload is initialized and ready to start
            barrier.wait()

            self.conn = psycopg2.connect(dbname=self.db_name, host=self.db_host, user=self.db_user, password=self.db_pwd)
            self.conn.set_session(autocommit=True)
            self.cursor = self.conn.cursor()

            print("Disabling autovacuum...")
            self.cursor.execute("alter table %s set ("
                                "autovacuum_enabled = off,"
                                "autovacuum_vacuum_scale_factor = 0,"
                                "autovacuum_vacuum_insert_scale_factor = 0,"
                                "autovacuum_vacuum_threshold = 0,"
                                "autovacuum_vacuum_cost_delay = 0,"
                                "autovacuum_vacuum_cost_limit = 10000"
                                ")" % self.table_name)

        self.env_info['experiment_id'] += 1

    def get_next_buffer_line(self):
        assert(self.is_replay)
        result = self.replay_buffer[self.replay_buffer_index]
        self.replay_buffer_index += 1
        return result

    def is_replay_finished(self):
        return self.replay_buffer_index >= len(self.replay_buffer)

    def write_replay_buffer_line(self, line):
        self.replay_buffer.append(line + "\n")

    def save_replay_buffer(self):
        with open(self.replay_filename, 'w') as f:
            f.writelines(self.replay_buffer)

    # Returns True if the run has finished
    def step(self):
        if self.is_replay:
            return self.get_next_buffer_line().startswith("finished")

        if not self.workload_thread.is_alive():
            self.write_replay_buffer_line("finished")
            self.save_replay_buffer()
            return True

        self.write_replay_buffer_line("step")
        time.sleep(1)
        return False

    def getTotalAndUsedSpace(self):
        if self.is_replay:
            total_space, used_space = [int(s) for s in self.get_next_buffer_line().split(" ")]
            return total_space, used_space

        try:
            self.cursor.execute("select pg_total_relation_size('public.%s')" % self.table_name)
            total_space = self.cursor.fetchall()[0][0]

            self.cursor.execute("select pg_table_size('public.%s')" % self.table_name)
            used_space = self.cursor.fetchall()[0][0]

            self.write_replay_buffer_line("%d %d" % (total_space, used_space))
            return total_space, used_space
        except psycopg2.errors.UndefinedTable:
            print("Table does not exist.")
            return 0, 0

    def getTupleStats(self):
        if self.is_replay:
            # Remember last tuple stats to return in case we have finished replaying.
            if not self.is_replay_finished():
                result = [int(s) for s in self.get_next_buffer_line().split(" ")]
                assert(len(result) == 5)
                self.last_tuplestats = result

            return self.last_tuplestats

        self.cursor.execute("select n_live_tup, n_dead_tup, seq_tup_read, vacuum_count, autovacuum_count from pg_stat_user_tables where relname = '%s'" % self.table_name)
        result = self.cursor.fetchall()[0]
        self.write_replay_buffer_line("%d %d %d %d %d"
                                      % (result[0], result[1], result[2], result[3], result[4]))
        return result

    def doVacuum(self):
        if not self.is_replay:
            self.cursor.execute("vacuum %s" % self.table_name)
