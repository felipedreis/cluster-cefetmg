#!/bin/bash

#http://slurm.schedmd.com/high_throughput.html

#munge tuning
sed -i 's/# DAEMON_ARGS.*/DAEMON_ARGS="--key-file /etc/munge/munge.key --num-threads 10/g' /etc/sysconfig/munge

cp -f $BASE_DIR/Conf/slurm.conf.test /etc/slurm/slurm.conf

echo "y" | sacctmgr add account cefetmg Description="Cluster default account" Organization=cefetmg

echo "y" | sacctmgr add account "ppgmmc" Description="User group" parent="cefetmg"
echo "y" | sacctmgr add account "posss" Description="User group" parent="cefetmg"
echo "y" | sacctmgr add account "pesq" Description="User group" parent="cefetmg"
echo "y" | sacctmgr add account "ict" Description="User group" parent="cefetmg"
echo "y" | sacctmgr add account "didatico" Description="User group" parent="cefetmg"

echo "y" | sacctmgr modify account cefetmg set MaxSubmitJobs=100 

qoss=`echo "part"{{30,10,2,1}d,{12,6}h}`

for qos in $qoss; do
	echo "y" |  sacctmgr add qos $qos
done

echo "y" | sacctmgr modify qos part30d set MaxSubmitJobs=5   MaxWall=31-0:0 Priority=1000
echo "y" | sacctmgr modify qos part10d set MaxSubmitJobs=3   MaxWall=10-0:0 Priority=1000
echo "y" | sacctmgr modify qos part2d  set MaxSubmitJobs=15  MaxWall=2-0:0  Priority=1000
echo "y" | sacctmgr modify qos part1d  set MaxSubmitJobs=30  MaxWall=1-0:0  Priority=1000
echo "y" | sacctmgr modify qos part12h set MaxSubmitJobs=50  MaxWall=12:00:00  Priority=1000
echo "y" | sacctmgr modify qos part6h  set MaxSubmitJobs=100 MaxWall=6:00:00   Priority=1000

echo "y" | sacctmgr modify Account set Fairshare=500 QosLevel=part30d,part10d,part2d,part1d,part12h,part6h DefaultQos=part6h where Account=ppgmmc
echo "y" | sacctmgr modify Account set Fairshare=400 QosLevel=part30d,part10d,part2d,part1d,part12h,part6h DefaultQos=part6h where Account=posss
echo "y" | sacctmgr modify Account set Fairshare=300 QosLevel=part30d,part10d,part2d,part1d,part12h,part6h DefaultQos=part6h where Account=pesq
echo "y" | sacctmgr modify Account set Fairshare=200  QosLevel=part10d,part2d,part1d,part12h,part6h DefaultQos=part6h where Account=ict
echo "y" | sacctmgr modify Account set Fairshare=100 QosLevel=part6h DefaultQos=part6h where Account=didatico