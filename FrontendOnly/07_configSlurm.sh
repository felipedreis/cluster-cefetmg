#!/bin/bash

#http://slurm.schedmd.com/high_throughput.html

#munge tuning
sed -i 's/# DAEMON_ARGS.*/DAEMON_ARGS="--key-file /etc/munge/munge.key --num-threads 10/g' /etc/sysconfig/munge

echo "y" | sacctmgr add account cluster Description="Cluster default account" Organization=cluster
echo "y" | sacctmgr modify account cluster set MaxSubmitJobs=100 

cp -f $BASE_DIR/Conf/slurm.conf.test /etc/slurm/slurm.conf

sacctmgr add qos part30d
sacctmgr modify qos part30d set MaxSubmitJobs=1 MaxWall=31-0:0 Priority=1000
sacctmgr modify Account set QosLevel+=part30d where Account=cluster
sacctmgr modify Account set DefaultQos=part30d where Account=cluster