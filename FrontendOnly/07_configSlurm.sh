#!/bin/bash

#http://slurm.schedmd.com/high_throughput.html

#munge tuning
sed -i 's/# DAEMON_ARGS.*/DAEMON_ARGS="--key-file /etc/munge/munge.key --num-threads 10/g' /etc/sysconfig/munge

echo "y" | sacctmgr add account cluster Description="Cluster default account" Organization=cluster
echo "y" | sacctmgr modify account cluster set MaxSubmitJobs=100