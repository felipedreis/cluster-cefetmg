#!/bin/bash

mkdir /tmp/valgrind
cd /tmp/valgrind


wget http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2

tar -xf valgrind-3.11.0.tar.bz2
cd valgrind-3.11.0

./configure --prefix=/opt/valgrind
make 
make install 

rocks create package /opt/valgrind valgrind

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls valgrind-*.rpm)

cp valgrind*.rpm $RPM_CONTRIB_DIR

cp $BASE_DIR/Modules/valgrind /etc/modulefiles

cd .. 
rm -rf valgrind/