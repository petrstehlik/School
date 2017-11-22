from random import random
from math import exp
import logging

class Neuron:
    _delta = 0.0
    _inputs = list()
    _output = 0.0
    _weights = list()
    _activation = 0.0

    def __init__(self, inputs):
        """
        Initiliaze neurons weights

        Weight for each input and one for the bias
        """
        self.log = logging.getLogger(__name__)

        # Add bias as the last weight
        self._weights = [random() for i in range(inputs+1)]

        self.log.debug("CREATE: Weights {0}".format(self._weights))

    def activate(self, inputs):
        """
        Calculate activation of the neuron where last weight is the bias
        """
        self._activation = self._weights[-1]
        for i, weight in enumerate(self._weights[:-1]):
            self._activation += weight * inputs[i]

    def transfer(self):
        """
        Sigmoid transfer function

        output = 1.0 / (1.0 + e^(-activation))
        """
        self._output = 1.0 / (1.0 + exp(-self._activation))
        return self._output

    def transfer_derivative(self):
        return self._output * (1.0 - self._output)

    def calc_error(self, index):
        return self._weights[index] * self._delta

    def calc_delta(self, error):
        self._delta = error * self.transfer_derivative()

    def update_weights(self, lrate, inputs):
        for j in range(len(inputs)):
            self._weights[j] += lrate * self._delta * inputs[j]

        self._weights[-1] += lrate * self._delta
    #
    # Getters
    #
    def output(self):
        return self._output

    def derivative(self):
        return self._derivative

    def delta(self):
        return self._delta

    def __repr__(self):
        return("<neuron.Neuron weights: {}, bias: {}, output: {}".format(self._weights[:-1], self._weights[-1], self._output))