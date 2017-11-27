import logging
import sys
import json
import numpy as np

np.set_printoptions(threshold='nan')

logging.basicConfig(level=logging.INFO)
log = logging.getLogger("MAIN")

print(sys.argv)

from network import Network
from neuron import Neuron
import analyzer

network = Network([60, 20, 14, 1])

#network.print_network()

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

log.info("Loading data")

with open('data.json') as fp:
    data = json.load(fp)

analyzer.stats(data)
stretched_data = []

for job in data:
    for metric in analyzer.metrics:

        if metric == "job_ips":
            for point in job[metric]['data']:
                point[1] = point[1]/(8000000000.0)
        elif metric == "job_CPU1_Temp" or metric == "job_CPU2_Temp":
            # Skip temperatures
            continue
        else:
            for point in job[metric]['data']:
                # normalize to fraction percentage
                point[1] = point[1]/(100.0)

        data = analyzer.stretch(job[metric]['data'], size=60)
        data = data.tolist()
        data.append([1 if job[metric]['suspicious'] else 0])
        stretched_data.append(data)
    #stretched_data.append(metrics)

log.info("Starting training")
#print(stretched_data[0])
#print(len(stretched_data[:-220]))

#print(stretched_data)

network.train(stretched_data[:-220], 0.5, epsilon = 0.1, epochs = 10000)

print("Expected: {}".format(stretched_data[-1][-1]))
print(network.predict(stretched_data[-1][:-1]))
