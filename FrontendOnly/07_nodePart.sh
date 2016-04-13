#!/bin/bash
#Altera como o particionamento sera' feito durante a instalacao do Rocks nos computes.

#O particionamento nos computes e' diferente do frontend.

STATUS=/root/deploy.stat

cd /export/rocks/install/site-profiles/6.1.1/nodes
if [ $? -ne 0 ];then
	echo "Nao foi possivel entrar no diretorio /export/rocks/install/site-profiles/6.1.1/nodes" &>2;
	exit 1;
fi

#O comando abaixo sera' inserido no replace-partition.xml. O comando indica para criar uma particao / de 100GB, outra swap, e o restante para uma 
# particao "mydata". Nao ha' necessidade de se criar esta particao.

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
		part / --size 1 --grow --ondisk sda\" > /tmp/user_partition_info" >> replace-partition.xml
	else
		echo "$LINE" >> replace-partition.xml
	fi
done < /export/rocks/install/site-profiles/6.2/nodes/skeleton.xml

echo "XML de particionamento dos computes criado"
