import logging
import sys
import json
import numpy as np
from multiprocessing import Process, Manager, Pool
from multiprocessing.managers import BaseManager
import pickle
from network import Network
from neuron import Neuron
import analyzer

logging.basicConfig(level=logging.INFO)
log = logging.getLogger("MAIN")
metric_data = dict()
networks = list()

class NetworkList:
    C6              = 0
    C3              = 1
    load_core       = 2
    ips             = 3
    sys_util        = 4
    io_util         = 5
    mem_util        = 6
    cpu_util        = 7
    l1l2_bound      = 8
    l3_bound        = 9
    front_end_bound = 10
    back_end_bound  = 11

metrics = [
    "job_C6res",
    "job_C3res",
    "job_load_core",
    "job_ips",
    "job_Sys_Utilization",
    "job_IO_Utilization",
    "job_Mem_Utilization",
    "job_CPU_Utilization",
    "job_L1L2_Bound",
    "job_L3_Bound",
    "job_front_end_bound",
    "job_back_end_bound"
        ]


INPUTS = 80

def normalize(job):
    for metric in analyzer.metrics:
        if metric == "job_ips":
            for point in job[metric]['data']:
               point[1] = point[1]/(8000000000.0)
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

def runner(x):
    global metrics

    networks[x].train(metric_data[metrics[x]], 0.5, epochs = 10000, epsilon = 0.1)
    with open('configs/' + metrics[x] + '_network.json', 'w+') as fp:
        json.dump(networks[x].export(), fp)

if __name__ == "__main__":
    BaseManager.register('Network', Network)
    manager = BaseManager()
    manager.start()

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

    #if len(sys.argv) > 1:
    #    with open(sys.argv[1], "r") as fp:
    #        networks_config = json.load(fp)
    #        networks = [Network.load(cfg) for cfg in networks_config]

    if len(sys.argv) == 2 and sys.argv[1] == "learn":
        networks = [
            Network([INPUTS, INPUTS/20, 3, 1], "C6res"),
            Network([INPUTS, INPUTS/20, 3, 1], "C3res"),
            Network([INPUTS, INPUTS/20, 3, 1], "load_core"),
            Network([INPUTS, INPUTS/20, 3, 1], "ips"),
            Network([INPUTS, INPUTS/20, 3, 1], "Sys_Utilization"),
            Network([INPUTS, INPUTS/20, 3, 1], "IO_Utilization"),
            Network([INPUTS, INPUTS/20, 3, 1], "Mem_Utilization"),
            Network([INPUTS, INPUTS/20, 3, 1], "CPU_Utilization"),
            Network([INPUTS, INPUTS/20, 3, 1], "L1L2_Bound"),
            Network([INPUTS, INPUTS/20, 3, 1], "L3_Bound"),
            Network([INPUTS, INPUTS/20, 3, 1], "front_end_bound"),
            Network([INPUTS, INPUTS/20, 3, 1], "back_end_bound")
            ]

        log.info("Starting training")

        p = Pool(processes = 12)

        p.map(runner, range(12))
        p.close()
        p.join()

    elif len(sys.argv) == 2 and sys.argv[1] == "eval":
        networks = [None] * (len(metrics) + 1)

        for x, metric in enumerate(metrics):
            print('configs/' + metric + '_network.json')
            with open('configs/' + metric + '_network.json') as fp:
                networks[x] = Network.load(json.load(fp))

        print("-------------- C6res")
        for item in metric_data["job_C6res"][-5:]:
            print("Expected: {0}, Got: {1:.2f}".format(item[-1], (networks[NetworkList.C6].predict(item[:-1])[0])))

        print("-------------- IPS")
        for item in metric_data["job_ips"][-5:]:
            print("Expected: {0}, Got: {1:.2f}".format(item[-1], (networks[NetworkList.ips].predict(item[:-1])[0])))

        print("-------------- BE Bound")
        for item in metric_data["job_back_end_bound"][-10:]:
            print("Expected: {0}, Got: {1:.2f}".format(item[-1], (networks[NetworkList.back_end_bound].predict(item[:-1])[0])))
