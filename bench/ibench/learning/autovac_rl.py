import time
import numpy

from learning.environment import BaseEnvironment
from learning.autovac_state import AutoVacState

class AutoVacEnv(BaseEnvironment):
    def env_init(self, env_info={}):
        """
        Setup for the environment called when the experiment first starts.
        """

        self.env_info = env_info
        self.stat_and_vac = env_info['stat_and_vac']

        self.state = AutoVacState(env_info['state_history_length'])

    def update_stats(self, action):
        total_space, used_space = self.stat_and_vac.getTotalAndUsedSpace()

        stats = self.stat_and_vac.getTupleStats()
        n_live_tup = stats[0]
        n_dead_tup = stats[1]
        seq_tup_read = stats[2]
        print("Live tup: %d, Dead dup: %d, Seq reads: %d, Vacuum count: %d"
              % (n_live_tup, n_dead_tup, seq_tup_read, self.delay_adjustment_count))

        live_raw_pct = 1.0 if n_live_tup+n_dead_tup == 0 else n_live_tup/(n_live_tup+n_dead_tup)

        used_pct = 1.0 if total_space == 0 else used_space/total_space
        live_pct = live_raw_pct*used_pct
        dead_pct = (1.0-live_raw_pct)*used_pct

        print("Total: %d, Used: %d, Live pct: %.2f, Dead pct: %.2f"
              % (total_space, used_space, 100.0*live_pct, 100.0*dead_pct))

        delta = max(0, seq_tup_read - self.state.num_read_tuples_buffer[0])
        delta_pct = 0.0 if n_live_tup == 0 else delta / n_live_tup

        self.state.update(n_live_tup, n_dead_tup, seq_tup_read, live_pct, dead_pct, delta_pct, delta, action)

    def update_reward_component(self, name, v):
        self.reward_components[name] += v
        return v

    def generate_reward(self, action, is_terminal):
        last_live_tup = self.state.num_live_tuples_buffer[0]
        live_pct = self.state.live_pct_buffer[0]
        dead_pct = self.state.dead_pct_buffer[0]
        last_read = self.state.num_read_delta_buffer[0]
        print("Last live tup: %d, Last live %%: %.2f, Last dead %%: %.2f, Last_read: %d"
              % (last_live_tup, 100.0*live_pct, 100.0*dead_pct, last_read))

        pct_penalty = lambda x: x/(1.01-x)
        bloat_pct_penalty = pct_penalty(1.0-live_pct)
        dead_pct_penalty = pct_penalty(dead_pct)

        # -1 unit of reward equivalent to scanning the entire table (live + dead tuples).
        # The reward is intended to be scale free.
        reward = 0
        if last_read > 0 and last_live_tup > 0:
            perc90 = numpy.percentile(numpy.array(self.state.num_read_delta_buffer), 90)

            # Reward having high throughput based on 90th percentile observed so far.
            reward = self.update_reward_component("throughput", 1.0 if perc90 < 0.0001 else last_read/perc90)
            print("90th percentile: %d, throughput reward: %.2f" % (perc90, reward))

            # Penalize table bloat, the worse the bloat the more we penalize.
            reward += self.update_reward_component("bloat", -0.1*bloat_pct_penalty)

            # Penalize for dead tuples.
            reward += self.update_reward_component("dead", -0.05*dead_pct_penalty)

        if action == 1:
            # Assume vacuuming is proportionally more expensive than scanning the table once.
            reward += self.update_reward_component("vacuum", -2.5-5.0*dead_pct)

        if is_terminal:
            # Final penalties. Those scale with the duration of the experiment.
            reward += self.update_reward_component("bloat", -0.01*self.step_count*bloat_pct_penalty)
            reward += self.update_reward_component("dead", -0.005*self.step_count*dead_pct_penalty)

        print("Returning reward: %.2f" % reward)
        return reward

    def env_start(self):
        """
        The first method called when the experiment starts, called before the
        agent starts.

        Returns:
            The first state observation from the environment.
        """

        print("Starting agent...")

        # For debugging
        self.reward_components = {"throughput": 0, "vacuum": 0, "bloat": 0, "dead": 0}

        self.state.init_state()
        self.stat_and_vac.startExp(self.env_info)
        self.env_info['experiment_id'] += 1

        self.delay_adjustment_count = 0
        self.step_count = 0
        self.initial_time = time.time()

        self.update_stats(0)
        initial_state = self.state.generate_state()

        reward = self.generate_reward(0, False)
        self.reward_obs_term = (reward, initial_state, False)
        return self.reward_obs_term[1]

    def env_step(self, action):
        """A step taken by the environment.

        Args:
            action: The action taken by the agent

        Returns:
            (float, state, Boolean): a tuple of the reward, state observation,
                and boolean indicating if it's terminal.
        """

        # effect system based on action
        if action == 0:
            # Not vacuuming
            print("Action 0: Idling.")
        elif action == 1:
            # Vacuuming
            print("Action 1: Vacuuming...")
            self.delay_adjustment_count += 1
        else:
            assert("Invalid action")

        # Apply vacuum before collecting new state
        self.stat_and_vac.applyAction(action)

        self.step_count += 1
        self.update_stats(action)
        current_state = self.state.generate_state()

        is_terminal = self.stat_and_vac.step()
        # Compute reward after applying the action.
        reward = self.generate_reward(action, is_terminal)

        if is_terminal:
            print("Terminating.")
            stats = self.stat_and_vac.getTupleStats()
            print("Time elapsed: %.2f, step count: %d, delay adjustments: %d, internal vac: %d, internal autovac: %d"
                  % ((time.time()-self.initial_time), self.step_count, self.delay_adjustment_count, stats[3], stats[4]))
            print("Reward components:", self.reward_components)
            self.stat_and_vac.endExp()

        self.reward_obs_term = (reward, current_state, is_terminal)
        return self.reward_obs_term
