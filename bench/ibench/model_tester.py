import sys
import torch
import numpy
from geneticalgorithm import geneticalgorithm as ga

from learning.rl import RLModel, default_network_arch, action_probabilities

rng = None
model_state = None
model = None

def minimize(x):
    x = list(map(float, [*x]))
    #print(x)

    state = torch.tensor([x])
    probs = action_probabilities(model, state, 0.01)
    return probs[0] if probs[1] < 0.000001 else probs[0]/probs[1]

if __name__ == '__main__':
    model_state = torch.load(sys.argv[1])
    model = RLModel(default_network_arch)
    model.load_state_dict(model_state.state_dict())

    rng = numpy.random.RandomState(0)
    varbound = numpy.array([[0.0, 100.0]]*20)
    model1 = ga(function = minimize, dimension = 20, variable_type='real', variable_boundaries = varbound)
    model1.run()

    convergence = model1.report
    solution = model1.ouput_dict
    print("Convergence: ", convergence)
    print("Solution: ", solution)