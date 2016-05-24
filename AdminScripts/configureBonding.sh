#!/bin/bash

#pega os hosts
for host in $(rocks list host | grep -v ^HOST | cut -d":" -f1);do
	#testa se o retorno do comando é nulo
	if [[ -z $(rocks list host interface $host | grep bond0) ]];then
		ifaces=""

		for line in $(rocks list host interface $host | grep -v ^SUBNET | tr -s ' ' '_');do
			if [[ "$line" =~ ^private* ]];then
				ip=$(echo $line | cut -d"_" -f4)
				iface=$(echo $line | cut -d"_" -f2)
				ifaces="$iface,$ifaces"
			#caso contrário, adiciona a lista de bonding
			elif [[ "$line" =~ ^-* ]];then
				iface=$(echo $line | cut -d"_" -f2)
				ifaces="$iface,$ifaces"
			fi
		done

		ifaces=${ifaces:0:${#ifaces}-1}
		echo "Configuring bond iface on $host with interfaces $ifaces"
		rocks add host bonded $host channel=bond0 interfaces=$ifaces ip=$ip network=private
		echo "Syncing config"
		rocks sync config
		echo "Updating host configuration"
		rocks sync host network $host
	fi
done