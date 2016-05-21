#!/bin/bash

mkdir -p /tmp/r
cd /tmp/r

#download the latest stable version of R
wget https://cloud.r-project.org/src/base/R-3/R-3.2.4-revised.tar.gz 

tar -xf R-3.2.4-revised.tar.gz 

# configure and install R in /opt/R path
cd R-revised
./configure --prefix=/opt/R  
make -j8
make install

#create package and copy it to rocks contrib dir
cd .. 
rm R-3.2.4.revised.tar.gz

rocks create package /opt/R R

$BASE_DIR/AuxScripts/addPackExtend.sh R-*.rpm

mv R-* $RPM_CONTRIB_DIR

cd /tmp
rm -rf r