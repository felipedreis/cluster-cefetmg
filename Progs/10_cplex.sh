#!/bin/bash

mkdir -p /tmp/cplex
cd /tmp/cplex

#colocar cplex no dropbox...
wget -c https://www.dropbox.com/s/t10natbfd02sahs/CPLEX_ENTER_SVR_12.6.3_LNX_X86-64.bin?dl=0
mv CPLEX_ENTER_SVR_12.6.3_LNX_X86-64.bin?dl=0 cplex_installer.bin

if [ ! -f  ./cplex_installer.bin ]; then
	echo "CPLEX instalation file not found"
	exit 1
fi

./cplex_installer.bin <<< "5

1




"
rocks create package /opt/ibm/ILOG/CPLEX_Enterprise_Server1263 cplex

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls cplex-*.rpm)

mv cplex*.rpm $RPM_CONTRIB_DIR
mv $BASE_DIR/Modules/cplex /etc/modulefiles

cd ..
rm -rf cplex