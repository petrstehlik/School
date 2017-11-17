from random import random
import time
from math import exp
import logging

class Neuron:
    def __init__(self, inputs = 0):
        """
        Initiliaze neurons weights

        Weight for each input and one for the bias
        """
        self.log = logging.getLogger(__name__)

        self.bias = random()
        self.input_weights = [random() for i in range(inputs)]
        self.output = 0.0
        self.delta = 0.0
        self.inputs = []

        self.log.debug("CREATE: Weights {0}:Bias {1:.2f}".format(self.input_weights, self.bias))

    def activate(self, inputs):
        self.activation = self.bias
        for i, weight in enumerate(self.input_weights):
            self.activation += weight * inputs[i]

    def transfer(self):
        """
        The sigmoid transfer function
        """
        self.output = 1.0 / (1.0 + exp(-self.activation))
        return(self.output)

    def transfer_derivative(self):
        return(self.output * (1.0 - self.output))

    def __repr__(self):
        return("<neuron.Neuron weights: {}, bias: {}, output: {}".format(self.input_weights, self.bias, self.output))
