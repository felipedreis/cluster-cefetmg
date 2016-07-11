#!/bin/bash

cd /export/rocks/install/site-profiles/$ROCKS_VER/nodes/

touch extend-compute.xml.tmp

if [ $? -ne 0 ];then
	echo "Erro ao criar arquivo temporario \"extend-compute.xml.tmp\"" 1>&2
	exit 1;
fi

PACK=`rpm -qp $1` 

IFS=$'\n'
while read line;do
	if [ "$line" == "</pre>" ];then
		echo -e $line >> extend-compute.xml.tmp;
		echo -e "<package>$PACK</package>" >> extend-compute.xml.tmp
	else
		echo -e $line >> extend-compute.xml.tmp;
	fi
done < extend-compute.xml
if [ $? -ne 0 ];then
	echo "Erro ao adicionar pacotes ao \"extend-compute.xml.tmp\"" 1>&2
	exit 1;
fi

mv extend-compute.xml extend-compute.xml.bkp
if [ $? -ne 0 ];then
	echo "Falha ao realizar backup do arquivo \"extend-compute.xml\"" 1>&2
	exit 1;
fi

mv extend-compute.xml.tmp extend-compute.xml
if [ $? -ne 0 ];then
	echo "Falha ao renomear arquivo \"extend-compute.xml.tmp\"" 1>&2
	exit 1;
fi