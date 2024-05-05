import sys
import os

# To be able to import from parent directory.
current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.dirname(current_dir))
from iibench import apply_options, run_benchmark

def insert_benchmark(init_barrier, env_info, exp_info):
    tag = "tag_%s_n%d" % (env_info['strategy'], env_info['experiment_id'])

    cmd = ["--setup", "--dbms=postgres", "--tag=%s" % tag,
           "--db_user=%s" % env_info['db_user'], "--db_name=%s" % env_info['db_name'],
           "--db_host=%s" % env_info['db_host'], "--db_password=%s" % env_info['db_pwd'],
           "--max_rows=100000000", "--secs_per_report=5",
           "--query_threads=3", "--delete_per_insert", "--max_seconds=%d" % env_info['max_seconds'], "--rows_per_commit=10000",
           "--initial_size=%d" % exp_info['initial_size'],
           "--inserts_per_second=%d" % exp_info['update_speed'],
           ]

    print("Running command: ", cmd)
    sys.stdout.flush()
    apply_options(cmd)
    run_benchmark(init_barrier)
    print("Workload finished.")

    # Collect and sort query latencies into a single file
    os.system("cat %s_dataQuery_thread_#* | sort -nr > %s_latencies.txt" % (tag, tag))
