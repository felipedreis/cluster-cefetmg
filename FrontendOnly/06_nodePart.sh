#!/bin/bash
#Altera como o particionamento sera' feito durante a instalacao do Rocks nos computes.

#O particionamento nos computes e' diferente do frontend.

STATUS=/root/deploy.stat

cd /export/rocks/install/site-profiles/$ROCKS_VER/nodes
if [ $? -ne 0 ];then
	echo "Nao foi possivel entrar no diretorio /export/rocks/install/site-profiles/$ROCKS_VER/nodes" &>2;
	exit 1;
fi

touch replace-partition.xml
if [ ! -f  replace-partition.xml ];then
	echo "Nao foi possivel criar o arquivo replace-partition.xml" &>2;
	exit 1;
fi

while IFS="" read LINE;do
	if [ "$LINE" == "<pre>" ];then
		echo "<pre>
		echo \"clearpart --all --initlabel --drives=sda
		part swap --size 32768 --ondisk sda
		part / --size 1 --grow --ondisk sda\" &gt; /tmp/user_partition_info" >> replace-partition.xml
	else
		echo "$LINE" >> replace-partition.xml
	fi
done < /export/rocks/install/site-profiles/$ROCKS_VER/nodes/skeleton.xml

echo "XML de particionamento dos computes criado"
