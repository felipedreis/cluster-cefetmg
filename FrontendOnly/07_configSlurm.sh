#!/bin/bash

#http://slurm.schedmd.com/high_throughput.html

#munge tuning
sed -i 's/# DAEMON_ARGS.*/DAEMON_ARGS="--key-file /etc/munge/munge.key --num-threads 10/g' /etc/sysconfig/munge

echo "y" | sacctmgr add account cluster Description="Cluster default account" Organization=cluster
echo "y" | sacctmgr modify account cluster set MaxSubmitJobs=100 

cp -f $BASE_DIR/Conf/slurm.conf.test /etc/slurm/slurm.conf

qoss=`echo "part"{{30,10,2,1}d,{12,6}h}`

for qos in qoss; do
	sacctmgr add qos $qos
done

sacctmgr modify qos part30d set MaxSubmitJobs=1   MaxWall=31-0:0 Priority=1000
sacctmgr modify qos part10d set MaxSubmitJobs=3   MaxWall=10-0:0 Priority=1000
sacctmgr modify qos part2d  set MaxSubmitJobs=15  MaxWall=2-0:0  Priority=1000
sacctmgr modify qos part1d  set MaxSubmitJobs=30  MaxWall=1-0:0  Priority=1000
sacctmgr modify qos part12h set MaxSubmitJobs=50  MaxWall=12:00  Priority=1000
sacctmgr modify qos part6h  set MaxSubmitJobs=100 MaxWall=6:00   Priority=1000

sacctmgr modify Account set QosLevel+=part30d where Account=cluster
sacctmgr modify Account set DefaultQos=part30d where Account=cluster