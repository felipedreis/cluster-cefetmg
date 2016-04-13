#!/bin/bash

mkdir -p /tmp/xvfb
cd /tmp/xvfb

yum --enablerepo="base" install --downloadonly --downloaddir=./ xorg-x11-server-Xvfb.x86_64

rpm -i *.rpm

for pack in $(ls *.rpm);do
	../AuxScripts/addPackExtend.sh $pack
done

mv * $RPM_CONTRIB_DIR

cd ..
rm -rf xvfb