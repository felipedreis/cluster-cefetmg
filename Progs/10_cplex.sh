#!/bin/bash

mkdir -p /tmp/cplex

#colocar cplex no dropbox...
cp /export/files/cplex_installer.bin /tmp/cplex

if [ ! -f  /export/files/cplex_installer.bin ]; then
	echo "CPLEX instalation file not found"
	exit 1
fi

cd /tmp/cplex 
./cplex_installer.bin <<< "5

1




"
rocks create package /opt/ibm/ILOG/CPLEX_Enterprise_Server1263 cplex

$BASE_DIR/AuxScripts/addPackExtend.sh $(ls cplex-*.rpm)

mv octave*.rpm $RPM_CONTRIB_DIR
mv $BASE_DIR/Modules/cplex /etc/modulefiles

cd ..
rm -rf cplex