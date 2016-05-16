#!/bin/bash

mkdir /tmp/mpich

cd /tmp/mpich
wget http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz
tar -cf mpich-3.2.tar.gz
cd mpich-3.2

./configure --prefix=/opt/mpich
make
make install

cd ..

rocks create package /opt/mpich mpich

$BASE_DIR/AuxScripts/addPackageExtend.sh mpich*.rpm

mv python*.rpm $RPM_CONTRIB_DIR/

cp $BASE_DIR/Modules/mpich /etc/modulefiles
