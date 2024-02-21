import os
import sys
from ctypes import c_int64

def run_with_params(resume_id, id, initial_size, update_speed, initial_delay, control_autovac, enable_pid):
    id.value += 1
    if id.value < resume_id:
        return
    print ("Running experiment %d" % id.value)
    sys.stdout.flush()

    cmd = "python3 iibench.py --setup --dbms=postgres --db_user=svilen --db_password=eddie --max_rows=100000000 --secs_per_report=120 --query_threads=3 --delete_per_insert --max_seconds=120"
    cmd += " --initial_size=%d" % initial_size
    cmd += " --inserts_per_second=%d" % update_speed
    cmd += " --initial_autovac_delay=%d" % initial_delay
    if control_autovac:
        cmd += " --control_autovac"
    if enable_pid:
        cmd += " --enable_pid"

    print("Running command: ", cmd)
    sys.stdout.flush()
    if os.system(cmd) != 0:
        print("Error. Quitting driver.")
        sys.stdout.flush()
        sys.exit()

if __name__ == '__main__':
    resume_id = 1
    print("Initial id: ", resume_id)
    sys.stdout.flush()

    id = c_int64(0)
    for initial_size in [0, 100000, 1000000]:
        for update_speed in [1000, 2000, 4000, 8000, 16000, 32000, 64000, 1000000]:
            run_with_params(resume_id, id, initial_size, update_speed, 60, False, False)
            run_with_params(resume_id, id, initial_size, update_speed, 60, True, True)
            for initial_delay in [1, 5, 15, 60]:
                run_with_params(resume_id, id, initial_size, update_speed, initial_delay, True, False)
