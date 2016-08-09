#!/bin/bash

#pega os hosts
for host in $(rocks list host | grep compute-* | cut -d":" -f1);do
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
		if [[ $host == $(hostname | cut -d"." -f1) ]];then
			echo "Configuring bond iface on $host with interfaces $ifaces"
			rocks add host bonded $host channel=bond0 interfaces=$ifaces ip=$ip network=private
			echo "Updating host configuration"
			rocks sync host network $host
			echo "Adding parameters"
			rocks set host interface options $host bond0 options="miimon=100 mode=balance-tlb"
			echo "Updating host configuration"
			rocks sync host network $host
			echo "Syncing config"
			rocks sync config
		else
			echo "Configuring bond iface on $host with interfaces $ifaces"
			rocks add host bonded $host channel=bond0 interfaces=$ifaces ip=$ip network=private
			echo "Syncing config"
			rocks sync config
			echo "Updating host configuration"
			rocks sync host network $host
			echo "Adding parameters"
			rocks set host interface options $host bond0 options="miimon=100 mode=balance-tlb"
			echo "Updating host configuration"
			rocks sync host network $host
		fi
	fi
done