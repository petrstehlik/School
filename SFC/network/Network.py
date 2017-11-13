import logging

from neuron import Neuron

class Network():
    layers = []

    def __init__(self, inputs, layers, outputs):
        """
        inputs: number on input neurons
        layers: list of layers with number of neuros in it
            (i.e. [3,2] means 1st layer with 3 neurons, 2nd layer with 2 neurons)
        outputs: number of outputs
        """
        self.log = logging.getLogger(__name__)
        self.inputs = inputs
        self.layers_num = layers
        self.outputs = outputs

        self.__create_network()

    def __create_network(self):
        index = 0

        # self.layers.append([Neuron() for i in range(self.inputs)])

        for i in self.layers_num:
            layer = []

            for j in range(i):
                self.log.debug("Create neuron %s in layer %s" % (j, index))
                layer.append(Neuron(inputs = i))

            self.log.debug(layer)
            self.layers.append(layer)
            index += 1

        self.layers.append([Neuron() for i in range(self.outputs)])

        for i in self.layers:
            print(i)

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

