import math
import sys
import time
from ctypes import c_int64

from iibench import get_conn, apply_options, run_main, FLAGS
from multiprocessing import Process

from learning.environment import BaseEnvironment
from learning.rl_glue import RLGlue
from learning.rl import Agent

import numpy as np
import torch

from tqdm.auto import tqdm

def run_with_params(apply_options_only, resume_id, id, initial_size, update_speed, initial_delay, control_autovac, enable_pid, enable_learning, enable_agent):
    id.value += 1
    if id.value < resume_id:
        return
    print ("Running experiment %d" % id.value)
    sys.stdout.flush()

    cmd = ["--setup", "--dbms=postgres", "--db_user=svilen", "--db_password=eddie", "--max_rows=100000000", "--secs_per_report=120",
           "--query_threads=3", "--delete_per_insert", "--max_seconds=120",
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
        if run_main(cmd) != 0:
            print("Error. Quitting driver.")
            sys.stdout.flush()
            sys.exit()

def benchmark(resume_id):
    id = c_int64(0)
    for initial_size in [100000, 1000000]:
        for update_speed in [4000, 8000, 16000, 32000]:
            #run_with_params(False, resume_id, id, initial_size, update_speed, 60, False, False, False, True)
            run_with_params(False, resume_id, id, initial_size, update_speed, 60, True, True, False, True)
            #for initial_delay in [1, 5, 15, 60]:
            #    run_with_params(False, resume_id, id, initial_size, update_speed, initial_delay, True, False, False, True)

class AutoVacEnv(BaseEnvironment):
    def env_init(self, env_info={}):
        """
        Setup for the environment called when the experiment first starts.
        """
        run_with_params(True,1, c_int64(0), 1000000, 16000, 60, True, False, True, False)
        self.experiment = Process(target=run_main, args=())

        self.num_live_tuples_buffer = []
        self.num_read_tuples_buffer = []

        self.live_pct_buffer = []
        self.num_read_deltapct_buffer = []

    def update_stats(self):
        self.cursor.execute("alter system set autovacuum_naptime to %d" % self.current_delay)
        self.cursor.execute("alter system set autovacuum_vacuum_scale_factor to 0")
        self.cursor.execute("alter system set autovacuum_vacuum_insert_scale_factor to 0")
        self.cursor.execute("alter system set autovacuum_vacuum_threshold to 0")
        self.cursor.execute("alter system set autovacuum_analyze_threshold to 0")
        self.cursor.execute("alter system set autovacuum_vacuum_cost_delay to 0")
        self.cursor.execute("alter system set autovacuum_vacuum_cost_limit to 10000")
        self.cursor.execute("select from pg_reload_conf()")

        self.cursor.execute("select * from pgstattuple('purchases_index')")
        pgstattuples = self.cursor.fetchall()
        #print(pgstattuples)

        t = pgstattuples[0]
        live_pct = t[3]
        dead_pct = t[6]
        free_pct = t[8]

        self.cursor.execute("select * from pg_stat_user_tables where relname = 'purchases_index'")
        pgstat_usertbl_tuples = self.cursor.fetchall()
        seq_tup_read = pgstat_usertbl_tuples[0][4]
        n_live_tuples = pgstat_usertbl_tuples[0][11]

        if len(self.num_read_tuples_buffer) == 0:
            delta_pct = 0.0
        else:
            delta_pct = (seq_tup_read - self.num_read_tuples_buffer[0]) / n_live_tuples

        if len(self.num_live_tuples_buffer) >= 10:
            self.num_live_tuples_buffer.pop()
            self.num_read_tuples_buffer.pop()
            self.live_pct_buffer.pop()
            self.num_read_deltapct_buffer.pop()

        self.num_live_tuples_buffer.append(n_live_tuples)
        self.num_read_tuples_buffer.append(seq_tup_read)
        self.live_pct_buffer.append(live_pct)
        self.num_read_deltapct_buffer.append(delta_pct)

    def generate_state(self):
        l1 = np.pad(self.live_pct_buffer, (0, 10-len(self.live_pct_buffer)), 'constant', constant_values=(0, 0))
        l2 = np.pad(self.num_read_deltapct_buffer, (0, 10-len(self.num_read_deltapct_buffer)), 'constant', constant_values=(0, 0))
        result = list(map(float, [*l1, *l2]))
        print(result)
        return result

    def generate_reward(self, did_vacuum):
        #TODO: generate reward

        #Default reward is: -(latest dead tuples) / (latest active tuples + latest dead tuples) * (Δ tuples read) => - (latest dead tuples) * (Δ tuples read) / (latest active tuples + latest dead tuples)^2
        #If action is starting vacuum have reward: -(latest active tuples + latest dead tuples) => -1
        return 0.0

    def env_start(self):
        """
        The first method called when the experiment starts, called before the
        agent starts.

        Returns:
            The first state observation from the environment.
        """
        self.experiment.start()
        time.sleep(1)

        self.current_delay = 60
        self.last_autovac_time = time.time()
        self.prev_delay = self.current_delay
        self.delay_adjustment_count = 0
        self.db_conn = get_conn()
        self.cursor = self.db_conn.cursor()

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

        print("Raw action: %.2f" % action)

        normalized_action = 1
        if action > 10:
            normalized_action += 5*60
        elif action > -10:
            normalized_action += 5*60*(1.0/(1.0+(math.exp(-action))))

        print("Normalized: %.2f" % normalized_action)
        time.sleep(1)

        # effect system based on action
        self.current_delay = normalized_action

        now = time.time()
        did_vacuum = False
        if int(now - self.last_autovac_time) > self.current_delay:
            did_vacuum = True
            self.last_autovac_time = now
            print("Vacuuming table...")
            sys.stdout.flush()
            self.cursor.execute("vacuum %s" % FLAGS.table_name)

        self.update_stats()
        current_state = self.generate_state()

        is_terminal = not self.experiment.is_alive()
        reward = self.generate_reward(did_vacuum)
        self.reward_obs_term = (reward, current_state, is_terminal)
        return self.reward_obs_term


def learn(resume_id):
    agent_configs = {
        'network_arch' : {'num_states':20,
                          'num_hidden_units' : 256,
                          'num_actions': 1},

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
        'num_episodes': 1000,
        'timeout': 1000
    }

    ### Instantiate the RLGlue class
    rl_glue = RLGlue(AutoVacEnv, Agent)

    ### Save sum of reward
    agent_sum_reward = np.zeros((experiment_configs['num_runs'], experiment_configs['num_episodes']))

    finetune = False
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
                torch.save({'episode':episode, 'model_state_dict':current_model.state_dict(), }, 'new_results2/current_model_{}.pth'.format(episode+1))

            print('Run:{}, episode:{}, reward:{}'.format(run, episode, episode_reward))

if __name__ == '__main__':
    resume_id = 1
    print("Initial id: ", resume_id)
    sys.stdout.flush()

    #benchmark(resume_id)
    learn(resume_id)
