#!/bin/bash

cd /tmp
wget https://www.python.org/ftp/python/3.4.4/Python-3.4.4.tgz

tar -xf Python-3.4.4.tgz 
cd Python-3.4.4/

./configure --prefix=/opt/python3.4
make
make install

cd ..
rm Python-3.4.4.tgz
rocks create package /opt/python3.4 python3.4

$BASE_DIR/AuxScripts/addPackageExtend.sh python*.rpm

mv python*.rpm $RPM_CONTRIB_DIR

cp $BASE_DIR/Modules/python3.4 /etc/modulefiles/

#install pip for python3.4
module load python3.4

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

#installing useful libraries for python 3.4
pip install numpy 
pip install pandas
pip install scipy
pip install sklearn
pip install --upgrade https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.8.0rc0-cp27-none-linux_x86_64.whl