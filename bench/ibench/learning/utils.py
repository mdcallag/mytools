import math

def collectExperimentParams(env_info):
    v = env_info['experiment_id']

    # Vary update speed from 500 to 32000
    update_speed = math.ceil(500*math.pow(2, v % 7))
    v //= 7

    # Vary initial size from 10^4 to 10^6
    initial_size = math.ceil(math.pow(10, 4 + (v % 3)))

    return {'initial_size': initial_size, 'update_speed': update_speed}
