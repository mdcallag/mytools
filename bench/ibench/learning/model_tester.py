import sys
import torch
import numpy
from geneticalgorithm import geneticalgorithm as ga

from learning.rl import RLModel, default_network_arch, action_probabilities

import torch.nn.functional as F

def maximize(x):
    x = list(map(float, [*x]))
    #print(x)
    state = torch.tensor([x])

    probs1 = action_probabilities(model1, state, 0.01)
    sum1 = probs1[0]+probs1[1]
    v1 = 0.0 if sum1 == 0 else probs1[0]/sum1

    probs2 = action_probabilities(model2, state, 0.01)
    sum2 = probs2[0]+probs2[1]
    v2 = 0.0 if sum2 == 0 else probs2[0]/sum2

    return abs(v1-v2)

def test_hidden_layer(model, id, val, size, apply_rect_linear):
    print("Input: %d/%d" % (id, size))

    input = [0.0 for i in range(size)]
    input[id] = val

    x = model.fc1(torch.tensor(input))
    if apply_rect_linear:
        x = F.relu(x)

    hidden = []
    for index, e in enumerate(x.tolist()):
        if abs(e) > 0.01:
            hidden.append((index, e))
    hidden = sorted(hidden, reverse=True, key = lambda sub: abs(sub[1]))

    print("Hidden layer activation: ", [(i, round(e, 1)) for i, e in hidden])

def test_hidden_layer_reversed(model, id, val, size):
    print("Input: %d/%d" % (id, size))

    input = [0.0 for i in range(size)]
    input[id] = val

    w = model.fc1.weight
    #print(w.size(), file=sys.stderr)
    w = torch.transpose(w, 0, 1)
    #print(w.size(), file=sys.stderr)
    x = F.linear(torch.tensor(input), w)

    input_activation = []
    for index, e in enumerate(x.tolist()):
        if abs(e) > 0.01:
            input_activation.append((index, e))
    input_activation = sorted(input_activation, reverse=True, key = lambda sub: abs(sub[1]))

    print("Input layer activation: ", [(i, round(e, 1)) for i, e in input_activation])

def test_output(model, id, val, size):
    print("Hidden: %d/%d" % (id, size))

    input = [0.0 for i in range(size)]
    input[id] = val

    output = model.fc2(torch.tensor(input)).tolist()
    print("Output layer activation: ", [round(e, 1) for e in output])
    if output[0] < output[1]:
        print("Vacuum preferred")

def test_given_input(model, input):
    #print("\n\nSpecific input: ", input)

    hidden_no_relu = model.fc1(torch.tensor(input))

    hidden_no_relu_display = []
    for index, e in enumerate(hidden_no_relu.tolist()):
        if abs(e) > 0.01:
            hidden_no_relu_display.append((index, e))
    hidden_no_relu_display = sorted(hidden_no_relu_display, reverse=True, key = lambda sub: abs(sub[1]))
    #print("Hidden no relu: ", [(i, round(e, 1)) for i, e in hidden_no_relu_display])


    hidden_relu = F.relu(hidden_no_relu)

    hidden_relu_display = []
    for index, e in enumerate(hidden_relu.tolist()):
        if abs(e) > 0.01:
            hidden_relu_display.append((index, e))
    hidden_relu_display = sorted(hidden_relu_display, reverse=True, key = lambda sub: abs(sub[1]))
    #print("Hidden with relu: ", [(i, round(e, 1)) for i, e in hidden_relu_display])

    output = model.fc2(hidden_relu)
    output = output.tolist()
    #print("Output: ", [round(e, 1) for e in output])
    #print("Selected action: ", "idling" if output[0] >= output[1] else "vacuum")
    return output

def test_given_inputs(model, history_size):
    for p in [0.0, 0.5, 1.0]:
        print("Vac %.2f ------> Dead pct" % p)
        for v1 in range(11):
            line = "L%3.1f " % (v1/10)
            for v2 in range(11-v1):
                input = [*([v1/10] * history_size), *([v2/10] * history_size), *([p] * history_size)]
                r = test_given_input(model, input)
                line += "%6.0f%s%6.0f " % (r[0], "i" if r[0] >= r[1] else "V", r[1])
            print(line)

def test(model):
    for v in [1.0, -1.0, 0]:
        for v1 in [True, False]:
            print("\n\nTesting %d inputs %s........" % (v, "with rect linear" if v1 else "without rect linear"))
            for i in range(20):
                print("=========================================================")
                test_hidden_layer(model, i, v, 20, v1)

    for v in [1.0, -1.0]:
        print("\n\nTesting %d hidden layer to input..." % v)
        for i in range(256):
            print("=========================================================")
            test_hidden_layer_reversed(model, i, v, 256)

    for v in [1.0, -1.0, 0]:
        print("\n\nTesting %d hidden layer....." % v)
        for i in range(256):
            print("=========================================================")
            test_output(model, i, v, 256)

    test_given_inputs(model1, 4)

if __name__ == '__main__':
    global model1_state
    model1_state = torch.load(sys.argv[1])

    global model2_state
    model2_state = torch.load(sys.argv[2])

    global model1
    model1 = RLModel(default_network_arch)
    model1.load_state_dict(model1_state['model_state_dict'])

    global model2
    model2 = RLModel(default_network_arch)
    model2.load_state_dict(model2_state['model_state_dict'])

    global rng
    rng = numpy.random.RandomState(0)

    test(model1)

    #varbound = numpy.array([[0.0, 100.0]]*20)
    #ga_model = ga(function = maximize, dimension = 20, variable_type='real', variable_boundaries = varbound)
    #ga_model.run()

    #convergence = ga_model.report
    #solution = ga_model.ouput_dict
    #print("Convergence: ", convergence)
    #print("Solution: ", solution)