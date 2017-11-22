import logging
import sys

logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger("MAIN")

print(sys.argv)

from network import Network
from neuron import Neuron

network = Network([2, 3, 3, 2])

network.print_network()

dataset = [
    [2.7810836,2.550537003,     [1, 0]],
	[1.465489372,2.362125076,   [1, 0]],
	[3.396561688,4.400293529,   [1, 0]],
	[1.38807019,1.850220317,    [1, 0]],
	[3.06407232,3.005305973,    [1, 0]],
	[7.627531214,2.759262235,   [0, 1]],
	[5.332441248,2.088626775,   [0, 1]],
	[6.922596716,1.77106367,    [0, 1]],
	[8.675418651,-0.242068655,  [0, 1]]
	]

log.info("Starting training")

network.train(dataset, 0.5, epsilon = 0.0001)

print("Expected: [0, 1]")
print(network.predict([7.673756466,3.508563011]))
