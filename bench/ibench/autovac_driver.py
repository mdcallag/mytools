import os
import sys
import math
import time

from iibench import apply_options, run_main, run_benchmark

from learning.autovac_rl import AutoVacEnv
from learning.rl_glue import RLGlue
from learning.rl import Agent, default_network_arch
import psycopg2

from multiprocessing import Barrier, Process

from tqdm.auto import tqdm

def run_with_params(apply_options_only, tag, db_host, db_user, db_pwd, db_name, initial_size, update_speed,
                    initial_delay, max_seconds, control_autovac, enable_pid, enable_learning, rl_model_filename, enable_agent):
    cmd = ["--setup", "--dbms=postgres", "--tag=%s" % tag,
           "--db_user=%s" % db_user, "--db_name=%s" % db_name,
           "--db_host=%s" % db_host, "--db_password=%s" % db_pwd,
           "--max_rows=100000000", "--secs_per_report=120",
           "--query_threads=3", "--delete_per_insert", "--max_seconds=%d" % max_seconds, "--rows_per_commit=10000",
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

    used_learned_model = len(rl_model_filename) > 0
    if used_learned_model:
        cmd.append("--use_learned_model")
        cmd.append("--learned_model_file=%s" % rl_model_filename)
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

    if not enable_learning:
        # Collect and sort query latencies into a single file
        os.system("cat %s_dataQuery_thread_#* | sort -nr > %s_latencies.txt" % (tag, tag))

def benchmark(resume_id):
    id = 0
    for initial_size in tqdm([10000, 100000, 1000000]):
        for update_speed in tqdm([500, 1000, 2000, 4000, 8000, 16000, 32000, 64000]):
            id += 1
            if id < resume_id:
                continue
            print("Running experiment %d" % id)
            sys.stdout.flush()

            tag_suffix = "_n%d_size%d_updates%d" % (id, initial_size, update_speed)
            tag1 = "tag_model1%s" % tag_suffix
            tag2 = "tag_model2%s" % tag_suffix
            tag3 = "tag_pid%s" % tag_suffix
            tag4 = "tag_vanilla%s" % tag_suffix

            # Control with RL model #1
            run_with_params(False, tag1, instance_url, instance_user, instance_password, instance_dbname,
                            initial_size, update_speed, 5, experiment_duration, True, False, False,
                            model1_filename, True)

            # Control with RL model #1
            run_with_params(False, tag2, instance_url, instance_user, instance_password, instance_dbname,
                            initial_size, update_speed, 5, experiment_duration, True, False, False,
                            model2_filename, True)

            # Control with PID
            run_with_params(False, tag3, instance_url, instance_user, instance_password, instance_dbname,
                            initial_size, update_speed, 5, experiment_duration, True, True, False,
                            "", True)

            # Control with default autovacuum
            run_with_params(False, tag4, instance_url, instance_user, instance_password, instance_dbname,
                            initial_size, update_speed, 5, experiment_duration, False, False, False,
                            "", True)

            gnuplot_cmd = ("gnuplot -e \"outfile='graph%s.png'; titlestr='Query latency graph (%s)'; filename1='%s_latencies.txt'; filename2='%s_latencies.txt'; filename3='%s_latencies.txt'; filename4='%s_latencies.txt'\" gnuplot_script.txt"
                           % (tag_suffix, tag_suffix, tag1, tag2, tag3, tag4))
            print("Gnuplot command: ", gnuplot_cmd)
            os.system(gnuplot_cmd)

def getParamsFromExperimentId(experiment_id):
    # Vary update speed from 1000 to 128000
    update_speed = math.ceil(1000.0*math.pow(2, experiment_id % 8))
    # Vary initial size from 10^4 to 10^6
    initial_size = math.ceil(math.pow(10, 4 + (experiment_id // 8) % 3))

    return initial_size, update_speed

def run_with_default_settings(barrier, env_info):
    experiment_id = env_info['experiment_id']
    initial_size, update_speed = getParamsFromExperimentId(experiment_id)

    run_with_params(True, "rl_model",
                    env_info['db_host'], env_info['db_user'], env_info['db_pwd'], env_info['db_name'],
                    initial_size, update_speed, env_info['initial_delay'], env_info['max_seconds'],
                    True, False, True, "", False)
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

    # Returns True if the run has finished
    def step(self):
        if not self.workload_thread.is_alive():
            return True

        time.sleep(1)
        return False

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

class SimulatedVacuum:
    def startExp(self, env_info):
        self.env_info = env_info
        self.initial_size, self.update_speed = getParamsFromExperimentId(self.env_info['experiment_id'])
        self.env_info['experiment_id'] += 1
        #print("Params: ", self.initial_size, self.update_speed)

        self.approx_bytes_per_tuple = 100
        self.used_space = 0
        self.total_space = 0

        self.n_live_tup = self.initial_size
        self.n_dead_tup = 0
        self.seq_tup_read = 0
        self.vacuum_count = 0

        self.step_count = 0
        self.max_steps = env_info['max_seconds']

    def step(self):
        self.n_dead_tup += self.update_speed

        sum = self.n_live_tup+self.n_dead_tup
        if sum > 0:
            # Weigh how many tuples we read per second by how many dead tuples we have.
            self.seq_tup_read += 15*3*self.n_live_tup*((self.n_live_tup/sum) ** 0.5)

        self.used_space = self.approx_bytes_per_tuple*sum
        if self.used_space > self.total_space:
            self.total_space = self.used_space

        self.step_count += 1
        return self.step_count >= self.max_steps

    def getTotalAndUsedSpace(self):
        return self.total_space, self.used_space

    def getTupleStats(self):
        return self.n_live_tup, self.n_dead_tup, self.seq_tup_read, self.vacuum_count, 0

    def doVacuum(self):
        self.n_dead_tup = 0
        self.vacuum_count += 1

def learn(resume_id):
    agent_configs = {
        'network_arch': default_network_arch,

        'batch_size': 8,
        'buffer_size': 50000,
        'gamma': 0.99,
        'learning_rate': 1e-4,
        'tau': 0.01 ,
        'seed': 0,
        'num_replay_updates': 5,
        'model_filename' : model1_filename
    }

    if model_type == "simulated":
        instance = SimulatedVacuum()
    elif model_type == "real":
        instance = PGStatAndVacuum()
    else:
        assert("Invalid model type")

    environment_configs = {
        'stat_and_vac': instance,
        'experiment_id': 0,
        'db_name': instance_dbname,
        'db_host': instance_url,
        'db_user': instance_user,
        'db_pwd': instance_password,
        'table_name': 'purchases_index',
        'initial_delay': 5,
        'max_seconds': experiment_duration
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
    cmd = sys.argv[1]

    global max_episodes
    max_episodes = int(sys.argv[2])
    global resume_id
    resume_id = int(sys.argv[3])
    global experiment_duration
    experiment_duration = int(sys.argv[4])
    global model_type
    model_type = sys.argv[5]
    global model1_filename
    model1_filename = sys.argv[6]
    global model2_filename
    model2_filename = sys.argv[7]
    global instance_url
    instance_url = sys.argv[8]
    global instance_user
    instance_user = sys.argv[9]
    global instance_password
    instance_password = sys.argv[10]
    global instance_dbname
    instance_dbname = sys.argv[11]

    if cmd == "benchmark":
        benchmark(resume_id)
    elif cmd == "learn":
        learn(resume_id)
    else:
        print("Invalid command")
