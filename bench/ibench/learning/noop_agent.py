
from learning.agent import BaseAgent

class NoOpAgent(BaseAgent):
    def __init__(self):
        self.name = 'NoOp Agent'
        self.episode_steps = 0
        self.sum_rewards = 0
        self.default_action = 0

    def agent_init(self, agent_config):
        self.default_action = agent_config['default_action']

    def agent_start(self, state):
        self.episode_steps = 0
        self.sum_rewards = 0
        return self.default_action

    def agent_step(self, reward, state):
        self.sum_rewards += reward
        self.episode_steps += 1
        return self.default_action

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
