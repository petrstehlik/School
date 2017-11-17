import logging

from neuron import Neuron

class Network():
    layers = []

    def __init__(self, inputs, layers):
        """
        inputs: number on input neurons
        layers: list of layers with number of neuros in it
            (i.e. [3,2] means 1st layer with 3 neurons, 2nd layer with 2 neurons)
        outputs: number of outputs
        """
        self.log = logging.getLogger(__name__)
        self.inputs = inputs
        self.layers_num = layers

        self.__create_network()

    def __create_network(self):
        index = 0

        # self.layers.append([Neuron() for i in range(self.inputs)])

        for i in self.layers_num:
            layer = []

            self.log.debug("CREATE:LAYER %s:NEURONS %s" % (index, i))

            for j in range(i):
                layer.append(Neuron(inputs = i))

            self.layers.append(layer)
            index += 1

        #self.layers.append([Neuron() for i in range(self.outputs)])

        #for i in self.layers:
        #    print(i)

    def forward_propagate(self, input_data):
        """
        input_data is the data which are transmitted by the first layer of neurons
        """
        for layer in self.layers:
            print(layer)
            new_inputs = []
            for n in layer:
                n.activate(input_data)
                n.output = n.transfer()
                new_inputs.append(n.output)

            input_data = new_inputs
        return input_data

    def backward_propagate_error(self, expected):
        for i in reversed(range(len(self.layers[:0]))):
            layer = self.layers[i]
            errors = list()
            if i != len(self.layers)-1:
                for j in range(len(layer)):
                    error = 0.0
                    print(j)
                    print(self.layers[i+1])
                    for n in self.layers[i + 1]:
                        print(n.input_weights)
                        error += (n.input_weights[j] * n.delta)
                    errors.append(error)
            else:
                for j in range(len(layer)):
                    n = layer[j]
                    errors.append(expected[j] - n.output)
            for j in range(len(layer)):
                n = layer[j]
                n.delta = errors[j] * n.transfer_derivative()


#        errors = []
#        for i, n in enumerate(self.layers[-1]):
#            """
#            Calcute the difference between expected output and the actual output for each output
#            neuron
#            """
#            n.error = expected[i] - n.output
#            errors.append(n.error)
#
#        for i, layer in reversed(enumerate(self.layers[:-1])):
#            """
#            Iterate through the rest of the network backwards
#
#            First compute the error of each neuron and then its delta
#
#            i holds the current layer index
#            layer is the layer itself
#            """
#            for n in layer:
#                error = 0.0
#
#                for prev_n in self.layers[i + 1]:
#                    error += n.

