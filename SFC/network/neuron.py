from random import seed, random
import time


class Neuron:
    def __init__(self, inputs = 0):
        """
        Initiliaze neurons weights

        Weight for each input and one for the bias
        """
        seed(int(time.time()))
        self.bias = random()
        self.input_weights = [random() for i in range(inputs)]
        self.output = 0
        self.inputs = []

    def activate(self, inputs):
        self.activation = self.bias
        for i, weight in enumerate(self.input_weights):
            self.activation += weight * inputs[i]

    def transfer(self):
        return 1.0 / (1.0 + exp(-self.activation))

