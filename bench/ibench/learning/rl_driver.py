import argparse

from autovac_rl import AutoVacEnv
from agent_env_glue import AgentEnvGlue
from workload import insert_benchmark
from rl_agent import RLAgent, default_network_arch

from simulated_vacuum import SimulatedVacuum
from pg_stat_and_vacuum import PGStatAndVacuum

def drive():
    agent_conf = {
        'network_arch': default_network_arch,

        'batch_size': 16,
        'buffer_size': 100000,
        'gamma': 0.99,
        'learning_rate': 0.0005,
        'tau': 0.1,
        'seed': 0,
        'num_replay_updates': 5,

        'enable_training': True,
        'start_episode': 0,
        'finetune': args.finetune,
        'model_filename' : args.model_filename,
        'default_action': 0
    }

    is_replay = False
    if args.model_type == "sim":
        instance = SimulatedVacuum()
    elif args.model_type == "real" or args.model_type == "real-replay":
        instance = PGStatAndVacuum()
        if args.model_type == "real-replay":
            is_replay = True
    else:
        assert False, "Invalid model type: %s" % args.model_type

    env_conf = {
        'stat_and_vac': instance,
        'workload_fn': insert_benchmark,
        'experiment_id': 0,
        'strategy': 'model1',
        'disable_autovac': True,
        'db_name': args.db_name,
        'db_host': args.db_url,
        'db_user': args.db_user,
        'db_pwd': args.db_pwd,
        'table_name': 'purchases_index',
        'initial_delay': 5,
        'initial_deleted_fraction': 0,
        'vacuum_buffer_usage_limit': 256,
        'max_seconds': args.experiment_duration,
        'approx_bytes_per_tuple': 100,
        'is_replay': is_replay,
        'replay_filename_mask': 'replay_n%d.txt',
        'state_history_length': 64 # 4^3
    }

    exp_conf = {
        'num_runs': 1,
        'num_episodes': args.max_episodes,
        'timeout': 1000
    }

    ### Instantiate the RLGlue class
    glue = AgentEnvGlue(AutoVacEnv, RLAgent)
    glue.run(env_conf, exp_conf, agent_conf)
    glue.cleanup()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Run the AutoVacuum reinforcement learning driver.")
    parser.add_argument('--max-episodes', type=int, default=100, help='Maximum number of episodes for the experiment')
    parser.add_argument("--finetune", action="store_true", help='Finetune existing model')
    parser.add_argument('--experiment-duration', type=int, default=120, help='Duration of the experiment in seconds')
    parser.add_argument('--model-type', type=str, choices=['sim', 'real', 'real-replay'], help='Type of the model (simulated or real)')
    parser.add_argument('--model-filename', type=str, default='model1.pth', help='Filename for the first model')
    parser.add_argument('--db-url', type=str, default='', help='URL of the database instance')
    parser.add_argument('--db-user', type=str, default='', help='Database user')
    parser.add_argument('--db-pwd', type=str, default='', help='Database password')
    parser.add_argument('--db-name', type=str, default='', help='Database name')

    args = parser.parse_args()

    drive()
