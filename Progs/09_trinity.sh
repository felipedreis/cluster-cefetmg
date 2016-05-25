#!/bin/bash

mkdir -p /tmp/trinity
cd /tmp/trinity

wget https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.2.0.tar.gz

if [ ! -f v2.2.0.tar.gz ];then
	echo "Falha ao baixar o arquivo de instalação do Trinity"
	exit 1
fi

tar -xzf v2.2.0.tar.gz

cp trinityrnaseq-2.2.0 /opt/trinity-2.2.0

rocks create package /opt/trinity-2.2.0 trinity

mv trinity*.rpm $RPM_CONTRIB_DIR

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls trinity-*.rpm)

cd /tmp
rm -rf trinity