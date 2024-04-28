import math

class AutoVacState:
    def __init__(self, history_length):
        self.history_length = history_length
        self.aggregation_sizes = [int(math.pow(4, i)) for i in range(math.ceil(math.log(self.history_length, 4))+1)]
        self.init_state()

    def init_state(self):
        # Readings we have obtained for the past several seconds.
        # To start the experiment, pad with some initial values.
        self.num_live_tuples_buffer = [0.0 for _ in range(self.history_length)]
        self.num_dead_tuples_buffer = [0.0 for _ in range(self.history_length)]
        self.num_read_tuples_buffer = [0.0 for _ in range(self.history_length)]
        self.num_read_delta_buffer = [0.0 for _ in range(self.history_length)]

        # The following buffers are used to generate the environment state.
        self.live_pct_buffer = [1.0 for _ in range(self.history_length)]
        self.dead_pct_buffer = [0.0 for _ in range(self.history_length)]
        self.num_read_deltapct_buffer = [30.0 for _ in range(self.history_length)]

    def update(self, n_live_tup, n_dead_tup, seq_tup_read, live_pct, dead_pct, delta_pct, delta):
        self.num_live_tuples_buffer.pop()
        self.num_live_tuples_buffer.insert(0, n_live_tup)
        self.num_dead_tuples_buffer.pop()
        self.num_dead_tuples_buffer.insert(0, n_dead_tup)
        self.num_read_tuples_buffer.pop()
        self.num_read_tuples_buffer.insert(0, seq_tup_read)
        self.live_pct_buffer.pop()
        self.live_pct_buffer.insert(0, live_pct)
        self.dead_pct_buffer.pop()
        self.dead_pct_buffer.insert(0, dead_pct)
        self.num_read_deltapct_buffer.pop()
        self.num_read_deltapct_buffer.insert(0, delta_pct)
        self.num_read_delta_buffer.pop()
        self.num_read_delta_buffer.insert(0, delta)

    def generate_state(self):
        # Average historical readings and append to result vector.
        result = [sum(r[0:v])/v for r in [self.live_pct_buffer, self.dead_pct_buffer, self.num_read_deltapct_buffer] for v in self.aggregation_sizes]
        print("Generated state: ", [round(x, 1) for x in result])
        return result