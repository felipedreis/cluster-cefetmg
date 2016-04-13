#!/bin/bash

mkdir -p /tmp/r
cd /tmp/r

yum --enablerepo="epel" install --downloadonly --downloaddir=./ $(yum --enablerepo="epel" list "R-*" | grep -v Available | cut -d" " -f1 | grep -v .i686 | tr -s '\n' ' ')

rpm -i *.rpm

for pack in $(ls *.rpm);do
	../AuxScripts/addPackExtend.sh $pack
done

mv * $RPM_CONTRIB_DIR

cd ..
rm -rf r

#download the latest stable version of R
#wget https://cloud.r-project.org/src/base/R-3/R-3.2.4-revised.tar.gz 

#tar -xf R-3.2.4-revised.tar.gz 

# configure and install R in /opt/R path
#cd R-revised
#./configure --prefix /opt/R  
#make
#make install

#create package and copy it to rocks contrib dir
#cd .. 
#rm R-3.2.4.revised.tar.gz

#rocks create package /opt/R R
#mv R-* $RPM_CONTRIB_DIR

#copy tcl modules
#cp $BASE_DIR/Modules/R-3.2.4 /etc/modulefiles/

#cd ..
#rm -rf r