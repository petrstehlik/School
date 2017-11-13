from random import random
import time
from math import exp

class Neuron:
    def __init__(self, inputs = 0):
        """
        Initiliaze neurons weights

        Weight for each input and one for the bias
        """
        self.bias = random()
        self.input_weights = [random() for i in range(inputs)]
        self.output = 0
        self.inputs = []

    def activate(self, inputs):
        self.activation = self.bias
        for i, weight in enumerate(self.input_weights):
            self.activation += weight * inputs[i]

    def transfer(self):
        """
        The sigmoid transfer function
        """
        return 1.0 / (1.0 + exp(-self.activation))

    def transfer_derivative(self):
        return(self.output * (1.0 - self.output))

    def __repr__(self):
        return("<neuron.Neuron weights: {}, bias: {}, output: {}".format(self.input_weights, self.bias, self.output))
