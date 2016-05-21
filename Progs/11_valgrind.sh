#!/bin/bash

mkdir -p /tmp/valgrind
cd /tmp/valgrind

wget http://valgrind.org/downloads/valgrind-3.11.0.tar.bz2

tar -xjf valgrind-3.11.0.tar.bz2
cd valgrind-3.11.0

./configure --prefix=/opt/valgrind
make -j8
make install 

rocks create package /opt/valgrind valgrind

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls valgrind-*.rpm)

cp valgrind*.rpm $RPM_CONTRIB_DIR

cd /tmp
rm -rf valgrind/