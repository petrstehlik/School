from __future__ import print_function
import logging
from random import seed
import time
import sys

from neuron import Neuron

class Network():
    layers = []

    def __init__(self, *args):
        """
        inputs: number on input neurons
        layers: list of layers with number of neuros in it
            (i.e. [3,2] means 1st layer with 3 neurons, 2nd layer with 2 neurons)
        outputs: number of outputs
        """
        seed(int(time.time()))
        self.log = logging.getLogger(__name__)
        self.layers_list = args[0]
        print(self.layers_list)
        self.__create_network()

    def __create_network(self):
        for index, neurons in enumerate(self.layers_list[1:]):
            self.log.debug("CREATE:LAYER %s:NEURONS %s" % (index, neurons))
            layer = [Neuron(self.layers_list[index]) for _ in range(neurons)]
            self.layers.append(layer)

    def print_network(self):
        """
        Print network in "graphical" form
        For debugging purposes only
        """
        for i, layer in enumerate(self.layers):
            print("------- Layer %s --------" % i)
            for neuron in layer:
                print("N (I:%s)\t" % (len(neuron._weights)), end="")
            print("")

    def forward_propagate(self, input_data):
        """
        input_data is the data which are transmitted by the first layer of neurons

        returns the output of last (output) layer
        """
        inputs = input_data
        for layer in self.layers:
            new_inputs = []
            for neuron in layer:
                neuron.activate(inputs)
                output = neuron.transfer()
                new_inputs.append(output)
            inputs = new_inputs
        return inputs

    def backward_propagate_error(self, expected):
        for i in reversed(range(len(self.layers))):
            layer = self.layers[i]
            errors = list()
            if i != len(self.layers)-1:
                for j in range(len(layer)):
                    error = 0.0
                    for n in self.layers[i + 1]:
                        error += n.calc_error(j)
                    errors.append(error)
            else:
                for j in range(len(layer)):
                    n = layer[j]
                    errors.append(expected[j] - n.output())
            for j, neuron in enumerate(layer):
                neuron.calc_delta(errors[j])

    def update_weights(self, row, lrate):
        for i, layer in enumerate(self.layers):
            inputs = row[:-1]

            if i != 0:
                # non-input layer, use outputs from previous layer
                inputs = [neuron.output() for neuron in self.layers[i-1]]
            for neuron in layer:
                # Update weights in the whole layer
                neuron.update_weights(lrate, inputs)

    def train(self, dataset, lrate, epochs = sys.maxint, epsilon = 0.0001 ):
        print("Max epochs = {}, epsilon = {}, learning rate = {}".format(epochs, epsilon, lrate))

        total_epochs = 0
        for epoch in xrange(epochs):
            total_epochs = epoch
            sum_error = 0.0

            for data in dataset:
                outputs = self.forward_propagate(data)
                expected = data[-1]

                sum_error += sum([(expected[i] - outputs[i])**2 for i in range(len(expected))])

                self.backward_propagate_error(expected)
                self.update_weights(data, lrate)

            if sum_error < epsilon:
                print("epoch={0}, lrate={1}, error={2:.5f}".format(epoch, lrate, sum_error), end='\r')
                sys.stdout.flush()
                break

            if epoch % 1 == 0:
                print("epoch = {0}, error = {1:.5f}".format(epoch, sum_error),end='\r')
                sys.stdout.flush()

        print(" "*100, end="\r")
        print("epochs = {0}, error = {1:.5f}".format(epoch, sum_error))

    def predict(self, data):
        output = self.forward_propagate(data)
        return output

