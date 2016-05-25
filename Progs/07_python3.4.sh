#!/bin/bash

mkdir -p /tmp/python_3
cd /tmp/python_3

wget https://www.python.org/ftp/python/3.4.4/Python-3.4.4.tgz

if [ ! -f Python-3.4.4.tgz ];then
	echo "Falha ao baixar o arquivo de instalação do Python-3"
	exit 1
fi

tar -xf Python-3.4.4.tgz 
cd Python-3.4.4/

./configure --prefix=/opt/python3.4
make -j8
make install

ln -s /opt/python3.4/bin/python3 /opt/python3.4/bin/python

#install pip for python3.4
module load python3.4

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

ln -s /opt/python3.4/bin/pip3 /opt/python3.4/bin/pip

#installing useful libraries for python 3.4
pip install numpy 
pip install pandas
pip install scipy
pip install sklearn
pip install biopython

cd ..
rm Python-3.4.4.tgz
rocks create package /opt/python3.4 python3.4

$BASE_DIR/AuxScripts/addPackageExtend.sh $(ls python*.rpm)

mv python*.rpm $RPM_CONTRIB_DIR

cd /tmp
rm -rf python_3