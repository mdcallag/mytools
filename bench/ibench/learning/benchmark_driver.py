import argparse

from autovac_rl import AutoVacEnv
from agent_env_glue import AgentEnvGlue
from rl_agent import RLAgent, default_network_arch
from pid_agent import PIDAgent
from noop_agent import NoOpAgent
from workload import insert_benchmark

from pg_stat_and_vacuum import PGStatAndVacuum

def do_run(strat, env_conf, exp_conf, agent_conf, agent_class):
    print("Testing strategy %s" % strat)

    env_conf['strategy'] = strat
    env_conf['experiment_id'] = 0

    glue = AgentEnvGlue(AutoVacEnv, agent_class)
    glue.run(env_conf, exp_conf, agent_conf)
    glue.cleanup()

def benchmark():
    agent_conf = {
        'network_arch': default_network_arch,

        'tau': 0.1,
        'enable_training': False,
        'finetune': True,
        'start_episode': 0,
        'model_filename' : '',
        'default_action': 0
    }

    env_conf = {
        'stat_and_vac': PGStatAndVacuum(),
        'workload_fn': insert_benchmark,
        'experiment_id': 0,
        'strategy': '',
        'disable_autovac': True,
        'db_name': args.db_name,
        'db_host': args.db_url,
        'db_user': args.db_user,
        'db_pwd': args.db_pwd,
        'table_name': 'purchases_index',
        'max_seconds': args.experiment_duration,
        'approx_bytes_per_tuple': 100,
        'is_replay': False,
        'replay_filename_mask': 'replay_n%d.txt',
        'state_history_length': 64 # 4^3
    }

    exp_conf = {
        'num_runs': 1,
        'num_episodes': args.max_episodes,
        'timeout': 1000
    }

    # Test model 1
    agent_conf['model_filename'] = args.model1_filename
    do_run('s1-model1', env_conf, exp_conf, agent_conf, RLAgent)

    # Test model 2
    agent_conf['model_filename'] = args.model2_filename
    do_run('s2-model2', env_conf, exp_conf, agent_conf, RLAgent)

    # Test PID controller
    do_run('s3-pid', env_conf, exp_conf, agent_conf, PIDAgent)

    # Test "always vacuum" strategy.
    agent_conf['default_action'] = 1
    do_run('s4-alwaysvac', env_conf, exp_conf, agent_conf, NoOpAgent)

    # Test "never vacuum" strategy.
    agent_conf['default_action'] = 0
    do_run('s5-nevervac', env_conf, exp_conf, agent_conf, NoOpAgent)

    # Test default autovacuum behavior (it is NOT disabled).
    env_conf['disable_autovac'] = False
    do_run('s6-default', env_conf, exp_conf, agent_conf, NoOpAgent)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Run benchmarking driver.")
    parser.add_argument('--max-episodes', type=int, default=100, help='Maximum number of episodes for the experiment')
    parser.add_argument('--experiment-duration', type=int, default=120, help='Duration of the experiment in seconds')
    parser.add_argument('--model1-filename', type=str, default='model1.pth', help='File name for the first model')
    parser.add_argument('--model2-filename', type=str, default='model2.pth', help='File name for the second model')
    parser.add_argument('--db-url', type=str, default='', help='URL of the database instance')
    parser.add_argument('--db-user', type=str, default='', help='Database user')
    parser.add_argument('--db-pwd', type=str, default='', help='Database password')
    parser.add_argument('--db-name', type=str, default='', help='Database name')

    args = parser.parse_args()

    benchmark()