import os
import argparse
import sys

from learning.autovac_rl import AutoVacEnv
from learning.rl_glue import RLGlue
from learning.rl import Agent, default_network_arch

from workloads.iibench_driver import run_with_params

from tqdm.auto import tqdm

from executors.simulated_vacuum import SimulatedVacuum
from executors.pg_stat_and_vacuum import PGStatAndVacuum

def benchmark(resume_id, experiment_duration, model_type, model1_filename, model2_filename, instance_url, instance_user, instance_password, instance_dbname):
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

def learn(resume_id, experiment_duration, model_type, model1_filename, model2_filename, instance_url, instance_user, instance_password, instance_dbname):
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

    is_replay = False
    if model_type == "simulated":
        instance = SimulatedVacuum()
    elif model_type == "real" or model_type == "real_replay":
        instance = PGStatAndVacuum()
        if model_type == "real_replay":
            is_replay = True
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
        'max_seconds': experiment_duration,
        'approx_bytes_per_tuple': 100,
        'is_replay': is_replay,
        'replay_filename_mask': 'replay_n%d.txt',
        'state_history_length': 10
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
    parser = argparse.ArgumentParser(description="Run the AutoVacuum reinforcement learning driver.")
    parser.add_argument('--cmd', type=str, choices=['benchmark', 'learn'], help='Command to execute (benchmark or learn)')
    parser.add_argument('--max-episodes', type=int, default=100, help='Maximum number of episodes for the experiment')
    parser.add_argument('--resume-id', type=int, default=0, help='Identifier to resume from a previous state')
    parser.add_argument('--experiment-duration', type=int, default=120, help='Duration of the experiment in seconds')
    parser.add_argument('--model-type', type=str, choices=['simulated', 'real'], help='Type of the model (simulated or real)')
    parser.add_argument('--model1-filename', type=str, default='model1.pth', help='Filename for the first model')
    parser.add_argument('--model2-filename', type=str, default='model2.pth', help='Filename for the second model')
    parser.add_argument('--instance-url', type=str, help='URL of the database instance')
    parser.add_argument('--instance-user', type=str, help='Database user')
    parser.add_argument('--instance-password', type=str, help='Database password')
    parser.add_argument('--instance-dbname', type=str, help='Database name')

    args = parser.parse_args()
    
    cmd = args.cmd

    max_episodes = args.max_episodes
    resume_id = args.resume_id
    experiment_duration = args.experiment_duration
    model_type = args.model_type
    model1_filename = args.model1_filename
    model2_filename = args.model2_filename
    instance_url = args.instance_url
    instance_user = args.instance_user
    instance_password = args.instance_password
    instance_dbname = args.instance_dbname

    if cmd == "benchmark":
        benchmark(resume_id, experiment_duration, model_type, model1_filename, model2_filename, instance_url, instance_user, instance_password, instance_dbname)
    elif cmd == "learn":
        learn(resume_id, experiment_duration, model_type, model1_filename, model2_filename, instance_url, instance_user, instance_password, instance_dbname)
    else:
        print("Invalid command")
