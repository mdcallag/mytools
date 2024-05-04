import math

from workloads.iibench_driver import collectExperimentParams
from executors.vacuum_experiment import VacuumExperiment

class SimulatedVacuum(VacuumExperiment):
    def startExp(self, env_info):
        self.env_info = env_info
        self.initial_size, self.update_speed = collectExperimentParams(self.env_info)

        #print("Environment info (for SimulatedVacuum):")
        #for x in self.env_info:
        #    print ('\t', x, ':', self.env_info[x])

        self.approx_bytes_per_tuple = env_info["approx_bytes_per_tuple"]
        self.used_space = 0
        self.total_space = 0

        self.n_live_tup = self.initial_size
        self.n_dead_tup = 0
        self.seq_tup_read = 0
        self.vacuum_count = 0
        self.last_action = 0

        self.step_count = 0
        self.max_steps = env_info['max_seconds']

        self.updateUsedSpace()

    def endExp(self):
        # Noop
        pass

    def updateUsedSpace(self):
        self.used_space = self.approx_bytes_per_tuple*(self.n_live_tup+self.n_dead_tup)
        if self.used_space > self.total_space:
            self.total_space = self.used_space

    def step(self):
        self.n_dead_tup += self.update_speed
        self.updateUsedSpace()

        if self.n_live_tup > 0:
            # Weigh how many tuples we read per second by how many dead tuples we have.
            #self.seq_tup_read += 15*3*self.n_live_tup*((self.n_live_tup/(self.n_live_tup+self.n_dead_tup)) ** 0.5)
            #self.seq_tup_read += 15*3*self.n_live_tup

            f1 = self.approx_bytes_per_tuple*self.n_live_tup/self.total_space
            f2 = self.approx_bytes_per_tuple*self.n_dead_tup/self.total_space
            # If we had vacuum on the previous step, reduce throughput.
            v = (50 if self.last_action == 1 else 100.0)*self.n_live_tup * math.sqrt(f1*(1.0-f2))
            self.seq_tup_read += v

        self.did_vacuum = False
        self.step_count += 1
        return self.step_count > self.max_steps

    def getTotalAndUsedSpace(self):
        return self.total_space, self.used_space

    def getTupleStats(self):
        return self.n_live_tup, self.n_dead_tup, self.seq_tup_read, self.vacuum_count, 0

    def applyAction(self, action):
        self.last_action = action
        if action == 1:
            self.vacuum_count += 1
            self.n_dead_tup = 0

            # Need to update used space before we query for stats.
            self.updateUsedSpace()
