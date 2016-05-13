#!/bin/bash

mkdir /tmp/cmake

cd /tmp/cmake
wget https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz
tar -xf cmake-3.5.2.tar.gz

cd cmake-3.5.2
./configure --prefix=/opt/cmake
make
make install

rocks create package /opt/cmake cmake

cp *.rpm $RPM_CONTRIB_DIR

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls cmake-*.rpm)

cp $BASE_DIR/Modules/cmake /etc/modulefiles

cd .. 
rm -rf cmake-3.5.2