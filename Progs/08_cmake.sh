#!/bin/bash

mkdir -p /tmp/cmake
cd /tmp/cmake

wget https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz

if [ ! -f cmake-3.5.2.tar.gz ];then
	echo "Falha ao baixar o arquivo de instalação do CMAKE"
	exit 1
fi

tar -xf cmake-3.5.2.tar.gz

cd cmake-3.5.2
./configure --prefix=/opt/cmake
make -j8
make install

rocks create package /opt/cmake cmake

cp *.rpm $RPM_CONTRIB_DIR

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls cmake-*.rpm)

cd /tmp 
rm -rf cmake