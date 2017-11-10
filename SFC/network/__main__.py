import logging

logging.basicConfig(level=logging.DEBUG)

from Network import Network
from neuron import Neuron

network = Network(5, [3,3], 2)
