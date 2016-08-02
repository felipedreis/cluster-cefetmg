#!/bin/bash

cd /tmp

wget http://fr.mirror.babylon.network/gcc/releases/gcc-6.1.0/gcc-6.1.0.tar.gz

if [ ! -f gcc-6.1.0.tar.gz ]; then
	echo "Falha ao baixar o arquivo de instalação do GCC"
	exit 1
fi

tar -xzf gcc-6.1.0.tar.gz
cd gcc-6.1.0

./contrib/download_prerequisites
cd ..
mkdir build
cd build
../gcc-6.1.0/configure --prefix=/opt/gcc --enable-languages=c,c++,fortran,go --disable-multilib

make -j8
make install 

rocks create package /opt/gcc gcc

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls gcc-*.rpm)

cp gcc*.rpm $RPM_CONTRIB_DIR
