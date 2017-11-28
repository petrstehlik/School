import logging
import sys
import json
import numpy as np
from multiprocessing import Pool
import argparse
import os
import signal

from network import Network
from neuron import Neuron
import analyzer

logging.basicConfig(level=logging.INFO)
log = logging.getLogger("MAIN")
metric_data = dict()
networks = list()
args = dict()

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

def runner(x):
    global metrics
    global args

    try:
        networks[x].train(metric_data[metrics[x]], 0.5, epochs = args.epochs, epsilon = 0.1)
    except Exception as e:
        log.error("Exception: {}, dumping config for {}".format(str(e), metrics[x]))
    finally:
        with open(os.path.join(args.config_dir, metrics[x] + '_network.json'), 'w+') as fp:
            json.dump(networks[x].export(), fp)

def argparser():
    global args
    parser = argparse.ArgumentParser()
    parser.add_argument('--train',
            action="store_true",
            help='Train the network using data.json dataset')
    parser.add_argument('--eval',
            dest='config_dir',
            default='configs',
            help='Evaluate learned network with data.json dataset')
    parser.add_argument('--max-epochs',
            dest="epochs",
            type=int,
            help="Maximum number of epochs (default: 10 000)",
            default=10000)

    args = parser.parse_args()

def initializer():
    """Ignore CTRL+C in the worker process."""
    signal.signal(signal.SIGINT, signal.SIG_IGN)

if __name__ == "__main__":
    argparser()
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

    if args.train:
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
            Network([INPUTS, INPUTS/20, 3, 1], "back_end_bound"),
            Network([14, 7, 3, 1], "jobber")
            ]

        log.info("Starting training")

        try:
            p = Pool(processes = 12, initializer=initializer)

            p.map(runner, range(12))
            p.close()
        except KeyboardInterrupt:
            p.terminate()
        finally:
            p.join()

    else:
        # networks = [None] * (len(metrics) + 1)
        network = None

        for x, metric in enumerate(metrics):
            with open(os.path.join(args.config_dir, metric + '_network.json'),) as fp:
                network = Network.load(json.load(fp))

            print("-- {}".format(metric))
            for item in metric_data[metric][-5:]:
                print("Expected: {0}, Got: {1:.2f}"
                        .format(item[-1], (network.predict(item[:-1])[0])))
