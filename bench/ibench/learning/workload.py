import time
import sys
import os
import psycopg2

from multiprocessing import Process

def wait_for_init_fn(init_barrier, env_info, exp_info):
    conn = psycopg2.connect(dbname=env_info['db_name'], host=env_info['db_host'], user=env_info['db_user'], password=env_info['db_pwd'])
    conn.set_session(autocommit=True)
    cursor = conn.cursor()

    while True:
        print("Waiting for workload initialization...")
        time.sleep(0.5)

        try:
            cursor.execute("select count(*) from %s" % env_info['table_name'])
            tuple_count = cursor.fetchall()[0][0]
        except psycopg2.errors.UndefinedTable:
            print("Table does not (yet) exist")
            continue

        print("Obtained %d/%d tuples..." % (tuple_count, exp_info['initial_size']))
        if tuple_count >= exp_info['initial_size']:
            break

    init_barrier.wait()
    print("Workload is initialized")

def insert_benchmark(init_barrier, env_info, exp_info):
    tag = "tag_%s_n%d" % (env_info['strategy'], env_info['experiment_id'])

    cmd = (("python3 iibench.py --setup --dbms=postgres "
           "--db_user=%s --db_name=%s --db_host=%s --db_password=%s "
           "--max_rows=100000000 --secs_per_report=5 --query_threads=3 --delete_per_insert "
            "--max_seconds=%d --rows_per_commit=10000 --table_name=%s "
           "--initial_size=%d --inserts_per_second=%d") %
           (env_info['db_user'], env_info['db_name'], env_info['db_host'], env_info['db_pwd'],
            env_info['max_seconds'], env_info['table_name'], exp_info['initial_size'], exp_info['update_speed']))

    wait_for_init_thread = Process(target=wait_for_init_fn, args=(init_barrier, env_info, exp_info))
    wait_for_init_thread.start()

    print("Running command: ", cmd)
    sys.stdout.flush()
    os.system(cmd)

    print("Joining init thread...")
    wait_for_init_thread.join()

    # Collect and sort query latencies into a single file
    os.system("cat all_readings_Query_thread_#* | sort -nr > %s_latencies.txt" % tag)

    print("Workload finished.")
