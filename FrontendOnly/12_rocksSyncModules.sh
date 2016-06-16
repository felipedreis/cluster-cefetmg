#!/bin/bash

mkdir -p /opt/rocks/lib/python2.6/site-packages/rocks/commands/sync/modules
cd /opt/rocks/lib/python2.6/site-packages/rocks/commands/sync/modules

cat << EOF > __init__.py
# Juan Lopes Ferreira
# Script para sincronização de módulos de ambiente

import os
import rocks.commands
from rocks.commands.sync.host import Parallel
from rocks.commands.sync.host import timeout

class Command(rocks.commands.sync.command):
	def run(self, params, args):
		cmd="rocks list host | grep -v Frontend | grep -v ^HOST | cut -d':' -f1"
		files='/etc/modulefiles/*'
		path='/etc/modulefiles'	
		threads=[]

		hosts=os.popen(cmd).readlines()

		for host in hosts:
			cmd='scp -q %s root@%s:%s' % (files,host.rstrip(),path)
			p=Parallel(cmd, host.rstrip())
			p.start()
			threads.append(p)

		for thread in threads:
			thread.join(timeout)

RollName="base"
EOF