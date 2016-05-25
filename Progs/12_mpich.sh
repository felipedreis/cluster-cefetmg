#!/bin/bash

mkdir -p /tmp/mpich
cd /tmp/mpich

wget http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz

tar -xzf mpich-3.2.tar.gz
cd mpich-3.2

./configure --prefix=/opt/mpich
make -j8
make install

cd ..

rocks create package /opt/mpich mpich

$BASE_DIR/AuxScripts/addPackageExtend.sh $(ls mpich*.rpm)

mv mpich*.rpm $RPM_CONTRIB_DIR

cd /tmp
rm -rf mpich