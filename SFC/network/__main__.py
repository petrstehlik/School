import logging

logging.basicConfig(level=logging.DEBUG)

from network import Network
from neuron import Neuron

network = Network(5, [3, 3, 2])

res = network.forward_propagate([
        0.25,
        0.125,
        0.265,
        0.75,
        0.95
    ])

print(res)
network.backward_propagate_error([0, 1])
