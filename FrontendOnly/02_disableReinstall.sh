#!/bin/bash
#desabilita reinstalação dos computes após queda de energia

#Para se alterar alguma configuracao do kickstart, deve-se criar um novo arquivo com o nome "replace-auto-kickstart.xml" e realizar as alteracoes neste arquivo.

cp -v /export/rocks/install/rocks-dist/x86_64/build/nodes/auto-kickstart.xml /export/rocks/install/site-profiles/$ROCKS_VER/nodes/replace-auto-kickstart.xml
if [ $? -ne "0" ];then
	echo "Nao foi possivel copiar o arquivo auto-kickstart.xml" &>2;
	exit 1;
fi

#Remove a linha que indica que os computes devem ser reinstalados.
sed -i '/rocks-boot-auto/d' /export/rocks/install/site-profiles/$ROCKS_VER/nodes/replace-auto-kickstart.xml
if [ $? -ne "0" ];then
	echo "Erro ao remover a linha do arquivo replace-auto-kickstart.xml" &>2;
	exit 1;
fi

echo "Reinstalacao em caso de queda de energia desabilitada"
