import math

from learning.agent import BaseAgent
from simple_pid import PID

class PIDAgent(BaseAgent):
    def __init__(self):
        self.name = 'PID Agent'

        self.episode_steps = 0
        self.sum_rewards = 0

        # Control frequency in logarithmic range from a low of 5 mins to a high of 1 second.
        # Input: Percentage of live tuples (from 0 to 100)
        # Goal: keep live percentage as close to 60%.
        self.pid = PID(Kp=0.5, Ki=0.5, Kd=2.0, setpoint=60.0, output_limits=(math.log(1/(5*60.0)), math.log(1.0)), auto_mode=True, time_fn=self.get_current_episode_steps)

    def get_action(self, state):
        live_pct = 100.0*state[0]
        pid_out = self.pid(live_pct)
        current_delay = 1.0/math.exp(pid_out)
        print("Live pct: %.2f, PID output: %.1f, current_delay: %.1f"
              % (live_pct, pid_out, current_delay))

        if self.episode_steps >= self.last_vacuum_step + current_delay:
            self.last_vacuum_step = self.episode_steps
            # Time to vacuum
            return 1

        # No vacuum
        return 0

    def get_current_episode_steps(self):
        return self.episode_steps

    def agent_start(self, state):
        self.episode_steps = 0
        self.sum_rewards = 0
        self.last_vacuum_step = 0
        self.pid.reset()
        return self.get_action(state)

    def agent_step(self, reward, state):
        self.sum_rewards += reward
        self.episode_steps += 1
        return self.get_action(state)

    def agent_end(self, reward):
        self.sum_rewards += reward
        self.episode_steps += 1

    def agent_message(self, message):
        """
        Return the given agent message.
        Args:
            message: String

       """
        if message == 'get_sum_reward':
            return self.sum_rewards
        else:
            raise Exception('No given message of the agent!')