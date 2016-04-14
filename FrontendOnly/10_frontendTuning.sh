#!/bin/bash

#http://slurm.schedmd.com/high_throughput.html

#net parameters tuning
sysctl -w net.ipv4.tcp_max_syn_backlog=4096
sysctl -w net.core.somaxconn=2048

systcl -w kernel.sched_min_granularity_ns=10000000
systcl -w kernel.sched_wakeup_granularity_ns=15000000
