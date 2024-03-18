import math
import sys
import time
from ctypes import c_int64

from iibench import get_conn, apply_options, run_main, run_benchmark, FLAGS
from multiprocessing import Process, Barrier

from learning.environment import BaseEnvironment
from learning.rl_glue import RLGlue
from learning.rl import Agent, default_network_arch

import numpy as np
import torch

from tqdm.auto import tqdm

# command line arguments
finetune = False
max_episodes = None
instance_password = None
instance_url = None
instance_user = None
instance_dbname = None

def run_with_params(apply_options_only, resume_id, id, initial_size, update_speed, initial_delay, control_autovac, enable_pid, enable_learning, enable_agent):
    id.value += 1
    if id.value < resume_id:
        return
    print ("Running experiment %d" % id.value)
    sys.stdout.flush()

    cmd = ["--setup", "--dbms=postgres",
           "--db_user=%s" % instance_user, "--db_name=%s" % instance_dbname,
           "--db_host=%s" % instance_url, "--db_password=%s" % instance_password,
           "--max_rows=100000000", "--secs_per_report=120",
           "--query_threads=3", "--delete_per_insert", "--max_seconds=120", "--rows_per_commit=10000",
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
            run_with_params(False, resume_id, id, initial_size, update_speed, 60, True, True, False, True)
            #for initial_delay in [1, 5, 15, 60]:
            #    run_with_params(False, resume_id, id, initial_size, update_speed, initial_delay, True, False, False, True)

class AutoVacEnv(BaseEnvironment):
    def env_init(self, env_info={}):
        """
        Setup for the environment called when the experiment first starts.
        """
        self.experiment = None

        self.num_live_tuples_buffer = []
        self.num_dead_tuples_buffer = []
        self.num_read_tuples_buffer = []

        self.live_pct_buffer = []
        self.num_read_deltapct_buffer = []
        self.num_read_delta_buffer = []

    def update_stats(self):
        self.cursor.execute("select pg_total_relation_size('public.purchases_index')")
        total_space = self.cursor.fetchall()[0][0]

        self.cursor.execute("select pg_table_size('public.purchases_index')")
        used_space = self.cursor.fetchall()[0][0]

        self.cursor.execute("select n_live_tup, n_dead_tup, seq_tup_read from pg_stat_user_tables where relname = '%s'" % FLAGS.table_name)
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
                # Assume vacuuming is approximately 10x more expensive than scanning the table once.
                reward -= 10

        #print("Returning reward:", reward)
        return reward

    def env_start(self):
        """
        The first method called when the experiment starts, called before the
        agent starts.

        Returns:
            The first state observation from the environment.
        """

        run_with_params(True, 1, c_int64(0), 100000, 32000, 5, True, False, True, False)
        barrier = Barrier(2)
        self.experiment = Process(target=run_benchmark, args=(barrier,))
        self.experiment.start()
        barrier.wait()
        print("Starting agent...")

        self.time_started = time.time()

        self.last_autovac_time = time.time()
        self.delay_adjustment_count = 0

        self.db_conn = get_conn()
        self.cursor = self.db_conn.cursor()
        self.cursor.execute("alter table %s set ("
                            "autovacuum_enabled = off,"
                            "autovacuum_vacuum_scale_factor = 0,"
                            "autovacuum_vacuum_insert_scale_factor = 0,"
                            "autovacuum_vacuum_threshold = 0,"
                            "autovacuum_vacuum_cost_delay = 0,"
                            "autovacuum_vacuum_cost_limit = 10000"
                            ")" % FLAGS.table_name)


        self.update_stats()
        initial_state = self.generate_state()

        is_terminal = not self.experiment.is_alive()
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

        is_terminal = not self.experiment.is_alive()
        if is_terminal:
            print("Terminating.")
            print("Delay adjustments: %d" % self.delay_adjustment_count)

        # compute reward before doing the vacuum (will clear dead tuples)
        reward = self.generate_reward(did_vacuum)
        if did_vacuum:
            self.cursor.execute("vacuum %s" % FLAGS.table_name)
            #print("..done")

        self.reward_obs_term = (reward, current_state, is_terminal)

        #self.cursor.execute("select vacuum_count, autovacuum_count from pg_stat_user_tables where relname = '%s'" % FLAGS.table_name)
        #internal_vac_count, internal_autovac_count = self.cursor.fetchall()[0]
        #print("===================> Time %.2f: Internal vac: %d, Internal autovac: %d"
        #      % (time.time()-self.time_started, internal_vac_count, internal_autovac_count))

        return self.reward_obs_term


def learn(resume_id):
    agent_configs = {
        'network_arch' : default_network_arch,

        'batch_size': 8,
        'buffer_size': 50000,
        'gamma': 0.99,
        'learning_rate': 1e-4,
        'tau':0.01 ,
        'seed':0,
        'num_replay_updates': 5

    }

    environment_configs = {}
    experiment_configs = {
        'num_runs': 1,
        'num_episodes': max_episodes,
        'timeout': 1000
    }

    ### Instantiate the RLGlue class
    rl_glue = RLGlue(AutoVacEnv, Agent)

    ### Save sum of reward
    agent_sum_reward = np.zeros((experiment_configs['num_runs'], experiment_configs['num_episodes']))

    for run in tqdm(range(experiment_configs['num_runs'])):
        # Set the random seed for agent and environment
        agent_configs['seed'] = run
        environment_configs['seed'] = run

        # Initialize the rl_glue
        rl_glue.rl_init(agent_configs, environment_configs)

        # Finetuning
        if finetune:
            checkpoint = torch.load(PATH)
            rl_glue.agent.model.load_state_dict(checkpoint['model_state_dict'])
            start_episode = checkpoint['episode'] + 1
            print('Finetuning...')
        else:
            start_episode = 0
            print('Training...')

        ### Loop over episodes
        for episode in tqdm(range(start_episode, start_episode + experiment_configs['num_episodes'])):
            # Run episode
            rl_glue.rl_episode(experiment_configs['timeout'])

            # Get reward
            episode_reward = rl_glue.rl_agent_message('get_sum_reward')
            # Save the reward in the array
            agent_sum_reward[run, episode - start_episode] = episode_reward

            # Save the model for testing
            if episode == start_episode + experiment_configs['num_episodes'] - 1:
                current_model = rl_glue.agent.model
                torch.save({'episode':episode, 'model_state_dict':current_model.state_dict(), }, 'current_model_{}.pth'.format(episode+1))

            print('Run:{}, episode:{}, reward:{}'.format(run, episode, episode_reward))

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
