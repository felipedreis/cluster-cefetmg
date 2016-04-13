#!/bin/bash

#http://slurm.schedmd.com/high_throughput.html

#net parameters tuning
sysctl -w net.ipv4.tcp_max_syn_backlog=4096
sysctl -w net.core.somaxconn=2048

#munge tuning
sed -i 's/# DAEMON_ARGS.*/DAEMON_ARGS="--key-file /etc/munge/munge.key --num-threads 10/g' /etc/sysconfig/munge

