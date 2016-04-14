#!/bin/bash

#http://slurm.schedmd.com/high_throughput.html

#munge tuning
sed -i 's/# DAEMON_ARGS.*/DAEMON_ARGS="--key-file /etc/munge/munge.key --num-threads 10/g' /etc/sysconfig/munge

/etc/slurm/slurm.conf
