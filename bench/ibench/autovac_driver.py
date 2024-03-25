import sys
import math
from ctypes import c_int64

from iibench import apply_options, run_main, run_benchmark

from learning.autovac_rl import AutoVacEnv
from learning.rl_glue import RLGlue
from learning.rl import Agent, default_network_arch
import psycopg2

from multiprocessing import Barrier, Process

# command line arguments
max_episodes = None
instance_password = None
instance_url = None
instance_user = None
instance_dbname = None

def run_with_params(apply_options_only, resume_id, id, db_host, db_user, db_pwd, db_name, initial_size, update_speed, initial_delay, control_autovac, enable_pid, enable_learning, enable_agent):
    id.value += 1
    if id.value < resume_id:
        return
    print ("Running experiment %d" % id.value)
    sys.stdout.flush()

    cmd = ["--setup", "--dbms=postgres",
           "--db_user=%s" % db_user, "--db_name=%s" % db_name,
           "--db_host=%s" % db_host, "--db_password=%s" % db_pwd,
           "--max_rows=100000000", "--secs_per_report=120",
           "--query_threads=3", "--delete_per_insert", "--max_seconds=120", "--rows_per_commit=5000",
           "--initial_size=%d" % initial_size,
           "--inserts_per_second=%d" % update_speed,
           "--initial_autovac_delay=%d" % initial_delay
           ]
    if control_autovac:
        cmd.append("--control_autovac")
    if enable_pid:
        cmd.append("--enable_pid")
    if enable_learning:
        cmd.append("--enable_learning")
    if enable_agent:
        cmd.append("--enable_agent")

    print("Running command: ", cmd)
    sys.stdout.flush()

    apply_options(cmd)
    if not apply_options_only:
        if run_main() != 0:
            print("Error. Quitting driver.")
            sys.stdout.flush()
            sys.exit()

def benchmark(resume_id):
    id = c_int64(0)
    for initial_size in [100000]:
        for update_speed in [32000]:
            #run_with_params(False, resume_id, id, initial_size, update_speed, 60, False, False, False, True)
            run_with_params(False, resume_id, id, instance_url, instance_user, instance_password, instance_dbname, initial_size, update_speed, 60, True, True, False, True)
            #for initial_delay in [1, 5, 15, 60]:
            #    run_with_params(False, resume_id, id, initial_size, update_speed, initial_delay, True, False, False, True)

def run_with_default_settings(barrier, env_info):
    experiment_id = env_info['experiment_id']

    # Vary update speed from 1000 to 128000
    update_speed = math.ceil(1000.0*math.pow(2, experiment_id % 8))
    # Vary initial size from 0 to 1000000
    initial_size = (experiment_id // 8) % 3
    initial_size = 0 if initial_size == 0 else 100000 if initial_size == 1 else 1000000

    run_with_params(True, 1, c_int64(experiment_id),
                    env_info['db_host'], env_info['db_user'], env_info['db_pwd'], env_info['db_name'],
                    initial_size, update_speed, env_info['initial_delay'],
                    True, False, True, False)
    run_benchmark(barrier)

class PGStatAndVacuum:
    def startExp(self, env_info):
        self.env_info = env_info
        self.db_name = env_info['db_name']
        self.db_host = env_info['db_host']
        self.db_user = env_info['db_user']
        self.db_pwd = env_info['db_pwd']
        self.table_name = env_info['table_name']

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

    def hasFinished(self):
        return not self.workload_thread.is_alive()

    def getTotalAndUsedSpace(self):
        try :
            self.cursor.execute("select pg_total_relation_size('public.%s')" % self.table_name)
            total_space = self.cursor.fetchall()[0][0]

            self.cursor.execute("select pg_table_size('public.%s')" % self.table_name)
            used_space = self.cursor.fetchall()[0][0]

            return total_space, used_space
        except psycopg2.errors.UndefinedTable:
            print("Table does not exist.")
            return 0, 0

    def getTupleStats(self):
        self.cursor.execute("select n_live_tup, n_dead_tup, seq_tup_read, vacuum_count, autovacuum_count from pg_stat_user_tables where relname = '%s'" % self.table_name)
        return self.cursor.fetchall()[0]

    def doVacuum(self):
        self.cursor.execute("vacuum %s" % self.table_name)


def learn(resume_id):
    agent_configs = {
        'network_arch': default_network_arch,

        'batch_size': 8,
        'buffer_size': 50000,
        'gamma': 0.99,
        'learning_rate': 1e-4,
        'tau': 0.01 ,
        'seed': 0,
        'num_replay_updates': 5

    }

    environment_configs = {
        'experiment_id': 0,
        'stat_and_vac': PGStatAndVacuum(),
        'db_name': instance_dbname,
        'db_host': instance_url,
        'db_user': instance_user,
        'db_pwd': instance_password,
        'table_name': 'purchases_index',
        'initial_delay': 5,
    }

    experiment_configs = {
        'num_runs': 1,
        'num_episodes': max_episodes,
        'timeout': 1000
    }

    ### Instantiate the RLGlue class
    rl_glue = RLGlue(AutoVacEnv, Agent)
    rl_glue.do_learn(environment_configs, experiment_configs, agent_configs)

if __name__ == '__main__':
    max_episodes = int(sys.argv[1])
    instance_url = sys.argv[2]
    instance_user = sys.argv[3]
    instance_password = sys.argv[4]
    instance_dbname = sys.argv[5]

    resume_id = 1
    print("Initial id: ", resume_id)
    sys.stdout.flush()

    #benchmark(resume_id)
    learn(resume_id)
