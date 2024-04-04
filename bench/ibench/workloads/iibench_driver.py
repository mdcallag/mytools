import os
import sys
import math

from iibench import apply_options, run_main, run_benchmark

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

def collectExperimentParams(env_info):
    experiment_id = env_info['experiment_id']
    # Vary update speed from 1000 to 128000
    update_speed = math.ceil(1000.0*math.pow(2, experiment_id % 8))
    # Vary initial size from 10^4 to 10^6
    initial_size = math.ceil(math.pow(10, 4 + (experiment_id // 8) % 3))

    return initial_size, update_speed

def run_with_default_settings(barrier, env_info):
    initial_size, update_speed = collectExperimentParams(env_info)

    run_with_params(True, "rl_model",
                    env_info['db_host'], env_info['db_user'], env_info['db_pwd'], env_info['db_name'],
                    initial_size, update_speed, env_info['initial_delay'], env_info['max_seconds'],
                    True, False, True, "", False)
    run_benchmark(barrier)

