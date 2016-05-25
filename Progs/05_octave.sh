#!/bin/bash

mkdir -p /tmp/octave
cd /tmp/octave

wget http://ftp.gnu.org/gnu/octave/octave-4.0.1.tar.gz

if [ ! -f octave-4.0.1.tar.gz ];then
	echo "Falha ao baixar o arquivo de instalação do OCTAVE"
	exit 1
fi

tar -xzf octave-4.0.1.tar.gz

# Compila o octave. No passo de config ele checa a existencia de libblas
# e liblapack, ambas devem existir no /usr/lib com o nome libblas.so e liblapack.so
cd octave-4.0.1
./configure --prefix=/opt/octave 
make -j8
make install

cd ..
rm octave-4.0.1.tar.gz
rocks create package /opt/octave octave

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls octave-*.rpm)

mv octave*.rpm $RPM_CONTRIB_DIR

cd /tmp
rm -rf octave