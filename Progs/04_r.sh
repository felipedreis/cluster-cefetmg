#!/bin/bash

#download the latest stable version of R
wget https://cloud.r-project.org/src/base/R-3/R-3.2.4-revised.tar.gz 

tar -xf R-3.2.4-revised.tar.gz 

# configure and install R in /opt/R path
cd R-revised
./configure --prefix /opt/R  
make
make install

#create package and copy it to rocks contrib dir
cd .. 
rm R-3.2.4.revised.tar.gz

rocks create package /opt/R R
mv R-* $RPM_CONTRIB_DIR

#copy tcl modules
cp $BASE_DIR/Modules/R-3.2.4 /etc/modulefiles/

cd ..
rm -rf r