#!/bin/bash

mkdir -p /tmp/python_2
cd /tmp/python_2

wget https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz

tar -xf Python-2.7.11.tgz 
cd Python-2.7.11/

./configure --prefix=/opt/python2.7
make -j8
make install

#install pip for python2.7
module load python2.7

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

#installing useful libraries for python 2.7
pip install numpy 
pip install pandas
pip install scipy
pip install sklearn
pip install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.8.0rc0-cp27-none-linux_x86_64.whl
pip install biopython

cd ..
rm Python-2.7.11.tgz

rocks create package /opt/python2.7 python2.7

$BASE_DIR/AuxScripts/addPackageExtend.sh $(ls python*.rpm)

mv python*.rpm $RPM_CONTRIB_DIR

cd /tmp
rm -rf python_2