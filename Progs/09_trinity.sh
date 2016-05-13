#!/bin/bash

mkdir /tmp/trinity

cd /tmp/trinity

wget https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.2.0.tar.gz

tar -xfz v2.2.0.tar.gz

cp trinityrnaseq-2.2.0 /opt/trinity-2.2.0

rocks create package /opt/trinity-2.2.0 trinity

mv trinity*.rpm $RPM_CONTR

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls trinity-*.rpm)

cp $BASE_DIR/Modules/trinity-2.2.0 /etc/modulefiles

cd ..
rm -rf trinity

