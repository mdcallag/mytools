import os
import sys
import math

# To be able to import from parent directory.
current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.dirname(current_dir))
from iibench import apply_options, run_benchmark

def run_with_params(tag, db_host, db_user, db_pwd, db_name, initial_size, update_speed, max_seconds):
    cmd = ["--setup", "--dbms=postgres", "--tag=%s" % tag,
           "--db_user=%s" % db_user, "--db_name=%s" % db_name,
           "--db_host=%s" % db_host, "--db_password=%s" % db_pwd,
           "--max_rows=100000000", "--secs_per_report=5",
           "--query_threads=3", "--delete_per_insert", "--max_seconds=%d" % max_seconds, "--rows_per_commit=10000",
           "--initial_size=%d" % initial_size,
           "--inserts_per_second=%d" % update_speed,
           ]

    print("Running command: ", cmd)
    sys.stdout.flush()
    apply_options(cmd)

def collectExperimentParams(env_info):
    v = env_info['experiment_id']

    # Vary update speed from 500 to 32000
    update_speed = math.ceil(500*math.pow(2, v % 7))
    v //= 7

    # Vary initial size from 10^4 to 10^6
    initial_size = math.ceil(math.pow(10, 4 + (v % 3)))

    return initial_size, update_speed

def run_with_default_settings(barrier, env_info):
    initial_size, update_speed = collectExperimentParams(env_info)
    tag = "tag_%s_n%d" % (env_info['strategy'], env_info['experiment_id'])

    run_with_params(tag, env_info['db_host'], env_info['db_user'], env_info['db_pwd'], env_info['db_name'], initial_size, update_speed, env_info['max_seconds'])
    run_benchmark(barrier)

    # Collect and sort query latencies into a single file
    os.system("cat %s_dataQuery_thread_#* | sort -nr > %s_latencies.txt" % (tag, tag))

