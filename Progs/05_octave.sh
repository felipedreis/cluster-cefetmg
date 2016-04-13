#!/bin/bash

cd /tmp

wget http://ftp.gnu.org/gnu/octave/octave-4.0.1.tar.gz

tar -xf octave-4.0.1.tar.gz

# Compila o octave. No passo de config ele checa a existencia de libblas
# e liblapack, ambas devem existir no /usr/lib com o nome libblas.so e liblapack.so
cd octave-4.0.1
./configure --prefix=/opt/octave 
make
make install

cd ..
rm octave-4.0.1.tar.gz
rocks create package /opt/octave octave

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls octave-*.rpm)

mv octave*.rpm $RPM_CONTRIB_DIR


cp $BASE_DIR/Modules/octave /etc/modulefiles/