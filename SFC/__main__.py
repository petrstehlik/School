import logging
import sys
import json
import numpy as np
from multiprocessing import Process, Manager
from multiprocessing.managers import BaseManager

np.set_printoptions(threshold='nan')

logging.basicConfig(level=logging.INFO)
log = logging.getLogger("MAIN")

from network import Network
from neuron import Neuron
import analyzer

INPUTS = 60

def normalize(job):
    for metric in analyzer.metrics:
        if metric == "job_ips":
            continue
            #for point in job[metric]['data']:
             #   point[1] = point[1]/(8000000000.0)
        if metric == "job_CPU1_Temp" or metric == "job_CPU2_Temp":
            # Skip temperatures
            continue
        else:
            for point in job[metric]['data']:
                # normalize to fraction percentage
                point[1] = point[1]/(100.0)

    return job

def prepare_data(metric, input_data):
    prep_data = []
    data = None
    for job in input_data:
        njob = normalize(job)

        data = analyzer.stretch(njob[metric]['data'], size=INPUTS)
        data = data.tolist()
        data.append([1 if njob[metric]['suspicious'] else 0])
        prep_data.append(data)

    return(prep_data)


    """
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
    """

        #stretched_data.append(metrics)

if __name__ == "__main__":
    BaseManager.register('Network', Network)
    manager = BaseManager()
    manager.start()

    network_C6 = manager.Network([INPUTS, INPUTS/20, 3, 1])
    network_C3 = manager.Network([INPUTS, INPUTS/20, 3, 1])

    network = Network([INPUTS, INPUTS/20, 3, 1])

    metric_data = dict()
    jobs = []

    log.info("Loading data")
    with open('data.json') as fp:
        data = json.load(fp)

    log.info("Normalizing dataset")
    for job in data:
        job = normalize(job)

    # Reorganize and interpolate data so that metrics from jobs are together
    for metric in analyzer.metrics:
        metric_data[metric] = []
        for job in data:
            point_data = analyzer.stretch(job[metric]['data'], size = INPUTS)
            point_data = point_data.tolist()
            point_data.append([1 if job[metric]['suspicious'] else 0])
            metric_data[metric].append(point_data)

    log.info("Starting training")

    jobs.append(Process(target=network_C6.train,
            args=(
                metric_data["job_C6res"][:-5],
                0.5
            ),
            kwargs={
                'epsilon' : 0.1,
                'epochs' : 10000
            }))

    jobs.append(Process(target=network_C3.train,
            args=(
                metric_data["job_C3res"][:-5],
                0.5
            ),
            kwargs={
                'epsilon' : 0.001,
                'epochs' : 10000
            }))

    """jobs.append(Process(target=network.train,
            args=(
                stretched_data["job_load_core"][:-5],
                0.5
            ),
            kwargs={
                'epsilon' : 0.01,
                'epochs' : 10000
            }))"""

    for job in jobs:
        job.start()

    for job in jobs:
        job.join()

    network.train(metric_data["job_C6res"], 0.5, epochs = 1500)

    print("--------------")
    for item in metric_data["job_C6res"]:
       print("Expected: {}, Got: {}".format(item[-1], network_C6.predict(item[:-1])))

    print("--------------")
    for item in metric_data["job_C6res"]:
       print("Expected: {}, Got: {}".format(item[-1], network.predict(item[:-1])))
